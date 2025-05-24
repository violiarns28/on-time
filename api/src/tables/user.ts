import { mysqlTable, serial, varchar } from 'drizzle-orm/mysql-core';
import { CommonModifier } from './common';

export const usersTable = mysqlTable('users', {
  id: serial().primaryKey(),
  name: varchar({ length: 255 }).notNull(),
  email: varchar({ length: 255 }).notNull().unique(),
  password: varchar({ length: 255 }).notNull(),
  ...CommonModifier,
});
