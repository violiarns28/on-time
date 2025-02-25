import { Static, t } from 'elysia';
import { CreateUserSchema, SelectUserSchema } from './user';

export const JWTSchema = t.Object({
  id: t.Number(),
  email: t.String(),
  name: t.String(),
  exp: t.Number(),
  iat: t.Number(),
});

export const LoginSchema = t.Object({
  email: t.String(),
  password: t.String(),
  device_id: t.String(),
});
export const LoginResponseSchema = t.Object({
  user: t.Omit(SelectUserSchema, ['password']),
  token: t.String(),
});

export const RegisterSchema = t
  .Omit(CreateUserSchema, ['id', 'createdAt', 'updatedAt'])
  .extend({
    device_id: t.String(),
  });
export const RegisterResponseSchema = LoginResponseSchema;

export const AuthHeaderSchema = t.Object({
  Authorization: t.Optional(t.String()),
  authorization: t.Optional(t.String()),
});

export type JWT = Static<typeof JWTSchema>;
