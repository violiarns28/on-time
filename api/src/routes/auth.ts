import { BadRequestError, ServerError } from '@/core/errors';
import { AuthMiddleware } from '@/core/middleware/auth';
import { DatabaseService } from '@/core/services/db';
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
import { sanitize } from '@/utils';
import Elysia from 'elysia';

export const AuthRouter = new Elysia()
  .prefix('all', '/auth')
  .use(AuthMiddleware)
  .use(DatabaseService)
  .post(
    '/login',
    async ({ body, db, generateJWT }) => {
      const { email, password, device_id } = body;
      const findUser = await db.query.user.findFirst({
        where: (fields, operators) => operators.eq(fields.email, email),
      });
      if (!findUser) {
        throw new BadRequestError('User not found');
      }

      if (!findUser.password || !password) {
        throw new BadRequestError('This account doesnt support password login');
      }

      const valid = await Bun.password.verify(
        password,
        findUser.password,
        'bcrypt',
      );
      if (!valid) {
        throw new BadRequestError('Invalid password');
      }

      const token = await generateJWT(findUser);
      return {
        message: 'Login success',
        data: {
          user: findUser,
          token,
        },
      };
    },
    {
      tags: ['Authentication'],
      detail: 'This endpoint is used to login user',
      body: LoginSchema,
      response: { 200: OkResponseSchema(LoginResponseSchema) },
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
          throw new BadRequestError('Email already registered');
        }

        if (!body.password || body.password.length < 8) {
          throw new BadRequestError('Password must be at least 8 characters');
        }

        const password = await Bun.password.hash(body.password, 'bcrypt');
        const newUserId = await trx
          .insert(table.user)
          .values({ ...body, password })
          .$returningId();
        const newUser = await trx.query.user.findFirst({
          where: (fields, operators) =>
            operators.eq(fields.id, newUserId[0].id),
        });
        if (!newUser) throw new ServerError('Failed to register');
        const token = await generateJWT(newUser);

        return {
          message: 'Register success',
          data: {
            user: sanitize(newUser, ['password']),
            token,
          },
        };
      }),
    {
      tags: ['Authentication'],
      detail: 'This endpoint is used to register new user',
      body: RegisterSchema,
      response: { 200: OkResponseSchema(RegisterResponseSchema) },
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
      return {
        message: 'Authenticated',
        data: findUser,
      };
    },
    {
      tags: ['Authentication'],
      detail:
        'This endpoint is used to authenticate user using JWT token from Authorization header',
      headers: AuthHeaderSchema,
      response: { 200: OkResponseSchema(SelectUserSchema) },
    },
  );
