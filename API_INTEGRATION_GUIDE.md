# 🌐 Agent Tokenization API Integration Guide

**Complete API documentation for external builders to integrate with the Agent Tokenization platform**

---

## 🚀 **Quick Start**

Your Agent Tokenization system exposes a **RESTful JSON API** that external applications can use to:
- Register and manage AI agents
- Create and track usage tokens
- Query agent attributes and capabilities
- Monitor system metrics and events

**Base URL:** `http://localhost:7575` (or your deployed endpoint)

---

## 🔐 **Authentication & Access**

### **Current Setup (Development)**
- **No authentication required** for localhost development
- **Direct API access** via HTTP requests

### **Production Considerations**
```javascript
// Future authentication headers
const headers = {
  'Authorization': 'Bearer YOUR_JWT_TOKEN',
  'Content-Type': 'application/json'
};
```

---

## 📊 **Core API Endpoints**

### **1. System Health & Status**

#### **GET /readyz**
Check if the API is ready to accept requests.

```bash
curl http://localhost:7575/readyz
```

**Response:**
```json
{
  "status": "ready",
  "timestamp": "2025-09-12T02:17:14.192Z"
}
```

#### **GET /livez**
Check if the API is alive and responding.

```bash
curl http://localhost:7575/livez
```

---

### **2. Agent Management**

#### **POST /v1/create**
Register a new AI agent in the system.

```javascript
const registerAgent = async (agentData) => {
  const response = await fetch('http://localhost:7575/v1/create', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer Alice'  // Party identifier
    },
    body: JSON.stringify({
      templateId: {
        packageId: "your-package-id",
        moduleName: "AgentTokenizationV2",
        entityName: "AgentRegistration"
      },
      argument: {
        operator: "Alice",
        agentId: "ai-agent-001",
        name: "GPT-4 Finance Assistant",
        description: "Advanced financial analysis AI agent",
        agentType: "LLM",
        capabilities: ["financial_analysis", "risk_assessment", "reporting"],
        attributes: {
          "model": "gpt-4",
          "version": "2024-03",
          "provider": "OpenAI"
        },
        isActive: true
      }
    })
  });
  
  return response.json();
};
```

**Response:**
```json
{
  "status": 200,
  "result": {
    "contractId": "00abc123...",
    "templateId": "AgentTokenizationV2:AgentRegistration",
    "argument": {
      "agentId": "ai-agent-001",
      "name": "GPT-4 Finance Assistant",
      "isActive": true
    }
  }
}
```

#### **POST /v1/query**
Query existing agents by criteria.

```javascript
const queryAgents = async (criteria) => {
  const response = await fetch('http://localhost:7575/v1/query', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer Alice'
    },
    body: JSON.stringify({
      templateIds: ["AgentTokenizationV2:AgentRegistration"],
      query: {
        agentType: criteria.type,
        isActive: true
      }
    })
  });
  
  return response.json();
};

// Usage
const llmAgents = await queryAgents({ type: "LLM" });
```

**Response:**
```json
{
  "status": 200,
  "result": [
    {
      "contractId": "00abc123...",
      "templateId": "AgentTokenizationV2:AgentRegistration",
      "argument": {
        "agentId": "ai-agent-001",
        "name": "GPT-4 Finance Assistant",
        "agentType": "LLM",
        "isActive": true
      }
    }
  ]
}
```

---

### **3. Usage Token Management**

#### **POST /v1/create (Usage Token)**
Create a usage token for an agent.

```javascript
const createUsageToken = async (agentId, usageData) => {
  const response = await fetch('http://localhost:7575/v1/create', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer Alice'
    },
    body: JSON.stringify({
      templateId: {
        packageId: "your-package-id",
        moduleName: "AgentTokenizationV2", 
        entityName: "AgentUsageToken"
      },
      argument: {
        operator: "Alice",
        agentId: agentId,
        tokenId: `token-${Date.now()}`,
        usageType: usageData.type,
        maxUsage: usageData.maxUsage,
        currentUsage: 0,
        metadata: usageData.metadata,
        isActive: true
      }
    })
  });
  
  return response.json();
};

// Usage
const token = await createUsageToken("ai-agent-001", {
  type: "API_CALLS",
  maxUsage: 1000,
  metadata: {
    "billing_tier": "premium",
    "rate_limit": "100_per_minute"
  }
});
```

#### **POST /v1/exercise**
Update usage on an existing token.

```javascript
const recordUsage = async (contractId, usageAmount) => {
  const response = await fetch('http://localhost:7575/v1/exercise', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer Alice'
    },
    body: JSON.stringify({
      templateId: {
        packageId: "your-package-id",
        moduleName: "AgentTokenizationV2",
        entityName: "AgentUsageToken"
      },
      contractId: contractId,
      choice: "RecordUsage",
      argument: {
        usageAmount: usageAmount,
        timestamp: new Date().toISOString()
      }
    })
  });
  
  return response.json();
};
```

---

### **4. System Queries**

#### **GET /v1/parties**
Get list of parties in the system.

```bash
curl http://localhost:7575/v1/parties
```

#### **POST /v1/query (System Stats)**
Query system statistics and metrics.

```javascript
const getSystemStats = async () => {
  const response = await fetch('http://localhost:7575/v1/query', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer Alice'
    },
    body: JSON.stringify({
      templateIds: ["AgentTokenizationV2:SystemOrchestrator"]
    })
  });
  
  return response.json();
};
```

---

## 🔧 **Integration Examples**

### **React/JavaScript Frontend**

```javascript
// Agent management service
class AgentTokenizationAPI {
  constructor(baseUrl = 'http://localhost:7575', party = 'Alice') {
    this.baseUrl = baseUrl;
    this.party = party;
  }
  
  async request(endpoint, options = {}) {
    const response = await fetch(`${this.baseUrl}${endpoint}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.party}`,
        ...options.headers
      }
    });
    
    if (!response.ok) {
      throw new Error(`API request failed: ${response.statusText}`);
    }
    
    return response.json();
  }
  
  async registerAgent(agentData) {
    return this.request('/v1/create', {
      method: 'POST',
      body: JSON.stringify({
        templateId: {
          packageId: "your-package-id",
          moduleName: "AgentTokenizationV2",
          entityName: "AgentRegistration"
        },
        argument: {
          operator: this.party,
          ...agentData
        }
      })
    });
  }
  
  async getAgents(filter = {}) {
    return this.request('/v1/query', {
      method: 'POST',
      body: JSON.stringify({
        templateIds: ["AgentTokenizationV2:AgentRegistration"],
        query: filter
      })
    });
  }
  
  async createUsageToken(agentId, tokenData) {
    return this.request('/v1/create', {
      method: 'POST',
      body: JSON.stringify({
        templateId: {
          packageId: "your-package-id",
          moduleName: "AgentTokenizationV2",
          entityName: "AgentUsageToken"
        },
        argument: {
          operator: this.party,
          agentId,
          ...tokenData
        }
      })
    });
  }
}

// Usage in React component
const AgentDashboard = () => {
  const [agents, setAgents] = useState([]);
  const api = new AgentTokenizationAPI();
  
  useEffect(() => {
    const loadAgents = async () => {
      try {
        const result = await api.getAgents({ isActive: true });
        setAgents(result.result);
      } catch (error) {
        console.error('Failed to load agents:', error);
      }
    };
    
    loadAgents();
  }, []);
  
  const registerNewAgent = async (agentData) => {
    try {
      await api.registerAgent(agentData);
      // Reload agents list
      const result = await api.getAgents({ isActive: true });
      setAgents(result.result);
    } catch (error) {
      console.error('Failed to register agent:', error);
    }
  };
  
  return (
    <div>
      <h2>AI Agents ({agents.length})</h2>
      {agents.map(agent => (
        <div key={agent.contractId}>
          <h3>{agent.argument.name}</h3>
          <p>Type: {agent.argument.agentType}</p>
          <p>Status: {agent.argument.isActive ? 'Active' : 'Inactive'}</p>
        </div>
      ))}
    </div>
  );
};
```

### **Python Backend Integration**

```python
import requests
import json
from datetime import datetime
from typing import Dict, List, Optional

class AgentTokenizationClient:
    def __init__(self, base_url: str = "http://localhost:7575", party: str = "Alice"):
        self.base_url = base_url
        self.party = party
        self.headers = {
            'Content-Type': 'application/json',
            'Authorization': f'Bearer {party}'
        }
    
    def _request(self, endpoint: str, method: str = "GET", data: Dict = None):
        url = f"{self.base_url}{endpoint}"
        response = requests.request(method, url, headers=self.headers, json=data)
        response.raise_for_status()
        return response.json()
    
    def register_agent(self, agent_data: Dict):
        payload = {
            "templateId": {
                "packageId": "your-package-id",
                "moduleName": "AgentTokenizationV2", 
                "entityName": "AgentRegistration"
            },
            "argument": {
                "operator": self.party,
                **agent_data
            }
        }
        return self._request("/v1/create", "POST", payload)
    
    def query_agents(self, filter_criteria: Dict = None):
        payload = {
            "templateIds": ["AgentTokenizationV2:AgentRegistration"],
            "query": filter_criteria or {}
        }
        return self._request("/v1/query", "POST", payload)
    
    def create_usage_token(self, agent_id: str, token_data: Dict):
        payload = {
            "templateId": {
                "packageId": "your-package-id",
                "moduleName": "AgentTokenizationV2",
                "entityName": "AgentUsageToken"  
            },
            "argument": {
                "operator": self.party,
                "agentId": agent_id,
                **token_data
            }
        }
        return self._request("/v1/create", "POST", payload)
    
    def record_usage(self, contract_id: str, usage_amount: int):
        payload = {
            "templateId": {
                "packageId": "your-package-id", 
                "moduleName": "AgentTokenizationV2",
                "entityName": "AgentUsageToken"
            },
            "contractId": contract_id,
            "choice": "RecordUsage",
            "argument": {
                "usageAmount": usage_amount,
                "timestamp": datetime.now().isoformat()
            }
        }
        return self._request("/v1/exercise", "POST", payload)

# Usage example
client = AgentTokenizationClient()

# Register a new agent
agent = client.register_agent({
    "agentId": "python-ai-001",
    "name": "Python ML Assistant", 
    "description": "Machine learning model for data analysis",
    "agentType": "ML_MODEL",
    "capabilities": ["data_analysis", "prediction", "classification"],
    "attributes": {
        "framework": "scikit-learn",
        "version": "1.3.0"
    },
    "isActive": True
})

print(f"Registered agent: {agent['result']['contractId']}")
```

### **Node.js/Express API Wrapper**

```javascript
const express = require('express');
const axios = require('axios');

class AgentTokenizationService {
  constructor(damlApiUrl = 'http://localhost:7575') {
    this.damlApiUrl = damlApiUrl;
  }
  
  async makeRequest(endpoint, method = 'GET', data = null, party = 'Alice') {
    const config = {
      method,
      url: `${this.damlApiUrl}${endpoint}`,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${party}`
      }
    };
    
    if (data) {
      config.data = data;
    }
    
    try {
      const response = await axios(config);
      return response.data;
    } catch (error) {
      throw new Error(`DAML API request failed: ${error.response?.data || error.message}`);
    }
  }
  
  async registerAgent(agentData, party = 'Alice') {
    const payload = {
      templateId: {
        packageId: "your-package-id",
        moduleName: "AgentTokenizationV2",
        entityName: "AgentRegistration"
      },
      argument: {
        operator: party,
        ...agentData
      }
    };
    
    return this.makeRequest('/v1/create', 'POST', payload, party);
  }
  
  async getAgents(filter = {}, party = 'Alice') {
    const payload = {
      templateIds: ["AgentTokenizationV2:AgentRegistration"],
      query: filter
    };
    
    return this.makeRequest('/v1/query', 'POST', payload, party);
  }
}

// Express API wrapper
const app = express();
app.use(express.json());

const agentService = new AgentTokenizationService();

// REST endpoints for external builders
app.post('/api/agents', async (req, res) => {
  try {
    const result = await agentService.registerAgent(req.body, req.headers['x-party'] || 'Alice');
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/agents', async (req, res) => {
  try {
    const result = await agentService.getAgents(req.query, req.headers['x-party'] || 'Alice');
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(3000, () => {
  console.log('Agent Tokenization API wrapper running on port 3000');
});
```

---

## 🔒 **Security & Production Setup**

### **CORS Configuration**

For external frontend access, configure CORS:

```json
{
  "cors": {
    "allow-origin": ["http://localhost:3000", "https://your-frontend-domain.com"],
    "allow-methods": ["GET", "POST", "PUT", "DELETE"],
    "allow-headers": ["Content-Type", "Authorization"]
  }
}
```

### **Authentication**

For production deployment:

```javascript
// JWT token verification
const verifyToken = (req, res, next) => {
  const token = req.headers.authorization?.replace('Bearer ', '');
  
  if (!token) {
    return res.status(401).json({ error: 'Authentication required' });
  }
  
  // Verify JWT token here
  // Set req.user = decoded token data
  next();
};
```

### **Rate Limiting**

```javascript
const rateLimit = require('express-rate-limit');

const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 1000, // limit each IP to 1000 requests per windowMs
  message: 'Too many requests, please try again later'
});

app.use('/api', apiLimiter);
```

---

## 📚 **SDK Libraries**

### **JavaScript/TypeScript SDK**

```typescript
interface Agent {
  agentId: string;
  name: string;
  description: string;
  agentType: string;
  capabilities: string[];
  attributes: Record<string, any>;
  isActive: boolean;
}

interface UsageToken {
  tokenId: string;
  agentId: string;
  usageType: string;
  maxUsage: number;
  currentUsage: number;
  metadata: Record<string, any>;
  isActive: boolean;
}

class AgentTokenizationSDK {
  // Implementation here
}
```

---

## 🔄 **WebSocket Streaming (Future)**

For real-time updates:

```javascript
const ws = new WebSocket('ws://localhost:7575/v1/stream');

ws.onmessage = (event) => {
  const update = JSON.parse(event.data);
  
  if (update.templateId === 'AgentTokenizationV2:AgentRegistration') {
    // Handle agent updates
    console.log('Agent updated:', update);
  }
};
```

---

## 📊 **API Testing**

### **Postman Collection**

Import this collection for testing:

```json
{
  "info": {
    "name": "Agent Tokenization API",
    "description": "Complete API collection for testing"
  },
  "item": [
    {
      "name": "Health Check",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "http://localhost:7575/readyz",
          "protocol": "http",
          "host": ["localhost"],
          "port": "7575",
          "path": ["readyz"]
        }
      }
    }
  ]
}
```

---

## 🎯 **Next Steps for Builders**

1. **Download this guide** and the SDK examples
2. **Test API endpoints** using provided examples  
3. **Build your frontend** using the JavaScript/Python clients
4. **Deploy your app** connecting to this Agent Tokenization backend
5. **Scale as needed** - the backend handles millions of agents

**Your Agent Tokenization platform is now ready for external builder integration!** 🚀