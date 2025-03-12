import { Database } from '@/core/services/db';
import { BlockData, SelectAttendance } from '@/schemas/attendance';
import { attendancesTable } from '@/tables/attendance';
import { usersTable } from '@/tables/user';
import { createHash } from 'crypto';
import { sql } from 'drizzle-orm';
import { Redis } from 'ioredis';
import { env } from '../config/env';
import { P2PService } from './p2p';

const REDIS_KEYS = {
  MINING_QUEUE: 'blockchain:mining:queue',
  MINING_LOCK: 'blockchain:mining:lock',
  BLOCKCHAIN_CACHE: 'blockchain:chain',
  DB_WRITE_QUEUE: 'blockchain:db:queue',
  DB_WRITER_LOCK: 'blockchain:db:writer:lock',
  RESULT_PREFIX: 'blockchain:result:',
};

const CONFIG = {
  LOCK_EXPIRY: 30000,
  DB_WRITE_INTERVAL: 5000,
  LOCK_DURATION: 10,
  RESULT_EXPIRY: 60,
  CACHE_EXPIRY: 86400, // 24 hours
  DB_BATCH_SIZE: 10,
  JOB_TIMEOUT: 30000, // 30 seconds
  POLL_INTERVAL: 500,
};

class Blockchain {
  private chain: SelectAttendance[] = [];
  private difficulty: number = 2;
  private db: Database;
  private redis: Redis;
  private initialized: boolean = false;
  private dbWriterInterval: Timer | null = null;

  constructor(db: Database, redis: Redis) {
    this.db = db;
    this.redis = redis;
  }

  public async init(): Promise<void> {
    if (this.initialized) return;

    if (!env.IS_SLAVE_NODE) {
      const systemUserId = await this.createSystemUser();
      const genesisBlock = await this.db.query.attendance.findFirst({
        where: (fields, operators) => operators.eq(fields.id, 1),
      });

      if (!genesisBlock) {
        await this.createGenesisBlock(systemUserId);
      }
    } else {
      const userRequest = await fetch(`${env.MASTER_NODE_URL_HTTP}/p2p/user`);
      const users = (await userRequest.json()).data;
      await this.db
        .insert(usersTable)
        .values(users)
        .onDuplicateKeyUpdate({
          set: { ...users },
        })
        .execute();
      const attendancesRequest = await fetch(
        `${env.MASTER_NODE_URL_HTTP}/p2p/user`,
      );
      const attendances = (await attendancesRequest.json()).data;
      this.chain = attendances;
      await this.db
        .insert(attendancesTable)
        .values(attendances)
        .onDuplicateKeyUpdate({
          set: { ...attendances },
        })
        .execute();
    }

    await this.loadChain();
    this.startDbWriter();
    this.initialized = true;
  }

  private startDbWriter(): void {
    if (this.dbWriterInterval) {
      clearInterval(this.dbWriterInterval);
    }

    this.dbWriterInterval = setInterval(
      () => this.processDbWriteQueue(),
      CONFIG.DB_WRITE_INTERVAL,
    );
  }

  private async processDbWriteQueue(): Promise<void> {
    const acquireLock = await this.redis.set(
      REDIS_KEYS.DB_WRITER_LOCK,
      'locked',
      'EX',
      CONFIG.LOCK_DURATION,
      'NX',
    );

    if (!acquireLock) return;

    try {
      let queuedBlock = await this.redis.lpop(REDIS_KEYS.DB_WRITE_QUEUE);
      let processedCount = 0;

      while (queuedBlock && processedCount < CONFIG.DB_BATCH_SIZE) {
        try {
          const block = JSON.parse(queuedBlock);
          await this.db.insert(attendancesTable).values(block).execute();
          processedCount++;
          console.log(`Persisted block #${block.id} to database`);
        } catch (error) {
          console.error('Error persisting block to database:', error);
          await this.redis.rpush(REDIS_KEYS.DB_WRITE_QUEUE, queuedBlock);
          break;
        }

        queuedBlock = await this.redis.lpop(REDIS_KEYS.DB_WRITE_QUEUE);
      }

      if (processedCount > 0) {
        console.log(`Processed ${processedCount} database writes`);
      }
    } catch (error) {
      console.error('Error in database writer process:', error);
    } finally {
      await this.redis.del(REDIS_KEYS.DB_WRITER_LOCK);
    }
  }

  private async createSystemUser(): Promise<number> {
    const user = await this.db.query.user.findFirst({
      where: (fields, operators) => operators.eq(fields.id, 1),
    });

    if (!user) {
      await this.db
        .insert(usersTable)
        .values({
          id: 1,
          name: 'GENESIS',
          email: 'genesis@ontime.com',
          password: await Bun.password.hash('genesis', 'bcrypt'),
          deviceId: 'genesis',
        })
        .execute();

      const find = await this.db.query.user.findFirst({
        where: (fields, operators) => operators.eq(fields.id, 1),
        columns: {
          id: true,
        },
      });
      return find?.id || 1;
    }
    return user.id;
  }

  private async createGenesisBlock(userId: number): Promise<void> {
    const date = new Date();
    const genesisBlock: SelectAttendance = {
      id: 1,
      userId,
      latitude: '0',
      longitude: '0',
      type: 'GENESIS',
      userName: 'GENESIS',
      timestamp: date.getTime(),
      date: date.toISOString().split('T')[0],
      hash: '0'.repeat(64), // Simplified from original string of 64 zeros
      previousHash: '0',
      nonce: 0,
    };

    try {
      await this.db.insert(attendancesTable).values(genesisBlock).execute();
      console.log('Genesis block created');
    } catch (error) {
      console.error('Error creating genesis block:', error);
      throw new Error('Failed to create genesis block');
    }
  }

  public getLatestBlock(): SelectAttendance {
    if (this.chain.length === 0) {
      throw new Error('Blockchain not loaded. Call loadChain first.');
    }
    return this.chain[this.chain.length - 1];
  }

  public async addBlock(data: BlockData): Promise<SelectAttendance> {
    if (!this.initialized) {
      await this.init();
    }

    const jobId = `job:${Date.now()}:${Math.random().toString(36).substring(2, 10)}`;
    const jobData = JSON.stringify({
      id: jobId,
      data,
      timestamp: Date.now(),
    });

    await this.redis.rpush(REDIS_KEYS.MINING_QUEUE, jobData);
    await this.processQueue();

    return this.waitForJobCompletion(jobId);
  }

  private async waitForJobCompletion(jobId: string): Promise<SelectAttendance> {
    const resultKey = `${REDIS_KEYS.RESULT_PREFIX}${jobId}`;
    const maxAttempts = Math.ceil(CONFIG.JOB_TIMEOUT / CONFIG.POLL_INTERVAL);

    for (let attempts = 0; attempts < maxAttempts; attempts++) {
      const result = await this.redis.get(resultKey);
      if (result) {
        await this.redis.del(resultKey);
        return JSON.parse(result);
      }

      await new Promise((resolve) => setTimeout(resolve, CONFIG.POLL_INTERVAL));
    }

    throw new Error('Block mining timed out');
  }

  private async processQueue(): Promise<void> {
    const acquireLock = await this.redis.set(
      REDIS_KEYS.MINING_LOCK,
      'locked',
      'EX',
      Math.floor(CONFIG.LOCK_EXPIRY / 1000),
      'NX',
    );

    if (!acquireLock) return;

    try {
      let jobData = await this.redis.lpop(REDIS_KEYS.MINING_QUEUE);

      while (jobData) {
        const job = JSON.parse(jobData);
        const resultKey = `${REDIS_KEYS.RESULT_PREFIX}${job.id}`;

        try {
          await this.syncChainWithCache();
          const latest = this.getLatestBlock();
          const newBlock = this.createNewBlock(latest, job.data);

          await this.queueBlockForPersistence(newBlock);

          this.chain.push(newBlock);
          await this.cacheChain();

          await this.redis.set(
            resultKey,
            JSON.stringify(newBlock),
            'EX',
            CONFIG.RESULT_EXPIRY,
          );
          console.log(`Processed block job ${job.id}`);
        } catch (error) {
          console.error(`Error processing block job ${job.id}:`, error);
          const errorMessage =
            error instanceof Error ? error.message : String(error);
          await this.redis.set(
            resultKey,
            JSON.stringify({ error: errorMessage }),
            'EX',
            CONFIG.RESULT_EXPIRY,
          );
        }

        jobData = await this.redis.lpop(REDIS_KEYS.MINING_QUEUE);
      }
    } catch (error) {
      console.error('Error in queue processor:', error);
    } finally {
      await this.redis.del(REDIS_KEYS.MINING_LOCK);

      const queueLength = await this.redis.llen(REDIS_KEYS.MINING_QUEUE);
      if (queueLength > 0) {
        setTimeout(() => this.processQueue(), 0);
      }
    }
  }

  private async queueBlockForPersistence(
    block: SelectAttendance,
  ): Promise<void> {
    try {
      await this.redis.rpush(REDIS_KEYS.DB_WRITE_QUEUE, JSON.stringify(block));
      console.log(`Queued block #${block.id} for database persistence`);
    } catch (error) {
      console.error('Error queueing block for persistence:', error);
      throw error;
    }
  }

  private createNewBlock(
    previousBlock: SelectAttendance,
    data: BlockData,
  ): SelectAttendance {
    const newBlock: SelectAttendance = {
      ...data,
      id: previousBlock.id + 1,
      timestamp: Date.now(),
      previousHash: previousBlock.hash,
      hash: '',
      nonce: 0,
    };

    return this.mineBlock(newBlock);
  }

  private calculateHash(block: SelectAttendance): string {
    const blockHash = { ...block, hash: '' };
    const dataString = JSON.stringify(blockHash);
    return createHash('sha256').update(dataString).digest('hex');
  }

  private mineBlock(block: SelectAttendance): SelectAttendance {
    const target = '0'.repeat(this.difficulty);

    do {
      block.nonce++;
      block.hash = this.calculateHash(block);
    } while (block.hash.substring(0, this.difficulty) !== target);

    console.log(`Block mined: ${block.hash}`);
    return block;
  }

  public isChainValid(): {
    valid: boolean;
    invalidBlock?: { previous: SelectAttendance; current: SelectAttendance };
  } {
    if (this.chain.length <= 1) return { valid: true };

    for (let i = 1; i < this.chain.length; i++) {
      const currentBlock = this.chain[i];
      const previousBlock = this.chain[i - 1];

      if (!this.isBlockValid(currentBlock, previousBlock)) {
        return {
          valid: false,
          invalidBlock: { previous: previousBlock, current: currentBlock },
        };
      }
    }

    return { valid: true };
  }

  public async replaceChain(newChain: SelectAttendance[]): Promise<boolean> {
    if (newChain.length <= 0) {
      console.log('Received empty chain, rejecting replacement');
      return false;
    }

    if (newChain.length <= this.chain.length) {
      console.log(
        'Received chain is not longer than current chain, rejecting replacement',
      );
      return false;
    }

    for (let i = 1; i < newChain.length; i++) {
      if (!this.isBlockValid(newChain[i], newChain[i - 1])) {
        console.log(
          `Invalid block at position ${i}, rejecting chain replacement`,
        );
        return false;
      }
    }

    if (newChain[0].hash !== this.chain[0].hash) {
      console.log('Genesis block mismatch, rejecting chain replacement');
      return false;
    }

    try {
      this.chain = [...newChain];
      await this.cacheChain();

      const existingBlockCount = await this.getExistingBlockCount();
      for (let i = existingBlockCount; i < newChain.length; i++) {
        await this.queueBlockForPersistence(newChain[i]);
      }

      console.log(`Chain replaced with ${newChain.length} blocks`);
      return true;
    } catch (error) {
      console.error('Error replacing chain:', error);
      return false;
    }
  }

  private async getExistingBlockCount(): Promise<number> {
    try {
      const result = await this.db
        .select({ count: sql<number>`COUNT(*)`.as('count') })
        .from(attendancesTable)
        .execute();

      return result && result.length > 0 ? Number(result[0].count) : 0;
    } catch (error) {
      console.error('Error getting block count:', error);
      return 0;
    }
  }

  private isBlockValid(
    currentBlock: SelectAttendance,
    previousBlock: SelectAttendance,
  ): boolean {
    if (currentBlock.previousHash !== previousBlock.hash) {
      return false;
    }

    const calculatedHash = this.calculateHash(currentBlock);
    if (calculatedHash !== currentBlock.hash) {
      return false;
    }

    const target = '0'.repeat(this.difficulty);
    if (currentBlock.hash.substring(0, this.difficulty) !== target) {
      return false;
    }

    return true;
  }

  private async loadChain(): Promise<void> {
    await this.redis.del(REDIS_KEYS.BLOCKCHAIN_CACHE);
    await this.loadChainFromDb();
    await this.cacheChain();
  }

  private async loadChainFromDb(): Promise<void> {
    try {
      const blocks = await this.db.query.attendance.findMany({
        orderBy(fields, operators) {
          return operators.asc(fields.id);
        },
        with: {
          user: {
            columns: {
              name: true,
            },
          },
        },
      });

      this.chain = blocks.map((block) => ({
        ...block,
        userName: block.user.name,
      }));

      console.log(`Loaded ${this.chain.length} blocks from database`);
    } catch (error) {
      console.error('Error loading blockchain from database:', error);
      throw new Error('Failed to load blockchain from database');
    }
  }

  private async cacheChain(): Promise<void> {
    try {
      await this.redis.set(
        REDIS_KEYS.BLOCKCHAIN_CACHE,
        JSON.stringify(this.chain),
        'EX',
        CONFIG.CACHE_EXPIRY,
      );
      console.log(`Cached ${this.chain.length} blocks in Redis`);
    } catch (error) {
      console.error('Error caching blockchain in Redis:', error);
    }
  }

  private async syncChainWithCache(): Promise<void> {
    const cachedChain = await this.redis.get(REDIS_KEYS.BLOCKCHAIN_CACHE);

    if (cachedChain) {
      try {
        this.chain = JSON.parse(cachedChain);
      } catch (error) {
        console.error('Error parsing cached blockchain during sync:', error);
      }
    }
  }

  public getChain(): SelectAttendance[] {
    return [...this.chain];
  }

  public shutdown(): void {
    if (this.dbWriterInterval) {
      clearInterval(this.dbWriterInterval);
      this.dbWriterInterval = null;
    }
  }
}

export class BlockchainService {
  private static instance: BlockchainService;
  private blockchain: Blockchain | null = null;

  public static getInstance(): BlockchainService {
    if (!BlockchainService.instance) {
      BlockchainService.instance = new BlockchainService();
    }
    return BlockchainService.instance;
  }

  public async initializeBlockchain(db: Database, redis: Redis): Promise<void> {
    if (!this.blockchain) {
      this.blockchain = new Blockchain(db, redis);
    }
    await this.blockchain.init();
  }

  public getBlockchain(): Blockchain {
    if (!this.blockchain) {
      throw new Error(
        'Blockchain not initialized. Call initializeBlockchain first.',
      );
    }
    return this.blockchain;
  }

  public async recordAttendanceAction(
    attendanceData: BlockData,
  ): Promise<SelectAttendance> {
    if (!this.blockchain) {
      throw new Error('Blockchain not initialized');
    }

    const newBlock = await this.blockchain.addBlock(attendanceData);

    try {
      const p2pService = P2PService.getInstance();
      p2pService.broadcastNewBlock(newBlock);
    } catch (error) {
      console.log(
        'P2P network not initialized or error broadcasting block:',
        error,
      );
    }

    return newBlock;
  }

  public verifyBlockchain(): {
    valid: boolean;
    invalidBlock?: { previous: SelectAttendance; current: SelectAttendance };
  } {
    if (!this.blockchain) {
      throw new Error('Blockchain not initialized');
    }
    return this.blockchain.isChainValid();
  }

  public shutdown(): void {
    if (this.blockchain) {
      this.blockchain.shutdown();
    }
  }
}
