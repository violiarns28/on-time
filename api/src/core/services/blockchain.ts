import { Database } from '@/core/services/db';
import { BlockData, SelectBlockchainLedger } from '@/schemas/blockchain';
import { table } from '@/tables';
import { createHash } from 'crypto';
import { gte } from 'drizzle-orm';
import cron from 'node-cron';

class Blockchain {
  private chain: SelectBlockchainLedger[];
  private difficulty: number = 2;
  private db: Database;

  constructor(db: Database) {
    this.db = db;
    this.chain = [];
    this.init();
  }

  private async init() {
    const findBlock = await this.db.query.blockchainLedger.findFirst({
      where: (fields, operators) => operators.eq(fields.blockIndex, 1),
    });
    if (!findBlock) {
      await this.db
        .insert(table.blockchainLedger)
        .values({
          id: 1,
          data: {
            data: {
              date: new Date().toISOString(),
              userId: 0,
              clockIn: null,
              clockOut: null,
              action: 'GENESIS',
              attendanceId: 0,
            },
            timestamp: new Date().getTime(),
            type: 'GENESIS',
          },
          blockIndex: 1,
          timestamp: new Date(),
          previousHash: '0',
          hash: '0',
          nonce: 0,
        })
        .$returningId()
        .execute();
    }
  }

  public getLatestBlock(): SelectBlockchainLedger {
    return this.chain[this.chain.length - 1];
  }

  public addBlock(data: any): SelectBlockchainLedger {
    const previousBlock = this.getLatestBlock();
    const newBlock = this.createNewBlock(previousBlock, data);
    this.chain.push(newBlock);

    this.persistBlock(newBlock);

    return newBlock;
  }

  private createNewBlock(
    previousBlock: SelectBlockchainLedger,
    data: any,
  ): SelectBlockchainLedger {
    const latest = this.getLatestBlock();
    const newBlock: SelectBlockchainLedger = {
      id: latest.id + 1,
      blockIndex: previousBlock.blockIndex + 1,
      timestamp: new Date().toISOString(),
      data: data,
      previousHash: previousBlock.hash,
      hash: '',
      nonce: 0,
    };

    return this.mineBlock(newBlock);
  }

  private calculateHash(block: SelectBlockchainLedger): string {
    const data = JSON.stringify(block.data);
    const args = [
      block.blockIndex,
      block.timestamp,
      data,
      block.previousHash,
      block.nonce,
    ];
    return createHash('sha256').update(args.join('')).digest('hex');
  }

  private mineBlock(block: SelectBlockchainLedger): SelectBlockchainLedger {
    const target = Array(this.difficulty + 1).join('0');

    while (block.hash?.substring(0, this.difficulty) !== target) {
      block.nonce++;
      block.hash = this.calculateHash(block);
    }

    console.log(`Block mined: ${block.hash}`);
    return block;
  }

  private async persistBlock(block: SelectBlockchainLedger): Promise<void> {
    try {
      await this.db.insert(table.blockchainLedger).values({
        blockIndex: block.blockIndex,
        timestamp: new Date(block.timestamp),
        data: block.data,
        previousHash: block.previousHash,
        hash: block.hash,
        nonce: block.nonce,
      });
    } catch (error) {
      console.error('Error persisting block to database:', error);
    }
  }

  public isChainValid(): Record<string, any> {
    for (let i = 1; i < this.chain.length; i++) {
      const currentBlock = this.chain[i];
      const previousBlock = this.chain[i - 1];

      if (currentBlock.hash !== this.calculateHash(currentBlock)) {
        return {
          valid: false,
          block: {
            previous: previousBlock,
            current: currentBlock,
          },
        };
      }

      if (currentBlock.previousHash !== previousBlock.hash) {
        return {
          valid: false,
          block: {
            previous: previousBlock,
            current: currentBlock,
          },
        };
      }
    }

    return {
      valid: true,
    };
  }

  private async cleanInvalidBlocks(): Promise<void> {
    console.log('Cleaning invalid blocks');
    for (let i = 1; i < this.chain.length; i++) {
      const currentBlock = this.chain[i];
      const previousBlock = this.chain[i - 1];
      console.log('Checking block:', currentBlock);

      if (currentBlock.hash !== this.calculateHash(currentBlock)) {
        this.chain = this.chain.slice(0, i);
        await this.db
          .delete(table.blockchainLedger)
          .where(
            gte(table.blockchainLedger.blockIndex, currentBlock.blockIndex),
          )
          .execute();
        await this.db
          .delete(table.attendance)
          .where(gte(table.attendance.id, currentBlock.data.data.attendanceId))
          .execute();
        break;
      }

      if (currentBlock.previousHash !== previousBlock.hash) {
        this.chain = this.chain.slice(0, i);
        await this.db
          .delete(table.blockchainLedger)
          .where(
            gte(table.blockchainLedger.blockIndex, currentBlock.blockIndex),
          )
          .execute();
        await this.db
          .delete(table.attendance)
          .where(gte(table.attendance.id, currentBlock.data.data.attendanceId))
          .execute();
        break;
      }
    }
  }

  public cronCleanInvalid(): void {
    // Run every 1 minutes
    cron.schedule('*/1 * * * *', () => {
      this.cleanInvalidBlocks();
    });
  }

  public async loadChainFromDb(): Promise<void> {
    try {
      this.chain = [];
      const blocks = await this.db.query.blockchainLedger.findMany({
        orderBy(fields, operators) {
          return operators.asc(fields.blockIndex);
        },
      });
      for (const block of blocks) {
        if (block.blockIndex === 0) continue;

        this.chain.push({
          id: block.id,
          blockIndex: block.blockIndex,
          timestamp: block.timestamp.toISOString(),
          data: block.data,
          previousHash: block.previousHash,
          hash: block.hash,
          nonce: block.nonce,
        });
      }

      console.log(`Loaded ${this.chain.length} blocks from database`);
    } catch (error) {
      console.error('Error loading blockchain from database:', error);
    }
  }

  public getChain(): SelectBlockchainLedger[] {
    return this.chain;
  }
}

export class BlockchainService {
  private static instance: BlockchainService;
  private blockchain: Blockchain | null = null;

  // private constructor() { }

  public static getInstance(): BlockchainService {
    if (!BlockchainService.instance) {
      BlockchainService.instance = new BlockchainService();
    }
    return BlockchainService.instance;
  }

  public async initializeBlockchain(db: Database): Promise<void> {
    this.blockchain = new Blockchain(db);
    await this.blockchain.loadChainFromDb();
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
    attendanceData: BlockData['data'],
  ): Promise<void> {
    if (!this.blockchain) {
      throw new Error('Blockchain not initialized');
    }

    this.blockchain.addBlock({
      type: 'ATTENDANCE',
      data: attendanceData,
      timestamp: Date.now(),
    });
  }

  public verifyBlockchain(): Record<string, any> {
    if (!this.blockchain) {
      throw new Error('Blockchain not initialized');
    }

    return this.blockchain.isChainValid();
  }
}
