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

export const AttendanceRouter = new Elysia()
  .prefix('all', '/attendances')
  .use(DatabaseService)
  .use(AuthWithUserMiddleware)
  .get(
    '',
    async () => {
      const data = blockchain.getChain();

      return {
        message: 'Find attendances success',
        data,
      };
    },
    {
      tags: ['Attendance'],
      detail: 'This endpoint is used to get all attendances',
      response: {
        200: OkResponseSchema(t.Array(SelectBlockchainLedgerSchema)),
      },
    },
  )
  .post(
    '',
    async ({ body, db }) => {
      const { userId, date, clockOut, clockIn } = body;

      const findAttendance = await db.query.attendance.findFirst({
        where(fields, operators) {
          return operators.and(
            operators.eq(fields.userId, userId),
            operators.eq(fields.date, date),
          );
        },
      });

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
            .set({ clockOut })
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
        .values(body)
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
        data: createAttendance,
      };
    },
    {
      tags: ['Attendance'],
      detail: 'This endpoint is used to clock in or clock out',
      body: CreateAttendanceSchema,
      response: { 200: OkResponseSchema(SelectAttendanceSchema) },
    },
  );
