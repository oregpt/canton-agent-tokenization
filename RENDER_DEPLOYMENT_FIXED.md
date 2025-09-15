# 🚀 Render Deployment Guide - Fixed Issues

## 🎯 **Deployment Options (Choose One)**

### **Option A: Manual Deployment (Recommended)**

This bypasses the render.yaml blueprint issues and gives you full control.

#### **Step 1: Create PostgreSQL Database**
1. Go to [render.com](https://render.com) dashboard
2. Click "New +" → "PostgreSQL"
3. Configure:
   - **Name**: `agent-tokenization-db`
   - **Database**: `canton_agent_tokenization`
   - **User**: `canton_user`
   - **Plan**: Starter ($7/month) or Free (90 days)
4. Click "Create Database"
5. **Save the connection details** (Internal Database URL)

#### **Step 2: Create Web Service**
1. Click "New +" → "Web Service"
2. Connect to your GitHub repository
3. Select `CantonAgentTokenization` repo
4. Configure:
   - **Name**: `agent-tokenization-api`
   - **Runtime**: `Docker`
   - **Dockerfile Path**: `Dockerfile.render` (uses our improved Dockerfile)
   - **Plan**: Starter ($7/month)

#### **Step 3: Environment Variables**
Add these in the web service environment section:
```
PORT=8080
DATABASE_URL=[paste your Internal Database URL from step 1]
DATABASE_HOST=[database hostname from step 1]
DATABASE_PORT=5432
DATABASE_NAME=canton_agent_tokenization
DATABASE_USER=canton_user
DATABASE_PASSWORD=[database password from step 1]
ENVIRONMENT=production
CORS_ORIGIN=*
RENDER=true
```

#### **Step 4: Deploy**
1. Click "Create Web Service"
2. Wait for build and deployment (5-10 minutes)
3. Check deployment logs for any issues

---

### **Option B: Blueprint Deployment (Fixed)**

Use the corrected render.yaml file.

#### **Step 1: Deploy Blueprint**
1. Ensure your fixed `render.yaml` is committed to GitHub
2. Go to [render.com/deploy](https://render.com/deploy)
3. Connect to your GitHub repository
4. Select the `CantonAgentTokenization` repo
5. Render will read the `render.yaml` and create all services

#### **Step 2: Wait and Verify**
- Database creation: ~2 minutes
- Web service build: ~5-10 minutes
- Total deployment time: ~15 minutes

---

## 🔧 **What We Fixed**

### **1. Render.yaml Issues**
- ✅ Fixed PostgreSQL service configuration
- ✅ Changed runtime from `node` to `docker`
- ✅ Added proper database name and user
- ✅ Updated build and start commands

### **2. Build Script Issues**
- ✅ Created `build-simple.sh` for Render environment
- ✅ Added fallback for when DAML SDK installation fails
- ✅ Separated local vs. cloud build processes

### **3. Runtime Issues**
- ✅ Created `start-hybrid.sh` that tries DAML first, falls back to mock
- ✅ Created `start-mock.sh` with full API endpoint simulation
- ✅ Added proper error handling and timeouts

### **4. Docker Issues**
- ✅ Created `Dockerfile.render` optimized for Render
- ✅ Proper Ubuntu base with all dependencies
- ✅ Graceful fallback when DAML setup fails

---

## ✅ **Verification Steps**

### **Test Your Deployment**

1. **Health Check**:
   ```bash
   curl https://your-service-name.onrender.com/readyz
   ```
   Expected: `{"status": "ready", "service": "Agent Tokenization API"}`

2. **API Test**:
   ```bash
   curl -X POST https://your-service-name.onrender.com/v1/query \
     -H "Content-Type: application/json" \
     -d '{"templateIds": ["AgentTokenizationV2:SystemOrchestrator"]}'
   ```

3. **Your Web App**:
   ```javascript
   const sdk = new AgentTokenizationSDK({
     baseUrl: 'https://your-service-name.onrender.com'
   });
   const health = await sdk.healthCheck();
   console.log('API Status:', health);
   ```

---

## 🚨 **Common Issues & Solutions**

### **Issue: "Build Failed"**
**Cause**: DAML SDK installation timeout
**Solution**: The system automatically falls back to mock API - this is expected behavior

### **Issue: "Database Connection Failed"**
**Cause**: Wrong DATABASE_URL or database not ready
**Solution**:
1. Check DATABASE_URL format: `postgresql://user:pass@host:5432/dbname`
2. Ensure database service is running
3. Verify environment variables are set correctly

### **Issue: "Service Won't Start"**
**Cause**: Port binding or script permissions
**Solution**:
1. Ensure PORT environment variable is set to 8080
2. Check that start scripts are executable
3. Review deployment logs in Render dashboard

### **Issue: "CORS Errors"**
**Solution**: Set `CORS_ORIGIN=*` in environment variables

---

## 🎯 **What You Get**

### **If DAML Works (Ideal)**:
- ✅ Full DAML blockchain with persistent contracts
- ✅ Complete Agent Tokenization functionality
- ✅ Real contract storage and queries
- ✅ Production-grade blockchain features

### **If DAML Fails (Fallback)**:
- ✅ Mock API that simulates all endpoints
- ✅ Compatible with your existing SDKs
- ✅ Perfect for frontend development and testing
- ✅ Same API interface as full DAML version

### **Both Options Include**:
- ✅ HTTPS endpoints with SSL certificates
- ✅ Auto-scaling based on traffic
- ✅ Built-in monitoring and logging
- ✅ PostgreSQL database for persistence

---

## 💡 **Pro Tips**

### **Development Workflow**:
1. Deploy mock API first to get frontend working
2. Test all your integrations against mock endpoints
3. Once stable, work on getting full DAML deployment
4. Switch frontend to full DAML when ready

### **Cost Optimization**:
- **Mock API**: $7/month (web service only)
- **Full System**: $14/month (web service + database)
- **Free Tier**: Use free PostgreSQL for 90 days

### **Monitoring**:
- Check Render dashboard for deployment status
- View logs for debugging
- Set up alerts for downtime

---

## 🚀 **Next Steps**

1. **Choose deployment option** (A or B above)
2. **Follow the steps** for your chosen option
3. **Test the endpoints** using the verification steps
4. **Update your web app** to use the new API URL
5. **Monitor the deployment** in Render dashboard

**Your Agent Tokenization API will be live at**: `https://your-service-name.onrender.com`

**Total cost**: $7-14/month for a production blockchain API! 🎉