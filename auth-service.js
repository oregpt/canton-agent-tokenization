// Production Authentication Service for DAML Agent Tokenization
const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const rateLimit = require('express-rate-limit');

const app = express();
app.use(express.json());

// Add CORS for web app access
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

// Configuration
const config = {
  JWT_SECRET: process.env.DAML_JWT_SECRET || 'daml-agent-tokenization-secret-2024',
  SERVICE_PORT: process.env.AUTH_PORT || 8080,
  DAML_LEDGER_ID: process.env.DAML_LEDGER_ID || 'sandbox',
  DAML_APP_ID: process.env.DAML_APP_ID || 'agent-tokenization-app',
  TOKEN_EXPIRY: '24h', // Shorter expiry for production
};

// Rate limiting
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 10, // limit each IP to 10 requests per windowMs
  message: { error: 'Too many authentication attempts' }
});

// Mock user database (replace with real database)
const users = {
  'agent-owner': {
    id: 'agent-owner',
    passwordHash: '$2b$10$example', // bcrypt hash
    damlParty: 'Alice',
    role: 'agent_owner',
    permissions: ['create_agents', 'create_usage_tokens', 'view_all']
  },
  'enterprise-user': {
    id: 'enterprise-user',
    passwordHash: '$2b$10$example',
    damlParty: 'Enterprise',
    role: 'enterprise',
    permissions: ['create_usage_tokens', 'view_own']
  },
  'end-user': {
    id: 'end-user',
    passwordHash: '$2b$10$example',
    damlParty: 'Bob',
    role: 'consumer',
    permissions: ['view_own']
  }
};

// Generate DAML JWT Token
function generateDAMLToken(user) {
  const payload = {
    "https://daml.com/ledger-api": {
      "ledgerId": config.DAML_LEDGER_ID,
      "applicationId": config.DAML_APP_ID,
      "actAs": [user.damlParty],
      "admin": user.role === 'agent_owner', // Only agent owners get admin
      "readAs": [user.damlParty]
    },
    "sub": user.damlParty,
    "aud": "https://daml.com/ledger-api",
    "iss": "agent-tokenization-system",
    "userId": user.id,
    "role": user.role,
    "permissions": user.permissions
  };

  return jwt.sign(payload, config.JWT_SECRET, {
    algorithm: 'HS256',
    expiresIn: config.TOKEN_EXPIRY
  });
}

// Authentication endpoint
app.post('/auth/login', authLimiter, async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({
        error: 'Username and password required'
      });
    }

    // Find user
    const user = users[username];
    if (!user) {
      return res.status(401).json({
        error: 'Invalid credentials'
      });
    }

    // Verify password (in production, use proper bcrypt comparison)
    // const validPassword = await bcrypt.compare(password, user.passwordHash);
    const validPassword = password === 'demo123'; // Demo only!

    if (!validPassword) {
      return res.status(401).json({
        error: 'Invalid credentials'
      });
    }

    // Generate DAML JWT
    const damlToken = generateDAMLToken(user);

    res.json({
      success: true,
      token: damlToken,
      user: {
        id: user.id,
        role: user.role,
        damlParty: user.damlParty,
        permissions: user.permissions
      },
      expiresIn: config.TOKEN_EXPIRY
    });

  } catch (error) {
    console.error('Authentication error:', error);
    res.status(500).json({
      error: 'Authentication service error'
    });
  }
});

// Token refresh endpoint
app.post('/auth/refresh', (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'No token provided' });
    }

    const token = authHeader.substring(7);
    const decoded = jwt.verify(token, config.JWT_SECRET);

    // Find user by userId from token
    const user = Object.values(users).find(u => u.id === decoded.userId);
    if (!user) {
      return res.status(401).json({ error: 'Invalid token' });
    }

    // Generate new token
    const newToken = generateDAMLToken(user);

    res.json({
      success: true,
      token: newToken,
      expiresIn: config.TOKEN_EXPIRY
    });

  } catch (error) {
    res.status(401).json({ error: 'Invalid or expired token' });
  }
});

// Validate token endpoint
app.get('/auth/validate', (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'No token provided' });
    }

    const token = authHeader.substring(7);
    const decoded = jwt.verify(token, config.JWT_SECRET);

    res.json({
      valid: true,
      user: {
        id: decoded.userId,
        role: decoded.role,
        damlParty: decoded.sub,
        permissions: decoded.permissions
      },
      expiresAt: new Date(decoded.exp * 1000)
    });

  } catch (error) {
    res.status(401).json({
      valid: false,
      error: 'Invalid or expired token'
    });
  }
});

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    service: 'agent-tokenization-auth',
    timestamp: new Date().toISOString()
  });
});

// Start server
const PORT = config.SERVICE_PORT;
app.listen(PORT, () => {
  console.log(`🔐 Agent Tokenization Auth Service running on port ${PORT}`);
  console.log(`📋 Available endpoints:`);
  console.log(`   POST /auth/login - User authentication`);
  console.log(`   POST /auth/refresh - Token refresh`);
  console.log(`   GET /auth/validate - Token validation`);
  console.log(`   GET /health - Health check`);
  console.log(`\n🧪 Demo users:`);
  console.log(`   agent-owner / demo123 - Alice (Agent Owner)`);
  console.log(`   enterprise-user / demo123 - Enterprise (Enterprise User)`);
  console.log(`   end-user / demo123 - Bob (End User)`);
});

module.exports = app;