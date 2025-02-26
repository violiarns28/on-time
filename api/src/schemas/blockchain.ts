import { table } from '@/tables';
import {
  createInsertSchema,
  createSelectSchema,
  createUpdateSchema,
} from 'drizzle-typebox';
import { Static, t } from 'elysia';

export const BlockDataSchema = t.Object({
  type: t.String(),
  data: t.Object({
    attendanceId: t.Number(),
    userId: t.Number(),
    date: t.String({ format: 'date' }),
    clockIn: t.Nullable(t.String()),
    clockOut: t.Nullable(t.String()),
  }),
  timestamp: t.Number(),
});

export type BlockData = Static<typeof BlockDataSchema>;

export const SelectBlockchainLedgerSchema = createSelectSchema(
  table.blockchainLedger,
);
export const CreateBlockchainLedgerSchema = createInsertSchema(
  table.blockchainLedger,
);

export const UpdateBlockchainLedgerSchema = createUpdateSchema(
  table.blockchainLedger,
);

export type SelectBlockchainLedger = Static<
  typeof SelectBlockchainLedgerSchema
>;
export type CreateBlockchainLedger = Static<
  typeof CreateBlockchainLedgerSchema
>;
export type UpdateBlockchainLedger = Static<
  typeof UpdateBlockchainLedgerSchema
>;
