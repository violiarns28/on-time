// @ts-nocheck
import { BadRequestError } from '@/core/errors';
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
      const userId = user.id;
      const { date: strDate, clockOut, clockIn } = body;
      if (!clockIn && !clockOut) {
        throw new BadRequestError('Clock in or clock out is required');
      }
      const date = new Date(strDate);
      console.log('date', date);

      const findAttendance = await db.query.attendance.findFirst({
        where(fields, operators) {
          return operators.and(
            operators.eq(fields.userId, userId),
            operators.eq(fields.date, strDate),
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
            date,
            clockOut,
          });

          return {
            message: 'Clock out successfully',
            data: {
              ...findAttendance,
              clockOut,
              date: strDate,
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
          date,
        })
        .$returningId()
        .execute();

      const createAttendance = await db.query.attendance.findFirst({
        where: (fields, operators) =>
          operators.eq(fields.id, createAttendanceId[0].id),
      });

      await blockchainService.recordAttendanceAction({
        action: 'CLOCK_IN',
        attendanceId: createAttendanceId[0].id,
        userId,
        date,
        clockIn,
      });

      return {
        message: 'Clock in successfully',
        data: {
          ...createAttendance,
          date: strDate,
        },
      };
    },
    {
      body: CreateAttendanceSchema,
      response: {
        200: {
          description: 'Clock in successfully',
          ...OkResponseSchema(SelectAttendanceSchema),
        },
      },
    },
  );
