import { sql } from 'drizzle-orm';
import { timestamp } from 'drizzle-orm/mysql-core';

export const CommonModifier = {
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at')
    .defaultNow()
    .$onUpdateFn(() => sql`NOW()`),
};
