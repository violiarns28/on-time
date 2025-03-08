import { AuthWithUserMiddleware } from '@/core/middleware/auth';
import { BlockchainService } from '@/core/services/blockchain';
import { DatabaseService, drizzleClient } from '@/core/services/db';
import { P2PNetworkService } from '@/core/services/p2p';
import { redisClient } from '@/core/services/redis';
import { NodeSchema } from '@/schemas/p2p';
import { OkResponseSchema } from '@/schemas/response';
import Elysia, { t } from 'elysia';

const blockchainService = BlockchainService.getInstance();
const p2pService = P2PNetworkService.getInstance();

// Initialize P2P service with default port 6001
p2pService.initialize(blockchainService, drizzleClient, redisClient, 6001);

export const P2PRouter = new Elysia({
  prefix: '/p2p',
  detail: {
    tags: ['P2P Network'],
    security: [
      {
        BearerAuth: [],
      },
    ],
  },
})
  .use(DatabaseService)
  .use(AuthWithUserMiddleware)
  .get(
    '/peers',
    async () => {
      const peers = p2pService.getPeers();
      return {
        message: 'Get peers success',
        data: peers,
      };
    },
    {
      response: {
        200: {
          description: 'Get peers success',
          ...OkResponseSchema(t.Array(NodeSchema)),
        },
      },
    },
  )
  .post(
    '/peers',
    async ({ body }) => {
      await p2pService.connectToPeers([body.url]);
      return {
        message: 'Add peer success',
        data: { url: body.url },
      };
    },
    {
      body: t.Object({
        url: t.String({
          description: 'WebSocket URL of the peer to connect to',
          example: 'ws://localhost:6001',
        }),
      }),
      response: {
        200: {
          description: 'Add peer success',
          ...OkResponseSchema(
            t.Object({
              url: t.String(),
            }),
          ),
        },
      },
    },
  )
  .get(
    '/sync',
    async () => {
      p2pService.broadcastQueryAll();
      return {
        message: 'Blockchain sync initiated',
        data: { status: 'syncing' },
      };
    },
    {
      response: {
        200: {
          description: 'Blockchain sync initiated',
          ...OkResponseSchema(
            t.Object({
              status: t.String(),
            }),
          ),
        },
      },
    },
  );
