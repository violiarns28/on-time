import { env } from '@/core/config/env';
import { AuthWithUserMiddleware } from '@/core/middleware/auth';
import { BlockchainService } from '@/core/services/blockchain';
import { DatabaseService, drizzleClient } from '@/core/services/db';
import { P2PNetworkService } from '@/core/services/p2p';
import { redisClient } from '@/core/services/redis';
import { NodeSchema } from '@/schemas/p2p';
import { OkResponseSchema } from '@/schemas/response';
import Elysia, { t } from 'elysia';

export const blockchainService = BlockchainService.getInstance();
export const p2pService = P2PNetworkService.getInstance();

p2pService.initialize(blockchainService, redisClient, drizzleClient, 6001);
if (env.IS_SLAVE_NODE) p2pService.addPeer(env.MASTER_NODE_URL_WS);

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
    async ({ query }) => {
      const peers = p2pService.getPeers();
      if (query.justUrl) {
        return {
          message: 'Get peers success',
          data: peers.map((peer) => peer.url),
        };
      } else {
        return {
          message: 'Get peers success',
          data: peers,
        };
      }
    },
    {
      query: t.Object({
        justUrl: t.Boolean({
          description: 'Return only the URL of the peers',
          example: true,
        }),
      }),
      response: {
        200: {
          description: 'Get peers success',
          ...OkResponseSchema(
            t.Union([t.Array(NodeSchema), t.Array(t.String())]),
          ),
        },
      },
    },
  )
  .post(
    '/peers',
    async ({ body }) => {
      if (Array.isArray(body)) {
        await p2pService.connectToPeers(body);

        return {
          message: 'Add peer success',
          data: body.map((url) => ({ url })),
        };
      } else {
        await p2pService.connectToPeers([body.url]);

        return {
          message: 'Add peer success',
          data: body,
        };
      }
    },
    {
      body: t.Union([
        t.Object({
          url: t.String({
            description: 'WebSocket URL of the peer to connect to',
            example: 'ws://localhost:6001',
          }),
        }),
        t.Array(
          t.String({
            description: 'WebSocket URL of the peer to connect to',
            example: 'ws://localhost:6001',
          }),
        ),
      ]),
      response: {
        200: {
          description: 'Add peer success',
          ...OkResponseSchema(
            t.Union([
              t.Object({
                url: t.String(),
              }),
              t.Array(t.Object({ url: t.String() })),
            ]),
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
