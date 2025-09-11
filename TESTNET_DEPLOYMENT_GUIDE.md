# 🌐 Canton Testnet Deployment Guide

Deploy your AI Agent Tokenization system to persistent Canton testnets where contracts won't disappear.

## 🎯 **Deployment Options (Persistent)**

### **Option 1: DAML Hub (Recommended - Free & Easy)**

DAML Hub provides free hosted Canton ledgers with persistent storage.

#### **Steps:**
1. **Sign up**: Go to [hub.daml.com](https://hub.daml.com)
2. **Create free account** (no cost for basic usage)
3. **Create new ledger**:
   - Click "Create Ledger"
   - Name: "AgentTokenization"
   - Type: "Sandbox" (for testing)
4. **Upload DAR**:
   - Upload: `agent-tokenization-v3-3.0.0.dar`
   - Wait for upload completion
5. **Deploy & Run Scripts**:
   ```bash
   # Get your hub ledger details from hub.daml.com
   daml script --dar agent-tokenization-v3-3.0.0.dar \
     --script-name AgentTokenizationV2:demoV2System \
     --ledger-host <YOUR_HUB_HOST> \
     --ledger-port 443 \
     --tls \
     --access-token-file <YOUR_TOKEN_FILE>
   ```

#### **Benefits:**
- ✅ **Persistent**: Contracts never disappear
- ✅ **Free**: No cost for testing
- ✅ **Web UI**: Visual contract explorer
- ✅ **Shared**: Others can access your contracts
- ✅ **Easy**: No local setup required

---

### **Option 2: Canton Network Testnet**

Enterprise-grade Canton Network with production-like features.

#### **Prerequisites:**
```bash
# Install Canton CLI
daml install canton
```

#### **Steps:**
1. **Register**: Go to [canton.network](https://canton.network)
2. **Get testnet access** (may require application)
3. **Configure connection**:
   ```bash
   # Create canton-config.conf
   canton {
     participants {
       participant1 {
         storage.type = memory
         admin-api.port = 5012
         ledger-api.port = 5011
       }
     }
   }
   ```
4. **Deploy**:
   ```bash
   canton -c canton-config.conf
   # In Canton console:
   participant1.dars.upload("agent-tokenization-v3-3.0.0.dar")
   ```

#### **Benefits:**
- ✅ **Production-grade**: Real Canton Network
- ✅ **Enterprise features**: Full Canton capabilities
- ✅ **Persistent**: Blockchain-backed storage
- ✅ **Scalable**: High-performance infrastructure

---

### **Option 3: Local Canton with Persistence**

Run Canton locally but with persistent database storage.

#### **Setup:**
1. **Install Canton**:
   ```bash
   daml install canton
   ```

2. **Create persistent config** (`canton-persistent.conf`):
   ```hocon
   canton {
     participants {
       participant1 {
         storage {
           type = postgres
           config {
             host = "localhost"
             port = 5432
             database = "canton_agent_tokenization"
             user = "canton"
             password = "your_password"
           }
         }
         admin-api.port = 5012
         ledger-api.port = 5011
       }
     }
   }
   ```

3. **Start with persistence**:
   ```bash
   # Setup PostgreSQL first
   # Then start Canton
   canton -c canton-persistent.conf
   ```

#### **Benefits:**
- ✅ **Persistent**: Database-backed storage
- ✅ **Local control**: Your own infrastructure
- ✅ **No internet**: Works offline
- ✅ **Fast**: Local network speeds

---

## 🚀 **Quick Start: DAML Hub Deployment**

Here's the fastest way to get persistent contracts:

### **Step 1: Prepare Your DAR**
```bash
cd "C:\Users\oreph\Documents\Canton\DAML Projects\CantonAgentTokenization"
daml build
# Ensure agent-tokenization-v3-3.0.0.dar exists
ls .daml/dist/
```

### **Step 2: Upload to DAML Hub**
1. Visit [hub.daml.com](https://hub.daml.com)
2. Sign in/Create account
3. Create new ledger: "AgentTokenization"
4. Upload DAR file: `agent-tokenization-v3-3.0.0.dar`

### **Step 3: Deploy Your Contracts**
Once uploaded, run from DAML Hub web interface or use CLI:
```bash
# Get connection details from hub.daml.com
daml script --dar agent-tokenization-v3-3.0.0.dar \
  --script-name AgentTokenizationV2:demoV2System \
  --ledger-host your-ledger.hub.daml.com \
  --ledger-port 443 \
  --tls \
  --access-token-file hub-token.txt
```

### **Step 4: Verify Persistence**
- Contracts will remain even after closing browser
- Access anytime via DAML Hub web interface
- Share ledger access with others
- Query contracts via persistent API endpoints

---

## 🔧 **Connection Examples**

### **DAML Hub API Connection**
```bash
# Health check
curl https://your-ledger.hub.daml.com/readyz \
  -H "Authorization: Bearer YOUR_HUB_TOKEN"

# Query contracts
curl -X POST https://your-ledger.hub.daml.com/v1/query \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_HUB_TOKEN" \
  -d '{"templateIds": ["AgentTokenizationV2:SystemOrchestrator"]}'
```

### **Canton Network Connection**
```bash
# Connect to Canton Network node
daml script --dar agent-tokenization-v3-3.0.0.dar \
  --script-name AgentTokenizationV2:demoV2System \
  --ledger-host canton-network-node.com \
  --ledger-port 443 \
  --tls \
  --participant participant1
```

---

## 📊 **Comparison Table**

| Feature | DAML Hub | Canton Network | Local Persistent |
|---------|----------|----------------|------------------|
| **Cost** | Free | Enterprise pricing | Infrastructure cost |
| **Setup** | 5 minutes | 30 minutes | 60+ minutes |
| **Persistence** | ✅ Cloud | ✅ Blockchain | ✅ Database |
| **Sharing** | ✅ Easy | ✅ Network | ❌ Local only |
| **Performance** | Good | Excellent | Variable |
| **Reliability** | High | Very High | Depends on setup |

---

## 🎯 **Recommended Path**

### **For Testing & Development:**
1. **Start with DAML Hub** - Get persistent contracts in 5 minutes
2. **Upload your DAR** - `agent-tokenization-v3-3.0.0.dar`
3. **Run demo script** - Create your ownership + usage contracts
4. **Share with others** - Public testnet access

### **For Production:**
1. **Evaluate Canton Network** - Enterprise-grade deployment
2. **Contact Digital Asset** - Get production access
3. **Deploy with persistence** - Blockchain-backed contracts
4. **Scale as needed** - Enterprise support available

---

## 🚨 **Important Notes**

### **Persistence Guarantees:**
- ✅ **DAML Hub**: Contracts persist indefinitely (free tier limits apply)
- ✅ **Canton Network**: Blockchain-backed permanent storage
- ✅ **Local Persistent**: Depends on your database backup strategy
- ❌ **Local Sandbox**: Contracts disappear when stopped

### **Access Control:**
- **DAML Hub**: Token-based access, shareable
- **Canton Network**: Enterprise identity management  
- **Local**: Direct database access only

### **Costs:**
- **DAML Hub**: Free tier available, pay for scale
- **Canton Network**: Enterprise licensing required
- **Local**: Infrastructure and maintenance costs

---

## 🎉 **Next Steps**

1. **Choose your deployment target** (recommend DAML Hub for testing)
2. **Follow the deployment steps** above
3. **Run your comprehensive test** on persistent infrastructure
4. **Share the persistent ledger** with others
5. **Build applications** using persistent API endpoints

**Your AI Agent Tokenization contracts will now persist forever!** 🚀