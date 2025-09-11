# 🔧 Persistent Canton Setup Guide

Set up Canton with PostgreSQL for permanent contract storage on Windows.

## 📋 **What You Need**

1. ✅ **DAML SDK** (already installed)
2. ❌ **PostgreSQL** (need to install)
3. ❌ **Canton Enterprise** (need to install)
4. ✅ **Your DAR file** (already built)

## 🚀 **Step-by-Step Setup**

### **Step 1: Install PostgreSQL**

#### **Option A: Download PostgreSQL (Recommended)**
1. Go to [postgresql.org/download/windows](https://www.postgresql.org/download/windows/)
2. Download PostgreSQL 15+ installer
3. Run installer with these settings:
   - **Port**: 5432 (default)
   - **Username**: postgres
   - **Password**: (choose a strong password, remember it!)
   - **Database**: postgres (default)

#### **Option B: Using Chocolatey (if available)**
```bash
# If you have chocolatey
choco install postgresql --version=15.4
```

#### **Option C: Docker (Alternative)**
```bash
# If you have Docker Desktop
docker run --name canton-postgres \
  -e POSTGRES_PASSWORD=canton123 \
  -e POSTGRES_DB=canton \
  -p 5432:5432 \
  -d postgres:15
```

### **Step 2: Install Canton Enterprise**

Canton Enterprise provides persistent storage capabilities.

```bash
# Install Canton via DAML
daml install canton
```

**Or download manually:**
1. Go to [github.com/digital-asset/canton](https://github.com/digital-asset/canton)
2. Download latest community edition
3. Extract to a folder

### **Step 3: Create Database**

After PostgreSQL is installed:

```sql
-- Connect to PostgreSQL as postgres user
-- Create database for Canton
CREATE DATABASE canton_agent_tokenization;

-- Create user for Canton
CREATE USER canton WITH PASSWORD 'canton_password_123';

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE canton_agent_tokenization TO canton;
```

### **Step 4: Configure Canton**

Create `canton-persistent.conf`:

```hocon
# Canton configuration with PostgreSQL persistence

canton {
  features {
    enable-testing-commands = yes
  }
  
  participants {
    participant1 {
      storage {
        type = postgres
        config {
          host = "localhost"
          port = 5432
          database = "canton_agent_tokenization"
          user = "canton"
          password = "canton_password_123"
        }
      }
      
      admin-api {
        address = "127.0.0.1"
        port = 5012
      }
      
      ledger-api {
        address = "127.0.0.1"
        port = 5011
      }
      
      parameters {
        # Enable JSON API
        ledger-api-server-parameters {
          enable-daml-lf-dev-version-support = true
        }
      }
    }
  }
  
  domains {
    local {
      storage {
        type = postgres
        config {
          host = "localhost"
          port = 5432
          database = "canton_agent_tokenization"
          user = "canton"
          password = "canton_password_123"
        }
      }
      
      public-api {
        address = "127.0.0.1"
        port = 5018
      }
      
      admin-api {
        address = "127.0.0.1"
        port = 5019
      }
    }
  }
}
```

### **Step 5: Start Canton with Persistence**

```bash
# Navigate to your project
cd "C:\Users\oreph\Documents\Canton\DAML Projects\CantonAgentTokenization"

# Start Canton with persistent config
canton -c canton-persistent.conf
```

### **Step 6: Initialize Canton Network**

In the Canton console:

```scala
// Bootstrap the network
local.start()
participant1.start()

// Connect participant to domain
participant1.domains.connect_local(local)

// Upload your DAR
participant1.dars.upload("agent-tokenization-v3-3.0.0.dar")
```

### **Step 7: Deploy Your Contracts**

In a new terminal:

```bash
# Run your demo script against persistent Canton
daml script --dar agent-tokenization-v3-3.0.0.dar \
  --script-name AgentTokenizationV2:demoV2System \
  --ledger-host localhost \
  --ledger-port 5011
```

## 🔍 **Verification Steps**

### **Test Persistence:**

1. **Deploy contracts** using the script above
2. **Stop Canton** (Ctrl+C in Canton console)
3. **Restart Canton** with same config
4. **Check contracts still exist**:
   ```bash
   # Query contracts after restart
   daml script --dar agent-tokenization-v3-3.0.0.dar \
     --script-name AgentTokenizationV2:initializeV2System \
     --ledger-host localhost \
     --ledger-port 5011
   ```

### **Database Verification:**

```sql
-- Connect to PostgreSQL
-- Check Canton tables were created
\c canton_agent_tokenization
\dt
```

You should see Canton's internal tables storing your contract data.

## 📊 **Benefits of This Setup**

### ✅ **Persistent Storage**
- Contracts survive Canton restarts
- Database-backed reliability
- Transaction history preserved

### ✅ **Local Control**
- Your own infrastructure
- No external dependencies
- Full data ownership

### ✅ **Development Ready**
- Fast local testing
- Complete Canton features
- Production-like setup

## 🚨 **Important Notes**

### **Database Security:**
- Use strong passwords in production
- Consider encrypted connections
- Regular database backups

### **Performance:**
- PostgreSQL on same machine is fine for development
- Consider separate database server for production
- Monitor database disk space

### **Backup Strategy:**
```bash
# Backup your database regularly
pg_dump -h localhost -U canton canton_agent_tokenization > backup.sql

# Restore if needed
psql -h localhost -U canton -d canton_agent_tokenization < backup.sql
```

## 🎯 **Troubleshooting**

### **Common Issues:**

#### **"Connection refused" error**
- Check PostgreSQL is running: `net start postgresql-x64-15`
- Verify port 5432 is open
- Check credentials in config file

#### **"Database does not exist"**
- Create database: `CREATE DATABASE canton_agent_tokenization;`
- Grant permissions to canton user

#### **Canton won't start**
- Check config file syntax (HOCON format)
- Verify database connection
- Check log files for errors

## 🚀 **Next Steps After Setup**

1. **Deploy your contracts** to persistent storage
2. **Test persistence** by restarting Canton
3. **Access JSON API** at http://localhost:7575 (if enabled)
4. **Build applications** using persistent contract data
5. **Scale as needed** (separate database server, etc.)

---

**Once set up, your AI Agent Tokenization contracts will persist forever!** 🎉