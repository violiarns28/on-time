import { table } from '@/tables';
import {
  createInsertSchema,
  createSelectSchema,
  createUpdateSchema,
} from 'drizzle-typebox';
import { Static } from 'elysia';

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
