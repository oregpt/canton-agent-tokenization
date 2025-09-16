# 🚀 **No-Auth Solution - Direct DAML API Access**

## 💡 **Skip Authentication Completely!**

Just use these pre-generated JWT tokens directly with the DAML API. **No auth service calls needed!**

---

## 🔑 **Ready-to-Use JWT Tokens (180 days)**

### **Full Access Token (Alice - Agent Owner)**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJBbGljZSJdLCJhZG1pbiI6dHJ1ZSwicmVhZEFzIjpbIkFsaWNlIl19LCJzdWIiOiJBbGljZSIsImF1ZCI6Imh0dHBzOi8vZGFtbC5jb20vbGVkZ2VyLWFwaSIsImlzcyI6ImFnZW50LXRva2VuaXphdGlvbi1zeXN0ZW0iLCJ1c2VySWQiOiJhbGljZSIsInJvbGUiOiJhZ2VudF9vd25lciIsInBlcm1pc3Npb25zIjpbImNyZWF0ZV9hZ2VudHMiLCJjcmVhdGVfdXNhZ2VfdG9rZW5zIiwidmlld19hbGwiXSwiaWF0IjoxNzU4MDYwNzU1LCJleHAiOjE3NzM2MTI3NTV9.8hV4fs36H73ZOEpCGNxJ0W7z2kUDU8JK7CqO8tZGNuI
```
**Use for:** Creating agents, creating usage tokens, full access

### **Enterprise Token (Enterprise User)**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJFbnRlcnByaXNlIl0sImFkbWluIjpmYWxzZSwicmVhZEFzIjpbIkVudGVycHJpc2UiXX0sInN1YiI6IkVudGVycHJpc2UiLCJhdWQiOiJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiLCJpc3MiOiJhZ2VudC10b2tlbml6YXRpb24tc3lzdGVtIiwidXNlcklkIjoiZW50ZXJwcmlzZSIsInJvbGUiOiJlbnRlcnByaXNlIiwicGVybWlzc2lvbnMiOlsiY3JlYXRlX3VzYWdlX3Rva2VucyIsInZpZXdfb3duIl0sImlhdCI6MTc1ODA2MDc1NSwiZXhwIjoxNzczNjEyNzU1fQ.nZZvW_7tGE6aVWgpX6Pu8E6iHJKlMzWNg8mGRIGGKek
```
**Use for:** Creating usage tokens only

### **View-Only Token (End User)**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJCb2IiXSwiYWRtaW4iOmZhbHNlLCJyZWFkQXMiOlsiQm9iIl19LCJzdWIiOiJCb2IiLCJhdWQiOiJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiLCJpc3MiOiJhZ2VudC10b2tlbml6YXRpb24tc3lzdGVtIiwidXNlcklkIjoidXNlciIsInJvbGUiOiJjb25zdW1lciIsInBlcm1pc3Npb25zIjpbInZpZXdfb3duIl0sImlhdCI6MTc1ODA2MDc1NSwiZXhwIjoxNzczNjEyNzU1fQ.q1LX3JRRl3-ZPmWnKv8oWHY82Z0KSLsOY3bA9-o5m8Q
```
**Use for:** Viewing registry only

---

## 🚀 **Direct API Usage (No Auth Service)**

### **For Local Development:**
```javascript
// Just use the token directly!
const FULL_ACCESS_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJBbGljZSJdLCJhZG1pbiI6dHJ1ZSwicmVhZEFzIjpbIkFsaWNlIl19LCJzdWIiOiJBbGljZSIsImF1ZCI6Imh0dHBzOi8vZGFtbC5jb20vbGVkZ2VyLWFwaSIsImlzcyI6ImFnZW50LXRva2VuaXphdGlvbi1zeXN0ZW0iLCJ1c2VySWQiOiJhbGljZSIsInJvbGUiOiJhZ2VudF9vd25lciIsInBlcm1pc3Npb25zIjpbImNyZWF0ZV9hZ2VudHMiLCJjcmVhdGVfdXNhZ2VfdG9rZW5zIiwidmlld19hbGwiXSwiaWF0IjoxNzU4MDYwNzU1LCJleHAiOjE3NzM2MTI3NTV9.8hV4fs36H73ZOEpCGNxJ0W7z2kUDU8JK7CqO8tZGNuI";

const API_BASE = "http://localhost:7575";

// Test health
fetch(`${API_BASE}/readyz`)
  .then(r => r.text())
  .then(console.log);

// Query agents
fetch(`${API_BASE}/v1/query`, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${FULL_ACCESS_TOKEN}`
  },
  body: JSON.stringify({
    templateIds: ["671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentRegistration"]
  })
})
.then(r => r.json())
.then(console.log);
```

### **For External Web Apps (with ngrok):**
```javascript
// 1. Start ngrok: ngrok http 7575
// 2. Use your ngrok URL
const API_BASE = "https://YOUR_NGROK_URL.ngrok-free.app";
const TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."; // Full token from above

fetch(`${API_BASE}/v1/query`, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${TOKEN}`
  },
  body: JSON.stringify({
    templateIds: ["671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentRegistration"]
  })
})
.then(r => r.json())
.then(console.log);
```

---

## 🧪 **Instant Test Commands**

### **Health Check (No Auth Required):**
```bash
curl http://localhost:7575/readyz
```

### **View Registry:**
```bash
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJBbGljZSJdLCJhZG1pbiI6dHJ1ZSwicmVhZEFzIjpbIkFsaWNlIl19LCJzdWIiOiJBbGljZSIsImF1ZCI6Imh0dHBzOi8vZGFtbC5jb20vbGVkZ2VyLWFwaSIsImlzcyI6ImFnZW50LXRva2VuaXphdGlvbi1zeXN0ZW0iLCJ1c2VySWQiOiJhbGljZSIsInJvbGUiOiJhZ2VudF9vd25lciIsInBlcm1pc3Npb25zIjpbImNyZWF0ZV9hZ2VudHMiLCJjcmVhdGVfdXNhZ2VfdG9rZW5zIiwidmlld19hbGwiXSwiaWF0IjoxNzU4MDYwNzU1LCJleHAiOjE3NzM2MTI3NTV9.8hV4fs36H73ZOEpCGNxJ0W7z2kUDU8JK7CqO8tZGNuI" \
  -d '{"templateIds":["671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentRegistration"]}'
```

### **Create Agent (Full Access Token Only):**
```bash
curl -X POST http://localhost:7575/v1/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJBbGljZSJdLCJhZG1pbiI6dHJ1ZSwicmVhZEFzIjpbIkFsaWNlIl19LCJzdWIiOiJBbGljZSIsImF1ZCI6Imh0dHBzOi8vZGFtbC5jb20vbGVkZ2VyLWFwaSIsImlzcyI6ImFnZW50LXRva2VuaXphdGlvbi1zeXN0ZW0iLCJ1c2VySWQiOiJhbGljZSIsInJvbGUiOiJhZ2VudF9vd25lciIsInBlcm1pc3Npb25zIjpbImNyZWF0ZV9hZ2VudHMiLCJjcmVhdGVfdXNhZ2VfdG9rZW5zIiwidmlld19hbGwiXSwiaWF0IjoxNzU4MDYwNzU1LCJleHAiOjE3NzM2MTI3NTV9.8hV4fs36H73ZOEpCGNxJ0W7z2kUDU8JK7CqO8tZGNuI" \
  -d '{
    "templateId": "671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentRegistration",
    "argument": {
      "operator": "Alice",
      "agentId": "test-agent-123",
      "name": "My Test Agent",
      "description": "A test AI agent",
      "agentType": "LLM",
      "capabilities": ["text_generation"],
      "attributes": {},
      "isActive": true
    }
  }'
```

---

## 🎯 **Summary**

### **Zero Authentication Approach:**
1. **Copy a JWT token** from above (based on access level needed)
2. **Use directly with DAML API** - no auth service calls
3. **Tokens last 180 days** - set it and forget it

### **Which Token to Use:**
- **Testing/Demo:** Use the Full Access Token
- **Enterprise Integration:** Use the Enterprise Token
- **Public/View-Only:** Use the View-Only Token

### **No Auth Service Required:**
- ❌ No need to call `/auth/login`
- ❌ No need to run auth service
- ❌ No username/password management
- ✅ Just copy token and use directly!

**This is the simplest possible approach!** 🚀