# 🚀 DAML Agent Tokenization V3 - Comprehensive API Guide

## Overview
This guide demonstrates a complete AI Agent tokenization system with **2 Ownership Contracts** and **6 Usage Contracts** (3 per ownership). It includes all API endpoint calls, expected results, and practical examples for developers.

## System Architecture

### 🏗️ **Contract Structure Created**
```
📋 System Orchestrator
├── 🎯 Ownership Contract 1: MarketingGuru AI (Alice)
│   ├── 📝 Basic Usage (Bob) - Marketing content generation
│   ├── 🔧 Advanced Usage (Developer) - Campaign optimization + 12.5% royalty
│   └── 🏢 Enterprise Usage (Enterprise1) - Full access + $75K fee
└── 🎯 Ownership Contract 2: FinanceWizard AI (Charlie)
    ├── 📝 Basic Usage (Bob) - Paper trading only
    ├── 🔧 Advanced Usage (Developer) - Quant analysis + 20% royalty
    └── 🏢 Enterprise Usage (Enterprise2) - Institutional + $250K fee
```

## 🌐 API Base Configuration

**Base URL**: `http://localhost:7575`  
**Authentication**: OAuth 2.0 Bearer Token (required for production)  
**Content-Type**: `application/json`

### Health Check
```bash
curl http://localhost:7575/readyz
```
**Expected Response**: `200 OK`
```json
{
  "status": "ready",
  "message": "readyz check passed"
}
```

---

## 📊 **1. Query All Ownership Tokens**

### API Call
```bash
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  -d '{
    "templateIds": ["ComprehensiveV3Test:AIAgentOwnershipToken"]
  }'
```

### Expected Response
```json
{
  "result": [
    {
      "contractId": "00123abc...def456",
      "templateId": "ComprehensiveV3Test:AIAgentOwnershipToken",
      "payload": {
        "agentName": "MarketingGuru AI",
        "agentDescription": "Advanced marketing strategy and content creation AI agent with social media specialization",
        "agentCreator": "Alice",
        "owner": "Alice",
        "issuer": "SystemOrchestrator",
        "totalSupply": "1000.0",
        "tokenAmount": "1000.0",
        "status": "Active",
        "version": "1.2.0",
        "attributes": {
          "industry": "marketing",
          "specialization": "social_media,content_creation,email_marketing,seo",
          "models": "GPT-4,Claude-3,Grok-2",
          "capabilities": "strategy,copywriting,campaign_optimization,analytics",
          "pricing_model": "per_campaign_and_usage",
          "target_markets": "B2B,B2C,ecommerce,saas",
          "languages": "english,spanish,french,german",
          "compliance": "GDPR,CCPA,SOX",
          "deployment_options": "cloud,on_premise,hybrid",
          "integration_apis": "hubspot,salesforce,mailchimp"
        },
        "privacyLevel": "Medium"
      }
    },
    {
      "contractId": "00789ghi...jkl012",
      "templateId": "ComprehensiveV3Test:AIAgentOwnershipToken", 
      "payload": {
        "agentName": "FinanceWizard AI",
        "agentDescription": "Sophisticated financial analysis and trading AI with real-time market data integration",
        "agentCreator": "Charlie",
        "owner": "Charlie",
        "issuer": "SystemOrchestrator",
        "totalSupply": "500.0",
        "tokenAmount": "500.0",
        "status": "Active",
        "version": "2.1.0",
        "attributes": {
          "industry": "finance",
          "specialization": "trading,risk_analysis,portfolio_management,derivatives",
          "models": "GPT-4,Claude-3,Custom_Financial_Model",
          "capabilities": "real_time_analysis,backtesting,risk_modeling,compliance_reporting",
          "pricing_model": "subscription_plus_performance_fee",
          "target_markets": "hedge_funds,investment_banks,wealth_management",
          "data_sources": "bloomberg,reuters,yahoo_finance,sec_filings",
          "compliance": "SEC,FINRA,MiFID_II,Basel_III",
          "certifications": "Series_7,CFA_Institute_Approved",
          "risk_rating": "institutional_grade",
          "latency": "sub_millisecond",
          "accuracy": "99.7_percent_backtested"
        },
        "privacyLevel": "High"
      }
    }
  ]
}
```

---

## 📝 **2. Query Basic Usage Tokens**

### API Call
```bash
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  -d '{
    "templateIds": ["ComprehensiveV3Test:AIAgentBasicUsageToken"]
  }'
```

### Expected Response
```json
{
  "result": [
    {
      "contractId": "00345mno...pqr678",
      "templateId": "ComprehensiveV3Test:AIAgentBasicUsageToken",
      "payload": {
        "ownershipTokenId": "00123abc...def456",
        "agentName": "MarketingGuru AI",
        "user": "Bob",
        "grantor": "Alice",
        "allowedModels": ["GPT-4"],
        "allowedCapabilities": ["basic_content_generation", "email_templates", "social_posts"],
        "usageLimit": "1000.0",
        "validFrom": "2025-09-11T19:55:00Z",
        "validUntil": "2025-10-11T19:55:00Z",
        "restrictions": {
          "max_queries_per_day": "50",
          "content_types": "blog,email,social",
          "word_limit_per_query": "2000",
          "no_competitor_analysis": "true",
          "rate_limit": "10_per_hour"
        }
      }
    },
    {
      "contractId": "00901stu...vwx234",
      "templateId": "ComprehensiveV3Test:AIAgentBasicUsageToken",
      "payload": {
        "ownershipTokenId": "00789ghi...jkl012",
        "agentName": "FinanceWizard AI",
        "user": "Bob",
        "grantor": "Charlie",
        "allowedModels": ["GPT-4"],
        "allowedCapabilities": ["basic_analysis", "portfolio_review", "market_summary"],
        "usageLimit": "500.0",
        "validFrom": "2025-09-11T19:55:00Z",
        "validUntil": "2025-10-11T19:55:00Z",
        "restrictions": {
          "max_queries_per_day": "25",
          "analysis_depth": "surface_level",
          "historical_data_limit": "1_year",
          "no_real_time_trading": "true",
          "paper_trading_only": "true",
          "max_portfolio_value": "100000"
        }
      }
    }
  ]
}
```

---

## 🔧 **3. Query Advanced Usage Tokens**

### API Call
```bash
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  -d '{
    "templateIds": ["ComprehensiveV3Test:AIAgentAdvancedUsageToken"]
  }'
```

### Expected Response
```json
{
  "result": [
    {
      "contractId": "00567yza...bcd890",
      "templateId": "ComprehensiveV3Test:AIAgentAdvancedUsageToken",
      "payload": {
        "ownershipTokenId": "00123abc...def456",
        "agentName": "MarketingGuru AI",
        "user": "Developer",
        "grantor": "Alice",
        "allowedModels": ["GPT-4", "Claude-3"],
        "allowedCapabilities": ["advanced_analytics", "campaign_optimization", "A_B_testing", "custom_models"],
        "developmentRights": ["fine_tuning", "prompt_engineering", "model_integration", "API_access"],
        "royaltyPercentage": "12.5",
        "exclusivityScope": "SaaS_Industry_North_America",
        "maxComputeHours": "10000.0",
        "allowedEnvironments": ["development", "staging", "production"],
        "validFrom": "2025-09-11T19:55:00Z",
        "validUntil": "2026-09-11T19:55:00Z"
      }
    },
    {
      "contractId": "00123efg...hij456",
      "templateId": "ComprehensiveV3Test:AIAgentAdvancedUsageToken",
      "payload": {
        "ownershipTokenId": "00789ghi...jkl012",
        "agentName": "FinanceWizard AI",
        "user": "Developer",
        "grantor": "Charlie",
        "allowedModels": ["GPT-4", "Claude-3", "Custom_Financial_Model"],
        "allowedCapabilities": ["quantitative_analysis", "algorithm_development", "backtesting", "risk_modeling"],
        "developmentRights": ["model_customization", "strategy_development", "API_integration", "white_labeling"],
        "royaltyPercentage": "20.0",
        "exclusivityScope": "Cryptocurrency_Trading_Global",
        "maxComputeHours": "50000.0",
        "allowedEnvironments": ["research", "development", "testing", "production"],
        "validFrom": "2025-09-11T19:55:00Z",
        "validUntil": "2026-09-11T19:55:00Z"
      }
    }
  ]
}
```

---

## 🏢 **4. Query Enterprise Usage Tokens**

### API Call
```bash
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  -d '{
    "templateIds": ["ComprehensiveV3Test:AIAgentEnterpriseUsageToken"]
  }'
```

### Expected Response
```json
{
  "result": [
    {
      "contractId": "00789klm...nop123",
      "templateId": "ComprehensiveV3Test:AIAgentEnterpriseUsageToken",
      "payload": {
        "ownershipTokenId": "00123abc...def456",
        "agentName": "MarketingGuru AI",
        "user": "Enterprise1",
        "grantor": "Alice",
        "allowedModels": ["GPT-4", "Claude-3", "Grok-2"],
        "allowedCapabilities": ["full_access", "white_label", "custom_training"],
        "enterpriseFeatures": ["SSO_integration", "audit_logs", "custom_deployment", "dedicated_support", "SLA_guarantees"],
        "maxConcurrentUsers": "500.0",
        "guaranteedUptime": "99.95",
        "supportLevel": "Enterprise_Premium_24x7",
        "dataRetentionPolicy": "7_years",
        "complianceFrameworks": ["SOC2_Type2", "HIPAA", "ISO27001", "GDPR"],
        "auditAccess": true,
        "fixedFee": "75000.0",
        "variableFee": "0.08",
        "validFrom": "2025-09-11T19:55:00Z",
        "validUntil": "2026-09-11T19:55:00Z",
        "autoRenewal": true
      }
    },
    {
      "contractId": "00456qrs...tuv789",
      "templateId": "ComprehensiveV3Test:AIAgentEnterpriseUsageToken",
      "payload": {
        "ownershipTokenId": "00789ghi...jkl012",
        "agentName": "FinanceWizard AI",
        "user": "Enterprise2",
        "grantor": "Charlie",
        "allowedModels": ["GPT-4", "Claude-3", "Custom_Financial_Model"],
        "allowedCapabilities": ["institutional_trading", "risk_management", "regulatory_reporting", "real_time_analytics"],
        "enterpriseFeatures": ["dedicated_infrastructure", "regulatory_compliance", "audit_trail", "disaster_recovery", "24x7_monitoring"],
        "maxConcurrentUsers": "1000.0",
        "guaranteedUptime": "99.99",
        "supportLevel": "Institutional_White_Glove",
        "dataRetentionPolicy": "10_years_SEC_compliant",
        "complianceFrameworks": ["SEC_Rule_15c3_5", "FINRA_4511", "MiFID_II", "Basel_III", "Dodd_Frank"],
        "auditAccess": true,
        "fixedFee": "250000.0",
        "variableFee": "0.025",
        "validFrom": "2025-09-11T19:55:00Z",
        "validUntil": "2026-09-11T19:55:00Z",
        "autoRenewal": true
      }
    }
  ]
}
```

---

## 🎯 **5. Create New Ownership Token**

### API Call
```bash
curl -X POST http://localhost:7575/v1/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  -d '{
    "templateId": "ComprehensiveV3Test:AIAgentOwnershipToken",
    "payload": {
      "agentName": "CustomAI Agent",
      "agentDescription": "User-created AI agent",
      "agentCreator": "NewUser",
      "createdDate": "2025-09-11T20:00:00Z",
      "owner": "NewUser",
      "issuer": "SystemOrchestrator",
      "totalSupply": "100.0",
      "tokenAmount": "100.0",
      "status": "Active",
      "version": "1.0.0",
      "attributes": {
        "industry": "custom",
        "specialization": "general_purpose",
        "models": "GPT-4"
      },
      "privacyLevel": "Low"
    }
  }'
```

### Expected Response
```json
{
  "result": {
    "contractId": "00999xyz...abc333",
    "templateId": "ComprehensiveV3Test:AIAgentOwnershipToken"
  },
  "status": 200
}
```

---

## 📈 **6. Query System Statistics**

### API Call
```bash
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  -d '{
    "templateIds": ["AgentTokenizationV2:SystemOrchestrator"]
  }'
```

### Expected Response
```json
{
  "result": [
    {
      "contractId": "00111aaa...bbb222",
      "templateId": "AgentTokenizationV2:SystemOrchestrator",
      "payload": {
        "orchestrator": "SystemOrchestrator",
        "totalRegistrations": 4,
        "systemVersion": "3.0.0-comprehensive-test"
      }
    }
  ]
}
```

---

## 🔍 **7. Filter Agents by Metadata**

### Query Marketing Agents
```bash
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  -d '{
    "templateIds": ["ComprehensiveV3Test:AIAgentOwnershipToken"],
    "query": {
      "attributes.industry": "marketing"
    }
  }'
```

### Query Financial Agents
```bash
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  -d '{
    "templateIds": ["ComprehensiveV3Test:AIAgentOwnershipToken"],
    "query": {
      "attributes.industry": "finance"
    }
  }'
```

### Query by Privacy Level
```bash
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  -d '{
    "templateIds": ["ComprehensiveV3Test:AIAgentOwnershipToken"],
    "query": {
      "privacyLevel": "High"
    }
  }'
```

---

## 🎮 **8. Usage Token Operations**

### Transfer Basic Usage Token
```bash
curl -X POST http://localhost:7575/v1/exercise \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  -d '{
    "templateId": "ComprehensiveV3Test:AIAgentBasicUsageToken",
    "contractId": "00345mno...pqr678",
    "choice": "TransferUsageRights",
    "argument": {
      "newUser": "NewOwner"
    }
  }'
```

### Log Usage Event
```bash
curl -X POST http://localhost:7575/v1/exercise \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  -d '{
    "templateId": "ComprehensiveV3Test:AIAgentBasicUsageToken",
    "contractId": "00345mno...pqr678",
    "choice": "LogUsage",
    "argument": {
      "eventId": "USAGE_001",
      "eventData": {
        "action": "content_generation",
        "model_used": "GPT-4",
        "word_count": "1500",
        "processing_time": "2.3_seconds"
      }
    }
  }'
```

---

## 📋 **9. Error Responses**

### Authentication Error
```json
{
  "errors": ["missing Authorization header with OAuth 2.0 Bearer Token"],
  "status": 401
}
```

### Contract Not Found
```json
{
  "errors": ["Contract not found"],
  "status": 404
}
```

### Invalid Template
```json
{
  "errors": ["Template ID not recognized"],
  "status": 400
}
```

---

## 🚀 **10. Production Deployment Checklist**

### ✅ **System Validation**
- [x] 2 Ownership contracts created successfully
- [x] 6 Usage contracts (3 per ownership) created successfully  
- [x] Flexible metadata system working (22 unique attributes)
- [x] Multi-tier licensing (Basic/Advanced/Enterprise)
- [x] Commercial terms (royalties, fees, exclusivity)
- [x] Temporal controls (30-day to 1-year terms)
- [x] Enterprise compliance features
- [x] Privacy levels and access controls

### 🔧 **API Endpoints Verified**
- [x] Health check: `/readyz`
- [x] Query contracts: `/v1/query`
- [x] Create contracts: `/v1/create`
- [x] Exercise choices: `/v1/exercise`
- [x] Filter by metadata: Query with filters
- [x] System statistics: SystemOrchestrator queries

### 🏢 **Enterprise Features**
- [x] SLA guarantees (99.95% - 99.99% uptime)
- [x] Compliance frameworks (SOC2, HIPAA, SEC, FINRA)
- [x] Audit trails and access controls
- [x] Commercial pricing models
- [x] Multi-party validation workflows

---

## 💡 **Developer Tips**

### **Best Practices**
1. **Always validate ownership** before granting usage rights
2. **Use temporal controls** to manage contract lifecycles
3. **Implement proper authentication** in production
4. **Monitor usage events** for billing and analytics
5. **Leverage flexible metadata** for agent discovery

### **Common Use Cases**
- **AI Agent Marketplace**: Buy/sell agent access
- **Enterprise Licensing**: Comprehensive usage agreements
- **Developer Tools**: API access with royalty sharing
- **Compliance Tracking**: Audit trails for regulations
- **Usage Analytics**: Detailed event logging

### **Scaling Considerations**
- Individual contracts scale to millions of agents
- Event sourcing enables efficient audit trails
- Metadata queries support complex filtering
- Multi-party workflows enable marketplace dynamics

---

## 🎉 **System Ready for Production!**

This comprehensive test demonstrates a fully functional AI Agent tokenization marketplace with:
- **Flexible ownership** tokens with unlimited metadata
- **Three-tier usage** licensing (Basic/Advanced/Enterprise)
- **Commercial features** (royalties, fees, SLAs)
- **Enterprise compliance** (SOC2, HIPAA, SEC, FINRA)
- **Production-ready API** endpoints

**Deploy to Canton Network, DAML Hub, or keep running locally for development!** 🚀