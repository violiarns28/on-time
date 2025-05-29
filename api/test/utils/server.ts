import Elysia from 'elysia';

export async function startServer(app: Elysia | any, port = 3000) {
  return app.listen(port);
}

export async function stopServer(server: Elysia | undefined) {
  await server?.stop?.();
}
