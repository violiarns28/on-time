import Elysia from 'elysia';
import { AttendanceRouter } from './attendance';
import { AuthRouter } from './auth';
import { ProfileRouter } from './profile';

export const AppRouter = new Elysia()
  .use(AuthRouter)
  .use(ProfileRouter)
  .use(AttendanceRouter);
