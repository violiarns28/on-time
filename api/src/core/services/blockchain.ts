import { Database } from '@/core/services/db';
import { BlockData, SelectAttendance } from '@/schemas/attendance';
import { attendancesTable } from '@/tables/attendance';
import { usersTable } from '@/tables/user';
import { createHash } from 'crypto';
import { gte } from 'drizzle-orm';

class Blockchain {
  private chain: SelectAttendance[] = [];
  private difficulty: number = 2;
  private db: Database;
  private initialized: boolean = false;

  constructor(db: Database) {
    this.db = db;
  }

  public async init(): Promise<void> {
    if (this.initialized) return;
    await this.createSystemUser();

    const genesisBlock = await this.db.query.attendance.findFirst({
      where: (fields, operators) => operators.eq(fields.id, 0),
    });

    if (!genesisBlock) {
      await this.createGenesisBlock();
    }

    await this.loadChainFromDb();

    this.initialized = true;
  }

  private async createSystemUser() {
    const user = await this.db.query.user.findFirst({
      where: (fields, operators) => operators.eq(fields.id, 0),
    });

    if (!user) {
      const ops = await this.db
        .insert(usersTable)
        .values({
          id: 0,
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

  private async createGenesisBlock(): Promise<void> {
    const date = new Date();
    const genesisBlock: SelectAttendance = {
      id: 0,
      userId: await this.createSystemUser(),
      latitude: '0',
      longitude: '0',
      type: 'GENESIS',
      userName: 'SYSTEM',
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
      throw new Error('Blockchain not loaded. Call loadChainFromDb first.');
    }
    return this.chain[this.chain.length - 1];
  }

  public async addBlock(data: BlockData): Promise<SelectAttendance> {
    if (this.chain.length === 0) {
      await this.loadChainFromDb();
    }

    const latest = this.getLatestBlock();
    const newBlock = this.createNewBlock(latest, data);

    try {
      await this.persistBlock(newBlock);
      this.chain.push(newBlock);
      return newBlock;
    } catch (error) {
      console.error('Error adding block:', error);
      throw new Error('Failed to add block to blockchain');
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
    const blockForHashing = {
      ...block,
      hash: '',
    };

    const dataString = JSON.stringify(blockForHashing);
    return createHash('sha256').update(dataString).digest('hex');
  }

  private mineBlock(block: SelectAttendance): SelectAttendance {
    const target = Array(this.difficulty + 1).join('0');

    do {
      block.nonce++;
      block.hash = this.calculateHash(block);
    } while (block.hash.substring(0, this.difficulty) !== target);

    console.log(`Block mined: ${block.hash}`);
    return block;
  }

  private async persistBlock(block: SelectAttendance): Promise<void> {
    try {
      await this.db.insert(attendancesTable).values(block).execute();
    } catch (error) {
      console.error('Error persisting block to database:', error);
      throw error;
    }
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

    const target = Array(this.difficulty + 1).join('0');
    if (currentBlock.hash.substring(0, this.difficulty) !== target) {
      return false;
    }

    return true;
  }

  private async cleanInvalidBlocks(): Promise<void> {
    console.log('Checking blockchain integrity...');

    await this.loadChainFromDb();
    const validationResult = this.isChainValid();

    if (!validationResult.valid && validationResult.invalidBlock) {
      console.warn('Invalid blocks detected, cleaning up...');
      const invalidBlock = validationResult.invalidBlock.current;

      this.chain = this.chain.filter((block) => block.id < invalidBlock.id);

      await this.deleteInvalidBlocks(invalidBlock.id);

      console.log(
        `Removed invalid blocks starting from index ${invalidBlock.id}`,
      );
    } else {
      console.log('Blockchain is valid');
    }
  }

  private async deleteInvalidBlocks(fromIndex: number): Promise<void> {
    try {
      await this.db
        .delete(attendancesTable)
        .where(gte(attendancesTable.id, fromIndex))
        .execute();
    } catch (error) {
      console.error('Error deleting invalid blocks:', error);
      throw new Error('Failed to delete invalid blocks');
    }
  }

  public async loadChainFromDb(): Promise<SelectAttendance[]> {
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
      return this.chain;
    } catch (error) {
      console.error('Error loading blockchain from database:', error);
      throw new Error('Failed to load blockchain from database');
    }
  }

  public getChain(): SelectAttendance[] {
    return [...this.chain];
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

  public async initializeBlockchain(db: Database): Promise<void> {
    if (!this.blockchain) {
      this.blockchain = new Blockchain(db);
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
    return await this.blockchain.addBlock(attendanceData);
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
}
