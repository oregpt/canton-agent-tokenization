# 🚀 **Platform Integration Guide - Real Authentication Flow**

## 🔧 **What You Need to Change in Your Platform**

Since you already have the DAML API integration working, you only need to **replace manual JWT handling with the authentication service**.

---

## 📋 **Before vs After**

### **❌ BEFORE: Manual Token (Current)**
```javascript
// Your current approach
const hardcodedToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6...';

fetch('http://localhost:7575/v1/create', {
  headers: { 'Authorization': `Bearer ${hardcodedToken}` }
});
```

### **✅ AFTER: Authentication Service (Secure)**
```javascript
// New secure approach
const authService = new AuthService('http://localhost:8080');
const token = await authService.login('agent-owner', 'demo123');

fetch('http://localhost:7575/v1/create', {
  headers: { 'Authorization': `Bearer ${token}` }
});
```

---

## 🔑 **Step-by-Step Integration**

### **Step 1: Add Authentication Endpoints**

**Add to your platform's API client:**

```javascript
class AgentTokenizationAPI {
  constructor() {
    this.authBaseUrl = 'http://localhost:8080';  // New auth service
    this.damlBaseUrl = 'http://localhost:7575';  // Existing DAML API
    this.token = null;
    this.user = null;
  }

  // NEW: Login method
  async login(username, password) {
    const response = await fetch(`${this.authBaseUrl}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password })
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.error);
    }

    this.token = data.token;
    this.user = data.user;

    // Store in localStorage for persistence
    localStorage.setItem('agent_token', data.token);
    localStorage.setItem('agent_user', JSON.stringify(data.user));

    return data;
  }

  // NEW: Auto-restore session
  restoreSession() {
    this.token = localStorage.getItem('agent_token');
    const userStr = localStorage.getItem('agent_user');
    this.user = userStr ? JSON.parse(userStr) : null;
    return !!this.token;
  }

  // MODIFIED: Add auto-authentication to existing methods
  async makeRequest(endpoint, options = {}) {
    if (!this.token) {
      throw new Error('Please login first');
    }

    // Your existing request logic, but with dynamic token
    return fetch(`${this.damlBaseUrl}${endpoint}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.token}`,  // Dynamic token
        ...options.headers
      }
    });
  }
}
```

### **Step 2: Update Your UI Login Flow**

**Add login form to your platform:**

```html
<!-- Add this to your platform's login page -->
<form id="loginForm">
  <select id="userRole">
    <option value="agent-owner">Agent Owner (Alice)</option>
    <option value="enterprise-user">Enterprise User</option>
    <option value="end-user">End User (Bob)</option>
  </select>
  <input type="password" id="password" placeholder="Password: demo123" />
  <button type="submit">Login</button>
</form>

<script>
document.getElementById('loginForm').onsubmit = async (e) => {
  e.preventDefault();

  const username = document.getElementById('userRole').value;
  const password = document.getElementById('password').value;

  try {
    const result = await api.login(username, password);
    console.log('Logged in as:', result.user);

    // Now redirect to your main app or refresh the UI
    location.reload();
  } catch (error) {
    alert('Login failed: ' + error.message);
  }
};
</script>
```

### **Step 3: Session Management**

**Add to your platform's app startup:**

```javascript
// On page load, try to restore session
window.addEventListener('load', async () => {
  const api = new AgentTokenizationAPI();

  if (api.restoreSession()) {
    console.log('Session restored for:', api.user);
    // User is logged in, show main app
    showMainApp();
  } else {
    // Show login form
    showLoginForm();
  }
});
```

---

## 🧪 **Real API Calls & Responses**

### **1. Authentication Service Health Check**

```bash
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

### **2. User Login**

```bash
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

### **3. View Registry (Public - No Auth)**

```bash
GET http://localhost:7575/readyz
```

**Response:**
```
[+] ledger ok (SERVING)
readyz check passed
```

**✅ Key Point:** View registry health check doesn't require authentication - your platform can call this freely.

### **4. Get Available Packages (Authenticated)**

```bash
GET http://localhost:7575/v1/packages
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response:**
```json
{
  "result": [
    "18597917bc74b69da52b6868f118979353b62ebec4363329cd3d843b46e76702",
    "86828b9843465f419db1ef8a8ee741d1eef645df02375ebf509cdc8c3ddd16cb",
    "...many more packages...",
    "671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b"
  ],
  "status": 200
}
```

**🔍 Template ID:** Use the last package ID: `671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b`

---

## 📊 **Template ID Discovery**

**The template IDs you need for your existing API calls:**

```javascript
const TEMPLATE_IDS = {
  OWNERSHIP_TOKEN: "671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentRegistration",
  USAGE_TOKEN: "671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentUsageToken"
};
```

---

## 🎯 **Available Users for Testing**

| Username | Password | Role | DAML Party | Can Create Ownership | Can Create Usage | Can View All |
|----------|----------|------|------------|---------------------|------------------|--------------|
| `agent-owner` | `demo123` | Agent Owner | Alice | ✅ | ✅ | ✅ |
| `enterprise-user` | `demo123` | Enterprise | Enterprise | ❌ | ✅ | ❌ |
| `end-user` | `demo123` | End User | Bob | ❌ | ❌ | ❌ |

---

## 🔧 **Migration Checklist**

### **Phase 1: Basic Integration (30 minutes)**
- [ ] Add authentication service calls to your API client
- [ ] Replace hardcoded JWT token with dynamic token from auth service
- [ ] Add login form to your platform
- [ ] Test login flow with `agent-owner` / `demo123`

### **Phase 2: Session Management (15 minutes)**
- [ ] Add localStorage token persistence
- [ ] Add session restoration on page load
- [ ] Add logout functionality

### **Phase 3: Template ID Update (10 minutes)**
- [ ] Update your existing API calls to use correct template IDs:
  - Ownership: `671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentRegistration`
  - Usage: `671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentUsageToken`

### **Phase 4: Testing (15 minutes)**
- [ ] Test ownership token creation with authenticated user
- [ ] Test usage token creation
- [ ] Test different user roles and permissions
- [ ] Verify session persistence across page reloads

---

## 🚦 **Quick Start**

**1. Start the auth service:**
```bash
cd "C:\Users\oreph\Documents\Canton\DAML Projects\CantonAgentTokenization"
node auth-service.js
```

**2. Update your platform's API calls:**
```javascript
// Replace this in your platform
const token = 'hardcoded-jwt-token';

// With this
const api = new AgentTokenizationAPI();
await api.login('agent-owner', 'demo123');
// api.token is now automatically set and valid
```

**3. Test with curl:**
```bash
# Login
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username": "agent-owner", "password": "demo123"}'

# Use token from response in your existing API calls
```

---

## 🎉 **Benefits of This Change**

| Feature | Before (Manual JWT) | After (Auth Service) |
|---------|-------------------|----------------------|
| **Security** | ❌ Exposed tokens | ✅ Server-generated |
| **Expiry** | ❌ 180 days | ✅ 24 hours |
| **User Management** | ❌ One user | ✅ Multiple roles |
| **Session Persistence** | ❌ None | ✅ localStorage |
| **Token Refresh** | ❌ Manual | ✅ Automatic |
| **Development Experience** | ❌ Copy/paste tokens | ✅ Simple login |

**Your platform will now have enterprise-grade authentication while keeping all your existing DAML API integration!** 🚀