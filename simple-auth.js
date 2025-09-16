// Simple No-Auth Token Service for Easy Web App Integration
const express = require('express');
const jwt = require('jsonwebtoken');

const app = express();
app.use(express.json());

// CORS for all requests
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
  if (req.method === 'OPTIONS') {
    res.sendStatus(200);
  } else {
    next();
  }
});

const JWT_SECRET = 'daml-agent-tokenization-secret-2024';

// Default JWT token for Alice (agent owner)
const DEFAULT_TOKEN = jwt.sign({
  "https://daml.com/ledger-api": {
    "ledgerId": "sandbox",
    "applicationId": "agent-tokenization-app",
    "actAs": ["Alice"],
    "admin": true,
    "readAs": ["Alice"]
  },
  "sub": "Alice",
  "aud": "https://daml.com/ledger-api",
  "iss": "agent-tokenization-system",
  "userId": "agent-owner",
  "role": "agent_owner",
  "permissions": ["create_agents", "create_usage_tokens", "view_all"]
}, JWT_SECRET, {
  algorithm: 'HS256',
  expiresIn: '7d' // 7 days
});

// Super simple endpoint - just returns a valid token
app.get('/token', (req, res) => {
  res.json({
    success: true,
    token: DEFAULT_TOKEN,
    user: {
      id: 'agent-owner',
      role: 'agent_owner',
      damlParty: 'Alice',
      permissions: ['create_agents', 'create_usage_tokens', 'view_all']
    },
    expiresIn: '7d',
    message: 'Default token for easy testing - no authentication required!'
  });
});

// Backward compatibility with login endpoint (no actual auth)
app.post('/auth/login', (req, res) => {
  res.json({
    success: true,
    token: DEFAULT_TOKEN,
    user: {
      id: 'agent-owner',
      role: 'agent_owner',
      damlParty: 'Alice',
      permissions: ['create_agents', 'create_usage_tokens', 'view_all']
    },
    expiresIn: '7d',
    message: 'No authentication required - returning default token'
  });
});

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    service: 'simple-token-service',
    timestamp: new Date().toISOString(),
    message: 'No-auth token service for easy web app integration'
  });
});

// Show the default token for easy copy/paste
app.get('/', (req, res) => {
  res.json({
    message: 'Simple Token Service for Agent Tokenization',
    instructions: 'GET /token to get a default JWT token',
    defaultToken: DEFAULT_TOKEN,
    usage: {
      damlAPI: 'https://27524c709935.ngrok-free.app',
      headers: {
        'Authorization': `Bearer ${DEFAULT_TOKEN}`,
        'Content-Type': 'application/json'
      }
    }
  });
});

const PORT = 8080;
app.listen(PORT, () => {
  console.log(`🚀 Simple Token Service running on port ${PORT}`);
  console.log(`📋 Endpoints:`);
  console.log(`   GET / - Service info and default token`);
  console.log(`   GET /token - Get default JWT token (no auth required)`);
  console.log(`   POST /auth/login - Login (returns default token)`);
  console.log(`   GET /health - Health check`);
  console.log(`\n🎯 Default Token (copy this):`);
  console.log(`   ${DEFAULT_TOKEN}`);
  console.log(`\n🔗 Use with DAML API:`);
  console.log(`   curl -H "Authorization: Bearer ${DEFAULT_TOKEN}" https://27524c709935.ngrok-free.app/readyz`);
});

module.exports = app;