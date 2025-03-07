import { Redis } from 'ioredis';
import { Config } from '../config';

export const redisClient = new Redis({
  host: Config.Redis.HOST,
  port: Config.Redis.PORT,
});
