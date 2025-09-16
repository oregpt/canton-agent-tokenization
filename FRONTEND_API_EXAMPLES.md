# 🌐 Agent Tokenization API - Frontend Integration Guide

**Base URL:** `https://27524c709935.ngrok-free.app`
**Authentication:** JWT Bearer Token (required for all requests)

---

## 🔑 **Authentication Headers**

```javascript
const API_BASE = 'https://27524c709935.ngrok-free.app';
const AUTH_TOKEN = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJhZ2VudC10b2tlbml6YXRpb24tbGVkZ2VyIiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJBbGljZSJdLCJhZG1pbiI6dHJ1ZSwicmVhZEFzIjpbIkFsaWNlIl19LCJzdWIiOiJBbGljZSIsImF1ZCI6Imh0dHBzOi8vZGFtbC5jb20vbGVkZ2VyLWFwaSIsImlzcyI6ImFnZW50LXRva2VuaXphdGlvbi1zeXN0ZW0iLCJleHAiOjE3NjA2MDg4MTMsImlhdCI6MTc1ODAxNjgxM30.92vfcUJNkM3v260edsvTl9lgSOnTc-p9dx3zoErweZE';

const headers = {
  'Content-Type': 'application/json',
  'Authorization': `Bearer ${AUTH_TOKEN}`
};
```

---

## 📊 **1. VIEW REGISTRY - Query All Agents**

### **API Call**
```javascript
const viewRegistry = async () => {
  const response = await fetch(`${API_BASE}/v1/query`, {
    method: 'POST',
    headers,
    body: JSON.stringify({
      templateIds: ["AgentTokenizationV2:AgentRegistration"]
    })
  });
  return response.json();
};
```

### **cURL Example**
```bash
curl -X POST https://27524c709935.ngrok-free.app/v1/query \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -d '{
    "templateIds": ["AgentTokenizationV2:AgentRegistration"]
  }'
```

### **Expected Response**
```json
{
  "result": [
    {
      "contractId": "00abc123def456...",
      "templateId": "AgentTokenizationV2:AgentRegistration",
      "argument": {
        "operator": "Alice",
        "agentId": "ai-agent-001",
        "name": "GPT-4 Finance Assistant",
        "description": "Advanced financial analysis AI agent",
        "agentType": "LLM",
        "capabilities": ["financial_analysis", "risk_assessment", "reporting"],
        "attributes": {
          "model": "gpt-4",
          "version": "2024-03",
          "provider": "OpenAI"
        },
        "isActive": true,
        "createdAt": "2025-09-16T10:00:00Z"
      },
      "signatories": ["Alice"],
      "observers": []
    }
  ]
}
```

---

## 🎯 **2. CREATE OWNERSHIP TOKEN**

### **API Call**
```javascript
const createOwnershipToken = async (agentData) => {
  const response = await fetch(`${API_BASE}/v1/create`, {
    method: 'POST',
    headers,
    body: JSON.stringify({
      templateId: "AgentTokenizationV2:AgentRegistration",
      argument: {
        operator: "Alice",
        agentId: `agent-${Date.now()}`,
        name: agentData.name,
        description: agentData.description,
        agentType: agentData.type || "LLM",
        capabilities: agentData.capabilities || [],
        attributes: agentData.attributes || {},
        isActive: true
      }
    })
  });
  return response.json();
};
```

### **Required Parameters**
```javascript
const agentData = {
  name: "Marketing AI Assistant",           // Required: Agent display name
  description: "AI for marketing campaigns", // Required: Agent description
  type: "LLM",                             // Optional: "LLM", "ML_MODEL", "API"
  capabilities: [                          // Optional: Array of strings
    "content_generation",
    "campaign_optimization",
    "analytics"
  ],
  attributes: {                            // Optional: Key-value metadata
    "model": "gpt-4",
    "provider": "OpenAI",
    "version": "2024-03",
    "industry": "marketing",
    "compliance": "GDPR,CCPA"
  }
};
```

### **cURL Example**
```bash
curl -X POST https://27524c709935.ngrok-free.app/v1/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -d '{
    "templateId": "AgentTokenizationV2:AgentRegistration",
    "argument": {
      "operator": "Alice",
      "agentId": "agent-1694876400000",
      "name": "Marketing AI Assistant",
      "description": "AI specialized in marketing campaigns and content creation",
      "agentType": "LLM",
      "capabilities": ["content_generation", "campaign_optimization", "analytics"],
      "attributes": {
        "model": "gpt-4",
        "provider": "OpenAI",
        "version": "2024-03",
        "industry": "marketing"
      },
      "isActive": true
    }
  }'
```

### **Success Response**
```json
{
  "result": {
    "contractId": "00xyz789abc123def456...",
    "templateId": "AgentTokenizationV2:AgentRegistration"
  },
  "status": 200,
  "completionOffset": "000000000000001a"
}
```

### **Error Response**
```json
{
  "errors": ["User 'Alice' submitted a command with invalid argument: ..."],
  "status": 400
}
```

---

## 🎫 **3. CREATE USAGE TOKEN**

### **API Call**
```javascript
const createUsageToken = async (ownershipContractId, usageData) => {
  const response = await fetch(`${API_BASE}/v1/create`, {
    method: 'POST',
    headers,
    body: JSON.stringify({
      templateId: "AgentTokenizationV2:AgentUsageToken",
      argument: {
        operator: "Alice",
        agentId: usageData.agentId,
        tokenId: `usage-${Date.now()}`,
        usageType: usageData.type,
        maxUsage: usageData.maxUsage,
        currentUsage: 0,
        metadata: usageData.metadata || {},
        isActive: true
      }
    })
  });
  return response.json();
};
```

### **Required Parameters**
```javascript
const usageData = {
  agentId: "agent-1694876400000",          // Required: Reference to ownership token
  type: "API_CALLS",                       // Required: "API_CALLS", "TIME_BASED", "FEATURES"
  maxUsage: 1000,                          // Required: Usage limit (number)
  metadata: {                              // Optional: Usage restrictions
    "billing_tier": "premium",
    "rate_limit": "100_per_minute",
    "valid_until": "2025-12-31T23:59:59Z",
    "allowed_features": ["basic_generation", "analytics"],
    "geographic_restriction": "US,CA,EU"
  }
};
```

### **cURL Example**
```bash
curl -X POST https://27524c709935.ngrok-free.app/v1/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -d '{
    "templateId": "AgentTokenizationV2:AgentUsageToken",
    "argument": {
      "operator": "Alice",
      "agentId": "agent-1694876400000",
      "tokenId": "usage-1694876500000",
      "usageType": "API_CALLS",
      "maxUsage": 1000,
      "currentUsage": 0,
      "metadata": {
        "billing_tier": "premium",
        "rate_limit": "100_per_minute",
        "valid_until": "2025-12-31T23:59:59Z"
      },
      "isActive": true
    }
  }'
```

### **Success Response**
```json
{
  "result": {
    "contractId": "00def456ghi789jkl012...",
    "templateId": "AgentTokenizationV2:AgentUsageToken"
  },
  "status": 200,
  "completionOffset": "000000000000001b"
}
```

---

## 🔄 **4. UPDATE USAGE TOKEN (Record Usage)**

### **API Call**
```javascript
const recordUsage = async (usageContractId, usageAmount) => {
  const response = await fetch(`${API_BASE}/v1/exercise`, {
    method: 'POST',
    headers,
    body: JSON.stringify({
      templateId: "AgentTokenizationV2:AgentUsageToken",
      contractId: usageContractId,
      choice: "RecordUsage",
      argument: {
        usageAmount: usageAmount,
        timestamp: new Date().toISOString(),
        eventData: {
          "action": "api_call",
          "endpoint": "/generate",
          "response_tokens": "150"
        }
      }
    })
  });
  return response.json();
};
```

### **cURL Example**
```bash
curl -X POST https://27524c709935.ngrok-free.app/v1/exercise \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -d '{
    "templateId": "AgentTokenizationV2:AgentUsageToken",
    "contractId": "00def456ghi789jkl012...",
    "choice": "RecordUsage",
    "argument": {
      "usageAmount": 5,
      "timestamp": "2025-09-16T10:30:00Z",
      "eventData": {
        "action": "content_generation",
        "tokens_used": "150"
      }
    }
  }'
```

---

## ❌ **Error Handling**

### **Authentication Errors**
```json
{
  "errors": ["missing Authorization header with OAuth 2.0 Bearer Token"],
  "status": 401
}
```

### **Invalid Template ID**
```json
{
  "errors": ["JsonReaderError. Cannot read JSON: Expected format packageId:module:entity"],
  "status": 400
}
```

### **Contract Not Found**
```json
{
  "errors": ["Contract not found or not visible to party"],
  "status": 404
}
```

---

## 📋 **Complete Integration Example**

```javascript
class AgentTokenizationAPI {
  constructor(baseUrl, authToken) {
    this.baseUrl = baseUrl;
    this.headers = {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${authToken}`
    };
  }

  async viewRegistry() {
    const response = await fetch(`${this.baseUrl}/v1/query`, {
      method: 'POST',
      headers: this.headers,
      body: JSON.stringify({
        templateIds: ["AgentTokenizationV2:AgentRegistration"]
      })
    });

    if (!response.ok) {
      throw new Error(`API Error: ${response.status}`);
    }

    return response.json();
  }

  async createOwnership(agentData) {
    const response = await fetch(`${this.baseUrl}/v1/create`, {
      method: 'POST',
      headers: this.headers,
      body: JSON.stringify({
        templateId: "AgentTokenizationV2:AgentRegistration",
        argument: {
          operator: "Alice",
          agentId: `agent-${Date.now()}`,
          name: agentData.name,
          description: agentData.description,
          agentType: agentData.type || "LLM",
          capabilities: agentData.capabilities || [],
          attributes: agentData.attributes || {},
          isActive: true
        }
      })
    });

    return response.json();
  }

  async createUsage(agentId, usageData) {
    const response = await fetch(`${this.baseUrl}/v1/create`, {
      method: 'POST',
      headers: this.headers,
      body: JSON.stringify({
        templateId: "AgentTokenizationV2:AgentUsageToken",
        argument: {
          operator: "Alice",
          agentId: agentId,
          tokenId: `usage-${Date.now()}`,
          usageType: usageData.type,
          maxUsage: usageData.maxUsage,
          currentUsage: 0,
          metadata: usageData.metadata || {},
          isActive: true
        }
      })
    });

    return response.json();
  }
}

// Usage Example
const api = new AgentTokenizationAPI(
  'https://27524c709935.ngrok-free.app',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
);

// View all agents
const agents = await api.viewRegistry();

// Create ownership token
const ownership = await api.createOwnership({
  name: "My Marketing AI",
  description: "Custom marketing assistant",
  capabilities: ["content_generation"]
});

// Create usage token
const usage = await api.createUsage("agent-123", {
  type: "API_CALLS",
  maxUsage: 1000
});
```

---

## 🎯 **Key Points for Frontend**

1. **All requests require JWT Bearer token**
2. **Responses are immediate** (DAML contracts are created synchronously)
3. **Contract IDs** are your unique identifiers for tokens
4. **Template IDs** must be exact format: `ModuleName:TemplateName`
5. **Error responses** include helpful error messages in `errors` array

**Your real DAML blockchain is ready for frontend integration!** 🚀