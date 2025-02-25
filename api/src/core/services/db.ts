import { table } from '@/tables';
import { drizzle } from 'drizzle-orm/mysql2';
import Elysia from 'elysia';
import mysql from 'mysql2/promise';
import { Config } from '../config';

const client = mysql.createPool({
  host: Config.DB.URL,
  port: Config.DB.PORT,
  user: Config.DB.USER,
  password: Config.DB.PASSWORD,
  database: Config.DB.DATABASE,
});

export const drizzleClient = drizzle({
  client,
  schema: table,
  mode: 'default',
});

export type Database = typeof drizzleClient;

export const DatabaseService = new Elysia().derive({ as: 'global' }, () => ({
  db: drizzleClient,
}));
