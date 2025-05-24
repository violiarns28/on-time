import { table } from '@/tables';
import { createInsertSchema, createSelectSchema } from 'drizzle-typebox';
import { Static, t } from 'elysia';

// const attendanceOverride = {
//   date: t.String({ format: 'date' }),
// };

const _SelectAttendanceSchema = createSelectSchema(table.attendance);
export const SelectAttendanceSchema = t.Composite([
  _SelectAttendanceSchema,
  t.Object({
    userName: t.String(),
  }),
]);
const InsertAttendanceSchema = createInsertSchema(table.attendance);

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
