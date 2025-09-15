# 🚀 Full DAML System Deployment Guide

## 🎯 **What This Deploys**

Instead of the mock API, this deploys the **complete DAML blockchain** with:

✅ **Real Ownership Contracts** - `AIAgentOwnershipToken`
✅ **Real Usage Contracts** - Basic, Advanced, Enterprise tiers
✅ **Comprehensive V3 System** - 2 ownership + 6 usage contracts
✅ **PostgreSQL Persistence** - Contracts survive restarts
✅ **Full Blockchain Features** - Immutable, auditable, scalable

## 📊 **Contract Types Available**

### **Ownership Contracts**
- `ComprehensiveV3Test:AIAgentOwnershipToken`
- Flexible metadata (unlimited key-value pairs)
- Commercial terms and licensing rights
- Transfer and ownership management

### **Usage Contracts**
- `ComprehensiveV3Test:AIAgentBasicUsageToken` - Limited access
- `ComprehensiveV3Test:AIAgentAdvancedUsageToken` - Development rights + royalties
- `ComprehensiveV3Test:AIAgentEnterpriseUsageToken` - Full features + SLAs

---

## 🚀 **Deployment Options**

### **Option A: New Full DAML Service**

1. **Create New Web Service**:
   - Go to Render dashboard
   - Click "New +" → "Web Service"
   - Connect to your GitHub repo
   - Configure:
     - **Name**: `agent-tokenization-full-daml`
     - **Runtime**: `Docker`
     - **Dockerfile Path**: `Dockerfile.full-daml`
     - **Plan**: Starter ($7/month)

2. **Environment Variables**:
   ```
   PORT=8080
   JAVA_OPTS=-Xmx2g -XX:+UseG1GC
   DATABASE_URL=[your existing database URL]
   DATABASE_HOST=[your existing database host]
   DATABASE_PORT=5432
   DATABASE_NAME=postgres
   DATABASE_USER=[your database user]
   DATABASE_PASSWORD=[your database password]
   ENVIRONMENT=production
   CORS_ORIGIN=*
   RENDER=true
   ```

3. **Deploy**:
   - Click "Create Web Service"
   - Wait 10-15 minutes for DAML SDK installation and build

### **Option B: Update Existing Service**

1. **Update Dockerfile Path**:
   - Go to your existing service settings
   - Change **Dockerfile Path** to: `Dockerfile.full-daml`

2. **Add Environment Variable**:
   ```
   JAVA_OPTS=-Xmx2g -XX:+UseG1GC
   ```

3. **Trigger Deploy**:
   - Push changes to GitHub or manually redeploy

---

## ⏰ **Expected Deployment Timeline**

- **Build Phase**: 8-12 minutes
  - System dependencies: 2-3 minutes
  - DAML SDK installation: 3-5 minutes
  - Project build: 2-3 minutes
  - Canton installation: 1-2 minutes

- **Startup Phase**: 3-5 minutes
  - DAML sandbox startup: 1-2 minutes
  - Contract deployment: 1-2 minutes
  - JSON API startup: 1 minute

- **Total**: 12-17 minutes for full deployment

---

## 🧪 **Testing the Full System**

### **1. Health Check**
```bash
curl https://your-service-name.onrender.com/readyz
```

### **2. Query Ownership Contracts**
```bash
curl -X POST https://your-service-name.onrender.com/v1/query \
  -H "Content-Type: application/json" \
  -d '{
    "templateIds": ["ComprehensiveV3Test:AIAgentOwnershipToken"]
  }'
```

**Expected Response** (Real contracts):
```json
{
  "result": [
    {
      "contractId": "real-contract-id-123",
      "templateId": "ComprehensiveV3Test:AIAgentOwnershipToken",
      "payload": {
        "agentName": "MarketingGuru AI",
        "agentDescription": "Advanced marketing strategy and content creation AI agent",
        "owner": "Alice",
        "totalSupply": "1000.0",
        "status": "Active",
        "attributes": {
          "industry": "marketing",
          "models": "GPT-4,Claude-3,Grok-2",
          "capabilities": "strategy,copywriting,analytics"
        }
      }
    }
  ]
}
```

### **3. Create New Ownership Contract**
```bash
curl -X POST https://your-service-name.onrender.com/v1/create \
  -H "Content-Type: application/json" \
  -d '{
    "templateId": "ComprehensiveV3Test:AIAgentOwnershipToken",
    "payload": {
      "agentName": "MyCustomAgent",
      "agentDescription": "My custom AI agent",
      "agentCreator": "Alice",
      "owner": "Alice",
      "issuer": "SystemOrchestrator",
      "totalSupply": "100.0",
      "tokenAmount": "100.0",
      "status": "Active",
      "version": "1.0.0",
      "attributes": {
        "industry": "technology",
        "capabilities": "custom_functionality"
      },
      "privacyLevel": "Medium"
    }
  }'
```

### **4. Create Usage Contract**
```bash
curl -X POST https://your-service-name.onrender.com/v1/create \
  -H "Content-Type: application/json" \
  -d '{
    "templateId": "ComprehensiveV3Test:AIAgentBasicUsageToken",
    "payload": {
      "ownershipTokenId": "ownership-contract-id-here",
      "agentName": "MyCustomAgent",
      "user": "Bob",
      "grantor": "Alice",
      "allowedModels": ["GPT-4"],
      "allowedCapabilities": ["basic_functionality"],
      "usageLimit": "500.0",
      "validFrom": "2025-09-15T00:00:00Z",
      "validUntil": "2025-10-15T00:00:00Z",
      "restrictions": {
        "max_queries_per_day": "25",
        "rate_limit": "5_per_hour"
      }
    }
  }'
```

---

## 🎯 **Key Differences from Mock API**

### **Mock API (Current)**
- Returns: `{"received": true, "status": "accepted", "message": "Agent API endpoint ready"}`
- No real contracts created
- No blockchain persistence
- Development testing only

### **Full DAML System (New)**
- Returns: Real contract IDs and data
- Creates immutable blockchain contracts
- PostgreSQL + blockchain persistence
- Production-ready with full features

---

## 🚨 **Troubleshooting**

### **Build Fails: "DAML SDK installation failed"**
**Solution**: The system will retry 3 times. If still failing, check logs and try:
1. Increase memory allocation: `JAVA_OPTS=-Xmx3g`
2. Restart the deployment
3. Use smaller plan temporarily for build

### **Startup Fails: "Sandbox connection timeout"**
**Solution**:
1. Check database connection is working
2. Verify `DATABASE_URL` format is correct
3. Increase startup timeout in health check

### **Contracts Not Found**
**Solution**:
1. Check if comprehensive test ran successfully in logs
2. Look for "✅ 2 Ownership Contracts Created" message
3. If failed, will fall back to quick test

### **Memory Issues**
**Solution**:
1. Upgrade to Professional plan ($25/month)
2. Reduce `JAVA_OPTS` memory: `-Xmx1g`
3. Consider using H2 database instead of PostgreSQL

---

## 📊 **Performance & Scaling**

### **Starter Plan Performance**
- **Memory**: 512MB (tight for full DAML)
- **CPU**: 0.1 vCPU
- **Recommendation**: Monitor memory usage

### **Professional Plan Benefits**
- **Memory**: 1GB (better for DAML)
- **CPU**: 0.5 vCPU
- **Better performance**: Faster contract operations

### **Scaling Options**
- **Horizontal**: Multiple DAML nodes (enterprise)
- **Vertical**: Upgrade Render plans
- **Database**: Separate PostgreSQL instance

---

## 🎉 **Success Indicators**

Your full DAML system is working when you see:

✅ **Build logs show**: "✅ DAML build successful"
✅ **Startup logs show**: "📦 Deploying comprehensive V3 contracts..."
✅ **API returns real contract data** instead of mock responses
✅ **Health check passes**: `/readyz` returns DAML status
✅ **Contracts persist** after service restarts

---

## 💰 **Cost Comparison**

| Plan | Mock API | Full DAML | Benefits |
|------|----------|-----------|----------|
| **Starter** | $7/month | $7/month | Real blockchain, same cost |
| **Professional** | $25/month | $25/month | Better performance for DAML |
| **+ Database** | $7/month | $7/month | PostgreSQL persistence |

**Total**: $14-32/month for production blockchain with real ownership and usage contracts!

---

## 🎯 **Next Steps**

1. **Deploy using Option A or B** above
2. **Monitor build logs** for DAML installation progress
3. **Test the new endpoints** with real contract creation
4. **Update your frontend** to handle real contract responses
5. **Celebrate** - you now have a production blockchain! 🎉

**Your Agent Tokenization platform will go from mock API to full blockchain in ~15 minutes!** 🚀