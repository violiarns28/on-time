import { table } from '@/tables';
import {
  createInsertSchema,
  createSelectSchema,
  createUpdateSchema,
} from 'drizzle-typebox';
import { Static, t } from 'elysia';

export const BlockDataSchema = t.Object({
  action: t.String(),
  attendanceId: t.Number(),
  userId: t.Number(),
  date: t.String({ format: 'date' }),
  clockIn: t.Nullable(t.String()),
  clockOut: t.Nullable(t.String()),
});

export type BlockData = Static<typeof BlockDataSchema>;

const blockchainLedgerOverride = {
  timestamp: t.String({ format: 'date-time' }),
};

export const SelectBlockchainLedgerSchema = createSelectSchema(
  table.blockchainLedger,
  blockchainLedgerOverride,
);
export const CreateBlockchainLedgerSchema = createInsertSchema(
  table.blockchainLedger,
  blockchainLedgerOverride,
);

export const UpdateBlockchainLedgerSchema = createUpdateSchema(
  table.blockchainLedger,
  blockchainLedgerOverride,
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
