import { table } from '@/tables';
import { createInsertSchema, createSelectSchema } from 'drizzle-typebox';
import { Static, t } from 'elysia';
import { CommonModifier } from './common';

const attendanceOverride = {
  date: t.String({ format: 'date' }),
  ...CommonModifier,
};

export const SelectAttendanceSchema = createSelectSchema(
  table.attendance,
  attendanceOverride,
);
const InsertAttendanceSchema = createInsertSchema(
  table.attendance,
  attendanceOverride,
);

export const CreateAttendanceSchema = t.Omit(InsertAttendanceSchema, [
  'id',
  'createdAt',
  'updatedAt',
]);

export type SelectAttendance = Static<typeof SelectAttendanceSchema>;
export type CreateAttendance = Static<typeof CreateAttendanceSchema>;
