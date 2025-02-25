import {
  int,
  mysqlTable,
  serial,
  text,
  timestamp,
  varchar,
} from 'drizzle-orm/mysql-core';
import { CommonModifier } from './common';

export const blockchainLedgerTable = mysqlTable('blockchain_ledger', {
  id: serial('id').primaryKey(),
  blockIndex: int('block_index').notNull(),
  timestamp: timestamp('timestamp').notNull(),
  data: text('data').notNull(),
  previousHash: varchar('previous_hash', { length: 64 }).notNull(),
  hash: varchar('hash', { length: 64 }).notNull(),
  nonce: int('nonce').notNull(),
  ...CommonModifier,
});
