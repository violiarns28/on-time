import { logger } from '@/utils/logger';
import { TypeCompiler } from '@sinclair/typebox/compiler';
import { Static, t } from 'elysia';

const EnvSchema = t.Object({
  ENV: t.String(),
  API_PORT: t.String(),
  JWT_SECRET: t.String(),
  SALT_ROUNDS: t
    .Transform(t.String())
    .Decode((v) => Number(v))
    .Encode((v) => v.toString()),

  DB_URL: t.String(),
  DB_PORT: t
    .Transform(t.String())
    .Decode((v) => Number(v))
    .Encode((v) => v.toString()),
  DB_USER: t.String(),
  DB_PASSWORD: t.String(),
  DB_NAME: t.String(),

  REDIS_HOST: t.String(),
  REDIS_PORT: t
    .Transform(t.String())
    .Decode((v) => Number(v))
    .Encode((v) => v.toString()),

  IS_SLAVE_NODE: t
    .Transform(t.String())
    .Decode((v) => v === 'true')
    .Encode((v) => (v ? 'true' : 'false')),
  MASTER_NODE_URL_WS: t.String(),
  MASTER_NODE_URL_HTTP: t.String(),
});

type Env = Static<typeof EnvSchema>;

declare global {
  namespace NodeJS {
    // eslint-disable-next-line prettier/prettier
    interface ProcessEnv extends Env { }
  }
}

const parseEnv = () => {
  const EnvCompiler = TypeCompiler.Compile(EnvSchema);
  const err = EnvCompiler.Errors(Bun.env);
  const errs = [...err];
  if (errs.length > 0) {
    errs.forEach((err) => {
      logger.error({
        path: err.path,
        message: err.message,
        actualValue: err.value,
      });
    });
    return process.exit(1);
  }

  return EnvCompiler.Decode(Bun.env);
};

export const env = parseEnv();
