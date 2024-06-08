const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 8080 });

wss.on('connection', (ws) => {
  console.log('Client connected');

  // Send a message back to the client upon connection
  ws.send('Welcome! Connection established.');

  ws.on('message', (message) => {
    console.log('Received message:', message);
    // Here you can handle the received video frame data
  });

  ws.on('close', () => {
    console.log('Client disconnected');
  });
});

console.log('WebSocket server is running on ws://localhost:8080');
