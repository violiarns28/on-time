import { mysqlTable, varchar, serial } from 'drizzle-orm/mysql-core';
import { CommonModifier } from './common';

export const usersTable = mysqlTable('users', {
  id: serial().primaryKey(),
  name: varchar({ length: 255 }).notNull(),
  email: varchar({ length: 255 }).notNull().unique(),
  password: varchar({ length: 255 }).notNull(),
  device_id: varchar({ length: 255 }).notNull(),
  ...CommonModifier,
});
