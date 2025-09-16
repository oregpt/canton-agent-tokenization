# 🔗 **Frontend Auth Integration - Use Your Existing Users**

## 💡 **The Smart Approach**

Since your frontend already has users authenticated, let's map them to DAML tokens instead of creating a separate auth system.

---

## 🎯 **Three Integration Patterns**

### **Pattern 1: User Role Mapping (Recommended)**

Map your existing user roles to DAML permissions:

```javascript
// In your frontend, after user logs in to YOUR system
function getDamlTokenForUser(user) {
  const roleMapping = {
    'admin': 'FULL_ACCESS_TOKEN',
    'premium': 'ENTERPRISE_TOKEN',
    'basic': 'VIEW_ONLY_TOKEN'
  };

  return roleMapping[user.role] || 'VIEW_ONLY_TOKEN';
}

// Usage
const user = getCurrentUser(); // Your existing auth
const damlToken = getDamlTokenForUser(user);

// Now use with DAML API
fetch('http://localhost:7575/v1/query', {
  headers: { 'Authorization': `Bearer ${damlToken}` }
});
```

### **Pattern 2: Dynamic Token Generation**

Generate DAML tokens based on your user data:

```javascript
// Add this endpoint to your backend
app.post('/api/daml-token', authenticate, (req, res) => {
  const user = req.user; // From your auth middleware

  // Map your user to DAML permissions
  let damlParty, permissions;

  if (user.isAdmin || user.role === 'premium') {
    damlParty = 'Alice';
    permissions = ['create_agents', 'create_usage_tokens', 'view_all'];
  } else if (user.isPaid || user.role === 'enterprise') {
    damlParty = 'Enterprise';
    permissions = ['create_usage_tokens', 'view_own'];
  } else {
    damlParty = 'Bob';
    permissions = ['view_own'];
  }

  // Generate DAML JWT
  const damlToken = jwt.sign({
    "https://daml.com/ledger-api": {
      "ledgerId": "sandbox",
      "applicationId": "agent-tokenization-app",
      "actAs": [damlParty],
      "admin": permissions.includes('create_agents'),
      "readAs": [damlParty]
    },
    "sub": damlParty,
    "aud": "https://daml.com/ledger-api",
    "iss": "agent-tokenization-system",
    "userId": user.id,
    "role": user.role,
    "permissions": permissions
  }, 'daml-agent-tokenization-secret-2024', {
    algorithm: 'HS256',
    expiresIn: '24h'
  });

  res.json({ damlToken });
});
```

### **Pattern 3: Cached Token Service**

Cache DAML tokens per user to avoid regeneration:

```javascript
// Simple in-memory cache (or use Redis)
const tokenCache = new Map();

class DamlTokenService {
  static async getTokenForUser(user) {
    const cacheKey = `${user.id}-${user.role}`;

    // Check cache first
    if (tokenCache.has(cacheKey)) {
      const cached = tokenCache.get(cacheKey);
      if (cached.expires > Date.now()) {
        return cached.token;
      }
    }

    // Generate new token
    const token = await this.generateTokenForUser(user);

    // Cache for 23 hours (refresh before expiry)
    tokenCache.set(cacheKey, {
      token: token,
      expires: Date.now() + (23 * 60 * 60 * 1000)
    });

    return token;
  }

  static generateTokenForUser(user) {
    // Same logic as Pattern 2
    return jwt.sign({...}, secret, { expiresIn: '24h' });
  }
}
```

---

## 🔧 **Implementation Examples**

### **Option A: Frontend Role Check**

```javascript
// In your React/Vue/Angular app
class AgentTokenizationService {
  constructor() {
    this.tokens = {
      admin: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJBbGljZSJdLCJhZG1pbiI6dHJ1ZSwicmVhZEFzIjpbIkFsaWNlIl19LCJzdWIiOiJBbGljZSIsImF1ZCI6Imh0dHBzOi8vZGFtbC5jb20vbGVkZ2VyLWFwaSIsImlzcyI6ImFnZW50LXRva2VuaXphdGlvbi1zeXN0ZW0iLCJ1c2VySWQiOiJhbGljZSIsInJvbGUiOiJhZ2VudF9vd25lciIsInBlcm1pc3Npb25zIjpbImNyZWF0ZV9hZ2VudHMiLCJjcmVhdGVfdXNhZ2VfdG9rZW5zIiwidmlld19hbGwiXSwiaWF0IjoxNzU4MDYwNzU1LCJleHAiOjE3NzM2MTI3NTV9.8hV4fs36H73ZOEpCGNxJ0W7z2kUDU8JK7CqO8tZGNuI",
      premium: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJFbnRlcnByaXNlIl0sImFkbWluIjpmYWxzZSwicmVhZEFzIjpbIkVudGVycHJpc2UiXX0sInN1YiI6IkVudGVycHJpc2UiLCJhdWQiOiJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiLCJpc3MiOiJhZ2VudC10b2tlbml6YXRpb24tc3lzdGVtIiwidXNlcklkIjoiZW50ZXJwcmlzZSIsInJvbGUiOiJlbnRlcnByaXNlIiwicGVybWlzc2lvbnMiOlsiY3JlYXRlX3VzYWdlX3Rva2VucyIsInZpZXdfb3duIl0sImlhdCI6MTc1ODA2MDc1NSwiZXhwIjoxNzczNjEyNzU1fQ.nZZvW_7tGE6aVWgpX6Pu8E6iHJKlMzWNg8mGRIGGKek",
      basic: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJCb2IiXSwiYWRtaW4iOmZhbHNlLCJyZWFkQXMiOlsiQm9iIl19LCJzdWIiOiJCb2IiLCJhdWQiOiJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiLCJpc3MiOiJhZ2VudC10b2tlbml6YXRpb24tc3lzdGVtIiwidXNlcklkIjoidXNlciIsInJvbGUiOiJjb25zdW1lciIsInBlcm1pc3Npb25zIjpbInZpZXdfb3duIl0sImlhdCI6MTc1ODA2MDc1NSwiZXhwIjoxNzczNjEyNzU1fQ.q1LX3JRRl3-ZPmWnKv8oWHY82Z0KSLsOY3bA9-o5m8Q"
    };
  }

  getDamlToken() {
    const user = this.getCurrentUser(); // Your existing method

    // Map your roles to DAML access levels
    if (user.isAdmin || user.role === 'admin') {
      return this.tokens.admin; // Full access
    }
    if (user.isPremium || user.subscription === 'pro') {
      return this.tokens.premium; // Create tokens
    }
    return this.tokens.basic; // View only
  }

  async createAgent(agentData) {
    const token = this.getDamlToken();

    return fetch('http://localhost:7575/v1/create', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      body: JSON.stringify({
        templateId: "671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentRegistration",
        argument: agentData
      })
    });
  }

  getCurrentUser() {
    // Your existing user method
    return JSON.parse(localStorage.getItem('user')) || {};
  }
}
```

### **Option B: Backend Token Generation**

```javascript
// Add to your existing backend API
const jwt = require('jsonwebtoken');

// Add this route to your existing Express app
app.get('/api/daml-token', yourAuthMiddleware, (req, res) => {
  const user = req.user; // From your auth system

  // Simple role mapping
  const getDamlConfigForUser = (user) => {
    if (user.role === 'admin' || user.isAdmin) {
      return {
        party: 'Alice',
        admin: true,
        permissions: ['create_agents', 'create_usage_tokens', 'view_all']
      };
    }
    if (user.role === 'premium' || user.subscription === 'pro') {
      return {
        party: 'Enterprise',
        admin: false,
        permissions: ['create_usage_tokens', 'view_own']
      };
    }
    return {
      party: 'Bob',
      admin: false,
      permissions: ['view_own']
    };
  };

  const config = getDamlConfigForUser(user);

  const damlToken = jwt.sign({
    "https://daml.com/ledger-api": {
      "ledgerId": "sandbox",
      "applicationId": "agent-tokenization-app",
      "actAs": [config.party],
      "admin": config.admin,
      "readAs": [config.party]
    },
    "sub": config.party,
    "aud": "https://daml.com/ledger-api",
    "iss": "agent-tokenization-system",
    "userId": user.id,
    "role": user.role,
    "permissions": config.permissions
  }, 'daml-agent-tokenization-secret-2024', {
    algorithm: 'HS256',
    expiresIn: '24h'
  });

  res.json({
    damlToken,
    permissions: config.permissions,
    party: config.party
  });
});

// In your frontend
async function getDamlToken() {
  const response = await fetch('/api/daml-token', {
    headers: {
      'Authorization': `Bearer ${yourExistingToken}` // Your auth
    }
  });

  const { damlToken } = await response.json();
  return damlToken;
}
```

---

## 🔄 **Role Mapping Examples**

### **Common Role Mappings:**

```javascript
const ROLE_MAPPINGS = {
  // Your Frontend Role → DAML Permissions
  'admin': { party: 'Alice', level: 'full', permissions: ['create_agents', 'create_usage_tokens', 'view_all'] },
  'owner': { party: 'Alice', level: 'full', permissions: ['create_agents', 'create_usage_tokens', 'view_all'] },
  'premium': { party: 'Enterprise', level: 'enterprise', permissions: ['create_usage_tokens', 'view_own'] },
  'pro': { party: 'Enterprise', level: 'enterprise', permissions: ['create_usage_tokens', 'view_own'] },
  'enterprise': { party: 'Enterprise', level: 'enterprise', permissions: ['create_usage_tokens', 'view_own'] },
  'basic': { party: 'Bob', level: 'view', permissions: ['view_own'] },
  'free': { party: 'Bob', level: 'view', permissions: ['view_own'] },
  'user': { party: 'Bob', level: 'view', permissions: ['view_own'] }
};
```

### **Subscription-Based Mapping:**

```javascript
function getDamlPermissions(user) {
  // Map based on subscription tier
  if (user.subscription === 'enterprise' || user.plan === 'business') {
    return ROLE_MAPPINGS.enterprise;
  }
  if (user.subscription === 'pro' || user.isPaid) {
    return ROLE_MAPPINGS.premium;
  }
  return ROLE_MAPPINGS.basic;
}
```

---

## 🎯 **Benefits of This Approach**

✅ **No duplicate auth** - users already logged into your system
✅ **Leverage existing roles** - map to DAML permissions
✅ **Seamless UX** - no additional login steps
✅ **Your control** - you decide who gets what access
✅ **Simple integration** - just map roles to tokens

---

## 🚀 **Quick Implementation**

**1. Pick your approach:** Frontend mapping (easiest) or Backend generation (more secure)

**2. Map your roles:**
```javascript
const userRole = getCurrentUser().role; // Your existing code
const damlToken = TOKENS[userRole] || TOKENS.basic; // Map to DAML
```

**3. Use with DAML API:**
```javascript
fetch('http://localhost:7575/v1/create', {
  headers: { 'Authorization': `Bearer ${damlToken}` }
});
```

**That's it!** Your existing users now have DAML access based on their current permissions. No separate auth system needed! 🎉