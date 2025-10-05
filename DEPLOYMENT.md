# 🚀 Canton Agent Tokenization - Railway Production Deployment

## 📡 **Live Deployment**

Your Canton Agent Tokenization platform is **deployed and running 24/7** on Railway!

**Public Endpoint:** `https://canton-agent-tokenization-production.up.railway.app`

## ✅ **Deployment Status**
- ✅ Railway hosting with 8GB RAM, 8 vCPU
- ✅ PostgreSQL database with automatic backups
- ✅ Health checks passing
- ✅ DAML JSON API accessible externally
- ✅ Auto-deployment from GitHub main branch

---

## 🌐 **API Access**

### Base URL
```
https://canton-agent-tokenization-production.up.railway.app
```

### Health Check
```bash
curl https://canton-agent-tokenization-production.up.railway.app/
# Returns: OK
```

### DAML JSON API Endpoints

All standard DAML JSON API endpoints are available:

- `POST /v1/query` - Query contracts
- `POST /v1/create` - Create contracts
- `POST /v1/exercise` - Exercise contract choices
- `GET /v1/parties` - List parties
- `GET /v1/packages` - List packages

### Example API Call

```bash
curl -X POST https://canton-agent-tokenization-production.up.railway.app/v1/query \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "templateIds": ["AgentTokenizationV2:AgentToken"]
  }'
```

---

## 🔧 **Architecture**

### Port Configuration
- **Port 8080** (Public): Reverse proxy + health checks
- **Port 7575** (Internal): DAML JSON API
- **Port 6865** (Internal): Canton Ledger API

### Components Running 24/7

1. **Health Server** (`healthcheck.py`): Python reverse proxy on port 8080
   - Handles Railway health checks (`/` and `/health` → 200 OK)
   - Forwards all other requests to DAML JSON API on port 7575

2. **Canton Sandbox**: DAML ledger with PostgreSQL persistence
   - Auto-initialized on startup with DAR file
   - Connected to Railway PostgreSQL database

3. **DAML JSON API**: REST API for ledger access
   - Bound to `0.0.0.0:7575` internally
   - Accessible externally via reverse proxy

---

## 📦 **Database**

**Provider:** Railway PostgreSQL
**Connection:** Automatic via `$DATABASE_URL` environment variable

The database persists:
- Contract state
- Transaction history
- Party information
- Package definitions (DAR files)

---

## 🔄 **Deployment Process**

### Automatic Deployment (Current Setup)
Every push to `main` branch triggers:

1. Railway detects GitHub push
2. Docker image builds from `Dockerfile`
3. Container deploys with health checks
4. Canton initializes and connects to PostgreSQL
5. DAML JSON API starts on port 7575
6. Reverse proxy routes external traffic

**Build Time:** ~20 seconds
**Startup Time:** ~3-5 minutes (Canton initialization)

### Manual Deployment
In Railway dashboard:
1. Go to your service
2. Click "Deployments"
3. Click "Redeploy" on latest commit

---

## 🛠️ **Troubleshooting**

### Check Deployment Logs
Railway Dashboard → Your Service → Deployments → View Logs

Key startup messages to look for:
```
Health check server listening on 0.0.0.0:8080
Started server: (ServerBinding(/[0:0:0:0:0:0:0:0]:7575),None)
DAR upload succeeded.
```

### Common Issues

**503 Service Unavailable on `/v1/*` endpoints**
- Canton is still initializing (takes 3-5 minutes after deployment)
- Check logs for "Started server" message
- Wait a few minutes and retry

**502 Bad Gateway**
- Railway port configuration issue
- Verify port is set to `8080` in Railway networking settings
- Check if service is running in Railway dashboard

**401 Unauthorized**
- ✅ This is normal! Just means you need authentication headers
- Add `Authorization: Bearer YOUR_TOKEN` header to requests
- DAML JSON API requires OAuth 2.0 Bearer tokens

---

## 📝 **Configuration Files**

### Key Files
- `Dockerfile` - Container build configuration
- `railway.toml` - Railway deployment settings
- `healthcheck.py` - Reverse proxy server
- `canton-railway.conf` - Canton configuration template
- `daml.yaml` - DAML project configuration

### Environment Variables (Auto-configured by Railway)
- `DATABASE_URL` - PostgreSQL connection string
- `PORT` - Set to `8080` by Railway

---

## 🔐 **Security**

- ✅ **HTTPS**: All traffic encrypted via Railway's edge proxy
- ✅ **Authentication**: DAML JSON API requires OAuth 2.0 Bearer tokens
- ✅ **Database**: PostgreSQL credentials managed by Railway
- ✅ **Secrets**: No sensitive data in code/repository

---

## 📊 **Monitoring**

### Health Checks
Railway continuously monitors: `GET /`
- **Success:** Returns `200 OK` with body `OK`
- **Frequency:** Every 30 seconds

### Application Logs
View real-time logs in Railway dashboard:
- API request/response logs
- Canton consensus events
- Database connection status
- Error traces

---

## 🚨 **Updating the Application**

### Standard Update Process

1. Make changes to your code locally
2. Commit and push to GitHub:
   ```bash
   git add .
   git commit -m "Description of changes"
   git push
   ```
3. Railway automatically detects push and redeploys
4. Monitor Railway logs for successful startup
5. Verify deployment with health check

### Database Schema Changes
Canton handles schema migrations automatically via Flyway. No manual intervention needed.

---

## 💰 **Cost Breakdown**

**Current Plan:** Railway Hobby ($5/month)
- 8GB RAM
- 8 vCPU
- PostgreSQL database included
- 100GB outbound bandwidth
- 24/7 uptime

---

## ✅ **Quick Reference**

### Replace ngrok with Railway in Your Code

**Before (ngrok):**
```javascript
const API_URL = "https://abc123.ngrok.io";
```

**After (Railway):**
```javascript
const API_URL = "https://canton-agent-tokenization-production.up.railway.app";
```

### Test Connection
```bash
# Health check
curl https://canton-agent-tokenization-production.up.railway.app/

# List packages (requires auth token)
curl https://canton-agent-tokenization-production.up.railway.app/v1/packages \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 📞 **Support Resources**

- **Railway Docs:** https://docs.railway.app
- **DAML Docs:** https://docs.daml.com
- **Canton Docs:** https://docs.daml.com/canton/
- **GitHub Repository:** https://github.com/oregpt/canton-agent-tokenization

---

## 🎉 **Success!**

Your Canton Agent Tokenization platform is now:
- ✅ Running 24/7 on Railway
- ✅ No more ngrok tunnels needed
- ✅ Persistent PostgreSQL storage
- ✅ Auto-deploying from GitHub
- ✅ Externally accessible via HTTPS

**Deployment Status:** 🟢 Live
**Last Updated:** October 5, 2025