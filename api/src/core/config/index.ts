import { normalizeMetaString } from '@/utils';
import { env } from 'bun';
import fs from 'fs';
import { Options } from 'logixlysia/src/types';

const meta = JSON.parse(fs.readFileSync('./package.json', 'utf8'));

const LoggerOptions: Options = {
  config: {
    showStartupMessage: true,
    startupMessageFormat: 'simple',
    timestamp: {
      translateTime: 'yyyy-mm-dd HH:MM:ss',
    },
    ip: true,
    logFilePath: './logs/example.log',
    customLogFormat:
      '🦊 {now} {level} {duration} {method} {pathname} {status} {message} {ip} {epoch}',
  },
} as const;

export const Database = {
  URL: env.DB_URL || 'localhost',
  PORT: parseInt(env.DB_PORT) || 3306,
  USER: env.DB_USER || 'postgres',
  PASSWORD: env.DB_PASSWORD || 'password',
  DATABASE: env.DB_NAME || 'myapp',
  MAX: 20,
} as const;

export const Redis = {
  HOST: env.REDIS_HOST || 'localhost',
  PORT: parseInt(env.REDIS_PORT) || 6379,
} as const;

export const Config = {
  NAME: normalizeMetaString(meta.name),
  VERSION: meta.version,
  PORT: env.API_PORT || 3000,
  JWT_SECRET: env.JWT_SECRET || 'secret',
  JWT_EXPIRES_IN: Math.floor(Date.now() / 1000) + 30 * 86400, // 30 days
  DB: Database,
  Redis,
  Logger: LoggerOptions,
} as const;
