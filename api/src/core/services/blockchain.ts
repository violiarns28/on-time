import { Database } from '@/core/services/db';
import { BlockData, SelectBlockchainLedger } from '@/schemas/blockchain';
import { table } from '@/tables';
import { createHash } from 'crypto';

class Blockchain {
  private chain: SelectBlockchainLedger[];
  private difficulty: number = 2;
  private db: Database;

  constructor(db: Database) {
    this.chain = [this.createGenesisBlock()];
    this.db = db;
  }

  private createGenesisBlock(): SelectBlockchainLedger {
    return {
      id: 0,
      blockIndex: 0,
      timestamp: new Date(),
      data: {
        type: 'GENESIS',
        data: {
          attendanceId: 0,
          userId: 0,
          date: '',
          clockIn: '',
          clockOut: '',
        },
        timestamp: Date.now(),
      },
      previousHash: '0',
      hash: '0',
      nonce: 0,
    };
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
      timestamp: new Date(),
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

  public isChainValid(): boolean {
    for (let i = 1; i < this.chain.length; i++) {
      const currentBlock = this.chain[i];
      const previousBlock = this.chain[i - 1];

      if (currentBlock.hash !== this.calculateHash(currentBlock)) {
        return false;
      }

      if (currentBlock.previousHash !== previousBlock.hash) {
        return false;
      }
    }

    return true;
  }

  public async loadChainFromDb(): Promise<void> {
    try {
      this.chain = [];
      const blocks = await this.db.query.blockchainLedger.findMany({
        orderBy(fields, operators) {
          return operators.asc(fields.blockIndex);
        },
      });
      this.chain = [this.createGenesisBlock()];
      for (const block of blocks) {
        if (block.blockIndex === 0) continue;

        this.chain.push({
          id: block.id,
          blockIndex: block.blockIndex,
          timestamp: block.timestamp,
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
    attendanceData: BlockData,
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

  public verifyBlockchain(): boolean {
    if (!this.blockchain) {
      throw new Error('Blockchain not initialized');
    }

    return this.blockchain.isChainValid();
  }
}
