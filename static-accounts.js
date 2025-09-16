// Static Account System - Simple Username/Password List
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

// Static account list - simple username/password pairs
const STATIC_ACCOUNTS = {
  // Agent Owners (Full Access)
  'alice': {
    password: 'demo123',
    damlParty: 'Alice',
    role: 'agent_owner',
    permissions: ['create_agents', 'create_usage_tokens', 'view_all'],
    description: 'Primary agent owner - full access'
  },
  'admin': {
    password: 'admin123',
    damlParty: 'Alice',
    role: 'agent_owner',
    permissions: ['create_agents', 'create_usage_tokens', 'view_all'],
    description: 'Admin account - full access'
  },
  'demo': {
    password: 'demo',
    damlParty: 'Alice',
    role: 'agent_owner',
    permissions: ['create_agents', 'create_usage_tokens', 'view_all'],
    description: 'Demo account - full access'
  },

  // Enterprise Users (Create Usage Tokens)
  'enterprise': {
    password: 'enterprise123',
    damlParty: 'Enterprise',
    role: 'enterprise',
    permissions: ['create_usage_tokens', 'view_own'],
    description: 'Enterprise customer - can create usage tokens'
  },
  'company': {
    password: 'company123',
    damlParty: 'Enterprise',
    role: 'enterprise',
    permissions: ['create_usage_tokens', 'view_own'],
    description: 'Company account - can create usage tokens'
  },
  'business': {
    password: 'business123',
    damlParty: 'Enterprise',
    role: 'enterprise',
    permissions: ['create_usage_tokens', 'view_own'],
    description: 'Business account - can create usage tokens'
  },

  // End Users (View Only)
  'bob': {
    password: 'bob123',
    damlParty: 'Bob',
    role: 'consumer',
    permissions: ['view_own'],
    description: 'End user - view only'
  },
  'user': {
    password: 'user123',
    damlParty: 'Bob',
    role: 'consumer',
    permissions: ['view_own'],
    description: 'Regular user - view only'
  },
  'guest': {
    password: 'guest123',
    damlParty: 'Bob',
    role: 'consumer',
    permissions: ['view_own'],
    description: 'Guest account - view only'
  },

  // Test Accounts
  'test': {
    password: 'test',
    damlParty: 'Alice',
    role: 'agent_owner',
    permissions: ['create_agents', 'create_usage_tokens', 'view_all'],
    description: 'Test account - full access'
  }
};

// Generate long-lasting JWT (180 days)
function generateLongToken(username, account) {
  return jwt.sign({
    "https://daml.com/ledger-api": {
      "ledgerId": "sandbox",
      "applicationId": "agent-tokenization-app",
      "actAs": [account.damlParty],
      "admin": account.role === 'agent_owner',
      "readAs": [account.damlParty]
    },
    "sub": account.damlParty,
    "aud": "https://daml.com/ledger-api",
    "iss": "agent-tokenization-system",
    "userId": username,
    "role": account.role,
    "permissions": account.permissions
  }, JWT_SECRET, {
    algorithm: 'HS256',
    expiresIn: '180d' // 180 days
  });
}

// Login endpoint
app.post('/auth/login', (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({
      error: 'Username and password required'
    });
  }

  const account = STATIC_ACCOUNTS[username.toLowerCase()];
  if (!account || account.password !== password) {
    return res.status(401).json({
      error: 'Invalid username or password'
    });
  }

  const token = generateLongToken(username, account);

  res.json({
    success: true,
    token: token,
    user: {
      username: username,
      damlParty: account.damlParty,
      role: account.role,
      permissions: account.permissions,
      description: account.description
    },
    expiresIn: '180 days'
  });
});

// List all available accounts (for developers)
app.get('/accounts', (req, res) => {
  const accounts = Object.entries(STATIC_ACCOUNTS).map(([username, account]) => ({
    username: username,
    password: account.password,
    damlParty: account.damlParty,
    role: account.role,
    permissions: account.permissions,
    description: account.description,
    token: generateLongToken(username, account)
  }));

  res.json({
    message: 'Static accounts for Agent Tokenization platform',
    accounts: accounts,
    usage: {
      damlAPI: 'https://27524c709935.ngrok-free.app',
      loginEndpoint: 'POST /auth/login',
      exampleLogin: {
        username: 'demo',
        password: 'demo'
      }
    }
  });
});

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    service: 'static-accounts-auth',
    timestamp: new Date().toISOString(),
    totalAccounts: Object.keys(STATIC_ACCOUNTS).length
  });
});

// Root endpoint with quick info
app.get('/', (req, res) => {
  res.json({
    message: 'Agent Tokenization - Static Accounts Auth Service',
    quickStart: {
      demo: { username: 'demo', password: 'demo', access: 'full' },
      enterprise: { username: 'enterprise', password: 'enterprise123', access: 'create tokens' },
      user: { username: 'user', password: 'user123', access: 'view only' }
    },
    endpoints: {
      login: 'POST /auth/login',
      accounts: 'GET /accounts',
      health: 'GET /health'
    }
  });
});

const PORT = 8080;
app.listen(PORT, () => {
  console.log(`🔐 Static Accounts Auth Service running on port ${PORT}`);
  console.log(`📋 Available accounts:`);

  Object.entries(STATIC_ACCOUNTS).forEach(([username, account]) => {
    console.log(`   ${username.padEnd(12)} / ${account.password.padEnd(15)} - ${account.description}`);
  });

  console.log(`\n🚀 Quick test:`);
  console.log(`   curl -X POST http://localhost:8080/auth/login -H "Content-Type: application/json" -d '{"username":"demo","password":"demo"}'`);
  console.log(`\n📖 Get all accounts: http://localhost:8080/accounts`);
});

module.exports = app;