// import {
//   CreateAttendanceSchema,
//   SelectAttendanceSchema,
// } from '@/schemas/attendance';
// import { OkResponseSchema } from '@/schemas/response';
// import Elysia from 'elysia';

// export const AttendanceRouter = new Elysia().prefix('all', '/attendance').post(
//   '/attendance',
//   async ({ body, db }) => {
//     const { user_id, latitude, longitude, date, clock_in, clock_out } = body;

//     const existingAttendance = await db.query.attendance.findFirst({
//       where: { user_id, date },
//     });

//     if (existingAttendance) {
//       if (existingAttendance.clock_in && !existingAttendance.clock_out) {
//         if (!clock_out) {
//           return {
//             message: 'You must clock out before clocking in again',
//             status: 'error',
//           };
//         }

//         const updatedAttendance = await db.query.attendance.update({
//           where: { id: existingAttendance.id },
//           data: { clock_out },
//         });

//         return {
//           message: 'Clock out successfully',
//           data: updatedAttendance,
//         };
//       }

//       return {
//         message: 'You have already presence today',
//         status: 'error',
//       };
//     }

//     const createAttendance = await db.query.attendance.create({
//       data: {
//         user_id,
//         latitude,
//         longitude,
//         date,
//         clock_in,
//       },
//     });

//     return {
//       message: 'Clock in successfully',
//       data: createAttendance,
//     };
//   },
//   {
//     tags: ['Attendance'],
//     detail: 'This endpoint is used to clock in or clock out',
//     body: CreateAttendanceSchema,
//     response: { 200: OkResponseSchema(SelectAttendanceSchema) },
//   },
// );
