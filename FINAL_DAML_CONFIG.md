# 🎯 **Final DAML Configuration - Ready for Agent Integration**

## 🚀 **Service Status**

✅ **DAML Service:** Running on `localhost:7575`
✅ **Canton Blockchain:** Running with PostgreSQL persistence
✅ **JWT Tokens:** 180-day pre-generated tokens ready
❌ **Auth Service:** Killed (no longer needed)
⚠️  **ngrok Tunnel:** `https://1ee63f126511.ngrok-free.app` (still pointing to 8080, see workaround below)

---

## 🔧 **Agent Integration Configuration**

### **DAML API Endpoints:**

```javascript
// For Local Development
const DAML_API_BASE = "http://localhost:7575";

// For External Access (Temporary Workaround)
// Since ngrok free plan limits to 1 tunnel, you can:
// 1. Kill the current ngrok: taskkill /f /im ngrok.exe
// 2. Start new tunnel: ngrok http 7575
// 3. Use the new URL provided

// Alternative: Use the current tunnel with port forwarding
const DAML_API_BASE = "https://1ee63f126511.ngrok-free.app";
// NOTE: This URL currently points to 8080, not 7575
```

### **Role-Based JWT Tokens (180-day expiry):**

```javascript
const TOKENS = {
  // 🔥 PLATFORM_ADMIN_TOKEN - Full access (create agents, tokens, view all)
  PLATFORM_ADMIN: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJBbGljZSJdLCJhZG1pbiI6dHJ1ZSwicmVhZEFzIjpbIkFsaWNlIl19LCJzdWIiOiJBbGljZSIsImF1ZCI6Imh0dHBzOi8vZGFtbC5jb20vbGVkZ2VyLWFwaSIsImlzcyI6ImFnZW50LXRva2VuaXphdGlvbi1zeXN0ZW0iLCJ1c2VySWQiOiJhbGljZSIsInJvbGUiOiJhZ2VudF9vd25lciIsInBlcm1pc3Npb25zIjpbImNyZWF0ZV9hZ2VudHMiLCJjcmVhdGVfdXNhZ2VfdG9rZW5zIiwidmlld19hbGwiXSwiaWF0IjoxNzU4MDYwNzU1LCJleHAiOjE3NzM2MTI3NTV9.8hV4fs36H73ZOEpCGNxJ0W7z2kUDU8JK7CqO8tZGNuI",

  // 👤 ADMIN_TOKEN - Agent owner access (create agents and tokens)
  ADMIN: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJBbGljZSJdLCJhZG1pbiI6dHJ1ZSwicmVhZEFzIjpbIkFsaWNlIl19LCJzdWIiOiJBbGljZSIsImF1ZCI6Imh0dHBzOi8vZGFtbC5jb20vbGVkZ2VyLWFwaSIsImlzcyI6ImFnZW50LXRva2VuaXphdGlvbi1zeXN0ZW0iLCJ1c2VySWQiOiJhZG1pbiIsInJvbGUiOiJhZG1pbiIsInBlcm1pc3Npb25zIjpbImNyZWF0ZV9hZ2VudHMiLCJjcmVhdGVfdXNhZ2VfdG9rZW5zIiwidmlld19hbGwiXSwiaWF0IjoxNzU4MDYwNzU1LCJleHAiOjE3NzM2MTI3NTV9.8hV4fs36H73ZOEpCGNxJ0W7z2kUDU8JK7CqO8tZGNuI",

  // 🏢 USER_TOKEN - Enterprise access (create usage tokens only)
  USER: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJFbnRlcnByaXNlIl0sImFkbWluIjpmYWxzZSwicmVhZEFzIjpbIkVudGVycHJpc2UiXX0sInN1YiI6IkVudGVycHJpc2UiLCJhdWQiOiJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiLCJpc3MiOiJhZ2VudC10b2tlbml6YXRpb24tc3lzdGVtIiwidXNlcklkIjoiZW50ZXJwcmlzZSIsInJvbGUiOiJlbnRlcnByaXNlIiwicGVybWlzc2lvbnMiOlsiY3JlYXRlX3VzYWdlX3Rva2VucyIsInZpZXdfb3duIl0sImlhdCI6MTc1ODA2MDc1NSwiZXhwIjoxNzczNjEyNzU1fQ.nZZvW_7tGE6aVWgpX6Pu8E6iHJKlMzWNg8mGRIGGKek",

  // 👁️ VIEWER_TOKEN - View only access (read agent registry)
  VIEWER: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJCb2IiXSwiYWRtaW4iOmZhbHNlLCJyZWFkQXMiOlsiQm9iIl19LCJzdWIiOiJCb2IiLCJhdWQiOiJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiLCJpc3MiOiJhZ2VudC10b2tlbml6YXRpb24tc3lzdGVtIiwidXNlcklkIjoidXNlciIsInJvbGUiOiJjb25zdW1lciIsInBlcm1pc3Npb25zIjpbInZpZXdfb3duIl0sImlhdCI6MTc1ODA2MDc1NSwiZXhwIjoxNzczNjEyNzU1fQ.q1LX3JRRl3-ZPmWnKv8oWHY82Z0KSLsOY3bA9-o5m8Q"
};
```

---

## 📋 **Template IDs for Contract Operations:**

```javascript
const TEMPLATE_IDS = {
  AGENT_REGISTRATION: "671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentRegistration",
  AGENT_USAGE_TOKEN: "671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentUsageToken"
};
```

---

## 🔥 **Ready-to-Use API Examples:**

### **1. Health Check (No Auth Required):**
```javascript
fetch(`${DAML_API_BASE}/readyz`)
  .then(r => r.text())
  .then(console.log);
```

### **2. View Agent Registry:**
```javascript
fetch(`${DAML_API_BASE}/v1/query`, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${TOKENS.PLATFORM_ADMIN}`
  },
  body: JSON.stringify({
    templateIds: [TEMPLATE_IDS.AGENT_REGISTRATION]
  })
})
.then(r => r.json())
.then(console.log);
```

### **3. Create Agent (Admin Only):**
```javascript
fetch(`${DAML_API_BASE}/v1/create`, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${TOKENS.PLATFORM_ADMIN}`
  },
  body: JSON.stringify({
    templateId: TEMPLATE_IDS.AGENT_REGISTRATION,
    argument: {
      operator: "Alice",
      agentId: `agent-${Date.now()}`,
      name: "AI Assistant",
      description: "Customer service agent",
      agentType: "LLM",
      capabilities: ["text_generation", "customer_support"],
      attributes: {
        model: "gpt-4",
        version: "2024.1"
      },
      isActive: true
    }
  })
})
.then(r => r.json())
.then(console.log);
```

### **4. Create Usage Token:**
```javascript
fetch(`${DAML_API_BASE}/v1/create`, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${TOKENS.USER}`
  },
  body: JSON.stringify({
    templateId: TEMPLATE_IDS.AGENT_USAGE_TOKEN,
    argument: {
      operator: "Enterprise",
      agentId: "agent-123",
      tokenId: `usage-${Date.now()}`,
      usageType: "monthly",
      maxUsage: 1000,
      currentUsage: 0,
      metadata: {
        plan: "enterprise",
        expires: "2024-12-31"
      },
      isActive: true
    }
  })
})
.then(r => r.json())
.then(console.log);
```

---

## 🎯 **Token Usage Mapping:**

| Token Type | Use Case | Permissions |
|------------|----------|-------------|
| `PLATFORM_ADMIN` | Platform owners, full control | Create agents, tokens, view all |
| `ADMIN` | Agent owners, manage their agents | Create agents, tokens, view all |
| `USER` | Enterprise customers | Create usage tokens, view own |
| `VIEWER` | Basic users, browse marketplace | View agent registry only |

---

## 🔧 **ngrok Tunnel Setup (For External Access):**

Since you're on the free ngrok plan (1 tunnel limit), to get external access to DAML API:

```bash
# Kill current tunnel
taskkill /f /im ngrok.exe

# Start tunnel for DAML API
ngrok http 7575

# You'll get a new URL like: https://abc123.ngrok-free.app
# Use this URL instead of localhost:7575
```

---

## ✅ **System Ready!**

Your Canton blockchain with DAML agent tokenization is now running and ready for integration. The auth service has been killed since you just need the JWT tokens for direct DAML API access.

**Key Points:**
- ✅ DAML service running on port 7575
- ✅ Pre-generated 180-day JWT tokens
- ✅ PostgreSQL persistence enabled
- ✅ All contract templates deployed
- ✅ No auth service needed (direct JWT access)

Your agent can now integrate using the tokens and API endpoints above! 🚀