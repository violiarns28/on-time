import { table } from '@/tables';
import { createInsertSchema, createSelectSchema } from 'drizzle-typebox';
import { Static, t } from 'elysia';

const attendanceOvveride = {
  date: t.String({ format: 'date' }),
};

export const SelectAttendanceSchema = createSelectSchema(
  table.attendance,
  attendanceOvveride,
);
const InsertAttendanceSchema = createInsertSchema(
  table.attendance,
  attendanceOvveride,
);

export const CreateAttendanceSchema = t.Omit(InsertAttendanceSchema, [
  'id',
  'createdAt',
  'updatedAt',
]);

export type SelectAttendance = Static<typeof SelectAttendanceSchema>;
export type CreateAttendance = Static<typeof CreateAttendanceSchema>;
