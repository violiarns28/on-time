import { drizzleClient } from '@/core/services/db';
import { usersTable } from '@/tables/user';
import { faker } from '@faker-js/faker';

async function seedUser() {
  const emails: Set<string> = new Set();
  const pw: string = await Bun.password.hash('password', 'bcrypt');

  while (emails.size < 5000) {
    const email: string = faker.internet.email({
      allowSpecialCharacters: true,
    });
    emails.add(email);
  }

  const userList = Array.from(emails).map((email: string) => ({
    name: faker.person.fullName(),
    email,
    password: pw,
    deviceId: faker.string.uuid(),
  }));

  const resId = await drizzleClient
    .insert(usersTable)
    .values(userList)
    .$returningId()
    .execute();

  if (resId) {
    console.log('Success seed user:', resId.length);
    process.exit(0);
  } else {
    console.log('Failed seed user:');
    process.exit(1);
  }
}

seedUser();
