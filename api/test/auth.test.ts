import { app } from '@/index';
import { describe, expect, it } from 'bun:test';
import { createTestUser, deleteTestUser } from './utils/db';

const AUTH_URL = 'http://localhost:3000/auth';

describe('User Register Tests', () => {
  it('should success on valid registration', async () => {
    const userData = {
      name: 'New User',
      email: 'new@user.com',
      password: 'newpassword',
    };
    await deleteTestUser(userData.email);
    const response = await app.handle(
      new Request(`${AUTH_URL}/register`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(userData),
      }),
    );
    const body = await response.json();
    expect(response.status).toBe(201);
    expect(body.message).toBe('Registration success');
    expect(body.data.user.email).toBe(userData.email);
    expect(body.data.token).toBeTruthy();
    expect(body.data.user.name).toBe(userData.name);
  });
  it('should return 409 if email already exists', async () => {
    const existingUser = await createTestUser({
      name: 'Existing User',
      email: 'existing@user.com',
      password: 'existingpassword',
    });
    const response = await app.handle(
      new Request(`${AUTH_URL}/register`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          name: 'New User',
          email: existingUser.email,
          password: 'newpassword',
        }),
      }),
    );
    const body = await response.json();
    expect(response.status).toBe(409);
    expect(body.errors.message).toBe('Email already exists');
    expect(body.errors.type).toBe('conflict');
  });

  it('should return 400 if password is too short', async () => {
    const response = await app.handle(
      new Request(`${AUTH_URL}/register`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          name: 'Short Password User',
          email: 'short@user.com',
          password: 'short',
        }),
      }),
    );
    const body = await response.json();
    expect(response.status).toBe(400);
    expect(body.errors.message).toBe('Password must be at least 8 characters');
    expect(body.errors.type).toBe('bad_request');
  });
});

describe('User Login Tests', () => {
  it('should success on valid credentials', async () => {
    const credentials = {
      email: 'valid@gmail.com',
      password: 'validpassword',
    };
    const user = await createTestUser({
      name: 'Valid User',
      ...credentials,
    });
    const response = await app.handle(
      new Request(`${AUTH_URL}/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(credentials),
      }),
    );

    const body = await response.json();
    expect(response.status).toBe(200);
    expect(body.message).toBe('Login success');
    expect(body.data.user.email).toBe(user.email);
    expect(body.data.token).toBeTruthy();
  });

  it('should return 400 if user not found', async () => {
    const response = await app.handle(
      new Request(`${AUTH_URL}/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          email: 'notfound@user.com',
          password: 'wrongpassword',
        }),
      }),
    );
    const body = await response.json();
    expect(response.status).toBe(400);
    expect(body.errors.message).toBe('User not found');
    expect(body.errors.type).toBe('bad_request');
  });
});

describe('User Session Authentication', () => {
  it('should authenticate user with valid token', async () => {
    const user = await createTestUser({
      name: 'Auth User',
      email: 'auth@user.com',
      password: 'authpassword',
    });
    const loginResponse = await app.handle(
      new Request(`${AUTH_URL}/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          email: user.email,
          password: 'authpassword',
        }),
      }),
    );
    const loginBody = await loginResponse.json();
    expect(loginResponse.status).toBe(200);
    expect(loginBody.data.token).toBeTruthy();
    const token = loginBody.data.token;
    const authResponse = await app.handle(
      new Request(`${AUTH_URL}/authenticate`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${token}`,
        },
      }),
    );
    const authBody = await authResponse.json();
    expect(authResponse.status).toBe(200);
    expect(authBody.data.email).toBe(user.email);
    expect(authBody.data.name).toBe(user.name);
  });
  it('should return 401 for invalid token', async () => {
    const response = await app.handle(
      new Request(`${AUTH_URL}/authenticate`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          Authorization: 'Bearer invalidtoken',
        },
      }),
    );
    const body = await response.json();
    expect(response.status).toBe(401);
    expect(body.errors.message).toBe('Invalid token');
    expect(body.errors.type).toBe('authentication');
  });
  it('should return 401 if no token provided', async () => {
    const response = await app.handle(
      new Request(`${AUTH_URL}/authenticate`, {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      }),
    );
    const body = await response.json();
    expect(response.status).toBe(401);
    expect(body.errors.message).toBe('No token provided');
    expect(body.errors.type).toBe('authentication');
  });
});
