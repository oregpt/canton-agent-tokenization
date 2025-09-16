# 🚀 **Real-World Authentication Examples for Your Platform**

## 🎯 **Executive Summary**

Your platform already works with DAML - you just need to **replace manual JWT tokens with the authentication service**. Here are the exact API calls and responses you'll get.

---

## 🔧 **What Changes in Your Platform**

### **Current Code (Manual JWT)**
```javascript
// ❌ What you're doing now
const hardcodedToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6...';

// Your existing API calls work fine, just hardcoded token
fetch('http://localhost:7575/v1/create', {
  headers: { 'Authorization': `Bearer ${hardcodedToken}` }
});
```

### **New Code (Secure Authentication)**
```javascript
// ✅ What you need to change to
const authAPI = 'http://localhost:8080';
const loginResponse = await fetch(`${authAPI}/auth/login`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ username: 'agent-owner', password: 'demo123' })
});

const { token } = await loginResponse.json();

// Same API calls, but with dynamic secure token
fetch('http://localhost:7575/v1/create', {
  headers: { 'Authorization': `Bearer ${token}` }
});
```

---

## 🧪 **Real API Calls & Responses**

### **1. Start Auth Service**
```bash
# Start this once - it runs alongside your DAML server
node auth-service.js
```

**Console Output:**
```
🔐 Agent Tokenization Auth Service running on port 8080
📋 Available endpoints:
   POST /auth/login - User authentication
   POST /auth/refresh - Token refresh
   GET /auth/validate - Token validation
   GET /health - Health check

🧪 Demo users:
   agent-owner / demo123 - Alice (Agent Owner)
   enterprise-user / demo123 - Enterprise (Enterprise User)
   end-user / demo123 - Bob (End User)
```

### **2. Health Check (No Auth Needed)**

**Request:**
```http
GET http://localhost:8080/health
```

**Response:**
```json
{
  "status": "healthy",
  "service": "agent-tokenization-auth",
  "timestamp": "2025-09-16T20:48:50.748Z"
}
```

### **3. User Login (Replace Manual JWT)**

**Request:**
```http
POST http://localhost:8080/auth/login
Content-Type: application/json

{
  "username": "agent-owner",
  "password": "demo123"
}
```

**Response:**
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJBbGljZSJdLCJhZG1pbiI6dHJ1ZSwicmVhZEFzIjpbIkFsaWNlIl19LCJzdWIiOiJBbGljZSIsImF1ZCI6Imh0dHBzOi8vZGFtbC5jb20vbGVkZ2VyLWFwaSIsImlzcyI6ImFnZW50LXRva2VuaXphdGlvbi1zeXN0ZW0iLCJ1c2VySWQiOiJhZ2VudC1vd25lciIsInJvbGUiOiJhZ2VudF9vd25lciIsInBlcm1pc3Npb25zIjpbImNyZWF0ZV9hZ2VudHMiLCJjcmVhdGVfdXNhZ2VfdG9rZW5zIiwidmlld19hbGwiXSwiaWF0IjoxNzU4MDU1NzM2LCJleHAiOjE3NTgxNDIxMzZ9.WLnAoEj1zKF_dVzBpeOOJb9gUaThEz0sVLFbuCVkRzM",
  "user": {
    "id": "agent-owner",
    "role": "agent_owner",
    "damlParty": "Alice",
    "permissions": ["create_agents", "create_usage_tokens", "view_all"]
  },
  "expiresIn": "24h"
}
```

**🔑 Key Point:** This token is what you use for all your existing DAML API calls!

### **4. DAML Health Check (Public)**

**Request:**
```http
GET http://localhost:7575/readyz
```

**Response:**
```
[+] ledger ok (SERVING)
readyz check passed
```

**✅ Important:** Registry health doesn't require authentication - your platform can call this anytime.

### **5. Get Template Package IDs (Authenticated)**

**Request:**
```http
GET http://localhost:7575/v1/packages
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6...
```

**Response:**
```json
{
  "result": [
    "18597917bc74b69da52b6868f118979353b62ebec4363329cd3d843b46e76702",
    "86828b9843465f419db1ef8a8ee741d1eef645df02375ebf509cdc8c3ddd16cb",
    "671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b"
  ],
  "status": 200
}
```

**📋 Template IDs for Your Platform:**
```javascript
const PACKAGE_ID = "671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b";

const TEMPLATES = {
  OWNERSHIP: `${PACKAGE_ID}:AgentTokenizationV2:AgentRegistration`,
  USAGE: `${PACKAGE_ID}:AgentTokenizationV2:AgentUsageToken`
};
```

---

## 🎯 **Available User Roles**

| Username | Password | DAML Party | Can Create Ownership | Can Create Usage | Use Case |
|----------|----------|------------|---------------------|------------------|----------|
| `agent-owner` | `demo123` | Alice | ✅ Yes | ✅ Yes | **Platform admin, AI company** |
| `enterprise-user` | `demo123` | Enterprise | ❌ No | ✅ Yes | **Enterprise customer** |
| `end-user` | `demo123` | Bob | ❌ No | ❌ No | **Individual user** |

---

## 📱 **Your Platform Integration Steps**

### **Step 1: Add Login to Your Platform (5 minutes)**

**Add this JavaScript to your existing platform:**

```javascript
class AgentAuth {
  constructor() {
    this.authUrl = 'http://localhost:8080';
    this.token = localStorage.getItem('agent_token');
    this.user = JSON.parse(localStorage.getItem('agent_user') || 'null');
  }

  async login(username, password) {
    const response = await fetch(`${this.authUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password })
    });

    const data = await response.json();
    if (!response.ok) throw new Error(data.error);

    this.token = data.token;
    this.user = data.user;

    localStorage.setItem('agent_token', this.token);
    localStorage.setItem('agent_user', JSON.stringify(this.user));

    return data;
  }

  getToken() {
    return this.token;
  }

  isLoggedIn() {
    return !!this.token;
  }

  logout() {
    this.token = null;
    this.user = null;
    localStorage.removeItem('agent_token');
    localStorage.removeItem('agent_user');
  }
}
```

### **Step 2: Update Your Existing API Calls (2 minutes)**

**Before:**
```javascript
// ❌ Remove this hardcoded token
const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6...';
```

**After:**
```javascript
// ✅ Use dynamic token
const auth = new AgentAuth();
const token = auth.getToken();

// All your existing API calls work the same!
fetch('http://localhost:7575/v1/create', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`
  },
  body: JSON.stringify({ /* your existing payload */ })
});
```

### **Step 3: Add Login UI (3 minutes)**

```html
<!-- Add to your platform's login page -->
<div id="loginSection">
  <h3>Login to Agent Tokenization</h3>
  <select id="userRole">
    <option value="agent-owner">Agent Owner (Full Access)</option>
    <option value="enterprise-user">Enterprise User</option>
    <option value="end-user">End User</option>
  </select>
  <input type="password" id="password" placeholder="Password: demo123" value="demo123" />
  <button onclick="doLogin()">Login</button>
</div>

<script>
const auth = new AgentAuth();

async function doLogin() {
  const username = document.getElementById('userRole').value;
  const password = document.getElementById('password').value;

  try {
    const result = await auth.login(username, password);
    alert(`Logged in as ${result.user.role}!`);
    document.getElementById('loginSection').style.display = 'none';

    // Show your main app
    showMainApp();
  } catch (error) {
    alert('Login failed: ' + error.message);
  }
}

// Check if already logged in
if (auth.isLoggedIn()) {
  document.getElementById('loginSection').style.display = 'none';
  showMainApp();
}
</script>
```

---

## 🔍 **Template ID Issue Resolution**

**The template ID format you need:**

```javascript
// Update these in your existing API calls
const TEMPLATES = {
  OWNERSHIP: "671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentRegistration",
  USAGE: "671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentUsageToken"
};
```

**Note:** The template format you tried before was missing the correct package ID. These are the correct ones from the live system.

---

## 🚦 **Quick Test**

**Test the complete flow:**

1. **Start auth service:** `node auth-service.js`
2. **Login:** `POST http://localhost:8080/auth/login` with `agent-owner`/`demo123`
3. **Use token:** Take the JWT from response and use in your existing DAML API calls
4. **Success!** Your platform now has secure authentication

---

## 📊 **Error Handling**

### **Authentication Errors**
```json
// Wrong username/password
{
  "error": "Invalid credentials"
}

// Missing fields
{
  "error": "Username and password required"
}
```

### **Rate Limiting**
```json
// Too many login attempts
{
  "error": "Too many authentication attempts"
}
```

### **DAML API Errors**
```json
// Wrong template ID
{
  "errors": ["Cannot resolve any template ID from request"],
  "status": 400
}

// Invalid JWT
{
  "errors": ["missing Authorization header with OAuth 2.0 Bearer Token"],
  "status": 401
}
```

---

## 🎉 **Summary**

**What you accomplished:**

✅ **Auth Service Running** - Port 8080
✅ **DAML Server Running** - Port 7575
✅ **Real JWT Tokens** - Working authentication
✅ **Template IDs** - Correct package format
✅ **User Roles** - agent-owner, enterprise-user, end-user
✅ **Integration Guide** - Ready for your platform

**What your platform needs to change:**

1. **Replace hardcoded JWT** with login call to `http://localhost:8080/auth/login`
2. **Add login UI** with username/password form
3. **Update template IDs** to use package hash format
4. **Test with different user roles**

**Total time:** About 15 minutes to integrate! 🚀

Your platform will then have enterprise-grade authentication while keeping all your existing DAML functionality.