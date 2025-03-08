import { Database } from '@/core/services/db';
import { BlockData, SelectAttendance } from '@/schemas/attendance';
import { attendancesTable } from '@/tables/attendance';
import { usersTable } from '@/tables/user';
import { createHash } from 'crypto';
import { Redis } from 'ioredis';
import { P2PNetworkService } from './p2p';

const MINING_QUEUE_KEY = 'blockchain:mining:queue';
const MINING_LOCK_KEY = 'blockchain:mining:lock';
const BLOCKCHAIN_CACHE_KEY = 'blockchain:chain';
const DB_WRITE_QUEUE_KEY = 'blockchain:db:queue';
const LOCK_EXPIRY = 30000;

class Blockchain {
  private chain: SelectAttendance[] = [];
  private difficulty: number = 2;
  private db: Database;
  private redis: Redis;
  private initialized: boolean = false;
  private dbWriterInterval: NodeJS.Timeout | null = null;

  constructor(db: Database, redis: Redis) {
    this.db = db;
    this.redis = redis;
  }

  public async init(): Promise<void> {
    if (this.initialized) return;

    const systemUserId = await this.createSystemUser();

    const genesisBlock = await this.db.query.attendance.findFirst({
      where: (fields, operators) => operators.eq(fields.id, 1),
    });

    if (!genesisBlock) {
      await this.createGenesisBlock(systemUserId);
    }

    await this.loadChain();
    this.startDbWriter();
    this.initialized = true;
  }

  private startDbWriter(): void {
    if (this.dbWriterInterval) {
      clearInterval(this.dbWriterInterval);
    }

    // @ts-ignore
    this.dbWriterInterval = setInterval(async () => {
      await this.processDbWriteQueue();
    }, 5000); // Process DB writes every 5 seconds
  }

  private async processDbWriteQueue(): Promise<void> {
    const lockKey = 'blockchain:db:writer:lock';
    const acquireLock = await this.redis.set(
      lockKey,
      'locked',
      'EX',
      10, // 10 seconds lock
      'NX',
    );

    if (!acquireLock) return;

    try {
      let queuedBlock = await this.redis.lpop(DB_WRITE_QUEUE_KEY);
      let processedCount = 0;
      const batchSize = 10; // Process up to 10 blocks at a time

      while (queuedBlock && processedCount < batchSize) {
        try {
          const block = JSON.parse(queuedBlock);
          await this.db.insert(attendancesTable).values(block).execute();
          processedCount++;
          console.log(`Persisted block #${block.id} to database`);
        } catch (error) {
          console.error('Error persisting block to database:', error);
          // Put the block back in the queue for retry
          await this.redis.rpush(DB_WRITE_QUEUE_KEY, queuedBlock);
          break;
        }

        queuedBlock = await this.redis.lpop(DB_WRITE_QUEUE_KEY);
      }

      if (processedCount > 0) {
        console.log(`Processed ${processedCount} database writes`);
      }
    } catch (error) {
      console.error('Error in database writer process:', error);
    } finally {
      await this.redis.del(lockKey);
    }
  }

  private async createSystemUser(): Promise<number> {
    const user = await this.db.query.user.findFirst({
      where: (fields, operators) => operators.eq(fields.id, 1),
    });

    if (!user) {
      const ops = await this.db
        .insert(usersTable)
        .values({
          id: 1,
          name: 'GENESIS',
          email: 'genesis@ontime.com',
          password: await Bun.password.hash('genesis', 'bcrypt'),
          deviceId: 'genesis',
        })
        .$returningId()
        .execute();
      return ops[0].id;
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
      hash: '0000000000000000000000000000000000000000000000000000000000000000',
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

    await this.redis.rpush(MINING_QUEUE_KEY, jobData);

    await this.processQueue();

    return await this.waitForJobCompletion(jobId);
  }

  private async waitForJobCompletion(jobId: string): Promise<SelectAttendance> {
    const resultKey = `blockchain:result:${jobId}`;
    let attempts = 0;
    const maxAttempts = 60; // 30 seconds (60 * 500ms)

    while (attempts < maxAttempts) {
      const result = await this.redis.get(resultKey);
      if (result) {
        await this.redis.del(resultKey);
        return JSON.parse(result);
      }

      await new Promise((resolve) => setTimeout(resolve, 500));
      attempts++;
    }

    throw new Error('Block mining timed out');
  }

  private async processQueue(): Promise<void> {
    const acquireLock = await this.redis.set(
      MINING_LOCK_KEY,
      'locked',
      'EX',
      Math.floor(LOCK_EXPIRY / 1000),
      'NX',
    );

    if (!acquireLock) return;

    try {
      let jobData = await this.redis.lpop(MINING_QUEUE_KEY);

      while (jobData) {
        const job = JSON.parse(jobData);

        try {
          // Use the in-memory chain or get from cache
          await this.syncChainWithCache();
          const latest = this.getLatestBlock();

          const newBlock = this.createNewBlock(latest, job.data);

          // Queue the block for persistence instead of immediate DB write
          await this.queueBlockForPersistence(newBlock);

          // Update the chain and cache it immediately
          this.chain.push(newBlock);
          await this.cacheChain();

          const resultKey = `blockchain:result:${job.id}`;
          await this.redis.set(resultKey, JSON.stringify(newBlock), 'EX', 60); // Expire after 60 seconds

          console.log(`Processed block job ${job.id}`);
        } catch (error) {
          console.error(`Error processing block job ${job.id}:`, error);
          const resultKey = `blockchain:result:${job.id}`;
          await this.redis.set(
            resultKey,
            JSON.stringify({
              error: error instanceof Error ? error.message : error,
            }),
            'EX',
            60,
          );
        }

        jobData = await this.redis.lpop(MINING_QUEUE_KEY);
      }
    } catch (error) {
      console.error('Error in queue processor:', error);
    } finally {
      await this.redis.del(MINING_LOCK_KEY);

      const queueLength = await this.redis.llen(MINING_QUEUE_KEY);
      if (queueLength > 0) {
        setTimeout(() => this.processQueue(), 0);
      }
    }
  }

  private async queueBlockForPersistence(
    block: SelectAttendance,
  ): Promise<void> {
    try {
      await this.redis.rpush(DB_WRITE_QUEUE_KEY, JSON.stringify(block));
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
      timestamp: new Date().getTime(),
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
          invalidBlock: {
            previous: previousBlock,
            current: currentBlock,
          },
        };
      }
    }

    return { valid: true };
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
    // Try to load from Redis cache first
    const cachedChain = await this.redis.get(BLOCKCHAIN_CACHE_KEY);

    if (cachedChain) {
      try {
        this.chain = JSON.parse(cachedChain);
        console.log(`Loaded ${this.chain.length} blocks from Redis cache`);
        return;
      } catch (error) {
        console.error(
          'Error parsing cached blockchain, loading from DB instead:',
          error,
        );
      }
    }

    // If not in cache or error, load from database
    await this.loadChainFromDb();

    // Cache the loaded chain
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
        BLOCKCHAIN_CACHE_KEY,
        JSON.stringify(this.chain),
        'EX',
        86400, // Cache for 24 hours
      );
      console.log(`Cached ${this.chain.length} blocks in Redis`);
    } catch (error) {
      console.error('Error caching blockchain in Redis:', error);
    }
  }

  private async syncChainWithCache(): Promise<void> {
    // Get the latest state from cache if available
    const cachedChain = await this.redis.get(BLOCKCHAIN_CACHE_KEY);

    if (cachedChain) {
      try {
        this.chain = JSON.parse(cachedChain);
      } catch (error) {
        console.error(
          'Error parsing cached blockchain during sync, using current chain:',
          error,
        );
      }
    }
  }

  public getChain(): SelectAttendance[] {
    return [...this.chain];
  }

  // Clean up resources on shutdown
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

    // Broadcast the new block to the P2P network if it's initialized
    try {
      const p2pService = P2PNetworkService.getInstance();
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

  // Method to clean up resources on shutdown
  public shutdown(): void {
    if (this.blockchain) {
      this.blockchain.shutdown();
    }
  }
}
