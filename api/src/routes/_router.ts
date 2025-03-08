import Elysia from 'elysia';
import { AttendanceRouter } from './attendance';
import { AuthRouter } from './auth';
import { P2PRouter } from './p2p';
import { ProfileRouter } from './profile';

export const AppRouter = new Elysia()
  .use(AuthRouter)
  .use(ProfileRouter)
  .use(AttendanceRouter)
  .use(P2PRouter);
