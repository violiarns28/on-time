import 'dotenv/config';
import { defineConfig } from 'drizzle-kit';
import fs from 'fs';
import { env } from 'process';

const schemaFiles = fs.readdirSync('./src/tables').filter((file) => {
  const content = fs.readFileSync(`./src/tables/${file}`, 'utf8');
  return content.includes('mysqlTable');
});

export default defineConfig({
  out: './drizzle',
  schema: schemaFiles.map((file) => `./src/tables/${file}`),
  dialect: 'mysql',
  dbCredentials: {
    host: env.DB_URL || 'localhost',
    port: env.DB_PORT || 3306,
    user: env.DB_USER || 'root',
    password: env.DB_PASSWORD || 'password',
    database: env.DB_NAME || 'myapp',
  },
});
