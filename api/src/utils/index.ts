import { getTableColumns, SQL, sql } from 'drizzle-orm';
import { MySqlTable } from 'drizzle-orm/mysql-core';
export const DEFAULT = Symbol();

export class MapWithDefault<K, V> extends Map<K | typeof DEFAULT, V> {
  get(key: K): V {
    return super.get(key) ?? (super.get(DEFAULT) as V);
  }
}
export function sanitize(
  obj: any,
  exceptsNotation: string[],
  deleteOperation = false,
) {
  const result: any = {};
  Object.keys(obj).forEach((key) => {
    if (deleteOperation) {
      if (exceptsNotation.includes(key)) {
        delete obj[key];
      }
    } else {
      if (!exceptsNotation.includes(key)) {
        result[key] = obj[key];
      }
    }
  });
  return result;
}

export function normalizeMetaString(str: string) {
  return str
    .split('-')
    .map((word) => word[0].toUpperCase() + word.slice(1))
    .join(' ');
}

export const buildConflictUpdateColumns = <
  T extends MySqlTable,
  Q extends keyof T['_']['columns'],
>(
  table: T,
  columns: Q[],
) => {
  const cls = getTableColumns(table);
  return columns.reduce(
    (acc, column) => {
      acc[column] = sql`values(${cls[column]})`;
      return acc;
    },
    {} as Record<Q, SQL>,
  );
};
