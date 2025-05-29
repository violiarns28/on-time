// dbUtils.ts
import { drizzleClient } from '@/core/services/db';
import { RegisterSchema } from '@/schemas/auth';
import { table } from '@/tables';
import { generateJWT } from '@/utils/jwt';
import { eq, not } from 'drizzle-orm';
import { Static } from 'elysia';

type CreateTestUserParams = Static<typeof RegisterSchema>;

export async function createTestUser(
  data: CreateTestUserParams,
  shouldDelete = true,
) {
  if (shouldDelete) await deleteTestUser(data.email);
  const hashed = await Bun.password.hash(data.password, 'bcrypt');
  const result = await drizzleClient
    .insert(table.user)
    .values({
      ...data,
      password: hashed,
    })
    .onDuplicateKeyUpdate({
      set: {
        name: data.name,
        password: hashed,
        updatedAt: new Date(),
      },
    })
    .$returningId();
  if (!result || result.length === 0) {
    throw new Error('Failed to create test user');
  }
  const createdUser = await drizzleClient.query.user.findFirst({
    where: (fields, operators) => operators.eq(fields.id, result[0].id),
  });
  if (!createdUser) {
    throw new Error('Failed to find created test user');
  }
  return createdUser;
}

export async function createTestUserWithToken(
  data: CreateTestUserParams,
  shouldDelete = true,
) {
  const user = await createTestUser(data, shouldDelete);
  const token = await generateJWT({
    ...user,
    createdAt: (user.createdAt ?? new Date()).toISOString(),
    updatedAt: (user.updatedAt ?? new Date()).toISOString(),
  });
  return {
    ...user,
    createdAt: user.createdAt?.toISOString() || null,
    updatedAt: user.updatedAt?.toISOString() || null,
    token,
  };
}

export async function deleteTestUser(email: string) {
  await drizzleClient.delete(table.user).where(eq(table.user.email, email));
}
export async function clearUsers() {
  await drizzleClient.delete(table.user);
}
export async function deleteAttendanceExceptGenesis() {
  await drizzleClient
    .delete(table.attendance)
    .where(not(eq(table.attendance.type, 'GENESIS')));
}
