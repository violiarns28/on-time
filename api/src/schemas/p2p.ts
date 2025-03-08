import { t } from 'elysia';

export const NodeSchema = t.Object({
  url: t.String(),
  nodeId: t.String(),
  lastSeen: t.Number(),
});
