import { attendancesTable } from './attendance';
import { blockchainLedgerTable } from './blockchain';
import { usersTable } from './user';

export const table = {
  user: usersTable,
  attendance: attendancesTable,
  blockchainLedger: blockchainLedgerTable,
} as const;

export type Table = typeof table;
