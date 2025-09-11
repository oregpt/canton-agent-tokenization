# 🚀 Simple Persistent Canton Setup - 30 Minutes

## 📥 **Step 1: Download & Install (15 mins)**

### **A. PostgreSQL Database**
1. Go to: https://www.postgresql.org/download/windows/
2. Download PostgreSQL 15+ installer (150MB)
3. Run installer:
   - Port: **5432**
   - Username: **postgres** 
   - Password: **canton123** (remember this!)
   - Database: **postgres**
4. Click through defaults for everything else

### **B. Canton Community Edition**
1. Go to: https://github.com/digital-asset/canton/releases
2. Download latest `canton-community-X.X.X.zip`
3. Extract to: `C:\canton\`

## 🔧 **Step 2: Quick Database Setup (5 mins)**

Open Command Prompt as Administrator:

```bash
# Connect to PostgreSQL
"C:\Program Files\PostgreSQL\15\bin\psql.exe" -U postgres

# In PostgreSQL prompt, create database:
CREATE DATABASE canton_tokens;
CREATE USER canton WITH PASSWORD 'canton123';
GRANT ALL PRIVILEGES ON DATABASE canton_tokens TO canton;
\q
```

## 📝 **Step 3: Create Config File (5 mins)**

Create `canton-config.conf` in your project folder:

```hocon
canton {
  features.enable-testing-commands = yes
  
  participants.participant1 {
    storage.type = postgres
    storage.config {
      host = "localhost"
      port = 5432
      database = "canton_tokens"
      user = "canton"
      password = "canton123"
    }
    admin-api.port = 5012
    ledger-api.port = 5011
  }
  
  domains.local {
    storage.type = postgres
    storage.config {
      host = "localhost"
      port = 5432
      database = "canton_tokens" 
      user = "canton"
      password = "canton123"
    }
    public-api.port = 5018
    admin-api.port = 5019
  }
}
```

## 🚀 **Step 4: Start Persistent Canton (5 mins)**

```bash
# Navigate to project
cd "C:\Users\oreph\Documents\Canton\DAML Projects\CantonAgentTokenization"

# Start Canton with your config
C:\canton\bin\canton.bat -c canton-config.conf
```

In Canton console:
```scala
local.start()
participant1.start()
participant1.domains.connect_local(local)
participant1.dars.upload("agent-tokenization-v3-3.0.0.dar")
```

## 🎯 **Step 5: Deploy Your Contracts**

New terminal:
```bash
daml script --dar agent-tokenization-v3-3.0.0.dar \
  --script-name AgentTokenizationV2:demoV2System \
  --ledger-host localhost --ledger-port 5011
```

## ✅ **Test Persistence**

1. Deploy contracts ☝️
2. Stop Canton (Ctrl+C)
3. Restart Canton with same command
4. Contracts should still be there!

## 🆘 **Alternative: Simpler H2 Database**

If PostgreSQL seems complex, you can use H2 (file-based):

```hocon
# Simpler config with H2 file database
canton {
  participants.participant1 {
    storage.type = h2
    storage.config.url = "jdbc:h2:./canton-data/participant1"
    admin-api.port = 5012
    ledger-api.port = 5011
  }
  
  domains.local {
    storage.type = h2
    storage.config.url = "jdbc:h2:./canton-data/domain"
    public-api.port = 5018
    admin-api.port = 5019
  }
}
```

This creates files in `canton-data/` folder - simpler but less production-ready than PostgreSQL.

---

**Total time: 30 minutes for permanent contract storage!** 🎉