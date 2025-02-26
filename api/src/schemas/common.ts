import { t } from 'elysia';

export const CommonModifier = {
  createdAt: t.Nullable(t.String({ format: 'date-time' })),
  updatedAt: t.Nullable(t.String({ format: 'date-time' })),
};
