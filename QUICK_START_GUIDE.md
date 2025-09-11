# 🚀 Quick Start Guide - AI Agent Tokenization V3

## 🎯 **What This System Does**

Creates **ownership tokens** (like deeds) for AI agents and **usage tokens** (like licenses) for accessing them. Think of it as a blockchain-based "app store" for AI agents with enterprise features.

## 📋 **Test Overview**

Our comprehensive test creates:
- **2 Ownership Contracts**: MarketingGuru AI + FinanceWizard AI
- **6 Usage Contracts**: 3 licenses per agent (Basic/Advanced/Enterprise)

## ⚡ **Quick Commands**

### 1. Run the Comprehensive Test
```bash
cd "C:\Users\oreph\Documents\Canton\DAML Projects\AgentTokenization\deployable-v2"
daml test --files daml/ComprehensiveV3Test.daml
```

### 2. Run Just the System Validation
```bash
daml script --dar .daml/dist/agent-tokenization-v3-3.0.0.dar --script-name ComprehensiveV3Test:quickV3Test --ledger-host localhost --ledger-port 6865
```

### 3. Build and Deploy
```bash
daml build
daml start
```

## 📊 **What Gets Created**

### 🎯 **Ownership Contract 1: MarketingGuru AI**
- **Owner**: Alice
- **Supply**: 1,000 tokens  
- **Metadata**: 10 flexible fields (industry, models, capabilities, etc.)
- **Privacy**: Medium level

#### Usage Licenses:
1. **Basic** (Bob): 1,000 queries, GPT-4 only, 30 days
2. **Advanced** (Developer): Campaign optimization, 12.5% royalty, 1 year
3. **Enterprise** (Enterprise1): Full access, $75K fee, 500 users

### 🎯 **Ownership Contract 2: FinanceWizard AI**
- **Owner**: Charlie
- **Supply**: 500 tokens (limited edition)
- **Metadata**: 12 fields (trading, compliance, certifications)
- **Privacy**: High level (financial data)

#### Usage Licenses:
1. **Basic** (Bob): Paper trading, $100K limit, 30 days
2. **Advanced** (Developer): Quant analysis, 20% royalty, crypto exclusivity
3. **Enterprise** (Enterprise2): Institutional grade, $250K fee, 1,000 users

## 🔧 **API Testing Commands**

### Health Check
```bash
curl http://localhost:7575/readyz
```

### Query All Ownership Tokens
```bash
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -d '{"templateIds": ["ComprehensiveV3Test:AIAgentOwnershipToken"]}'
```

### Query Usage Tokens by Type
```bash
# Basic Usage Tokens
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -d '{"templateIds": ["ComprehensiveV3Test:AIAgentBasicUsageToken"]}'

# Advanced Usage Tokens  
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -d '{"templateIds": ["ComprehensiveV3Test:AIAgentAdvancedUsageToken"]}'

# Enterprise Usage Tokens
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -d '{"templateIds": ["ComprehensiveV3Test:AIAgentEnterpriseUsageToken"]}'
```

## 🎮 **Interactive Testing**

### Step 1: Start the System
```bash
daml start --start-navigator=no
```

### Step 2: Run Comprehensive Test
```bash
daml script --dar .daml/dist/agent-tokenization-v3-3.0.0.dar --script-name ComprehensiveV3Test:comprehensiveV3Test --ledger-host localhost --ledger-port 6865
```

### Step 3: Check API Endpoints
Use the curl commands above or tools like **Postman** to interact with the API.

## 📈 **Expected Output**

When you run `comprehensiveV3Test`, you'll see:

```
🚀 DAML Agent Tokenization V3 - COMPREHENSIVE TEST
==================================================
Creating 2 Ownership Contracts + 6 Usage Contracts (3 per ownership)

✅ System Orchestrator initialized

📝 CREATING OWNERSHIP CONTRACT 1: MarketingGuru AI
=================================================
✅ Ownership Contract 1 Created:
   • Agent: MarketingGuru AI
   • Owner: Alice
   • Supply: 1000 tokens
   • Attributes: 10 metadata fields
   • Privacy Level: Medium

📝 Creating Usage Contract 1.1: Basic Marketing Access for Bob
✅ Basic Usage Token 1.1 Created for Bob
   • Models: GPT-4 only
   • Limit: 1000 queries over 30 days
   • Restrictions: 50 queries/day, no competitor analysis

[... continues for all 6 usage contracts ...]

🎯 COMPREHENSIVE TEST RESULTS
=============================
✅ 2 Ownership Contracts Created:
   1. MarketingGuru AI (Alice) - 1000 tokens, Medium privacy
   2. FinanceWizard AI (Charlie) - 500 tokens, High privacy

✅ 6 Usage Contracts Created:
   Marketing Contracts:
   • Basic (Bob): 1000 queries, GPT-4 only
   • Advanced (Developer): 12.5% royalty, SaaS exclusivity
   • Enterprise (Enterprise1): $75K fee, 500 users

   Financial Contracts:
   • Basic (Bob): 500 queries, paper trading
   • Advanced (Developer): 20% royalty, crypto exclusivity
   • Enterprise (Enterprise2): $250K fee, institutional grade

🚀 SYSTEM READY FOR PRODUCTION MARKETPLACE!
   • Flexible metadata: ✅ (22 unique attributes)
   • Multi-tier licensing: ✅ (Basic/Advanced/Enterprise)
   • Commercial terms: ✅ (Royalties, fees, exclusivity)
   • Enterprise features: ✅ (SLAs, compliance, audit)
   • Temporal controls: ✅ (30-day to 1-year terms)
```

## 💡 **Key Features Demonstrated**

### ✅ **Flexible Metadata System**
Each agent can have completely different attributes:
- **Marketing**: industry, specialization, integration_apis
- **Finance**: certifications, risk_rating, latency, accuracy

### ✅ **Three-Tier Licensing**
- **Basic**: Limited access, usage restrictions
- **Advanced**: Development rights, royalties, exclusivity
- **Enterprise**: Full features, SLAs, compliance

### ✅ **Commercial Terms**
- Fixed fees ($75K, $250K)
- Variable fees (per query)
- Royalty percentages (12.5%, 20%)
- Exclusivity scopes (geographic, industry)

### ✅ **Enterprise Features**
- SLA guarantees (99.95% - 99.99% uptime)
- Compliance frameworks (SOC2, HIPAA, SEC, FINRA)
- Audit access and event logging
- Auto-renewal capabilities

## 🛠️ **Troubleshooting**

### Issue: "Package not found"
**Solution**: Make sure to upload the new DAR to the ledger:
```bash
daml build
# The DAR is automatically uploaded when using daml start
```

### Issue: "Authentication required"
**Solution**: The JSON API requires proper JWT tokens in production. For local testing, use DAML scripts instead of curl commands.

### Issue: "Parse errors"
**Solution**: Check DAML syntax, especially time functions and imports.

## 🎉 **Success Criteria**

You know it's working when:
- ✅ Build completes without errors
- ✅ Test creates 8 contracts (2 ownership + 6 usage)
- ✅ API endpoints return contract data
- ✅ Flexible metadata shows different attributes per agent
- ✅ Commercial terms are properly structured

## 🚀 **Next Steps**

1. **Customize the agents** - Modify attributes and pricing
2. **Add your own contracts** - Create new ownership tokens
3. **Deploy to production** - Use Canton Network or DAML Hub
4. **Build a frontend** - Connect via JSON API
5. **Add authentication** - Implement JWT tokens for security

**This system is now ready for a commercial AI agent marketplace!** 🎊