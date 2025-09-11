# 🌐 API Usage Examples

Your DAML Agent Tokenization V2 system exposes a REST API at:
**Base URL**: `http://localhost:7575`

## ✅ Health Check
```bash
curl http://localhost:7575/readyz
```

## 📋 Query Active Contracts

### Get All Agent Registrations
```bash
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -d '{
    "templateIds": ["AgentTokenizationV2:AgentRegistration"]
  }'
```

### Get All Usage Tokens
```bash
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -d '{
    "templateIds": ["AgentTokenizationV2:UsageToken"]
  }'
```

### Get System Orchestrator Status
```bash
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -d '{
    "templateIds": ["AgentTokenizationV2:SystemOrchestrator"]
  }'
```

### Get All Usage Events (Audit Trail)
```bash
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -d '{
    "templateIds": ["AgentTokenizationV2:UsageEvent"]
  }'
```

## 🚀 Create New Contracts

### Create New Agent Registration
```bash
curl -X POST http://localhost:7575/v1/create \
  -H "Content-Type: application/json" \
  -d '{
    "templateId": "AgentTokenizationV2:AgentRegistration",
    "payload": {
      "agentId": "my_custom_agent_002",
      "owner": "Alice",
      "registrar": "SystemOrchestrator", 
      "metadata": {
        "agentId": "my_custom_agent_002",
        "name": "My Custom AI Agent",
        "description": "Custom agent via API",
        "createdAt": "2025-09-05T06:20:00Z",
        "version": "1.0"
      },
      "isActive": true
    }
  }'
```

## 💡 Pro Tip
Use **Postman** or **Insomnia** for a visual interface to test these APIs!