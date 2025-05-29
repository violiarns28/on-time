import { app } from '@/index';
import { describe, expect, it } from 'bun:test';
import {
  createTestUserWithToken,
  deleteAttendanceExceptGenesis,
} from './utils/db';

const ATTENDANCE_URL = 'http://localhost:3000/attendances';

describe('Attendance Tests', () => {
  it('should get attendance list', async () => {
    const user = await createTestUserWithToken({
      name: 'Attendance User',
      email: 'attendance@user.com',
      password: 'attendancepassword',
    });
    const response = await app.handle(
      new Request(`${ATTENDANCE_URL}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${user.token}`,
        },
      }),
    );
    const body = await response.json();
    expect(response.status).toBe(200);
    expect(body.message).toBe('Find attendances success');
    expect(Array.isArray(body.data)).toBe(true);
  });
  it('should get latest attendance for user', async () => {
    const user = await createTestUserWithToken({
      name: 'Latest Attendance User',
      email: 'latest@user.com',
      password: 'latestpassword',
    });
    const clockInResponse = await app.handle(
      new Request(`${ATTENDANCE_URL}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${user.token}`,
        },
        body: JSON.stringify({ type: 'CLOCK_IN' }),
      }),
    );
    expect(clockInResponse.status).toBe(201);
    const clockInBody = await clockInResponse.json();
    expect(clockInBody.message).toBe('Clock in successfully');
    expect(clockInBody.data.type).toBe('CLOCK_IN');
    expect(clockInBody.data.userId).toBe(user.id);
    const response = await app.handle(
      new Request(`${ATTENDANCE_URL}/me/latest?type=CLOCK_IN`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${user.token}`,
        },
      }),
    );
    const body = await response.json();
    expect(response.status).toBe(200);
    expect(body.message).toBe('Find latest attendance success');
    expect(body.data.type).toBe('CLOCK_IN');
    expect(body.data.userId).toBe(user.id);
  });

  it('should clock in attendance', async () => {
    const user = await createTestUserWithToken({
      name: 'Clock In User',
      email: 'clockin@user.com',
      password: 'clockinpassword',
    });
    const response = await app.handle(
      new Request(`${ATTENDANCE_URL}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${user.token}`,
        },
        body: JSON.stringify({ type: 'CLOCK_IN' }),
      }),
    );
    const body = await response.json();
    expect(response.status).toBe(201);
    expect(body.message).toBe('Clock in successfully');
    expect(body.data.type).toBe('CLOCK_IN');
    expect(body.data.userId).toBe(user.id);
  });

  it('should clock out attendance', async () => {
    await deleteAttendanceExceptGenesis();
    const user = await createTestUserWithToken(
      {
        name: 'Clock Out User',
        email: 'clockout@user.com',
        password: 'clockoutpassword',
      },
      false,
    );
    // First clock in
    const clockInResponse = await app.handle(
      new Request(`${ATTENDANCE_URL}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${user.token}`,
        },
        body: JSON.stringify({ type: 'CLOCK_IN' }),
      }),
    );
    expect(clockInResponse.status).toBe(201);
    const clockInBody = await clockInResponse.json();
    expect(clockInBody.message).toBe('Clock in successfully');
    expect(clockInBody.data.type).toBe('CLOCK_IN');
    expect(clockInBody.data.userId).toBe(user.id);
    // Now clock out
    const clockOutResponse = await app.handle(
      new Request(`${ATTENDANCE_URL}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${user.token}`,
        },
        body: JSON.stringify({ type: 'CLOCK_OUT' }),
      }),
    );
    const clockOutBody = await clockOutResponse.json();
    expect(clockOutResponse.status).toBe(201);
    expect(clockOutBody.message).toBe('Clock out successfully');
    expect(clockOutBody.data.type).toBe('CLOCK_OUT');
    expect(clockOutBody.data.userId).toBe(user.id);
  });
});
