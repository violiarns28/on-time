import { AuthWithUserMiddleware } from '@/core/middleware/auth';
import { DatabaseService } from '@/core/services/db';
import { OkResponseSchema } from '@/schemas/response';
import { SelectUserSchema, UpdateUserSchema } from '@/schemas/user';
import { table } from '@/tables';
import { eq } from 'drizzle-orm';
import Elysia from 'elysia';

export const ProfileRouter = new Elysia()
  .prefix('all', '/profile')
  .use(DatabaseService)
  .use(AuthWithUserMiddleware)
  .get(
    '/me',
    async ({ getUser }) => {
      const user = await getUser();
      return {
        message: 'Find user success',
        data: user,
      };
    },
    {
      tags: ['Profile'],
      detail: 'This endpoint is used to get user profile',
      response: { 200: OkResponseSchema(SelectUserSchema) },
    },
  )
  .post(
    '/me',
    async ({ body, db, getUser }) =>
      await db.transaction(async (trx) => {
        console.log('body', body);
        const user = await getUser();
        if (body.email) user.email = body.email;
        if (body.name) user.name = body.name;
        if (body.password) user.password = body.password;
        if (body.deviceId) user.deviceId = body.deviceId;

        await trx
          .update(table.user)
          .set(user)
          .where(eq(table.user.id, user.id))
          .execute();

        return {
          message: 'Updated',
          data: user,
        };
      }),
    {
      tags: ['Profile'],
      detail: 'This endpoint is used to update user profile',
      body: UpdateUserSchema,
      response: { 200: OkResponseSchema(SelectUserSchema) },
    },
  );
