import { AuthWithUserMiddleware } from '@/core/middleware/auth';
import { DatabaseService } from '@/core/services/db';
import { OkResponseSchema } from '@/schemas/response';
import { SelectUserSchema, UpdateUserSchema } from '@/schemas/user';
import { table } from '@/tables';
import { eq } from 'drizzle-orm';
import Elysia from 'elysia';

export const ProfileRouter = new Elysia({
  prefix: '/profile',
  detail: {
    tags: ['Profile'],
    security: [
      {
        BearerAuth: [],
      },
    ],
  },
})
  .use(DatabaseService)
  .use(AuthWithUserMiddleware)
  .get(
    '/me',
    async ({ getUser }) => {
      const user = await getUser();
      return {
        message: 'Find user success',
        data: {
          ...user,
          createdAt: user.createdAt?.toISOString() || null,
          updatedAt: user.updatedAt?.toISOString() || null,
        },
      };
    },
    {
      response: {
        200: {
          description: 'Find user success',
          ...OkResponseSchema(SelectUserSchema),
        },
      },
    },
  )
  .put(
    '/me',
    async ({ body, db, getUser }) =>
      await db.transaction(async (trx) => {
        console.log('body', body);
        const user = await getUser();
        if (body.name) user.name = body.name;
        if (body.password) {
          const hash = await Bun.password.hash(body.password, 'bcrypt');
          user.password = hash;
        }
        user.updatedAt = new Date();

        await trx
          .update(table.user)
          .set(user)
          .where(eq(table.user.id, user.id))
          .execute();

        return {
          message: 'Updated',
          data: {
            ...user,
            createdAt: user?.createdAt?.toISOString() || null,
            updatedAt: user?.updatedAt?.toISOString() || null,
          },
        };
      }),
    {
      body: UpdateUserSchema,
      response: {
        200: {
          description: 'Updated profile success',
          ...OkResponseSchema(SelectUserSchema),
        },
      },
    },
  );
