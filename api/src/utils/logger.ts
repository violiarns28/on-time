import { env } from '@/core/config/env';

export const logger = {
  error: (message?: any, ...optionalParams: any[]) => {
    if (env.ENV === 'development') {
      console.error('[ERROR]', message, ...optionalParams);
    }
  },
  info: (message?: any, ...optionalParams: any[]) => {
    if (env.ENV === 'development') {
      console.log('[INFO]', message, ...optionalParams);
    }
  },
};
