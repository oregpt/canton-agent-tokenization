# 🚀 Railway + Supabase Deployment Guide

**Complete guide to deploy Canton Agent Tokenization to Railway with Supabase PostgreSQL**

---

## 📋 **Prerequisites**

- ✅ Supabase account (free tier works)
- ✅ Railway account (free tier works)
- ✅ GitHub account for code deployment

---

## 🗄️ **Step 1: Set Up Supabase Database**

### **1.1 Create Supabase Project**
1. Go to https://supabase.com
2. Click **"New Project"**
3. Choose organization and name: `canton-agent-tokenization`
4. **Set a strong database password** (write this down!)
5. Choose region closest to your users

### **1.2 Get Connection Details**
1. In Supabase dashboard → **Settings** → **Database**
2. In **Connection string** section, copy the **Postgres** connection string:
   ```
   postgresql://postgres.xxxxxxxxxxxx:[YOUR-PASSWORD]@aws-0-us-east-1.pooler.supabase.com:6543/postgres
   ```
3. **Important**: Note down these values:
   - **Host**: `aws-0-us-east-1.pooler.supabase.com` (or your region)
   - **Port**: `6543`
   - **User**: `postgres.xxxxxxxxxxxx`
   - **Password**: Your database password
   - **Database**: `postgres`

### **1.3 Configure Connection Pooling**
1. In Supabase → **Settings** → **Database**
2. Ensure **Connection pooling** is enabled
3. Set **Pool mode** to **Session** (not Transaction)

---

## ⚙️ **Step 2: Update Canton Configuration**

### **2.1 Edit canton-supabase.conf**
Replace the placeholder values in `canton-supabase.conf` with your Supabase details:

```hocon
# In both participants.participant1.storage.config AND domains.local.storage.config:

host = "aws-0-us-east-1.pooler.supabase.com"  # YOUR region
port = 6543
database = "postgres"
user = "postgres.YOUR_PROJECT_REF"  # FROM SUPABASE
password = "${SUPABASE_DB_PASSWORD}"  # Will be set in Railway env vars
```

### **2.2 Test Configuration Locally (Optional)**
```bash
# Set environment variable
export SUPABASE_DB_PASSWORD="your_supabase_password"

# Test connection
daml start --sandbox-option --config=canton-supabase.conf --start-navigator=no
```

---

## 🚂 **Step 3: Deploy to Railway**

### **3.1 Push Code to GitHub**
```bash
# Initialize git (if not already done)
git init
git add .
git commit -m "Railway deployment setup"

# Push to GitHub
git remote add origin https://github.com/yourusername/canton-agent-tokenization.git
git push -u origin main
```

### **3.2 Create Railway Project**
1. Go to https://railway.app
2. Sign up/login with GitHub
3. Click **"New Project"**
4. Select **"Deploy from GitHub repo"**
5. Choose your `canton-agent-tokenization` repository

### **3.3 Configure Environment Variables**
In Railway dashboard:
1. Go to your project → **Variables** tab
2. Add environment variable:
   - **Key**: `SUPABASE_DB_PASSWORD`
   - **Value**: Your Supabase database password

### **3.4 Deploy**
1. Railway will automatically start building using your Dockerfile
2. Build time: ~5-10 minutes (installing DAML SDK)
3. Check **Deployments** tab for progress

---

## 🌐 **Step 4: Get Your Public URL**

### **4.1 Enable Public Access**
1. In Railway project → **Settings** tab
2. Click **"Generate Domain"**
3. You'll get a URL like: `https://canton-agent-tokenization-production.up.railway.app`

### **4.2 Test Your Deployment**
```bash
# Test health endpoint
curl https://your-railway-url.up.railway.app:7575/readyz

# Test package list
curl https://your-railway-url.up.railway.app:7575/v1/packages
```

---

## 🔧 **Step 5: Update Your Frontend**

### **5.1 Replace ngrok URL**
Update your frontend/platform to use Railway URL instead of ngrok:

**Before:**
```javascript
const API_BASE = "https://27524c709935.ngrok-free.app";
```

**After:**
```javascript
const API_BASE = "https://your-railway-url.up.railway.app:7575";
```

### **5.2 Test All Operations**
1. Agent registration
2. Token creation
3. Token queries
4. Usage tracking

---

## 📊 **Expected Costs**

### **Free Tier (Limited)**
- **Supabase**: Free (2GB storage, 500MB database)
- **Railway**: $5/month (500 execution hours)
- **Total**: $5/month

### **Production Tier**
- **Supabase**: $25/month (8GB+, better performance)
- **Railway**: $20/month (unlimited execution)
- **Total**: $45/month

---

## 🔍 **Troubleshooting**

### **Common Issues**

#### **1. Database Connection Failed**
```
Error: Connection to database failed
```
**Solution:**
- Verify Supabase connection details in `canton-supabase.conf`
- Check `SUPABASE_DB_PASSWORD` environment variable in Railway
- Ensure connection pooling is set to **Session mode**

#### **2. Build Timeout**
```
Error: Build exceeded time limit
```
**Solution:**
- Railway free tier has build time limits
- Upgrade to Hobby plan for longer builds
- Or optimize Dockerfile (cache DAML SDK installation)

#### **3. Port Binding Issues**
```
Error: Address already in use
```
**Solution:**
- Railway automatically assigns ports
- Ensure Dockerfile exposes port 7575
- Check Railway port configuration in dashboard

#### **4. CORS Errors from Frontend**
```
Error: Access to fetch blocked by CORS policy
```
**Solution:**
- Verify `--allow-insecure-tokens` flag in startup script
- Check Railway domain is accessible
- Add proper CORS headers if needed

### **Health Checks**

```bash
# Railway deployment health
curl https://your-railway-url.up.railway.app:7575/readyz

# Database connectivity
curl -X POST https://your-railway-url.up.railway.app:7575/v1/packages

# JWT authentication (with your token)
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     https://your-railway-url.up.railway.app:7575/v1/query
```

---

## 🎯 **Success Criteria**

✅ **Deployment Complete When:**
- Railway build succeeds
- Health check returns 200 OK
- Package list API returns data
- JWT authentication works
- Frontend can connect without ngrok

✅ **Migration Complete When:**
- All existing wallets work
- Token creation functions
- Agent registration works
- Usage tracking functions
- 24/7 uptime confirmed

---

## 📝 **Next Steps After Deployment**

1. **Monitor Performance**
   - Check Railway metrics dashboard
   - Monitor Supabase database usage
   - Set up alerts for downtime

2. **Security Hardening**
   - Add proper SSL certificate
   - Implement rate limiting
   - Add API authentication

3. **Scaling Preparation**
   - Monitor database connection pool usage
   - Plan for horizontal scaling if needed
   - Consider CDN for global users

---

## 💡 **Pro Tips**

- **Backup Strategy**: Supabase provides automatic backups
- **Monitoring**: Use Railway's built-in monitoring
- **Logs**: Check Railway logs for debugging
- **Updates**: Git push to main branch auto-deploys
- **Rollback**: Railway keeps deployment history for easy rollbacks

---

**🚀 You're now running a production-grade DAML blockchain on Railway + Supabase!**

*No more ngrok tunnels, no more local dependencies - your agent tokenization platform is live 24/7.*