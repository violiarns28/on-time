import { table } from '@/tables';
import {
  createInsertSchema,
  createSelectSchema,
  createUpdateSchema,
} from 'drizzle-typebox';
import { Static, t } from 'elysia';

export const SelectAttendanceSchema = createSelectSchema(table.attendance);
export const CreateAttendanceSchema = createInsertSchema(table.attendance, {
  user_id: t.String({ minLength: 1 }),
  latitude: t.String({ pattern: '^-?\d{1,7}\.\d{1,5}$' }),
  longitude: t.String({ pattern: '^-?\d{1,7}\.\d{1,5}$' }),
  date: t.String({ format: 'date-time' }),
  clock_in: t.String({ pattern: '^\d{2}:\d{2}:\d{2}$' }),
  clock_out: t.Optional(t.String({ pattern: '^\d{2}:\d{2}:\d{2}$' })),
});

export const UpdateAttendanceSchema = createUpdateSchema(table.attendance);

export type SelectAttendance = Static<typeof SelectAttendanceSchema>;
export type CreateAttendance = Static<typeof CreateAttendanceSchema>;
export type UpdateAttendance = Static<typeof UpdateAttendanceSchema>;
