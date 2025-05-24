import { table } from '@/tables';
import { createInsertSchema, createSelectSchema } from 'drizzle-typebox';
import { Static, t } from 'elysia';
import { CommonModifier } from './common';

const userOverride = {
  email: t.String({ format: 'email' }),
  ...CommonModifier,
};

const _SelectUserSchema = createSelectSchema(table.user, userOverride);
export const SelectUserSchema = t.Omit(_SelectUserSchema, ['password']);

export const CreateUserSchema = createInsertSchema(table.user, userOverride);

export const UpdateUserSchema = t.Omit(CreateUserSchema, [
  'id',
  'email',
  'createdAt',
  'updatedAt',
]);

export type SelectUser = Static<typeof SelectUserSchema>;
export type CreateUser = Static<typeof CreateUserSchema>;
export type UpdateUser = Static<typeof UpdateUserSchema>;
