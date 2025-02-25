import { table } from '@/tables';
import {
  createInsertSchema,
  createSelectSchema,
  createUpdateSchema,
} from 'drizzle-typebox';
import { Static } from 'elysia';

export const SelectAttendanceSchema = createSelectSchema(table.attendance);
export const CreateAttendanceSchema = createInsertSchema(table.attendance);

export const UpdateAttendanceSchema = createUpdateSchema(table.attendance);

export type SelectAttendance = Static<typeof SelectAttendanceSchema>;
export type CreateAttendance = Static<typeof CreateAttendanceSchema>;
export type UpdateAttendance = Static<typeof UpdateAttendanceSchema>;
