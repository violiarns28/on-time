import { BadRequestError, ServerError } from '@/core/errors';
import { AuthWithUserMiddleware } from '@/core/middleware/auth';
import { BlockchainService } from '@/core/services/blockchain';
import { DatabaseService, drizzleClient } from '@/core/services/db';
import {
  CreateAttendanceSchema,
  SelectAttendanceSchema,
} from '@/schemas/attendance';
import { SelectBlockchainLedgerSchema } from '@/schemas/blockchain';
import { OkResponseSchema } from '@/schemas/response';
import { table } from '@/tables';
import { eq } from 'drizzle-orm';
import Elysia, { t } from 'elysia';

const blockchainService = BlockchainService.getInstance();
blockchainService.initializeBlockchain(drizzleClient);
const blockchain = blockchainService.getBlockchain();
await blockchain.loadChainFromDb();

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
    '',
    async ({ getUser }) => {
      await getUser();
      await blockchain.loadChainFromDb();
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
          ...OkResponseSchema(t.Array(SelectBlockchainLedgerSchema)),
        },
      },
    },
  )
  .post(
    '',
    async ({ body, db, getUser }) => {
      const user = await getUser();
      console.log('user', user);
      const userId = user.id;
      const { date, clockOut, clockIn } = body;
      if (!clockIn && !clockOut) {
        throw new BadRequestError('Clock in or clock out is required');
      }

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
        if (findAttendance.clockIn && !findAttendance.clockOut) {
          if (!clockOut) {
            return {
              message: 'You must clock out before clocking in again',
              status: 'error',
            };
          }
          await db
            .update(table.attendance)
            .set({
              ...findAttendance,
              clockOut,
            })
            .where(eq(table.attendance.id, findAttendance.id));

          await blockchainService.recordAttendanceAction({
            action: 'CLOCK_OUT',
            attendanceId: findAttendance.id,
            userId,
            date: date,
            clockIn: null,
            clockOut,
          });

          return {
            message: 'Clock out successfully',
            data: {
              ...findAttendance,
              clockOut,
              date: date,
              createdAt: findAttendance?.createdAt?.toISOString() || null,
              updatedAt: findAttendance?.updatedAt?.toISOString() || null,
            },
          };
        }

        return {
          message: 'You have already presence today',
          status: 'error',
        };
      }

      const createAttendanceId = await db
        .insert(table.attendance)
        .values({
          ...body,
          date: date,
          userId,
        })
        .$returningId()
        .execute();

      const createAttendance = await db.query.attendance.findFirst({
        where: (fields, operators) =>
          operators.eq(fields.id, createAttendanceId[0].id),
      });

      if (!createAttendance) {
        throw new ServerError('Failed to create attendance');
      }

      await blockchainService.recordAttendanceAction({
        action: 'CLOCK_IN',
        attendanceId: createAttendanceId[0].id,
        userId,
        date: date,
        clockIn: clockIn || null,
        clockOut: null,
      });

      return {
        message: 'Clock in successfully',
        data: {
          ...createAttendance,
          date: date,
          createdAt: createAttendance?.createdAt?.toISOString() || null,
          updatedAt: createAttendance?.updatedAt?.toISOString() || null,
        },
      };
    },
    {
      body: t.Omit(CreateAttendanceSchema, ['userId']),
      response: {
        200: {
          description: 'Clock in successfully',
          ...OkResponseSchema(SelectAttendanceSchema),
        },
      },
    },
  );
