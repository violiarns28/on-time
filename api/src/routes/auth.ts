import { BadRequestError, ConflictError, ServerError } from '@/core/errors';
import { AuthMiddleware } from '@/core/middleware/auth';
import { BlockchainService } from '@/core/services/blockchain';
import { DatabaseService } from '@/core/services/db';
import { P2PService } from '@/core/services/p2p';
import {
  AuthHeaderSchema,
  LoginResponseSchema,
  LoginSchema,
  RegisterResponseSchema,
  RegisterSchema,
} from '@/schemas/auth';
import { OkResponseSchema } from '@/schemas/response';
import { SelectUserSchema } from '@/schemas/user';
import { table } from '@/tables';
import { password as pw } from 'bun';
import Elysia from 'elysia';

export const blockchainService = BlockchainService.getInstance();
export const p2pService = P2PService.getInstance();

export const AuthRouter = new Elysia({
  prefix: '/auth',
})
  .use(AuthMiddleware)
  .use(DatabaseService)
  .post(
    '/login',
    async ({ body, db, generateJWT }) => {
      const { email, password, deviceId } = body;
      const findUser = await db.query.user.findFirst({
        where: (fields, operators) => operators.eq(fields.email, email),
      });
      if (!findUser) {
        throw new BadRequestError('User not found');
      }

      if (!findUser.password || !password) {
        throw new BadRequestError('This account doesnt support password login');
      }

      const valid = await pw.verify(password, findUser.password, 'bcrypt');
      if (!valid) {
        throw new BadRequestError('Invalid credentials');
      }

      if (findUser.deviceId !== deviceId) {
        throw new BadRequestError('Invalid device');
      }

      const user = {
        ...findUser,
        createdAt: findUser.createdAt?.toISOString() || null,
        updatedAt: findUser.updatedAt?.toISOString() || null,
      };

      const token = await generateJWT(user);
      return {
        message: 'Login success',
        data: {
          user,
          token,
        },
      };
    },
    {
      tags: ['Authentication'],
      detail: 'This endpoint is used to login user',
      body: LoginSchema,
      response: {
        200: {
          description: 'Login success',
          ...OkResponseSchema(LoginResponseSchema),
        },
      },
    },
  )
  .post(
    '/register',
    async ({ body, db, generateJWT }) =>
      await db.transaction(async (trx) => {
        const findUser = await trx.query.user.findFirst({
          where: (fields, operators) => operators.eq(fields.email, body.email),
        });

        if (findUser) {
          throw new ConflictError('Email already registered');
        }

        if (!body.password || body.password.length < 8) {
          throw new BadRequestError('Password must be at least 8 characters');
        }

        const password = await pw.hash(body.password, 'bcrypt');
        const newUserId = await trx
          .insert(table.user)
          .values({
            ...body,
            password,
          })
          .$returningId();
        const newUser = await trx.query.user.findFirst({
          where: (fields, operators) =>
            operators.eq(fields.id, newUserId[0].id),
        });
        if (!newUser) throw new ServerError('Failed to register');
        const user = {
          ...newUser,
          createdAt: (newUser.createdAt ?? new Date()).toISOString(),
          updatedAt: (newUser.updatedAt ?? new Date()).toISOString(),
        };
        p2pService.broadcastNewUser({ ...user, password });

        const token = await generateJWT(user);

        return {
          message: 'Register success',
          data: {
            user,
            token,
          },
        };
      }),
    {
      tags: ['Authentication'],
      detail: 'This endpoint is used to register new user',
      body: RegisterSchema,
      response: {
        200: {
          description: 'Register success',
          ...OkResponseSchema(RegisterResponseSchema),
        },
      },
    },
  )
  .get(
    '/authenticate',
    async ({ bearer, jwt, db }) => {
      const claims = await jwt.verify(bearer);
      if (!claims) {
        throw new BadRequestError('Invalid token');
      }
      const findUser = await db.query.user.findFirst({
        where: (fields, operators) =>
          operators.eq(fields.id, Number(claims.id)),
      });
      if (!findUser) {
        throw new BadRequestError('User not found');
      }
      const user = {
        ...findUser,
        createdAt: findUser.createdAt?.toISOString() || null,
        updatedAt: findUser.updatedAt?.toISOString() || null,
      };
      return {
        message: 'Authenticated',
        data: user,
      };
    },
    {
      tags: ['Authentication'],
      detail:
        'This endpoint is used to authenticate user using JWT token from Authorization header',
      headers: AuthHeaderSchema,
      response: {
        200: {
          description: 'Authenticated successfully',
          ...OkResponseSchema(SelectUserSchema),
        },
      },
    },
  );
