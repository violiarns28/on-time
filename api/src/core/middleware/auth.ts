import { JWT } from '@/schemas/auth';
import { SelectUser } from '@/schemas/user';
import { bearer } from '@elysiajs/bearer';
import jwt, { JWTPayloadSpec } from '@elysiajs/jwt';
import Elysia from 'elysia';
import { Config } from '../config';
import { AuthenticationError, AuthorizationError } from '../errors';
import { DatabaseService } from '../services/db';

export const AuthMiddleware = new Elysia()
  .use(bearer())
  .use(
    jwt({
      name: 'jwt',
      secret: Config.JWT_SECRET,
    }),
  )
  .derive({ as: 'global' }, ({ jwt, bearer, cookie: { auth } }) => ({
    async verifyJWT() {
      if (!bearer) throw new AuthorizationError('Unauthorized');
      const verify = await jwt.verify(bearer);
      if (!verify) throw new AuthenticationError('Invalid token');
      return verify as JWT & Record<string, string | number> & JWTPayloadSpec;
    },
    async generateJWT(user: SelectUser) {
      const token = await jwt.sign({
        id: user.id,
        email: user.email,
        name: user.name,
        exp: Config.JWT_EXPIRES_IN, // 30 days
        iat: Math.floor(Date.now() / 1000),
      });
      auth.set({
        value: token,
        httpOnly: true,
        maxAge: 30 * 86400, // 30 days
      });
      return token;
    },
  }));

export const AuthWithUserMiddleware = new Elysia()
  .use(DatabaseService)
  .use(AuthMiddleware)
  .derive({ as: 'global' }, async ({ verifyJWT, db }) => ({
    async getUser() {
      const verified = await verifyJWT();
      if (!verified) throw new AuthenticationError('Invalid token');
      const user = await db.query.user.findFirst({
        where: (fields, operators) => operators.eq(fields.id, verified.id),
      });
      if (!user) throw new AuthenticationError('User not found');
      return user;
    },
  }));
