# 🔄 Restart Guide - Running Your Local Canton Setup

**Quick reference for starting your Agent Tokenization blockchain after leaving a session**

---

## ⚡ **Quick Start (If Everything Was Working)**

### **Windows Users**

1. **Check PostgreSQL Service:**
   ```cmd
   net start | findstr postgres
   # Should show: postgresql-x64-17 - PostgreSQL Server 17
   ```

2. **Start PostgreSQL if needed:**
   ```cmd
   net start postgresql-x64-17
   ```

3. **Navigate to Project:**
   ```cmd
   cd "C:\Users\%USERNAME%\Documents\Canton\DAML Projects\CantonAgentTokenization"
   ```

4. **Start Canton Sandbox:**
   ```cmd
   daml start --start-navigator=no
   ```

5. **Wait for Ready Message:**
   ```
   DAR upload succeeded.
   Started server: (ServerBinding(/127.0.0.1:7575),None)
   Press 'r' + 'Enter' to re-build and upload...
   ```

6. **Test API (in new terminal):**
   ```cmd
   curl http://localhost:7575/readyz
   # Should return: ready status
   ```

### **macOS/Linux Users**

1. **Start PostgreSQL Service:**
   ```bash
   # Homebrew
   brew services start postgresql@17
   
   # Or system service
   sudo systemctl start postgresql
   ```

2. **Navigate to Project:**
   ```bash
   cd ~/Documents/Canton/DAML\ Projects/CantonAgentTokenization
   ```

3. **Start Canton Sandbox:**
   ```bash
   daml start --start-navigator=no
   ```

4. **Test API:**
   ```bash
   curl http://localhost:7575/readyz
   ```

---

## 🔍 **Troubleshooting Common Issues**

### **Issue: "PostgreSQL connection refused"**

**Solution:**
```bash
# Windows
net start postgresql-x64-17

# macOS (Homebrew)
brew services start postgresql@17

# Linux
sudo systemctl start postgresql
```

### **Issue: "Database does not exist"**

**Solution:**
```bash
# Windows
set PGPASSWORD=canton123
"C:\Program Files\PostgreSQL\17\bin\createdb.exe" -U postgres canton_agent_tokenization

# macOS/Linux
export PGPASSWORD=canton123
createdb -U postgres canton_agent_tokenization
```

### **Issue: "Port already in use"**

**Solution:**
```bash
# Find what's using the port
# Windows
netstat -ano | findstr :7575
netstat -ano | findstr :6865

# macOS/Linux
lsof -i :7575
lsof -i :6865

# Kill the process if needed
# Windows: taskkill /PID <process_id> /F
# macOS/Linux: kill -9 <process_id>
```

### **Issue: "DAR file not found"**

**Solution:**
```bash
# Rebuild the project
daml build

# Check DAR exists
# Windows
dir .daml\dist\*.dar

# macOS/Linux
ls .daml/dist/*.dar
```

---

## ✅ **Verification Checklist**

After starting, verify these services are running:

- [ ] **PostgreSQL Database** (port 5432)
  ```bash
  # Test connection
  psql -U postgres -h localhost -c "SELECT version();"
  ```

- [ ] **Canton Sandbox** (port 6865)
  ```bash
  # Should be shown in daml start output
  ```

- [ ] **JSON API Server** (port 7575)  
  ```bash
  curl http://localhost:7575/readyz
  ```

- [ ] **Agent Contracts Deployed**
  ```bash
  # Test with your SDK or direct API call
  ```

---

## 📊 **Service Status Quick Reference**

| Service | Port | Check Command | Expected Result |
|---------|------|---------------|-----------------|
| PostgreSQL | 5432 | `psql -U postgres -h localhost -c "\l"` | Database list |
| Canton Sandbox | 6865 | Visible in `daml start` output | Ledger ready |
| JSON API | 7575 | `curl localhost:7575/readyz` | HTTP 200 |

---

## 🎯 **What Should Be Working**

After successful restart:

### **External Builders Can:**
- ✅ **Register agents** via JavaScript/Python SDKs
- ✅ **Create usage tokens** for billing/tracking  
- ✅ **Query agent data** via REST API
- ✅ **Record usage events** and track metrics

### **Test Integration:**
```javascript
// JavaScript test
const sdk = new AgentTokenizationSDK({baseUrl: 'http://localhost:7575'});
const agents = await sdk.queryAgents({isActive: true});
console.log('Active agents:', agents.length);
```

```python
# Python test
from agent_tokenization_sdk import AgentTokenizationSDK
with AgentTokenizationSDK() as sdk:
    agents = sdk.query_agents({'isActive': True})
    print(f'Active agents: {len(agents)}')
```

---

## 🚨 **If Nothing Works**

### **Complete Reset (Nuclear Option):**

1. **Stop all services:**
   ```bash
   # Stop daml start (Ctrl+C)
   # Stop PostgreSQL service
   ```

2. **Restart PostgreSQL:**
   ```bash
   # Windows
   net stop postgresql-x64-17
   net start postgresql-x64-17
   
   # macOS/Linux
   brew services restart postgresql@17
   # or sudo systemctl restart postgresql
   ```

3. **Clean and rebuild:**
   ```bash
   daml clean-cache
   daml build
   ```

4. **Start fresh:**
   ```bash
   daml start --start-navigator=no
   ```

---

## 📞 **When to Use Full Deployment Guide**

Use the complete **LOCAL_DEPLOYMENT_GUIDE.md** if:
- ❌ This is your first time setting up
- ❌ You're on a new computer  
- ❌ PostgreSQL isn't installed
- ❌ You need detailed explanations
- ❌ Nothing in this restart guide works

**This restart guide assumes everything was working before and you just need to start the services again.**