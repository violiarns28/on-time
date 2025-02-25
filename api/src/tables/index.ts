import { attendancesTable } from './attendance';
import { usersTable } from './user';

export const table = {
  user: usersTable,
  attendance: attendancesTable,
} as const;

export type Table = typeof table;
