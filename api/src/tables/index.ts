import { attendanceRelation, attendancesTable } from './attendance';
import { usersTable } from './user';

export const table = {
  user: usersTable,
  attendance: attendancesTable,
  attendanceRelation,
  // blockchainLedger: blockchainLedgerTable,
} as const;

export type Table = typeof table;
