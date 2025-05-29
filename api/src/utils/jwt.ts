import { Config } from '@/core/config';
import { SelectUser } from '@/schemas/user';
import { JWTPayload, SignJWT } from 'jose';

export async function generateJWT(user: SelectUser): Promise<string> {
  const payload: JWTPayload = {
    id: user.id,
    email: user.email,
    name: user.name,
    exp: Math.floor(Date.now() / 1000) + Config.JWT_EXPIRES_IN,
    iat: Math.floor(Date.now() / 1000),
  };
  const secret = new TextEncoder().encode(Config.JWT_SECRET);
  const jwt = await new SignJWT(payload)
    .setProtectedHeader({ alg: 'HS256' })
    .sign(secret);
  return jwt;
}
