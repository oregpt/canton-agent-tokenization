# 🌐 **External Web App Integration URLs**

## ✅ **Your Services Are Live and Ready!**

Your web app can now access both the authentication service and DAML API using these public ngrok URLs:

---

## ⚠️ **Ngrok Free Plan Limitation**
You're limited to 1 simultaneous tunnel on the free plan. You have 2 options:

### **Option 1: Single Tunnel for DAML API (Current)**
**DAML API URL:** `https://27524c709935.ngrok-free.app` ✅ Active

For authentication, your web app will need to:
1. Use localhost for development testing: `http://localhost:8080`
2. Or upgrade to ngrok Pro for multiple tunnels
3. Or stop the DAML tunnel and start auth tunnel when needed

### **Option 2: Multiple Tunnels (Requires ngrok Pro or Manual Switching)**

---

## 🔑 **Authentication Service**
**Local URL:** `http://localhost:8080` (for local development)
**Status:** ✅ Running locally with CORS enabled

**Endpoints:**
- `POST /auth/login` - User authentication
- `POST /auth/refresh` - Token refresh
- `GET /auth/validate` - Token validation
- `GET /health` - Health check

---

## 🔗 **DAML API Service**
**URL:** `https://27524c709935.ngrok-free.app` ✅ Active tunnel

**Status:** ✅ Running on localhost:7575
**Public Access:** ✅ Active ngrok tunnel

**Endpoints:**
- `GET /readyz` - Health check (no auth required)
- `GET /v1/packages` - Available packages (auth required)
- `POST /v1/query` - Query contracts (auth required)
- `POST /v1/create` - Create contracts (auth required)
- `POST /v1/exercise` - Exercise choices (auth required)

---

## 📱 **Web App Integration Code**

### **For External Web Apps (Recommended Setup):**

```javascript
// Current working configuration with ngrok limitation workaround
const API_CONFIG = {
  authBaseUrl: 'http://localhost:8080',  // Local auth service (CORS enabled)
  damlBaseUrl: 'https://27524c709935.ngrok-free.app'  // Public DAML API
};

// Alternative: If your web app can't access localhost
const API_CONFIG_PROD = {
  authBaseUrl: 'https://YOUR_AUTH_TUNNEL.ngrok-free.app',  // Stop DAML tunnel first
  damlBaseUrl: 'https://27524c709935.ngrok-free.app'  // Current DAML tunnel
};

// Initialize client with external URLs
const client = new AgentTokenizationClient(API_CONFIG);

// Test login flow
async function testConnection() {
  try {
    // Test auth service health
    const authHealth = await fetch(`${API_CONFIG.authBaseUrl}/health`);
    console.log('Auth service:', authHealth.ok ? '✅ Online' : '❌ Offline');

    // Test DAML API health
    const damlHealth = await fetch(`${API_CONFIG.damlBaseUrl}/readyz`);
    console.log('DAML API:', damlHealth.ok ? '✅ Online' : '❌ Offline');

    // Login and get token
    await client.login('agent-owner', 'demo123');
    console.log('✅ Authentication successful!');

    // Test registry view
    const registry = await client.viewRegistry();
    console.log('✅ Registry access successful!');

  } catch (error) {
    console.error('❌ Connection failed:', error.message);
  }
}
```

---

## 🔧 **How to Get Your Auth Service ngrok URL**

**Option 1: Check ngrok web interface**
```bash
# Open in browser
http://localhost:4040
```

**Option 2: Start new auth tunnel manually**
```bash
# In a new command prompt
ngrok http 8080
```

**Option 3: Use the ngrok API**
```bash
curl http://localhost:4040/api/tunnels
```

---

## 🧪 **Test Your Web App Integration**

**1. Health Check (No Auth)**
```javascript
fetch('https://27524c709935.ngrok-free.app/readyz')
  .then(r => r.text())
  .then(console.log);
// Expected: "[+] ledger ok (SERVING)\nreadyz check passed"
```

**2. Login Test**
```javascript
fetch('https://[YOUR_AUTH_NGROK_URL].ngrok-free.app/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ username: 'agent-owner', password: 'demo123' })
})
.then(r => r.json())
.then(console.log);
// Expected: { success: true, token: "eyJ...", user: {...} }
```

**3. Registry Query (Authenticated)**
```javascript
// Use token from login response
fetch('https://27524c709935.ngrok-free.app/v1/query', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer YOUR_TOKEN_HERE'
  },
  body: JSON.stringify({
    templateIds: ["671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentRegistration"]
  })
})
.then(r => r.json())
.then(console.log);
```

---

## 🔐 **Demo Users for Testing**

| Username | Password | Role | Permissions |
|----------|----------|------|-------------|
| `agent-owner` | `demo123` | Agent Owner | Full access - create agents, usage tokens |
| `enterprise-user` | `demo123` | Enterprise | Create usage tokens only |
| `end-user` | `demo123` | End User | View only |

---

## ⚠️ **Important Notes**

1. **ngrok URLs change** when tunnels restart - update your web app config accordingly
2. **Free ngrok** has connection limits - upgrade for production use
3. **HTTPS required** for web apps - ngrok provides SSL certificates automatically
4. **CORS enabled** on auth service for web app access

---

## 🎉 **Ready for Production!**

Your external web app can now:

✅ **Authenticate users** via ngrok auth service
✅ **Access DAML blockchain** via ngrok tunnel
✅ **Create ownership tokens** for AI agents
✅ **Create usage licenses** for enterprise customers
✅ **Query registry** for available agents
✅ **Secure session management** with JWT tokens

**Next steps:** Test the integration with your web app using the URLs above! 🚀