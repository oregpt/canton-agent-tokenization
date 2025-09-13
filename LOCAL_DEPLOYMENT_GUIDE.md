# 🚀 Complete Local Deployment Guide - DAML Agent Tokenization V3

**A comprehensive step-by-step guide to deploy the Agent Tokenization system locally with persistent PostgreSQL storage.**

---

## 🧠 **What You're Building**

When you complete this guide, you'll have a **full blockchain system** running on your computer:

### **⛓️ Local Development Blockchain**
- **Canton Sandbox** - A private blockchain ledger running locally
- **Not a public blockchain** like Bitcoin/Ethereum, but a **development environment**
- **Full blockchain features** including smart contracts, immutable ledger, and consensus
- **Instant transactions** with no fees (optimized for development)

### **🏗️ System Components**

```
Your Computer After Setup:
├── 🗄️ PostgreSQL Database (port 5432)
│   └── Persistent storage for blockchain data and transactions
├── ⛓️ Canton Sandbox (port 6865) 
│   └── DAML blockchain engine (validates transactions & enforces rules)
├── 🌐 JSON API Server (port 7575)
│   └── REST API for external applications to interact with blockchain
└── 💾 DAML Smart Contracts
    └── Your deployed business logic running on the blockchain
```

### **🔍 How It Works**

#### **Canton Sandbox = The Blockchain Engine**
- **Validates all transactions** (like Bitcoin/Ethereum nodes do)
- **Enforces smart contract rules** (your DAML code)
- **Manages blockchain consensus** (single-node for development)
- **Handles cryptographic integrity** and immutability

#### **PostgreSQL = The Storage Layer**
- **Stores blockchain data** persistently (survives restarts)
- **Maintains transaction history** and contract states
- **Provides fast SQL queries** for data retrieval
- **Enterprise-grade reliability** for production use

#### **JSON API = The Interface**
- **REST endpoints** for external applications
- **Translates HTTP requests** to blockchain operations
- **Handles authentication** and party management
- **Enables web/mobile app integration**

### **🎯 What This Gives You**

#### **Real Blockchain Benefits:**
- ✅ **Immutable audit trail** - All changes are permanently recorded
- ✅ **Smart contract enforcement** - Business rules automatically enforced
- ✅ **Cryptographic integrity** - Data cannot be tampered with
- ✅ **Multi-party coordination** - Multiple organizations can participate

#### **Development-Friendly Features:**
- ✅ **Instant transactions** - No waiting for mining or confirmations
- ✅ **Free to use** - No gas fees or transaction costs
- ✅ **Full control** - Restart, reset, or debug as needed
- ✅ **SQL queries** - Use familiar database operations

#### **Production Ready:**
- ✅ **Enterprise architecture** - Same technology used by banks
- ✅ **Scalable to real networks** - Deploy to Canton Network or DAML Hub
- ✅ **Privacy-preserving** - Built-in selective disclosure features

### **🔄 Different from Public Blockchains**

| Feature | Your Local Setup | Bitcoin/Ethereum |
|---------|-----------------|------------------|
| **Network** | Single computer | Global network |
| **Speed** | Instant | Minutes to hours |
| **Cost** | Free | Gas fees required |
| **Privacy** | Private by default | Public by default |
| **Control** | Full control | No control |
| **Purpose** | Development/Enterprise | Public decentralization |

**Think of it as your own private blockchain laboratory where you can build, test, and deploy enterprise-grade blockchain applications!**

---

## 📋 **Prerequisites**

Before starting, ensure you have:

- ✅ **Windows 10/11** or **macOS 10.15+** or **Linux** (Ubuntu/Debian/CentOS)
- ✅ DAML SDK 2.8.0+ installed
- ✅ Administrator/sudo privileges (for PostgreSQL installation)
- ✅ 4GB+ available disk space
- ✅ Internet connection for downloads

---

## 🛠️ **Step 1: Install PostgreSQL**

### **🪟 Windows Installation**

1. **Navigate to PostgreSQL Downloads:**
   - Go to: https://www.postgresql.org/download/windows/
   - Click "Download the installer"

2. **Download PostgreSQL 17:**
   - Select the latest PostgreSQL 17.x version
   - Choose "Windows x86-64" architecture
   - Download the installer (approximately 400MB)

3. **Run the Installer:**
   ```cmd
   # Run the downloaded postgresql_17.exe file as Administrator
   ```

4. **Installation Settings (CRITICAL - Follow Exactly):**
   - **Installation Directory:** `C:\Program Files\PostgreSQL\17` (default)
   - **Data Directory:** `C:\Program Files\PostgreSQL\17\data` (default)
   - **Password:** Enter a secure password and **REMEMBER IT** (we'll use `canton123` in this guide)
   - **Port:** `5432` (default)
   - **Locale:** Default locale (default)
   - **Components:** Select all (PostgreSQL Server, pgAdmin 4, Stack Builder, Command Line Tools)

5. **Complete Installation:**
   - Click "Next" through all screens
   - Wait for installation to complete (5-10 minutes)
   - **DO NOT** launch Stack Builder when prompted
   - Click "Finish"

6. **Verify Installation:**
   ```cmd
   # Open Command Prompt as Administrator
   "C:\Program Files\PostgreSQL\17\bin\psql.exe" --version
   # Should output: psql (PostgreSQL) 17.x
   ```

### **🍎 macOS Installation**

#### **Option A: Using Homebrew (Recommended)**

1. **Install Homebrew (if not installed):**
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install PostgreSQL 17:**
   ```bash
   # Update Homebrew
   brew update
   
   # Install PostgreSQL
   brew install postgresql@17
   ```

3. **Start PostgreSQL Service:**
   ```bash
   # Start PostgreSQL service
   brew services start postgresql@17
   
   # Add PostgreSQL to PATH
   echo 'export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

4. **Set Up Database User:**
   ```bash
   # Create postgres user with password
   createuser -s postgres
   psql postgres -c "ALTER USER postgres PASSWORD 'canton123';"
   ```

#### **Option B: Using Postgres.app**

1. **Download Postgres.app:**
   - Go to: https://postgresapp.com/
   - Download the latest version with PostgreSQL 17

2. **Install and Configure:**
   - Drag Postgres.app to Applications folder
   - Launch Postgres.app
   - Click "Initialize" to create a new server
   - Set password to `canton123` when prompted

3. **Add to PATH:**
   ```bash
   echo 'export PATH="/Applications/Postgres.app/Contents/Versions/17/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

#### **Option C: Official macOS Installer**

1. **Download Official Installer:**
   - Go to: https://www.postgresql.org/download/macosx/
   - Download the PostgreSQL 17 installer for macOS

2. **Install with GUI:**
   - Follow the installer prompts
   - Set password to `canton123`
   - Keep default port `5432`
   - Install all components

3. **Verify Installation:**
   ```bash
   /Library/PostgreSQL/17/bin/psql --version
   # Should output: psql (PostgreSQL) 17.x
   ```

#### **Option D: Using 0xsend Homebrew Canton Tap (Advanced)**

*Note: This is an alternative approach for experienced developers who want standalone Canton control.*

1. **Install Canton via Community Homebrew Tap:**
   ```bash
   # Add the community Canton tap
   brew tap 0xsend/homebrew-canton
   
   # Install Canton (includes latest features)
   brew install canton
   ```

2. **Advantages of This Approach:**
   - ✅ **Latest Canton features** (pre-release versions)
   - ✅ **Automatic updates** (checks every 12 hours)
   - ✅ **Standalone Canton control** (independent of DAML SDK)
   - ✅ **Version switching** capabilities

3. **Use with Your Configuration:**
   ```bash
   # After PostgreSQL setup, start Canton with your config
   canton -c canton-persistent.conf
   ```

4. **Important Considerations:**
   - ⚠️ **Advanced users only** - requires Canton configuration knowledge
   - ⚠️ **Pre-release versions** - may have stability considerations  
   - ⚠️ **Different from DAML SDK approach** - separate installation path
   - ⚠️ **Manual configuration required** - no integrated `daml start` workflow

*For most users, we recommend the standard approaches above. This option is for developers who need cutting-edge Canton features or prefer standalone Canton deployment.*

### **🐧 Linux Installation (Ubuntu/Debian)**

```bash
# Update package list
sudo apt update

# Install PostgreSQL 17
sudo apt install -y postgresql-17 postgresql-client-17

# Start PostgreSQL service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Set password for postgres user
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'canton123';"

# Verify installation
psql --version
```

### **🔍 Verification (All Platforms)**

After installation, verify PostgreSQL is working:

```bash
# Test connection (use appropriate path for your OS)
psql -U postgres -h localhost -p 5432 -c "SELECT version();"
# Enter password: canton123
# Should show PostgreSQL version information
```

---

## 🗄️ **Step 2: Set Up Database**

### **🪟 Windows Database Setup**

1. **Open Command Prompt as Administrator:**
   ```cmd
   # Press Win+R, type "cmd", press Ctrl+Shift+Enter
   ```

2. **Set Environment Variable:**
   ```cmd
   set PGPASSWORD=canton123
   # Replace 'canton123' with YOUR PostgreSQL password
   ```

3. **Create the Database:**
   ```cmd
   "C:\Program Files\PostgreSQL\17\bin\createdb.exe" -U postgres canton_agent_tokenization
   ```

4. **Verify Database Creation:**
   ```cmd
   "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -l | findstr canton_agent_tokenization
   # Should show: canton_agent_tokenization | postgres | UTF8 | ...
   ```

### **🍎 macOS Database Setup**

1. **Set Environment Variable:**
   ```bash
   export PGPASSWORD=canton123
   # Replace 'canton123' with YOUR PostgreSQL password
   ```

2. **Create the Database:**
   ```bash
   createdb -U postgres canton_agent_tokenization
   ```

3. **Verify Database Creation:**
   ```bash
   psql -U postgres -l | grep canton_agent_tokenization
   # Should show: canton_agent_tokenization | postgres | UTF8 | ...
   ```

### **🐧 Linux Database Setup**

1. **Set Environment Variable:**
   ```bash
   export PGPASSWORD=canton123
   # Replace 'canton123' with YOUR PostgreSQL password
   ```

2. **Create the Database:**
   ```bash
   createdb -U postgres canton_agent_tokenization
   ```

3. **Verify Database Creation:**
   ```bash
   psql -U postgres -l | grep canton_agent_tokenization
   # Should show: canton_agent_tokenization | postgres | UTF8 | ...
   ```

### **🔧 Alternative Method (All Platforms)**

If the above methods fail, connect directly to PostgreSQL:

**Windows:**
```cmd
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres
```

**macOS/Linux:**
```bash
psql -U postgres
```

**Then in the PostgreSQL prompt:**
```sql
CREATE DATABASE canton_agent_tokenization;
\l
\q
```

---

## 📁 **Step 3: Download Project Files**

### **Get the Agent Tokenization Project**

1. **Create Project Directory:**
   ```cmd
   mkdir "C:\Users\%USERNAME%\Documents\Canton\DAML Projects\CantonAgentTokenization"
   cd "C:\Users\%USERNAME%\Documents\Canton\DAML Projects\CantonAgentTokenization"
   ```

2. **Download Project Files:**
   - Contact the project maintainer for the complete project archive
   - Or clone from repository if available
   - Ensure you have these key files:
     - `daml.yaml` (project configuration)
     - `daml/` folder (containing all DAML source files)
     - `.daml/dist/agent-tokenization-v3-3.0.0.dar` (compiled DAR file)

3. **Verify Project Structure:**
   ```cmd
   dir
   # Should show:
   # daml.yaml
   # daml/
   # .daml/
   # README.md
   # (other files)
   ```

---

## ⚙️ **Step 4: Configure Canton**

### **Create Canton Configuration File**

1. **Navigate to Project Directory:**
   ```cmd
   cd "C:\Users\%USERNAME%\Documents\Canton\DAML Projects\CantonAgentTokenization"
   ```

2. **Create Configuration File:**
   Create a file named `canton-persistent.conf` with the following content:

   ```hocon
   # Canton configuration with PostgreSQL persistence for local deployment
   
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
             user = "postgres"
             password = "canton123"
             # Replace 'canton123' with YOUR PostgreSQL password
             max-connections = 16
             min-connections = 4
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
             user = "postgres"
             password = "canton123"
             # Replace 'canton123' with YOUR PostgreSQL password
             max-connections = 16
             min-connections = 4
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

3. **IMPORTANT: Update Password**
   - Replace `canton123` with YOUR actual PostgreSQL password
   - The password appears in **4 places** in the config file
   - Save the file

---

## 🚀 **Step 5: Build and Deploy**

### **Build the Project**

1. **Verify DAML Installation:**
   ```cmd
   daml version
   # Should show DAML SDK version 2.8.0 or higher
   ```

2. **Build the Project:**
   ```cmd
   cd "C:\Users\%USERNAME%\Documents\Canton\DAML Projects\CantonAgentTokenization"
   daml build
   ```

3. **Verify DAR Creation:**
   ```cmd
   dir .daml\dist
   # Should show: agent-tokenization-v3-3.0.0.dar
   ```

### **Start Canton Sandbox**

1. **Start DAML Sandbox (Method 1 - Recommended):**
   ```cmd
   daml start --start-navigator=no
   ```

   **OR (Method 2 - With Custom Config):**
   ```cmd
   # This method uses our PostgreSQL config but requires Canton installation
   # First install Canton (if not already installed):
   # Download from https://github.com/digital-asset/canton/releases
   
   # Then start with custom config:
   canton -c canton-persistent.conf
   ```

2. **Wait for Startup (Important!):**
   - Watch the console output
   - Wait for messages like:
     ```
     DAR upload succeeded.
     Started server: (ServerBinding(/127.0.0.1:7575),None)
     Press 'r' + 'Enter' to re-build and upload...
     ```
   - This can take 2-5 minutes on first run

3. **Verify Services Running:**
   - **Canton Sandbox:** localhost:6865
   - **JSON API:** localhost:7575
   - **Navigator (if enabled):** localhost:7500

---

## 📊 **Step 6: Deploy Agent Tokenization System**

### **Run the Deployment Script**

1. **Open New Command Prompt Window:**
   ```cmd
   # Keep the Canton sandbox running in the first window
   # Open a NEW Command Prompt window
   ```

2. **Navigate to Project:**
   ```cmd
   cd "C:\Users\%USERNAME%\Documents\Canton\DAML Projects\CantonAgentTokenization"
   ```

3. **Deploy the System:**
   ```cmd
   daml script --dar .daml\dist\agent-tokenization-v3-3.0.0.dar --script-name AgentTokenizationV2:demoV2System --ledger-host localhost --ledger-port 6865
   ```

4. **Expected Output:**
   ```
   🎯 DAML Agent Tokenization V2 - Live Deployment Demo
   ===================================================
   ✅ V2 System Orchestrator initialized
   ✅ Agent created using V2 scalable architecture:
      • Individual registration contract (scales to millions)
      • Normalized attribute storage (efficient queries)
   ✅ Usage token created using V2 event-sourced architecture:
      • Immutable token (no expensive archive/create cycles)
      • Separate event log (full audit trail)
   ✅ V2 System deployed successfully!
      • Total agents: 1
      • System version: 2.0.0-testnet
      • Deployment time: [TIMESTAMP]
   
   🎉 READY FOR PRODUCTION DEPLOYMENT TO:
      • Canton Network (production)
      • DAML Hub (hosted testing)
      • Local Canton (development)
   ```

---

## ✅ **Step 7: Verification and Testing**

### **Verify Deployment Success**

1. **Check Database Storage:**
   ```cmd
   set PGPASSWORD=canton123
   "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d canton_agent_tokenization -c "\dt"
   # Should show Canton's internal tables storing contract data
   ```

2. **Test JSON API (Optional):**
   ```cmd
   # Open web browser and go to:
   http://localhost:7575/readyz
   # Should return: 200 OK
   ```

3. **Test Navigator (If Enabled):**
   ```cmd
   # Open web browser and go to:
   http://localhost:7500
   # Should show DAML Navigator interface
   ```

### **Test Persistence**

1. **Stop Canton Sandbox:**
   ```cmd
   # In the Canton window, press Ctrl+C
   ```

2. **Restart Canton:**
   ```cmd
   daml start --start-navigator=no
   ```

3. **Verify Contracts Still Exist:**
   ```cmd
   # Run a query script to verify contracts persisted
   daml script --dar .daml\dist\agent-tokenization-v3-3.0.0.dar --script-name AgentTokenizationV2:initializeV2System --ledger-host localhost --ledger-port 6865
   ```

---

## 🔧 **Troubleshooting Guide**

### **Common Issues and Solutions**

#### **Issue: PostgreSQL Connection Failed**
```
Error: Connection refused to localhost:5432
```

**Solution:**
1. Check PostgreSQL service is running:
   ```cmd
   net start | findstr postgres
   # Should show: postgresql-x64-17 - PostgreSQL Server 17
   ```

2. Start PostgreSQL if not running:
   ```cmd
   net start postgresql-x64-17
   ```

3. Verify port 5432 is not blocked:
   ```cmd
   netstat -an | findstr :5432
   # Should show: TCP 0.0.0.0:5432 ... LISTENING
   ```

#### **Issue: Database Does Not Exist**
```
Error: database "canton_agent_tokenization" does not exist
```

**Solution:**
```cmd
set PGPASSWORD=your_password_here
"C:\Program Files\PostgreSQL\17\bin\createdb.exe" -U postgres canton_agent_tokenization
```

#### **Issue: DAML Build Fails**
```
Error: Could not resolve dependencies
```

**Solution:**
1. Clean build artifacts:
   ```cmd
   rmdir /s .daml
   ```

2. Rebuild:
   ```cmd
   daml build
   ```

3. If still failing, check `daml.yaml` for correct dependencies

#### **Issue: Canton Takes Too Long to Start**
```
Waiting for canton sandbox to start...
```

**Solution:**
- Be patient - first startup can take 5+ minutes
- Check system resources (RAM, disk space)
- Try restarting with `daml clean-cache` first

#### **Issue: DAR File Not Found**
```
Error: agent-tokenization-v3-3.0.0.dar (The system cannot find the file specified)
```

**Solution:**
1. Verify DAR exists:
   ```cmd
   dir .daml\dist\*.dar
   ```

2. If missing, rebuild:
   ```cmd
   daml build
   ```

3. Use full path in script command:
   ```cmd
   daml script --dar "C:\Users\%USERNAME%\Documents\Canton\DAML Projects\CantonAgentTokenization\.daml\dist\agent-tokenization-v3-3.0.0.dar" --script-name AgentTokenizationV2:demoV2System --ledger-host localhost --ledger-port 6865
   ```

---

## 📈 **Advanced Configuration**

### **Performance Tuning**

For better performance with large datasets:

1. **PostgreSQL Configuration:**
   Edit `C:\Program Files\PostgreSQL\17\data\postgresql.conf`:
   ```
   shared_buffers = 256MB
   effective_cache_size = 1GB
   work_mem = 4MB
   maintenance_work_mem = 64MB
   ```

2. **Canton Configuration:**
   Add to `canton-persistent.conf`:
   ```hocon
   canton {
     parameters {
       batching {
         max-batch-size = 100
         max-batch-cost = 100000
       }
     }
   }
   ```

### **Security Hardening**

For production-like local deployments:

1. **Create Dedicated Database User:**
   ```sql
   -- Connect as postgres user
   CREATE USER canton WITH PASSWORD 'secure_canton_password_123';
   GRANT ALL PRIVILEGES ON DATABASE canton_agent_tokenization TO canton;
   ```

2. **Update Configuration:**
   ```hocon
   user = "canton"
   password = "secure_canton_password_123"
   ```

---

## 🎯 **Success Checklist**

After completing this guide, you should have:

- ✅ PostgreSQL 17 installed and running
- ✅ `canton_agent_tokenization` database created
- ✅ Project files downloaded and configured
- ✅ Canton configuration file with correct password
- ✅ DAML project built successfully
- ✅ Canton sandbox running on localhost:6865
- ✅ JSON API running on localhost:7575
- ✅ Agent Tokenization system deployed with sample data
- ✅ Contracts persisting between Canton restarts
- ✅ All verification tests passing

## 📞 **Support**

If you encounter issues not covered in this guide:

1. **Check Log Files:**
   - Canton logs: Console output
   - PostgreSQL logs: `C:\Program Files\PostgreSQL\17\data\log\`

2. **Verify Prerequisites:**
   - DAML SDK version 2.8.0+
   - PostgreSQL 17.x installed correctly
   - All required ports available

3. **Common Commands Reference:**
   ```cmd
   # Check DAML version
   daml version
   
   # Check PostgreSQL service
   net start | findstr postgres
   
   # Restart PostgreSQL
   net stop postgresql-x64-17 && net start postgresql-x64-17
   
   # Clean DAML cache
   daml clean-cache
   ```

---

## 🎉 **Congratulations!**

You have successfully deployed the DAML Agent Tokenization V3 system locally with persistent PostgreSQL storage. Your system is now ready for:

- 🔬 **Development and Testing**
- 🏢 **Enterprise Evaluation**
- 🚀 **Production Migration Planning**
- 📊 **Performance Benchmarking**

The system demonstrates enterprise-grade features including:
- Individual agent registration contracts (scales to millions)
- Normalized attribute storage with efficient queries
- Event-sourced usage tracking with immutable audit trails
- Multi-party validation workflows
- Persistent storage with database reliability

**Your Agent Tokenization platform is now live and ready for AI agent management at scale!** 🚀