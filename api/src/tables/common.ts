import { sql } from 'drizzle-orm';
import { timestamp } from 'drizzle-orm/mysql-core';

export const CommonModifier = {
  created_at: timestamp('created_at').defaultNow(),
  updated_at: timestamp('updated_at')
    .defaultNow()
    .$onUpdateFn(() => sql`NOW()`),
};
