import { drizzleClient } from '@/core/services/db';
import { usersTable } from '@/tables/user';
import { faker } from '@faker-js/faker';

async function seedUser() {
  console.time('Seeding users');
  const pw: string = await Bun.password.hash('password', 'bcrypt');

  // Generate unique emails more efficiently using domains and usernames
  const domains = [
    'gmail.com',
    'yahoo.com',
    'outlook.com',
    'example.com',
    'mail.com',
    'fastmail.com',
    'proton.me',
    'icloud.com',
  ];
  const emailSet = new Set<string>();

  // Pre-generate more users than needed to account for potential duplicates
  for (let i = 0; i < 120000 && emailSet.size < 100000; i++) {
    const username = `${faker.internet
      .username()
      .toLowerCase()
      .replace(/[^a-z0-9]/g, '')}${faker.number.int(9999)}`;
    const domain = domains[faker.number.int(domains.length - 1)];
    const email = `${username}@${domain}`;
    emailSet.add(email);
  }

  const emails = Array.from(emailSet).slice(0, 100000);
  console.log(`Generated ${emails.length} unique emails`);

  // Process in batches to avoid memory issues and improve performance
  const BATCH_SIZE = 1000;
  let totalInserted = 0;

  for (let i = 0; i < emails.length; i += BATCH_SIZE) {
    const batch = emails.slice(i, i + BATCH_SIZE).map((email) => ({
      name: faker.person.fullName(),
      email,
      password: pw,
      deviceId: faker.string.uuid(),
    }));

    const resIds = await drizzleClient
      .insert(usersTable)
      .values(batch)
      .$returningId()
      .execute();

    totalInserted += resIds.length;
    console.log(`Progress: ${totalInserted}/${emails.length} users inserted`);
  }

  console.timeEnd('Seeding users');
  console.log(`Successfully seeded ${totalInserted} users`);
  process.exit(0);
}

seedUser().catch((error) => {
  console.error('Error seeding users:', error);
  process.exit(1);
});
