import { table } from '@/tables';
import { createInsertSchema, createSelectSchema } from 'drizzle-typebox';
import { Static, t } from 'elysia';

// const attendanceOverride = {
//   date: t.String({ format: 'date' }),
// };

export const SelectAttendanceSchema = createSelectSchema(
  table.attendance,
  // attendanceOverride,
);
const InsertAttendanceSchema = createInsertSchema(
  table.attendance,
  // attendanceOverride,
);

export const CreateAttendanceSchema = t.Omit(InsertAttendanceSchema, []);

export const BlockDataSchema = t.Omit(SelectAttendanceSchema, [
  'id',
  'hash',
  'previousHash',
  'nonce',
]);

export type SelectAttendance = Static<typeof SelectAttendanceSchema>;
export type CreateAttendance = Static<typeof CreateAttendanceSchema>;
export type BlockData = Static<typeof BlockDataSchema>;
