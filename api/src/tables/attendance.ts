import {
  mysqlTable,
  decimal,
  datetime,
  time,
  serial,
  bigint,
} from 'drizzle-orm/mysql-core';
import { usersTable } from './user';
import { CommonModifier } from './common';

export const attendancesTable = mysqlTable('attendances', {
  id: serial().primaryKey(),
  user_id: bigint({ mode: 'bigint', unsigned: true })
    .notNull()
    .references(() => usersTable.id, { onDelete: 'cascade' }),

  latitude: decimal('latitude', { precision: 12, scale: 5 }).notNull(),
  longitude: decimal('longitude', { precision: 12, scale: 5 }).notNull(),
  date: datetime('date').notNull(),
  clock_in: time('clock_in').notNull(),
  clock_out: time('clock_out'),
  ...CommonModifier,
});
