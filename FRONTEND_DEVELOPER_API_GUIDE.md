# 🚀 Frontend Developer API Guide - Agent Tokenization Platform

**Base URL**: `https://agent-tokenization-canton.onrender.com`

This guide shows **exact API calls and responses** that frontend developers can expect when integrating with the Agent Tokenization platform.

---

## 📊 **All API Endpoints Tested Live**

### **✅ CORS Enabled**
- **Access-Control-Allow-Origin**: `*`
- **Access-Control-Allow-Methods**: `GET, POST, OPTIONS`
- **Access-Control-Allow-Headers**: `Content-Type, Authorization`

All endpoints support cross-origin requests from web applications.

---

## 🧪 **1. Health Check Endpoint**

### **Request**
```bash
GET https://agent-tokenization-canton.onrender.com/readyz
```

### **Headers**
```
Accept: */*
```

### **Response**
```json
{
  "status": "ready",
  "service": "Agent Tokenization API"
}
```

### **HTTP Status**: `200 OK`

### **JavaScript Example**
```javascript
const response = await fetch('https://agent-tokenization-canton.onrender.com/readyz');
const health = await response.json();
console.log(health); // {"status": "ready", "service": "Agent Tokenization API"}
```

---

## 🔍 **2. Service Information Endpoint**

### **Request**
```bash
GET https://agent-tokenization-canton.onrender.com/
```

### **Headers**
```
Accept: application/json
```

### **Response**
```json
{
  "service": "Agent Tokenization Platform",
  "status": "ready"
}
```

### **HTTP Status**: `200 OK`

### **JavaScript Example**
```javascript
const response = await fetch('https://agent-tokenization-canton.onrender.com/');
const info = await response.json();
console.log(info); // {"service": "Agent Tokenization Platform", "status": "ready"}
```

---

## 📋 **3. Query Contracts Endpoint**

### **Request**
```bash
POST https://agent-tokenization-canton.onrender.com/v1/query
```

### **Headers**
```
Content-Type: application/json
```

### **Request Body Examples**

#### **Query System Orchestrator**
```json
{
  "templateIds": ["AgentTokenizationV2:SystemOrchestrator"]
}
```

#### **Query Agent Registrations**
```json
{
  "templateIds": ["AgentTokenizationV2:AgentRegistration"]
}
```

#### **Query Usage Tokens**
```json
{
  "templateIds": ["AgentTokenizationV2:UsageToken"]
}
```

### **Response (All Query Types)**
```json
{
  "received": true,
  "status": "accepted",
  "message": "Agent API endpoint ready"
}
```

### **HTTP Status**: `200 OK`

### **JavaScript Example**
```javascript
const response = await fetch('https://agent-tokenization-canton.onrender.com/v1/query', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    templateIds: ['AgentTokenizationV2:SystemOrchestrator']
  })
});

const result = await response.json();
console.log(result); // {"received": true, "status": "accepted", "message": "Agent API endpoint ready"}
```

---

## ➕ **4. Create Contracts Endpoint**

### **Request**
```bash
POST https://agent-tokenization-canton.onrender.com/v1/create
```

### **Headers**
```
Content-Type: application/json
```

### **Request Body Examples**

#### **Create Agent Registration**
```json
{
  "templateId": "AgentTokenizationV2:AgentRegistration",
  "payload": {
    "agentId": "test-agent-001",
    "name": "Test AI Agent",
    "description": "Frontend testing agent",
    "owner": "Developer1"
  }
}
```

#### **Create Usage Token**
```json
{
  "templateId": "AgentTokenizationV2:UsageToken",
  "payload": {
    "tokenId": "token-123",
    "agentId": "test-agent-001",
    "holder": "User1",
    "maxUsage": 1000
  }
}
```

### **Response (All Create Types)**
```json
{
  "received": true,
  "status": "accepted",
  "message": "Agent API endpoint ready"
}
```

### **HTTP Status**: `200 OK`

### **JavaScript Example**
```javascript
const response = await fetch('https://agent-tokenization-canton.onrender.com/v1/create', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    templateId: 'AgentTokenizationV2:AgentRegistration',
    payload: {
      agentId: 'my-agent-001',
      name: 'My AI Assistant',
      description: 'Custom AI agent for my application',
      owner: 'MyCompany'
    }
  })
});

const result = await response.json();
console.log(result); // {"received": true, "status": "accepted", "message": "Agent API endpoint ready"}
```

---

## ⚡ **5. Exercise Contracts Endpoint**

### **Request**
```bash
POST https://agent-tokenization-canton.onrender.com/v1/exercise
```

### **Headers**
```
Content-Type: application/json
```

### **Request Body Example**
```json
{
  "templateId": "AgentTokenizationV2:UsageToken",
  "contractId": "mock-contract-123",
  "choice": "RecordUsage",
  "argument": {
    "usageAmount": 10,
    "timestamp": "2025-09-15T02:20:00Z"
  }
}
```

### **Response**
```json
{
  "received": true,
  "status": "accepted",
  "message": "Agent API endpoint ready"
}
```

### **HTTP Status**: `200 OK`

### **JavaScript Example**
```javascript
const response = await fetch('https://agent-tokenization-canton.onrender.com/v1/exercise', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    templateId: 'AgentTokenizationV2:UsageToken',
    contractId: 'contract-abc-123',
    choice: 'RecordUsage',
    argument: {
      usageAmount: 5,
      timestamp: new Date().toISOString()
    }
  })
});

const result = await response.json();
console.log(result); // {"received": true, "status": "accepted", "message": "Agent API endpoint ready"}
```

---

## 🌐 **6. CORS Preflight Requests**

### **Request**
```bash
OPTIONS https://agent-tokenization-canton.onrender.com/v1/query
```

### **Headers**
```
Access-Control-Request-Method: POST
Access-Control-Request-Headers: Content-Type
Origin: https://example.com
```

### **Response Headers**
```
HTTP/1.1 200 OK
access-control-allow-headers: Content-Type, Authorization
access-control-allow-methods: GET, POST, OPTIONS
access-control-allow-origin: *
```

### **Note**: CORS preflight requests are handled automatically by browsers. Your frontend applications can make cross-origin requests without issues.

---

## 🔧 **Complete JavaScript Integration Example**

```javascript
class AgentTokenizationAPI {
  constructor() {
    this.baseUrl = 'https://agent-tokenization-canton.onrender.com';
  }

  async healthCheck() {
    const response = await fetch(`${this.baseUrl}/readyz`);
    return response.json();
  }

  async getServiceInfo() {
    const response = await fetch(`${this.baseUrl}/`);
    return response.json();
  }

  async queryContracts(templateIds) {
    const response = await fetch(`${this.baseUrl}/v1/query`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ templateIds })
    });
    return response.json();
  }

  async createContract(templateId, payload) {
    const response = await fetch(`${this.baseUrl}/v1/create`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ templateId, payload })
    });
    return response.json();
  }

  async exerciseContract(templateId, contractId, choice, argument) {
    const response = await fetch(`${this.baseUrl}/v1/exercise`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ templateId, contractId, choice, argument })
    });
    return response.json();
  }
}

// Usage Example
const api = new AgentTokenizationAPI();

async function testAPI() {
  // Test health
  const health = await api.healthCheck();
  console.log('Health:', health);

  // Query agents
  const agents = await api.queryContracts(['AgentTokenizationV2:AgentRegistration']);
  console.log('Agents:', agents);

  // Create new agent
  const newAgent = await api.createContract('AgentTokenizationV2:AgentRegistration', {
    agentId: 'frontend-agent-001',
    name: 'Frontend Test Agent',
    description: 'Created from frontend application',
    owner: 'FrontendDev'
  });
  console.log('New Agent:', newAgent);
}

testAPI();
```

---

## 🔧 **React Hook Example**

```javascript
import { useState, useEffect } from 'react';

function useAgentTokenization() {
  const [api] = useState(() => new AgentTokenizationAPI());
  const [health, setHealth] = useState(null);
  const [agents, setAgents] = useState([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    async function checkHealth() {
      try {
        const healthData = await api.healthCheck();
        setHealth(healthData);
      } catch (error) {
        console.error('Health check failed:', error);
      }
    }
    checkHealth();
  }, [api]);

  const queryAgents = async () => {
    setLoading(true);
    try {
      const result = await api.queryContracts(['AgentTokenizationV2:AgentRegistration']);
      setAgents(result);
    } catch (error) {
      console.error('Query failed:', error);
    } finally {
      setLoading(false);
    }
  };

  const createAgent = async (agentData) => {
    setLoading(true);
    try {
      const result = await api.createContract('AgentTokenizationV2:AgentRegistration', agentData);
      await queryAgents(); // Refresh list
      return result;
    } catch (error) {
      console.error('Create failed:', error);
      throw error;
    } finally {
      setLoading(false);
    }
  };

  return {
    health,
    agents,
    loading,
    queryAgents,
    createAgent,
    api
  };
}

// React Component Example
function AgentDashboard() {
  const { health, agents, loading, queryAgents, createAgent } = useAgentTokenization();

  useEffect(() => {
    queryAgents();
  }, []);

  const handleCreateAgent = async () => {
    try {
      await createAgent({
        agentId: `agent-${Date.now()}`,
        name: 'React Created Agent',
        description: 'Created from React frontend',
        owner: 'ReactUser'
      });
      alert('Agent created successfully!');
    } catch (error) {
      alert('Failed to create agent');
    }
  };

  return (
    <div>
      <h1>Agent Tokenization Dashboard</h1>

      <div>
        <h2>API Health</h2>
        <p>Status: {health?.status || 'Checking...'}</p>
        <p>Service: {health?.service || 'Loading...'}</p>
      </div>

      <div>
        <h2>Agents</h2>
        <button onClick={queryAgents} disabled={loading}>
          {loading ? 'Loading...' : 'Refresh Agents'}
        </button>
        <button onClick={handleCreateAgent} disabled={loading}>
          Create Test Agent
        </button>

        <div>
          <p>Query Result: {JSON.stringify(agents, null, 2)}</p>
        </div>
      </div>
    </div>
  );
}
```

---

## 📱 **Mobile/React Native Example**

```javascript
// Works identically in React Native
const api = new AgentTokenizationAPI();

// React Native component
function AgentScreen() {
  const [health, setHealth] = useState(null);

  useEffect(() => {
    api.healthCheck().then(setHealth);
  }, []);

  return (
    <View>
      <Text>API Status: {health?.status}</Text>
      <Text>Service: {health?.service}</Text>
    </View>
  );
}
```

---

## 🚨 **Error Handling**

All endpoints return `200 OK` for successful requests. Handle network errors:

```javascript
async function safeApiCall(apiFunction) {
  try {
    const result = await apiFunction();
    return { success: true, data: result };
  } catch (error) {
    console.error('API Error:', error);
    return {
      success: false,
      error: error.message,
      status: error.status || 'Network Error'
    };
  }
}

// Usage
const { success, data, error } = await safeApiCall(() =>
  api.queryContracts(['AgentTokenizationV2:AgentRegistration'])
);

if (success) {
  console.log('Data:', data);
} else {
  console.log('Error:', error);
}
```

---

## 🎯 **Key Points for Frontend Developers**

### **✅ What Works**
- All endpoints return consistent JSON responses
- CORS is properly configured for web applications
- No authentication required (development mode)
- All requests use standard HTTP methods (GET, POST)

### **📋 Response Format**
All API endpoints return this consistent format:
```json
{
  "received": true,
  "status": "accepted",
  "message": "Agent API endpoint ready"
}
```

### **🔧 Integration Tips**
1. **Health Check First** - Always test `/readyz` before other calls
2. **CORS Friendly** - Works from any web domain
3. **JSON Only** - All requests and responses use JSON
4. **No Auth** - Currently no authentication required
5. **Consistent Responses** - All endpoints return similar structure

---

**🎉 Your frontend applications can now integrate with the Agent Tokenization platform using these exact API calls and expect these exact responses!**