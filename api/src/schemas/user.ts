import { table } from '@/tables';
import {
  createInsertSchema,
  createSelectSchema,
  createUpdateSchema,
} from 'drizzle-typebox';
import { Static, t } from 'elysia';
const user = createSelectSchema(table.user);
export const SelectUserSchema = t.Omit(user, ['password']);
export const CreateUserSchema = createInsertSchema(table.user, {
  email: t.String({ format: 'email' }),
  device_id: t.String(),
});

export const UpdateUserSchema = createUpdateSchema(table.user);

export type SelectUser = Static<typeof SelectUserSchema>;
export type CreateUser = Static<typeof CreateUserSchema>;
export type UpdateUser = Static<typeof UpdateUserSchema>;
