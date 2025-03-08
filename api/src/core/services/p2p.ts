import { BlockchainService } from '@/core/services/blockchain';
import { Database } from '@/core/services/db';
import { SelectAttendance } from '@/schemas/attendance';
import crypto from 'crypto';
import { EventEmitter } from 'events';
import { Redis } from 'ioredis';
import ip from 'ip';
import os from 'os';
import WebSocket from 'ws';

enum MessageType {
  // eslint-disable-next-line no-unused-vars
  QUERY_LATEST = 'QUERY_LATEST',
  // eslint-disable-next-line no-unused-vars
  QUERY_ALL = 'QUERY_ALL',
  // eslint-disable-next-line no-unused-vars
  RESPONSE_BLOCKCHAIN = 'RESPONSE_BLOCKCHAIN',
  // eslint-disable-next-line no-unused-vars
  NEW_BLOCK = 'NEW_BLOCK',
  // eslint-disable-next-line no-unused-vars
  REGISTER_NODE = 'REGISTER_NODE',
  // eslint-disable-next-line no-unused-vars
  NODE_LIST = 'NODE_LIST',
  // eslint-disable-next-line no-unused-vars
  HANDSHAKE = 'HANDSHAKE',
  // eslint-disable-next-line no-unused-vars
  PING = 'PING',
  // eslint-disable-next-line no-unused-vars
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

const NODES_KEY = 'blockchain:p2p:nodes';
const HEARTBEAT_INTERVAL = 30000; // 30 seconds
const NODE_TIMEOUT = 300000; // 5 minutes
const RECONNECT_INTERVAL = 10000; // 10 seconds

export class P2PNetworkService extends EventEmitter {
  private static instance: P2PNetworkService;
  private server: WebSocket.Server | null = null;
  private peers: Map<string, Peer> = new Map();
  private blockchain!: BlockchainService;
  private redis!: Redis;
  private port!: number;
  private nodeId: string;
  private heartbeatInterval: Timer | null = null;
  private reconnectInterval: Timer | null = null;
  private syncInterval: Timer | null = null;
  private initialized: boolean = false;

  private constructor() {
    super();
    this.nodeId = this.generateNodeId();
  }

  public static getInstance(): P2PNetworkService {
    if (!P2PNetworkService.instance) {
      P2PNetworkService.instance = new P2PNetworkService();
    }
    return P2PNetworkService.instance;
  }

  private generateNodeId(): string {
    const hostname = os.hostname();
    const ipAddress = ip.address();
    const timestamp = Date.now();
    const uniqueString = `${hostname}-${ipAddress}-${timestamp}-${Math.random()}`;
    return crypto
      .createHash('sha256')
      .update(uniqueString)
      .digest('hex')
      .substring(0, 10);
  }

  public async initialize(
    blockchain: BlockchainService,
    db: Database,
    redis: Redis,
    port: number = 6001,
  ): Promise<void> {
    if (this.initialized) return;

    this.blockchain = blockchain;
    this.redis = redis;
    this.port = port;

    await this.startServer();
    await this.loadPeersFromRedis();
    this.startHeartbeat();
    this.startReconnectService();
    this.startBlockchainSync();

    this.initialized = true;
    console.log(
      `P2P network initialized. Node ID: ${this.nodeId}, listening on port ${this.port}`,
    );
  }

  private async startServer(): Promise<void> {
    return new Promise((resolve, reject) => {
      try {
        this.server = new WebSocket.Server({ port: this.port });

        this.server.on('connection', (ws: WebSocket, req) => {
          this.handleConnection(ws, req);
        });

        this.server.on('error', (error) => {
          console.error('WebSocket server error:', error);
          reject(error);
        });

        this.server.on('listening', () => {
          console.log(`P2P server listening on port ${this.port}`);
          resolve();
        });
      } catch (error) {
        console.error('Failed to start P2P server:', error);
        reject(error);
      }
    });
  }

  private handleConnection(ws: WebSocket, req: any): void {
    console.log(`New peer connection from ${req.socket.remoteAddress}`);

    ws.on('message', (data: WebSocket.Data) => {
      try {
        const message: PeerMessage = JSON.parse(data.toString());
        this.handleMessage(ws, message);
      } catch (error) {
        console.error('Error handling message:', error);
      }
    });

    ws.on('error', (error) => {
      console.error('WebSocket connection error:', error);
    });

    ws.on('close', () => {
      console.log('Peer disconnected');
      // We don't remove the peer here, just mark it as disconnected
      // by removing the ws instance. The reconnect service will try to reconnect.
      this.removePeerBySocket(ws);
    });

    // Send handshake message to the new peer
    this.sendHandshake(ws);
  }

  private removePeerBySocket(ws: WebSocket): void {
    for (const [url, peer] of this.peers.entries()) {
      if (peer.ws === ws) {
        const updatedPeer = { ...peer };
        delete updatedPeer.ws;
        this.peers.set(url, updatedPeer);
        console.log(`Marked peer ${url} as disconnected`);
        break;
      }
    }
  }

  private async handleMessage(
    ws: WebSocket,
    message: PeerMessage,
  ): Promise<void> {
    const { type, data, nodeId } = message;

    // Update the peer's lastSeen timestamp
    this.updatePeerLastSeen(nodeId);

    console.log(`Received ${type} message from node ${nodeId}`);

    switch (type) {
      case MessageType.HANDSHAKE:
        await this.handleHandshake(ws, data, nodeId);
        break;

      case MessageType.QUERY_LATEST:
        this.handleQueryLatest(ws);
        break;

      case MessageType.QUERY_ALL:
        this.handleQueryAll(ws);
        break;

      case MessageType.RESPONSE_BLOCKCHAIN:
        await this.handleBlockchainResponse(data);
        break;

      case MessageType.NEW_BLOCK:
        await this.handleNewBlock(data);
        break;

      case MessageType.REGISTER_NODE:
        await this.handleRegisterNode(data);
        break;

      case MessageType.NODE_LIST:
        await this.handleNodeList(data);
        break;

      case MessageType.PING:
        this.handlePing(ws);
        break;

      case MessageType.PONG:
        // PONG messages are handled implicitly by updating lastSeen above
        break;

      default:
        console.log(`Unknown message type: ${type}`);
    }
  }

  private async handleHandshake(
    ws: WebSocket,
    data: any,
    nodeId: string,
  ): Promise<void> {
    const { url } = data;

    // Add the new peer to our list
    this.addPeer(url, ws, nodeId);

    // Share our node list with the new peer
    const nodeList = this.getNodeList();
    this.sendMessage(ws, {
      type: MessageType.NODE_LIST,
      data: nodeList,
      nodeId: this.nodeId,
      timestamp: Date.now(),
    });

    // Query the peer's blockchain
    this.sendMessage(ws, {
      type: MessageType.QUERY_ALL,
      data: null,
      nodeId: this.nodeId,
      timestamp: Date.now(),
    });
  }

  private handleQueryLatest(ws: WebSocket): void {
    const blockchainInstance = this.blockchain.getBlockchain();
    try {
      const latestBlock = blockchainInstance.getLatestBlock();
      this.sendMessage(ws, {
        type: MessageType.RESPONSE_BLOCKCHAIN,
        data: [latestBlock],
        nodeId: this.nodeId,
        timestamp: Date.now(),
      });
    } catch (error) {
      console.error('Error getting latest block:', error);
    }
  }

  private handleQueryAll(ws: WebSocket): void {
    const blockchainInstance = this.blockchain.getBlockchain();
    const chain = blockchainInstance.getChain();
    this.sendMessage(ws, {
      type: MessageType.RESPONSE_BLOCKCHAIN,
      data: chain,
      nodeId: this.nodeId,
      timestamp: Date.now(),
    });
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
          // We can append the received block to our chain
          console.log('Appending received block to our chain');
          // This would require a method in the Blockchain class to add a pre-mined block
          // For now, we broadcast what we have and let consensus work
          this.broadcastLatest();
        } else if (blocks.length === 1) {
          // We need the entire blockchain from this peer
          console.log('Querying for entire blockchain');
          this.broadcastQueryAll();
        } else {
          // Received blockchain is longer than current blockchain
          console.log('Received blockchain is longer than current blockchain');
          // This would require a method to replace the chain in the Blockchain class
          // Consider implementing a consensus mechanism
          this.handleChainReplacement(blocks);
        }
      } else {
        console.log(
          'Received blockchain is not longer than current blockchain. No action needed.',
        );
      }
    } catch (error) {
      console.error('Error handling blockchain response:', error);
    }
  }

  private async handleChainReplacement(
    blocks: SelectAttendance[],
  ): Promise<void> {
    // This is a simplified consensus mechanism
    // A more robust implementation would validate the entire chain

    // Check if the received chain is valid
    const isValidChain = this.validateChain(blocks);

    if (isValidChain) {
      console.log(
        'Received blockchain is valid. Replacing current blockchain.',
      );
      // This would require adding a method to the Blockchain class to replace the chain
      // For now, we'll just log it
      console.log(`Would replace chain with ${blocks.length} blocks`);

      // Emit an event that could be handled elsewhere in the application
      this.emit('chainReplacement', blocks);
    } else {
      console.log(
        'Received blockchain is invalid. Keeping current blockchain.',
      );
    }
  }

  private validateChain(blocks: SelectAttendance[]): boolean {
    // Basic validation: check that each block points to the previous one correctly
    // and that the hash difficulty is correct

    if (blocks.length === 0) return false;

    // Check genesis block
    if (blocks[0].id !== 1 || blocks[0].previousHash !== '0') {
      console.log('Invalid genesis block');
      return false;
    }

    const difficulty = 2; // Should match the difficulty in the Blockchain class
    const target = '0'.repeat(difficulty);

    for (let i = 1; i < blocks.length; i++) {
      const currentBlock = blocks[i];
      const previousBlock = blocks[i - 1];

      // Check block sequence
      if (currentBlock.id !== previousBlock.id + 1) {
        console.log(`Invalid block sequence at block ${i}`);
        return false;
      }

      // Check previous hash reference
      if (currentBlock.previousHash !== previousBlock.hash) {
        console.log(`Invalid previous hash reference at block ${i}`);
        return false;
      }

      // Check hash difficulty
      if (currentBlock.hash.substring(0, difficulty) !== target) {
        console.log(`Invalid hash difficulty at block ${i}`);
        return false;
      }

      // Here you would also verify the hash calculation itself
      // by recalculating it based on the block's contents
    }

    return true;
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
        // This would require a method in the Blockchain class to add a pre-mined block
        console.log(`Valid new block received: ${block.id}`);
        // Emit an event that could be handled elsewhere
        this.emit('newValidBlock', block);
      } else {
        console.log('New block rejected: invalid previous hash');
      }
    } catch (error) {
      console.error('Error handling new block:', error);
    }
  }

  private async handleRegisterNode(data: any): Promise<void> {
    const { url, nodeId } = data;
    if (url && nodeId) {
      this.addPeer(url, undefined, nodeId);
    }
  }

  private async handleNodeList(nodes: NodeInfo[]): Promise<void> {
    if (!Array.isArray(nodes)) return;

    for (const node of nodes) {
      // Don't add ourselves
      if (node.nodeId !== this.nodeId) {
        // Check if we already have this node
        if (!this.peers.has(node.url)) {
          this.addPeer(node.url, undefined, node.nodeId, node.lastSeen);
        }
      }
    }
  }

  private handlePing(ws: WebSocket): void {
    this.sendMessage(ws, {
      type: MessageType.PONG,
      data: null,
      nodeId: this.nodeId,
      timestamp: Date.now(),
    });
  }

  private sendHandshake(ws: WebSocket): void {
    const myUrl = `ws://${ip.address()}:${this.port}`;
    this.sendMessage(ws, {
      type: MessageType.HANDSHAKE,
      data: { url: myUrl },
      nodeId: this.nodeId,
      timestamp: Date.now(),
    });
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
    const nodeList: NodeInfo[] = [];

    for (const [url, peer] of this.peers.entries()) {
      nodeList.push({
        url,
        nodeId: peer.nodeId,
        lastSeen: peer.lastSeen,
      });
    }

    // Add ourselves
    nodeList.push({
      url: `ws://${ip.address()}:${this.port}`,
      nodeId: this.nodeId,
      lastSeen: Date.now(),
    });

    return nodeList;
  }

  public async addPeer(
    url: string,
    ws?: WebSocket,
    nodeId?: string,
    lastSeen: number = Date.now(),
  ): Promise<void> {
    if (this.peers.has(url)) {
      const existingPeer = this.peers.get(url)!;

      // Update the WebSocket connection if provided
      if (ws) {
        existingPeer.ws = ws;
      }

      // Update the nodeId if provided
      if (nodeId) {
        existingPeer.nodeId = nodeId;
      }

      existingPeer.lastSeen = lastSeen;
      this.peers.set(url, existingPeer);
      console.log(`Updated peer: ${url}, nodeId: ${existingPeer.nodeId}`);
    } else {
      this.peers.set(url, {
        url,
        ws,
        nodeId: nodeId || 'unknown',
        lastSeen,
      });
      console.log(`Added new peer: ${url}, nodeId: ${nodeId || 'unknown'}`);
    }

    await this.savePeersToRedis();
  }

  private removePeer(url: string): void {
    if (this.peers.has(url)) {
      const peer = this.peers.get(url)!;

      // Close the WebSocket connection if it exists
      if (peer.ws) {
        try {
          peer.ws.close();
        } catch (error) {
          console.error(`Error closing connection to peer ${url}:`, error);
        }
      }

      this.peers.delete(url);
      console.log(`Removed peer: ${url}`);

      this.savePeersToRedis();
    }
  }

  private async savePeersToRedis(): Promise<void> {
    try {
      const peerList: NodeInfo[] = [];

      for (const [url, peer] of this.peers.entries()) {
        peerList.push({
          url,
          nodeId: peer.nodeId,
          lastSeen: peer.lastSeen,
        });
      }

      await this.redis.set(NODES_KEY, JSON.stringify(peerList));
    } catch (error) {
      console.error('Error saving peers to Redis:', error);
    }
  }

  private async loadPeersFromRedis(): Promise<void> {
    try {
      const peersJson = await this.redis.get(NODES_KEY);

      if (peersJson) {
        const peers: NodeInfo[] = JSON.parse(peersJson);

        for (const peer of peers) {
          // Don't add ourselves
          if (peer.url !== `ws://${ip.address()}:${this.port}`) {
            this.addPeer(peer.url, undefined, peer.nodeId, peer.lastSeen);
            this.connectToPeer(peer.url);
          }
        }

        console.log(`Loaded ${peers.length} peers from Redis`);
      }
    } catch (error) {
      console.error('Error loading peers from Redis:', error);
    }
  }

  private startHeartbeat(): void {
    if (this.heartbeatInterval) {
      clearInterval(this.heartbeatInterval);
    }

    this.heartbeatInterval = setInterval(() => {
      this.sendHeartbeat();
      this.cleanupStaleNodes();
    }, HEARTBEAT_INTERVAL);

    console.log('Heartbeat service started');
  }

  private sendHeartbeat(): void {
    for (const [, peer] of this.peers.entries()) {
      if (peer.ws && peer.ws.readyState === WebSocket.OPEN) {
        this.sendMessage(peer.ws, {
          type: MessageType.PING,
          data: null,
          nodeId: this.nodeId,
          timestamp: Date.now(),
        });
      }
    }
  }

  private cleanupStaleNodes(): void {
    const now = Date.now();
    const stalePeers: string[] = [];

    for (const [url, peer] of this.peers.entries()) {
      if (now - peer.lastSeen > NODE_TIMEOUT) {
        stalePeers.push(url);
      }
    }

    for (const url of stalePeers) {
      console.log(`Removing stale node: ${url}`);
      this.removePeer(url);
    }
  }

  private startReconnectService(): void {
    if (this.reconnectInterval) {
      clearInterval(this.reconnectInterval);
    }

    this.reconnectInterval = setInterval(() => {
      this.reconnectToPeers();
    }, RECONNECT_INTERVAL);

    console.log('Reconnect service started');
  }

  private reconnectToPeers(): void {
    for (const [url, peer] of this.peers.entries()) {
      if (!peer.ws || peer.ws.readyState !== WebSocket.OPEN) {
        this.connectToPeer(url);
      }
    }
  }

  private startBlockchainSync(): void {
    if (this.syncInterval) {
      clearInterval(this.syncInterval);
    }

    this.syncInterval = setInterval(() => {
      this.broadcastQueryLatest();
    }, 60000); // Sync every minute

    console.log('Blockchain sync service started');
  }

  private connectToPeer(url: string): void {
    try {
      const ws = new WebSocket(url);

      ws.on('open', () => {
        console.log(`Connected to peer: ${url}`);
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
          console.error('Error handling message:', error);
        }
      });

      ws.on('error', (error) => {
        console.error(`WebSocket connection error to ${url}:`, error);
      });

      ws.on('close', () => {
        console.log(`Connection to peer ${url} closed`);
        const peer = this.peers.get(url);

        if (peer) {
          delete peer.ws;
          this.peers.set(url, peer);
        }
      });
    } catch (error) {
      console.error(`Failed to connect to peer ${url}:`, error);
    }
  }

  private sendMessage(ws: WebSocket, message: PeerMessage): void {
    try {
      ws.send(JSON.stringify(message));
    } catch (error) {
      console.error('Error sending message:', error);
    }
  }

  private broadcastMessage(message: PeerMessage): void {
    for (const [, peer] of this.peers.entries()) {
      if (peer.ws && peer.ws.readyState === WebSocket.OPEN) {
        this.sendMessage(peer.ws, message);
      }
    }
  }

  public broadcastNewBlock(block: SelectAttendance): void {
    this.broadcastMessage({
      type: MessageType.NEW_BLOCK,
      data: block,
      nodeId: this.nodeId,
      timestamp: Date.now(),
    });
  }

  public broadcastQueryLatest(): void {
    this.broadcastMessage({
      type: MessageType.QUERY_LATEST,
      data: null,
      nodeId: this.nodeId,
      timestamp: Date.now(),
    });
  }

  public broadcastQueryAll(): void {
    this.broadcastMessage({
      type: MessageType.QUERY_ALL,
      data: null,
      nodeId: this.nodeId,
      timestamp: Date.now(),
    });
  }

  public broadcastLatest(): void {
    try {
      const blockchainInstance = this.blockchain.getBlockchain();
      const latestBlock = blockchainInstance.getLatestBlock();

      this.broadcastMessage({
        type: MessageType.RESPONSE_BLOCKCHAIN,
        data: [latestBlock],
        nodeId: this.nodeId,
        timestamp: Date.now(),
      });
    } catch (error) {
      console.error('Error broadcasting latest block:', error);
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
    if (this.heartbeatInterval) {
      clearInterval(this.heartbeatInterval);
      this.heartbeatInterval = null;
    }

    if (this.reconnectInterval) {
      clearInterval(this.reconnectInterval);
      this.reconnectInterval = null;
    }

    if (this.syncInterval) {
      clearInterval(this.syncInterval);
      this.syncInterval = null;
    }

    // Close all WebSocket connections
    for (const [url, peer] of this.peers.entries()) {
      if (peer.ws) {
        try {
          peer.ws.close();
        } catch (error) {
          console.error(`Error closing connection to peer ${url}:`, error);
        }
      }
    }

    // Close the server
    if (this.server) {
      this.server.close((error) => {
        if (error) {
          console.error('Error closing P2P server:', error);
        } else {
          console.log('P2P server closed');
        }
      });
    }

    console.log('P2P network service shut down');
  }
}
