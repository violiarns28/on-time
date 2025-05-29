import { Config } from '@/core/config';
import { env } from '@/core/config/env';
import {
  AuthenticationError,
  AuthorizationError,
  BadRequestError,
  BaseError,
  ConflictError,
  ServerError,
  StorageError,
  UnsupportedMediaTypeError,
} from '@/core/errors';
import { LoggerMiddleware } from '@/core/middleware/logger';
import { BlockchainService } from '@/core/services/blockchain';
import { drizzleClient } from '@/core/services/db';
import { P2PService } from '@/core/services/p2p';
import { redisClient } from '@/core/services/redis';
import { AppRouter } from '@/routes/_router';
import { logger } from '@/utils/logger';
import cors from '@elysiajs/cors';
import { serverTiming } from '@elysiajs/server-timing';
import { swagger } from '@elysiajs/swagger';
import { Elysia, ValidationError } from 'elysia';

process.env.TZ = 'Asia/Jakarta';

export const blockchainService = BlockchainService.getInstance();
blockchainService.initializeBlockchain(drizzleClient, redisClient);
export const blockchain = blockchainService.getBlockchain();

export const p2pService = P2PService.getInstance();
p2pService.initialize(blockchainService, drizzleClient, 6001);
if (env.IS_SLAVE_NODE) p2pService.addPeer(env.MASTER_NODE_URL_WS);

export const app = new Elysia({
  name: Config.NAME,
})
  .error({
    AUTHENTICATION: AuthenticationError,
    AUTHORIZATION: AuthorizationError,
    BAD_REQUEST: BadRequestError,
    VALIDATION: ValidationError,
    CONFLICT: ConflictError,
    STORAGE: StorageError,
    SERVER: ServerError,
    UNKNOWN: ServerError,
    INVALID_OPERATION: BadRequestError,
    UNSUPPORTED_MEDIA_TYPE: UnsupportedMediaTypeError,
  })
  .onError(({ error, code, set, route, path }) => {
    try {
      logger.error('<=============== ERROR ===============>');
      logger.info('[ROUTE] : ', route);
      logger.info('[PATH] : ', path);
      logger.info('[ERROR] : ', error);
      logger.info('[CODE] : ', code);
      logger.error('<=============== ERROR ===============>');

      let httpCode;
      if (error instanceof BaseError) {
        httpCode = error.status;
        logger.info('[HTTP CODE] : ', httpCode);
      }
      set.status = httpCode;
      const errorType = 'type' in error ? error.type : 'internal';
      if (code == 'VALIDATION') {
        return { errors: error.all.map((e) => e.summary) };
      }
      return Response.json(
        {
          errors: error,
          type: errorType,
        },
        { status: httpCode },
      );
    } catch (error) {
      logger.info(error);

      return { errors: 'Internal server error', type: 'internal' };
    }
  })
  .use(LoggerMiddleware)
  .use(serverTiming())
  .use(cors())
  .use(
    swagger({
      documentation: {
        info: {
          title: Config.NAME,
          version: Config.VERSION,
        },
        components: {
          securitySchemes: {
            BearerAuth: {
              type: 'http',
              scheme: 'bearer',
              bearerFormat: 'JWT',
            },
          },
        },
      },
    }),
  )
  .use(AppRouter)
  .onStop(() => {
    blockchain.shutdown();
    p2pService.shutdown();
  });

app.listen(Config.PORT, () => {
  logger.info(`Server listening on port ${Config.PORT}`);
});
