import { relations } from 'drizzle-orm';
import {
  bigint,
  date,
  int,
  mysqlEnum,
  mysqlTable,
  varchar,
} from 'drizzle-orm/mysql-core';
import { usersTable } from './user';

const attendanceType = mysqlEnum('attendance_type', [
  'GENESIS',
  'CLOCK_IN',
  'CLOCK_OUT',
]);

export const attendancesTable = mysqlTable('attendances', {
  id: int().primaryKey(),
  userId: int('user_id', {}).notNull(),
  type: attendanceType.notNull(),
  date: date({ mode: 'string' }).notNull(),
  timestamp: bigint({ mode: 'number' }).notNull(),
  hash: varchar({ length: 64 }).notNull(),
  previousHash: varchar('previous_hash', { length: 64 }).notNull(),
  nonce: int().notNull(),
});

export const attendanceRelation = relations(attendancesTable, ({ one }) => ({
  user: one(usersTable, {
    fields: [attendancesTable.userId],
    references: [usersTable.id],
  }),
}));
