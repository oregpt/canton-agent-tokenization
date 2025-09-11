# 🚀 Canton AI Agent Tokenization System

A comprehensive DAML-based system for tokenizing AI agents on Canton Network with ownership tokens, usage licenses, and flexible metadata.

## 🎯 Overview

This system enables:
- **AI Agent Ownership** - Create deed-like ownership tokens for AI agents
- **Usage Licensing** - Three-tier licensing system (Basic/Advanced/Enterprise)  
- **Flexible Metadata** - Unlimited key-value attributes per agent
- **Commercial Terms** - Royalties, fees, exclusivity, SLAs
- **Enterprise Features** - Compliance, audit trails, auto-renewal

## 📊 System Architecture

```
📋 System Orchestrator
├── 🎯 AI Agent Ownership Tokens
│   ├── 📝 Basic Usage Licenses
│   ├── 🔧 Advanced Usage Licenses (with royalties)
│   └── 🏢 Enterprise Usage Licenses (with SLAs)
└── 📈 System Statistics & Tracking
```

## ⚡ Quick Start

### Prerequisites
- DAML SDK 2.10.2+
- Canton (optional, for production)

### Run the Demo
```bash
# Build the system
daml build

# Start local sandbox
daml start

# Run comprehensive test (creates 2 ownership + 6 usage contracts)
daml script --dar .daml/dist/agent-tokenization-v3-3.0.0.dar --script-name AgentTokenizationV2:demoV2System --ledger-host localhost --ledger-port 6865
```

### Test the API
```bash
# Health check
curl http://localhost:7575/readyz

# Query contracts (requires JWT token in production)
curl -X POST http://localhost:7575/v1/query \
  -H "Content-Type: application/json" \
  -d '{"templateIds": ["AgentTokenizationV2:SystemOrchestrator"]}'
```

## 📚 Documentation

- **[📖 Comprehensive API Guide](COMPREHENSIVE_API_GUIDE.md)** - Complete API reference with curl examples
- **[⚡ Quick Start Guide](QUICK_START_GUIDE.md)** - Easy setup instructions  
- **[📋 Test Summary](COMPREHENSIVE_TEST_SUMMARY.md)** - Overview of test system
- **[🚀 Deployment Guide](DEPLOYMENT.md)** - Production deployment options

## 🎮 Demo System

The comprehensive test creates:

### **Ownership Tokens**
1. **MarketingGuru AI** - 1,000 tokens, marketing specialization
2. **FinanceWizard AI** - 500 tokens, financial trading focus

### **Usage Licenses (6 total)**
- **2 Basic**: Limited access, usage caps
- **2 Advanced**: Development rights, 12.5%-20% royalties  
- **2 Enterprise**: Full access, $75K-$250K fees, 99.95%-99.99% SLAs

## 🔧 Key Features

### ✅ **Flexible Metadata System**
```json
"attributes": {
  "industry": "marketing",
  "models": "GPT-4,Claude-3,Grok-2",
  "capabilities": "strategy,copywriting,analytics",
  "compliance": "GDPR,CCPA,SOX",
  "integration_apis": "hubspot,salesforce,mailchimp"
}
```

### ✅ **Commercial Terms**
- **Fixed fees**: $75K - $250K enterprise licenses
- **Variable fees**: Per-query pricing  
- **Royalties**: 12.5% - 20% to ownership token holders
- **Exclusivity**: Geographic and industry scopes

### ✅ **Enterprise Features**
- **SLA guarantees**: 99.95% - 99.99% uptime
- **Compliance**: SOC2, HIPAA, SEC, FINRA, GDPR
- **Audit trails**: Complete transaction logging
- **Auto-renewal**: Subscription management

## 🌐 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/readyz` | GET | Health check |
| `/v1/query` | POST | Query contracts |
| `/v1/create` | POST | Create new contracts |
| `/v1/exercise` | POST | Execute contract choices |

## 🏗️ Project Structure

```
├── daml/
│   ├── AgentTokenizationV2.daml          # Core system (working)
│   ├── ComprehensiveV3Test.daml          # Full test suite
│   └── TestV2.daml                       # Simple tests
├── .daml/dist/                           # Built DAR files
├── COMPREHENSIVE_API_GUIDE.md            # Complete API docs
├── QUICK_START_GUIDE.md                  # Setup guide
├── DEPLOYMENT.md                         # Production deployment
└── daml.yaml                             # Project config
```

## 🚀 Deployment Options

### **1. Local Development**
```bash
daml start
```

### **2. DAML Hub (Testnet)**
1. Visit [hub.daml.com](https://hub.daml.com)
2. Upload `agent-tokenization-v3-3.0.0.dar`
3. Deploy to hosted ledger

### **3. Canton Network (Production)**
```bash
daml install canton
# Configure canton-config.conf
canton -c canton-config.conf
# Upload DAR in Canton console
```

## 📈 Use Cases

- **🏪 AI Agent Marketplace** - Buy/sell AI agent access
- **🏢 Enterprise Licensing** - Comprehensive usage agreements  
- **🔧 Developer Tools** - API access with royalty sharing
- **📊 Compliance Tracking** - Audit trails for regulations
- **📈 Usage Analytics** - Detailed event logging

## 🎯 Production Ready

- ✅ **Scalable architecture** (millions of agents)
- ✅ **Enterprise security** model
- ✅ **Multi-party validation** workflows  
- ✅ **Event sourcing** for audit compliance
- ✅ **Strong typing** eliminates configuration errors

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Built with [DAML](https://daml.com/) and [Canton](https://canton.io/)
- Designed for [Canton Network](https://canton.network/) deployment
- Compatible with [DAML Hub](https://hub.daml.com/) for testing

---

**🎉 Ready for commercial AI agent marketplace deployment!**