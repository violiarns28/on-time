import { BadRequestError } from '@/core/errors';
import { AuthWithUserMiddleware } from '@/core/middleware/auth';
import { DatabaseService } from '@/core/services/db';
import {
  CreateAttendanceSchema,
  SelectAttendanceSchema,
} from '@/schemas/attendance';
import { OkResponseSchema } from '@/schemas/response';
import { table } from '@/tables';
import { sql } from 'drizzle-orm';
import Elysia, { t } from 'elysia';
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
    async ({ body, db, getUser }) => {
      const user = await getUser();
      console.log('user', user);
      const userId = user.id;
      const { type, deviceId } = body;

      if (!type) {
        throw new BadRequestError('Type is required');
      }
      console.log('Type', type);

      if (deviceId !== user.deviceId) {
        throw new BadRequestError('Invalid device');
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

      console.log('findAttendance', findAttendance);

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
            latitude: body.latitude.toString(),
            longitude: body.longitude.toString(),
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
        latitude: body.latitude.toString(),
        longitude: body.longitude.toString(),
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
        t.Object({
          deviceId: t.String(),
        }),
      ]),
      response: {
        200: {
          description: 'Clock in successfully',
          ...OkResponseSchema(SelectAttendanceSchema),
        },
      },
    },
  )
  .post(
    '/simulate',
    // Optimized router implementation for faster response times
    async ({ body, db }) => {
      // Wrap the DB query in a Promise.race with a timeout
      const getUserPromise = db
        .select()
        .from(table.user)
        .orderBy(sql`RAND()`)
        .limit(1)
        .execute();

      // Use a timeout to ensure we don't get stuck waiting for DB
      const timeoutPromise = new Promise((_, reject) => {
        setTimeout(() => reject(new Error('Database query timed out')), 1000);
      });

      try {
        // Use Promise.race to get result from either DB query or timeout
        const [user] = (await Promise.race([
          getUserPromise,
          timeoutPromise,
        ])) as any;
        const userId = user.id;
        const { type } = body;

        if (!type) {
          throw new BadRequestError('Type is required');
        }

        const now = new Date();
        const date = now.toISOString().split('T')[0];

        // Only check for existing attendance if absolutely necessary
        // This can be optimized further by caching attendance records
        const findAttendancePromise = await db.query.attendance.findFirst({
          where(fields, operators) {
            return operators.and(
              operators.eq(fields.userId, userId),
              operators.eq(fields.date, date),
            );
          },
        });

        const findAttendance = await Promise.race([
          findAttendancePromise,
          new Promise((_, reject) =>
            setTimeout(
              () => reject(new Error('Attendance query timed out')),
              1000,
            ),
          ),
        ]);

        // Prepare the attendance data immediately
        const attendanceData = {
          ...body,
          type:
            findAttendance?.type === 'CLOCK_IN' && type === 'CLOCK_OUT'
              ? 'CLOCK_OUT'
              : 'CLOCK_IN',
          date,
          userId,
          timestamp: now.getTime(),
          userName: user.name,
          latitude: body.latitude.toString(),
          longitude: body.longitude.toString(),
        };

        // If user already has attendance and trying to clock in again, return error
        if (
          findAttendance &&
          !(findAttendance.type === 'CLOCK_IN' && type === 'CLOCK_OUT')
        ) {
          return {
            message: 'You have already presence today',
            status: 'error',
          };
        }

        // Get fast response with placeholder block
        const placeholderBlock =
          await blockchainService.recordAttendanceAction(attendanceData);

        return {
          message: `${attendanceData.type === 'CLOCK_IN' ? 'Clock in' : 'Clock out'} successfully queued`,
          data: placeholderBlock,
          status: 'pending',
        };
      } catch (error) {
        console.error('Error processing attendance:', error);

        // Provide a fallback response if DB queries fail
        // This ensures the API still responds quickly even if the DB is slow
        return {
          message: 'Attendance request received but processing delayed',
          status: 'delayed',
          error: error instanceof Error ? error.message : 'Unknown error',
        };
      }
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
          'latitude',
          'longitude',
        ]),
        t.Object({
          deviceId: t.String(),
          latitude: t.String(),
          longitude: t.String(),
        }),
      ]),
      response: {
        200: {
          description: 'Attendance action processed',
          ...OkResponseSchema(
            t.Intersect([
              SelectAttendanceSchema,
              t.Object({
                status: t.Optional(t.String()),
              }),
            ]),
          ),
        },
      },
    },
  );
