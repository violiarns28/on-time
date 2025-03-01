import {
  bigint,
  date,
  decimal,
  int,
  mysqlEnum,
  mysqlTable,
  varchar,
} from 'drizzle-orm/mysql-core';

const attendanceType = mysqlEnum('attendance_type', [
  'GENESIS',
  'CLOCK_IN',
  'CLOCK_OUT',
]);

export const attendancesTable = mysqlTable('attendances', {
  id: int().primaryKey(),
  userId: int('user_id', {}).notNull(),
  latitude: decimal('latitude', { precision: 12, scale: 5 }).notNull(),
  longitude: decimal('longitude', { precision: 12, scale: 5 }).notNull(),
  type: attendanceType.notNull(),
  date: date({ mode: 'string' }).notNull(),
  timestamp: bigint({ mode: 'number' }).notNull(),
  hash: varchar({ length: 64 }).notNull(),
  previousHash: varchar('previous_hash', { length: 64 }).notNull(),
  nonce: int().notNull(),
});
