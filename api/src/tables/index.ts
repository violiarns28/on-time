import { attendancesTable } from './attendance';
import { usersTable } from './user';

export const table = {
  user: usersTable,
  attendance: attendancesTable,
  // blockchainLedger: blockchainLedgerTable,
} as const;

export type Table = typeof table;
