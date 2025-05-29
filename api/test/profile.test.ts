import { app } from '@/index';
import { describe, expect, it } from 'bun:test';
import { createTestUserWithToken } from './utils/db';

const PROFILE_URL = 'http://localhost:3000/profile';

describe('Get Profile Tests', () => {
  it('should return user profile', async () => {
    const user = await createTestUserWithToken({
      name: 'Test User',
      email: 'test@user.com',
      password: 'testpassword',
    });

    const response = await app.handle(
      new Request(`${PROFILE_URL}/me`, {
        method: 'GET',
        headers: { Authorization: `Bearer ${user.token}` },
      }),
    );
    const body = await response.json();
    expect(response.status).toBe(200);
    expect(body.message).toBe('Find user success');
    expect(body.data.email).toBe(user.email);
    expect(body.data.name).toBe(user.name);
  });

  it('should update user profile', async () => {
    const user = await createTestUserWithToken({
      name: 'Update User',
      email: 'update@user.com',
      password: 'updatepassword',
    });
    const updateResponse = await app.handle(
      new Request(`${PROFILE_URL}/me`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${user.token}`,
        },
        body: JSON.stringify({
          name: 'Updated Name',
          password: 'newpassword',
        }),
      }),
    );
    const updateBody = await updateResponse.json();
    expect(updateResponse.status).toBe(200);
    expect(updateBody.message).toBe('Updated');
    expect(updateBody.data.email).toBe(user.email);
    expect(updateBody.data.name).toBe('Updated Name');
    expect(updateBody.data.password).toBeUndefined();
  });

  it('should return 401 if not authenticated', async () => {
    const response = await app.handle(
      new Request(`${PROFILE_URL}/me`, {
        method: 'GET',
      }),
    );
    expect(response.status).toBe(403);
    const body = await response.json();
    expect(body.errors.message).toBe('Unauthorized');
    expect(body.errors.type).toBe('authorization');
  });
});
