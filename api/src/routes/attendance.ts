import { BadRequestError } from '@/core/errors';
import { AuthWithUserMiddleware } from '@/core/middleware/auth';
import { BlockchainService } from '@/core/services/blockchain';
import { DatabaseService, drizzleClient } from '@/core/services/db';
import {
  CreateAttendanceSchema,
  SelectAttendanceSchema,
} from '@/schemas/attendance';
import { OkResponseSchema } from '@/schemas/response';
import Elysia, { t } from 'elysia';

const blockchainService = BlockchainService.getInstance();
blockchainService.initializeBlockchain(drizzleClient);
const blockchain = blockchainService.getBlockchain();

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
    '/me',
    async ({ db, getUser }) => {
      const user = await getUser();
      const userId = user.id;
      const data = blockchain.getChain();
      const attendances = data.filter((attendance) => attendance.userId === userId);
      return {
        message: 'Find attendances success',
        data: attendances,
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
  .post(
    '',
    async ({ body, db, getUser }) => {
      const user = await getUser();
      console.log('user', user);
      const userId = user.id;
      const { timestamp, type, deviceId } = body;
      if (!timestamp) {
        throw new BadRequestError('Timestamp is required');
      }

      if (!type) {
        throw new BadRequestError('Type is required');
      }

      if (deviceId !== user.deviceId) {
        throw new BadRequestError('Invalid device');
      }

      const date = new Date(timestamp).toISOString().split('T')[0];

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
  );
