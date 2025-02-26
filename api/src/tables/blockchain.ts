import { BlockData } from '@/schemas/blockchain';
import {
  int,
  json,
  mysqlTable,
  serial,
  timestamp,
  varchar,
} from 'drizzle-orm/mysql-core';

export const blockchainLedgerTable = mysqlTable('blockchain_ledger', {
  id: serial('id').primaryKey(),
  blockIndex: int('block_index').notNull(),
  timestamp: timestamp('timestamp').notNull(),
  data: json('data').$type<BlockData>().notNull(),
  previousHash: varchar('previous_hash', { length: 64 }).notNull(),
  hash: varchar('hash', { length: 64 }).notNull(),
  nonce: int('nonce').notNull(),
});
