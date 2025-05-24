/* eslint-disable no-unused-vars */
import { BlockchainService } from '@/core/services/blockchain';
import { SelectAttendance } from '@/schemas/attendance';
import { table } from '@/tables';
import { usersTable } from '@/tables/user';
import { buildConflictUpdateColumns } from '@/utils';
import crypto from 'crypto';
import ip from 'ip';
import os from 'os';
import { env } from 'process';
import WebSocket from 'ws';
import { Database } from './db';

enum MessageType {
  QUERY_LATEST = 'QUERY_LATEST',
  QUERY_ALL = 'QUERY_ALL',
  RESPONSE_BLOCKCHAIN = 'RESPONSE_BLOCKCHAIN',
  NEW_BLOCK = 'NEW_BLOCK',
  NEW_USER = 'NEW_USER',
  REGISTER_NODE = 'REGISTER_NODE',
  NODE_LIST = 'NODE_LIST',
  HANDSHAKE = 'HANDSHAKE',
  PING = 'PING',
  PONG = 'PONG',
}

interface PeerMessage {
  type: MessageType;
  data: any;
  nodeId: string;
  timestamp: number;
}

interface Peer {
  url: string;
  ws?: WebSocket;
  nodeId: string;
  lastSeen: number;
}

interface NodeInfo {
  url: string;
  nodeId: string;
  lastSeen: number;
}

interface NewUserData {
  id: number;
  name: string;
  email: string;
  password: string;
  deviceId: string;
  createdAt: string;
  updatedAt: string;
}

// Configuration constants
const CONFIG = {
  HEARTBEAT_INTERVAL: 30000, // 30 seconds
  NODE_TIMEOUT: 300000, // 5 minutes
  RECONNECT_INTERVAL: 10000, // 10 seconds
  BLOCKCHAIN_SYNC_INTERVAL: 60000, // 1 minute
  MINING_DIFFICULTY: 2, // Should match blockchain difficulty
};

export class P2PService {
  private static instance: P2PService;
  private server: WebSocket.Server | null = null;
  private peers: Map<string, Peer> = new Map();
  private blockchain!: BlockchainService;
  private db!: Database;
  private port!: number;
  private nodeId: string;
  private intervals: { [key: string]: Timer | null } = {
    heartbeat: null,
    reconnect: null,
    sync: null,
  };
  private initialized: boolean = false;

  private constructor() {
    this.nodeId = this.generateNodeId();
  }

  public static getInstance(): P2PService {
    if (!P2PService.instance) {
      P2PService.instance = new P2PService();
    }
    return P2PService.instance;
  }

  private generateNodeId(): string {
    const uniqueString = `${os.hostname()}-${ip.address()}-${Date.now()}-${Math.random()}`;
    return crypto
      .createHash('sha256')
      .update(uniqueString)
      .digest('hex')
      .substring(0, 10);
  }

  public async initialize(
    blockchain: BlockchainService,
    database: Database,
    port: number = 6002,
  ): Promise<void> {
    if (this.initialized) return;

    this.blockchain = blockchain;
    this.port = port;
    this.db = database;

    await this.startServer();
    this.startPeriodicServices();

    if (env.IS_SLAVE_NODE) {
      await this.connectToPeers([env.MASTER_NODE_URL_WS]);
    }
    this.initialized = true;
    console.log(
      `P2P network initialized. Node ID: ${this.nodeId}, listening on port ${this.port}`,
    );
  }

  private startPeriodicServices(): void {
    this.startIntervalService(
      'heartbeat',
      () => {
        this.sendHeartbeat();
        this.cleanupStaleNodes();
      },
      CONFIG.HEARTBEAT_INTERVAL,
    );

    this.startIntervalService(
      'reconnect',
      () => {
        this.reconnectToPeers();
      },
      CONFIG.RECONNECT_INTERVAL,
    );

    this.startIntervalService(
      'sync',
      () => {
        this.broadcastQueryLatest();
      },
      CONFIG.BLOCKCHAIN_SYNC_INTERVAL,
    );
  }

  private startIntervalService(
    name: string,
    callback: () => void,
    interval: number,
  ): void {
    if (this.intervals[name]) {
      clearInterval(this.intervals[name] as NodeJS.Timeout);
    }

    this.intervals[name] = setInterval(callback, interval);
    console.log(`[P2P Service] ${name} service started`);
  }

  private async startServer(): Promise<void> {
    return new Promise((resolve, reject) => {
      try {
        this.server = new WebSocket.Server({ port: this.port });

        this.server.on('connection', (ws: WebSocket, req) => {
          this.handleConnection(ws, req);
        });

        this.server.on('error', (error) => {
          console.error('[P2P Service] WebSocket server error:', error);
          reject(error);
        });

        this.server.on('listening', () => {
          console.log(
            `[P2P Service] P2P server listening on port ${this.port}`,
          );
          resolve();
        });
      } catch (error) {
        console.error('[P2P Service] Failed to start P2P server:', error);
        reject(error);
      }
    });
  }

  private handleConnection(ws: WebSocket, req: any): void {
    console.log(
      `[P2P Service] New peer connection from ${req.socket.remoteAddress}`,
    );

    ws.on('message', (data: WebSocket.Data) => {
      try {
        const message: PeerMessage = JSON.parse(data.toString());
        this.handleMessage(ws, message);
      } catch (error) {
        console.error('[P2P Service] Error handling message:', error);
      }
    });

    ws.on('error', (error) => {
      console.error('[P2P Service] WebSocket connection error:', error);
    });

    ws.on('close', () => {
      console.log('Peer disconnected');
      this.removePeerBySocket(ws);
    });

    this.sendHandshake(ws);
  }

  private async handleMessage(
    ws: WebSocket,
    message: PeerMessage,
  ): Promise<void> {
    const { type, data, nodeId } = message;

    this.updatePeerLastSeen(nodeId);
    console.log(`[P2P Service] Received ${type} message from node ${nodeId}`);

    const handlers: {
      [key in MessageType]?: (ws: WebSocket, data: any) => Promise<void>;
    } = {
      [MessageType.HANDSHAKE]: async () =>
        this.handleHandshake(ws, data, nodeId),
      [MessageType.QUERY_LATEST]: async () => this.handleQueryLatest(ws),
      [MessageType.QUERY_ALL]: async () => this.handleQueryAll(ws),
      [MessageType.RESPONSE_BLOCKCHAIN]: async () =>
        this.handleBlockchainResponse(data),
      [MessageType.NEW_BLOCK]: async () => this.handleNewBlock(data),
      [MessageType.NEW_USER]: async () => this.handleNewUser(data),
      [MessageType.REGISTER_NODE]: async () => this.handleRegisterNode(data),
      [MessageType.NODE_LIST]: async () => this.handleNodeList(data),
      [MessageType.PING]: async () => this.handlePing(ws),
      // eslint-disable-next-line prettier/prettier
      [MessageType.PONG]: async () => {}, // No action needed
    };

    const handler = handlers[type];
    if (handler) {
      await handler(ws, data);
    } else {
      console.log(`[P2P Service] Unknown message type: ${type}`);
    }
  }

  private async handleNewBlock(block: SelectAttendance): Promise<void> {
    if (!block) {
      console.log('Received invalid block');
      return;
    }

    try {
      const blockchainInstance = this.blockchain.getBlockchain();
      const latestBlockHeld = blockchainInstance.getLatestBlock();

      if (block.previousHash === latestBlockHeld.hash) {
        console.log(`[P2P Service] Valid new block received: ${block.id}`);

        try {
          blockchainInstance.addBlock(block);
          console.log(
            `[P2P Service] Successfully added block ${block.id} to the chain`,
          );
          this.broadcastNewBlock(block);
        } catch (error) {
          console.error('[P2P Service] Error handling new valid block:', error);
        }
      } else {
        console.log('New block rejected: invalid previous hash');
      }
    } catch (error) {
      console.error('[P2P Service] Error handling new block:', error);
    }
  }

  private async handleHandshake(
    ws: WebSocket,
    data: any,
    nodeId: string,
  ): Promise<void> {
    const { url } = data;

    this.addPeer(url, ws, nodeId);

    const nodeList = this.getNodeList();
    this.sendMessage(ws, this.createMessage(MessageType.NODE_LIST, nodeList));
    this.sendMessage(ws, this.createMessage(MessageType.QUERY_ALL, null));
  }

  private async handleNewUser(data: NewUserData) {
    await this.db
      .insert(table.user)
      .values({
        ...data,
        createdAt: new Date(data.createdAt),
        updatedAt: new Date(data.updatedAt),
      })
      .onDuplicateKeyUpdate({
        set: buildConflictUpdateColumns(usersTable, [
          'name',
          'email',
          'password',
          'createdAt',
          'updatedAt',
        ]),
      });
  }

  private handleQueryLatest(ws: WebSocket): void {
    try {
      const blockchainInstance = this.blockchain.getBlockchain();
      const latestBlock = blockchainInstance.getLatestBlock();
      this.sendMessage(
        ws,
        this.createMessage(MessageType.RESPONSE_BLOCKCHAIN, [latestBlock]),
      );
    } catch (error) {
      console.error('[P2P Service] Error getting latest block:', error);
    }
  }

  private handleQueryAll(ws: WebSocket): void {
    const blockchainInstance = this.blockchain.getBlockchain();
    const chain = blockchainInstance.getChain();
    this.sendMessage(
      ws,
      this.createMessage(MessageType.RESPONSE_BLOCKCHAIN, chain),
    );
  }

  private async handleBlockchainResponse(
    blocks: SelectAttendance[],
  ): Promise<void> {
    if (!Array.isArray(blocks) || blocks.length === 0) {
      console.log('Received empty blockchain');
      return;
    }

    const blockchainInstance = this.blockchain.getBlockchain();
    const latestBlockReceived = blocks[blocks.length - 1];

    try {
      const latestBlockHeld = blockchainInstance.getLatestBlock();

      if (latestBlockReceived.id > latestBlockHeld.id) {
        console.log(
          `Blockchain possibly behind. We have: ${latestBlockHeld.id}, Peer has: ${latestBlockReceived.id}`,
        );

        if (latestBlockHeld.hash === latestBlockReceived.previousHash) {
          console.log('Appending received block to our chain');
          this.broadcastLatest();
        } else if (blocks.length === 1) {
          console.log('Querying for entire blockchain');
          this.broadcastQueryAll();
        } else {
          console.log('Received blockchain is longer than current blockchain');
          this.handleChainReplacement(blocks);
        }
      } else {
        console.log(
          'Received blockchain is not longer than current blockchain. No action needed.',
        );
      }
    } catch (error) {
      console.error('[P2P Service] Error handling blockchain response:', error);
    }
  }

  private async handleChainReplacement(
    blocks: SelectAttendance[],
  ): Promise<void> {
    const isValidChain = this.validateChain(blocks);

    if (isValidChain) {
      console.log(
        '[P2P Service] Received blockchain is valid. Replacing current blockchain.',
      );
      console.log(`[P2P Service] Replacing chain with ${blocks.length} blocks`);

      try {
        const blockchainInstance = this.blockchain.getBlockchain();
        blockchainInstance.replaceChain(blocks);
        console.log('Chain successfully replaced');
      } catch (error) {
        console.error('[P2P Service] Error replacing blockchain:', error);
      }
    } else {
      console.log(
        '[P2P Service] Received blockchain is invalid. Keeping current blockchain.',
      );
    }
  }

  private validateChain(blocks: SelectAttendance[]): boolean {
    if (blocks.length === 0) return false;

    if (blocks[0].id !== 1 || blocks[0].previousHash !== '0') {
      console.log('Invalid genesis block');
      return false;
    }

    const difficulty = CONFIG.MINING_DIFFICULTY;
    const target = '0'.repeat(difficulty);

    for (let i = 1; i < blocks.length; i++) {
      const currentBlock = blocks[i];
      const previousBlock = blocks[i - 1];

      if (currentBlock.id !== previousBlock.id + 1) {
        console.log(`[P2P Service] Invalid block sequence at block ${i}`);
        return false;
      }

      if (currentBlock.previousHash !== previousBlock.hash) {
        console.log(
          `[P2P Service] Invalid previous hash reference at block ${i}`,
        );
        return false;
      }

      if (currentBlock.hash.substring(0, difficulty) !== target) {
        console.log(`[P2P Service] Invalid hash difficulty at block ${i}`);
        return false;
      }
    }

    return true;
  }

  private async handleRegisterNode(data: {
    url: string;
    nodeId: string;
  }): Promise<void> {
    const { url, nodeId } = data;
    if (url && nodeId) {
      this.addPeer(url, undefined, nodeId);
    }
  }

  private async handleNodeList(nodes: NodeInfo[]): Promise<void> {
    if (!Array.isArray(nodes)) return;

    for (const node of nodes) {
      if (node.nodeId !== this.nodeId && !this.peers.has(node.url)) {
        this.addPeer(node.url, undefined, node.nodeId, node.lastSeen);
      }
    }
  }

  private handlePing(ws: WebSocket): void {
    this.sendMessage(ws, this.createMessage(MessageType.PONG, null));
  }

  public async addPeer(
    url: string,
    ws?: WebSocket,
    nodeId?: string,
    lastSeen: number = Date.now(),
  ): Promise<void> {
    console.log(`[P2P Service] Adding peer: ${url}`);

    if (this.peers.has(url)) {
      const existingPeer = this.peers.get(url)!;

      const updatedPeer = {
        ...existingPeer,
        ...(ws && { ws }),
        ...(nodeId && { nodeId }),
        lastSeen,
      };

      this.peers.set(url, updatedPeer);
      console.log(
        `[P2P Service] Updated peer: ${url}, nodeId: ${updatedPeer.nodeId}`,
      );
    } else {
      this.peers.set(url, {
        url,
        ws,
        nodeId: nodeId || 'unknown',
        lastSeen,
      });
      console.log(
        `[P2P Service] Added new peer: ${url}, nodeId: ${nodeId || 'unknown'}`,
      );
    }
  }

  private removePeerBySocket(ws: WebSocket): void {
    for (const [url, peer] of this.peers.entries()) {
      if (peer.ws === ws) {
        const updatedPeer = { ...peer };
        delete updatedPeer.ws;
        this.peers.set(url, updatedPeer);
        console.log(`[P2P Service] Marked peer ${url} as disconnected`);
        break;
      }
    }
  }

  private removePeer(url: string): void {
    if (this.peers.has(url)) {
      const peer = this.peers.get(url)!;

      if (peer.ws) {
        try {
          peer.ws.close();
        } catch (error) {
          console.error(
            `[P2P Service] Error closing connection to peer ${url}:`,
            error,
          );
        }
      }

      this.peers.delete(url);
      console.log(`[P2P Service] Removed peer: ${url}`);
    }
  }

  private sendHandshake(ws: WebSocket): void {
    const myUrl = `ws://${ip.address()}:${this.port}`;
    this.sendMessage(
      ws,
      this.createMessage(MessageType.HANDSHAKE, { url: myUrl }),
    );
  }

  private updatePeerLastSeen(nodeId: string): void {
    for (const [url, peer] of this.peers.entries()) {
      if (peer.nodeId === nodeId) {
        peer.lastSeen = Date.now();
        this.peers.set(url, peer);
        break;
      }
    }
  }

  private getNodeList(): NodeInfo[] {
    const nodeList: NodeInfo[] = Array.from(this.peers.entries()).map(
      ([url, peer]) => ({
        url,
        nodeId: peer.nodeId,
        lastSeen: peer.lastSeen,
      }),
    );

    nodeList.push({
      url: `ws://${ip.address()}:${this.port}`,
      nodeId: this.nodeId,
      lastSeen: Date.now(),
    });

    return nodeList;
  }

  private sendHeartbeat(): void {
    const pingMessage = this.createMessage(MessageType.PING, null);

    for (const [, peer] of this.peers.entries()) {
      if (peer.ws && peer.ws.readyState === WebSocket.OPEN) {
        this.sendMessage(peer.ws, pingMessage);
      }
    }
  }

  private cleanupStaleNodes(): void {
    const now = Date.now();
    const stalePeers: string[] = [];

    for (const [url, peer] of this.peers.entries()) {
      if (now - peer.lastSeen > CONFIG.NODE_TIMEOUT) {
        stalePeers.push(url);
      }
    }

    for (const url of stalePeers) {
      console.log(`[P2P Service] Removing stale node: ${url}`);
      this.removePeer(url);
    }
  }

  private reconnectToPeers(): void {
    for (const [url, peer] of this.peers.entries()) {
      if (!peer.ws || peer.ws.readyState !== WebSocket.OPEN) {
        this.connectToPeer(url);
      }
    }
  }

  private connectToPeer(url: string): void {
    try {
      const ws = new WebSocket(url);

      ws.on('open', () => {
        console.log(`[P2P Service] Connected to peer: ${url}`);
        const peer = this.peers.get(url);

        if (peer) {
          peer.ws = ws;
          this.peers.set(url, peer);
          this.sendHandshake(ws);
        }
      });

      ws.on('message', (data: WebSocket.Data) => {
        try {
          const message: PeerMessage = JSON.parse(data.toString());
          this.handleMessage(ws, message);
        } catch (error) {
          console.error('[P2P Service] Error handling message:', error);
        }
      });

      ws.on('error', (error) => {
        console.error(
          `[P2P Service] WebSocket connection error to ${url}:`,
          error,
        );
      });

      ws.on('close', () => {
        console.log(`[P2P Service] Connection to peer ${url} closed`);
        const peer = this.peers.get(url);

        if (peer) {
          delete peer.ws;
          this.peers.set(url, peer);
        }
      });
    } catch (error) {
      console.error(`[P2P Service] Failed to connect to peer ${url}:`, error);
    }
  }

  private createMessage(type: MessageType, data: any): PeerMessage {
    return {
      type,
      data,
      nodeId: this.nodeId,
      timestamp: Date.now(),
    };
  }

  private sendMessage(ws: WebSocket, message: PeerMessage): void {
    try {
      ws.send(JSON.stringify(message));
    } catch (error) {
      console.error('[P2P Service] Error sending message:', error);
    }
  }

  private broadcastMessage(message: PeerMessage): void {
    for (const [, peer] of this.peers.entries()) {
      if (peer.ws && peer.ws.readyState === WebSocket.OPEN) {
        this.sendMessage(peer.ws, message);
      }
    }
  }

  private createAndBroadcastMessage(type: MessageType, data: any): void {
    this.broadcastMessage(this.createMessage(type, data));
  }

  public broadcastNewUser(data: NewUserData) {
    this.createAndBroadcastMessage(MessageType.NEW_USER, data);
  }

  public broadcastNewBlock(block: SelectAttendance): void {
    this.createAndBroadcastMessage(MessageType.NEW_BLOCK, block);
  }

  public broadcastQueryLatest(): void {
    this.createAndBroadcastMessage(MessageType.QUERY_LATEST, null);
  }

  public broadcastQueryAll(): void {
    this.createAndBroadcastMessage(MessageType.QUERY_ALL, null);
  }

  public broadcastAllBlocks(): void {
    const blockchainInstance = this.blockchain.getBlockchain();
    const chain = blockchainInstance.getChain();

    this.createAndBroadcastMessage(MessageType.RESPONSE_BLOCKCHAIN, chain);
  }

  public broadcastLatest(): void {
    try {
      const blockchainInstance = this.blockchain.getBlockchain();
      const latestBlock = blockchainInstance.getLatestBlock();

      this.createAndBroadcastMessage(MessageType.RESPONSE_BLOCKCHAIN, [
        latestBlock,
      ]);
    } catch (error) {
      console.error('[P2P Service] Error broadcasting latest block:', error);
    }
  }

  public async connectToPeers(peerUrls: string[]): Promise<void> {
    for (const url of peerUrls) {
      if (!this.peers.has(url)) {
        await this.addPeer(url);
        this.connectToPeer(url);
      }
    }
  }

  public getPeers(): NodeInfo[] {
    return this.getNodeList();
  }

  public shutdown(): void {
    Object.entries(this.intervals).forEach(([name, timer]) => {
      if (timer) {
        clearInterval(timer as NodeJS.Timeout);
        this.intervals[name] = null;
      }
    });

    for (const [url, peer] of this.peers.entries()) {
      if (peer.ws) {
        try {
          peer.ws.close();
        } catch (error) {
          console.error(
            `[P2P Service] Error closing connection to peer ${url}:`,
            error,
          );
        }
      }
    }

    if (this.server) {
      this.server.close((error) => {
        if (error) {
          console.error('[P2P Service] Error closing P2P server:', error);
        } else {
          console.log('P2P server closed');
        }
      });
    }

    console.log('P2P network service shut down');
  }
}
