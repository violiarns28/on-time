import {
  bigint,
  datetime,
  decimal,
  mysqlTable,
  serial,
  time,
} from 'drizzle-orm/mysql-core';
import { CommonModifier } from './common';
import { usersTable } from './user';

export const attendancesTable = mysqlTable('attendances', {
  id: serial().primaryKey(),
  userId: bigint('user_id', { mode: 'bigint', unsigned: true })
    .notNull()
    .references(() => usersTable.id, { onDelete: 'cascade' }),
  latitude: decimal('latitude', { precision: 12, scale: 5 }).notNull(),
  longitude: decimal('longitude', { precision: 12, scale: 5 }).notNull(),
  date: datetime('date').notNull(),
  clockIn: time('clock_in').notNull(),
  clockOut: time('clock_out'),
  ...CommonModifier,
});
