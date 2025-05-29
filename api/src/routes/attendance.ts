import { BadRequestError } from '@/core/errors';
import { AuthWithUserMiddleware } from '@/core/middleware/auth';
import { DatabaseService } from '@/core/services/db';
import {
  CreateAttendanceSchema,
  SelectAttendanceSchema,
} from '@/schemas/attendance';
import { OkResponseSchema } from '@/schemas/response';
import { table } from '@/tables';
import { attendancesTable } from '@/tables/attendance';
import { format } from '@fast-csv/format';
import { sql } from 'drizzle-orm';
import Elysia, { t } from 'elysia';
import { PassThrough } from 'stream';
import { blockchain, blockchainService } from '..';
export const AttendanceRouter = new Elysia({
  prefix: '/attendances',
  detail: {
    tags: ['Attendance'],
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
    '/',
    async ({ getUser }) => {
      await getUser();
      const data = blockchain.getChain();
      return {
        message: 'Find attendances success',
        data,
      };
    },
    {
      response: {
        200: {
          description: 'Find attendances success',
          ...OkResponseSchema(t.Array(SelectAttendanceSchema)),
        },
      },
    },
  )
  .get(
    '/me/latest',
    async ({ getUser, query }) => {
      const user = await getUser();
      const userId = user.id;
      const data = blockchain.getChain();
      const attendances = data.filter(
        (attendance) =>
          attendance.userId === userId && attendance.type === query.type,
      );
      if (!attendances.length) {
        return {
          message: 'Find latest attendance success',
          data: null,
        };
      }
      const latestAttendance = attendances[attendances.length - 1];
      return {
        message: 'Find latest attendance success',
        data: latestAttendance,
      };
    },
    {
      response: {
        200: {
          description: 'Find latest attendance success',
          ...OkResponseSchema(t.Union([SelectAttendanceSchema, t.Null()])),
        },
      },
      query: t.Pick(SelectAttendanceSchema, ['type']),
    },
  )
  .post(
    '/',
    async ({ body, db, getUser, set }) => {
      const user = await getUser();
      const userId = user.id;
      const { type } = body;

      if (!type) {
        throw new BadRequestError('Type is required');
      }
      const now = new Date();

      const date = now.toISOString().split('T')[0];

      const findAttendance = await db.query.attendance.findFirst({
        where(fields, operators) {
          return operators.and(
            operators.eq(fields.userId, userId),
            operators.eq(fields.date, date),
          );
        },
      });
      if (findAttendance) {
        if (findAttendance.type === type) {
          throw new BadRequestError(
            `You have already clocked ${type === 'CLOCK_IN' ? 'in' : 'out'} today`,
          );
        }
        if (findAttendance.type === 'CLOCK_IN' && type === 'CLOCK_OUT') {
          const result = await blockchainService.recordAttendanceAction({
            ...body,
            type: 'CLOCK_OUT',
            date,
            userId,
            timestamp: now.getTime(),
            userName: user.name,
          });

          set.status = 201;
          return {
            message: 'Clock out successfully',
            data: result,
          };
        }

        return {
          message: 'You have already presence today',
          status: 'error',
        };
      }

      const result = await blockchainService.recordAttendanceAction({
        ...body,
        type: 'CLOCK_IN',
        date,
        userId,
        timestamp: now.getTime(),
        userName: user.name,
      });

      set.status = 201;
      return {
        message: 'Clock in successfully',
        data: result,
      };
    },
    {
      body: t.Intersect([
        t.Omit(CreateAttendanceSchema, [
          'id',
          'userId',
          'date',
          'hash',
          'previousHash',
          'timestamp',
          'nonce',
        ]),
      ]),
      response: {
        201: {
          description: 'Clock in successfully',
          ...OkResponseSchema(SelectAttendanceSchema),
        },
      },
    },
  )
  .post(
    '/simulate',
    async ({ body, db }) => {
      const user = (
        await db
          .select()
          .from(table.user)
          .orderBy(sql`RAND()`)
          .limit(1)
          .execute()
      )[0];
      const userId = user.id;
      const { type } = body;

      if (!type) {
        throw new BadRequestError('Type is required');
      }

      const now = new Date();

      const date = now.toISOString().split('T')[0];

      const findAttendance = await db.query.attendance.findFirst({
        where(fields, operators) {
          return operators.and(
            operators.eq(fields.userId, userId),
            operators.eq(fields.date, date),
          );
        },
      });

      if (findAttendance) {
        if (findAttendance.type === 'CLOCK_IN' && type === 'CLOCK_OUT') {
          const result = await blockchainService.recordAttendanceAction({
            ...body,
            type: 'CLOCK_OUT',
            date,
            userId,
            timestamp: now.getTime(),
            userName: user.name,
          });

          return {
            message: 'Clock out successfully',
            data: result,
          };
        }

        return {
          message: 'You have already presence today',
          status: 'error',
        };
      }

      const result = await blockchainService.recordAttendanceAction({
        ...body,
        type: 'CLOCK_IN',
        date,
        userId,
        userName: user.name,
        timestamp: now.getTime(),
      });

      return {
        message: 'Clock in successfully',
        data: result,
      };
    },
    {
      body: t.Intersect([
        t.Omit(CreateAttendanceSchema, [
          'id',
          'userId',
          'date',
          'hash',
          'previousHash',
          'timestamp',
          'nonce',
        ]),
      ]),
      response: {
        200: {
          description: 'Clock in successfully',
          ...OkResponseSchema(SelectAttendanceSchema),
        },
      },
    },
  )
  .get('/export', async ({ set, db }) => {
    // 1. Get all data
    const rows = await db.select().from(attendancesTable);

    // 2. Create CSV stream
    const csvStream = format({ headers: true });

    // 3. Pipe the data into the stream
    const passThrough = new PassThrough();
    csvStream.pipe(passThrough);

    for (const row of rows) {
      csvStream.write({
        id: row.id,
        userId: row.userId,
        type: row.type,
        date: row.date,
        timestamp: row.timestamp,
        hash: row.hash,
        previousHash: row.previousHash,
        nonce: row.nonce,
      });
    }

    csvStream.end();

    // 4. Set headers to force download
    set.headers['Content-Type'] = 'text/csv';
    set.headers['Content-Disposition'] =
      'attachment; filename="attendance_export.csv"';

    return passThrough;
  });
