import { Config } from '@/core/config';
import {
  AuthenticationError,
  AuthorizationError,
  BadRequestError,
  ConflictError,
  ServerError,
  StorageError,
  UnsupportedMediaTypeError,
} from '@/core/errors';
import { LoggerMiddleware } from '@/core/middleware/logger';
import cors from '@elysiajs/cors';
import { serverTiming } from '@elysiajs/server-timing';
import { swagger } from '@elysiajs/swagger';
import { Elysia, ValidationError } from 'elysia';
import { AppRouter } from './routes/_router';

process.env.TZ = "Asia/Jakarta";

const app = new Elysia({
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
      console.error('<=============== ERROR ===============>');
      console.log('[ROUTE] : ', route);
      console.log('[PATH] : ', path);
      console.log('[ERROR] : ', error);
      console.error('<=============== ERROR ===============>');

      let httpCode;
      switch (code) {
        case 'PARSE':
        case 'BAD_REQUEST':
          httpCode = 400;
          break;
        case 'CONFLICT':
          httpCode= 409;
          break;
        case 'UNSUPPORTED_MEDIA_TYPE':
          httpCode = 415;
          break;
        case 'VALIDATION':
          httpCode = 422;
          break;
        case 'NOT_FOUND':
          httpCode = 404;
          break;
        case 'INVALID_COOKIE_SIGNATURE':
        case 'AUTHENTICATION':
        case 'AUTHORIZATION':
          httpCode = 401;
          break;
        case 'INTERNAL_SERVER_ERROR':
        case 'UNKNOWN':
          httpCode = 500;
          break;
        default:
          httpCode = 500;
          break;
      }
      set.status = httpCode;
      const errorType = 'type' in error ? error.type : 'internal';
      if (code == 'VALIDATION') {
        return { errors: error.all.map((e)=> e.summary) };
      }
      return Response.json(
        {
          errors: error,
          type: errorType,
        },
        { status: httpCode },
      );
    } catch (error) {
      console.log(error);

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
  .use(AppRouter);

app.listen(Config.PORT, () => {
  console.log(`Server listening on port ${Config.PORT}`);
});
