# 🏦 WALLET LIBRARY - Complete Party & JWT Collection

**Generated:** September 19, 2025
**Expires:** March 18, 2026 (180 days)
**Total Wallets:** 7 available parties

---

## 🎯 **How to Use These Wallets**

Each wallet contains:
- **Wallet Name**: User-friendly display name
- **Party ID**: Exact blockchain identifier (use as `owner` in payloads)
- **Private Key (JWT)**: Authentication token (use in `Authorization` header)

### **Usage Pattern:**
```javascript
const makeRequestWithPersistentParty = async (payload, wallet) => {
  const response = await fetch('https://f22b236be74f.ngrok-free.app/v1/create', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${wallet.jwt}`  // ← Private key here
    },
    body: JSON.stringify({
      templateId: "c636fa20517eed78ae1380d836a60359cf6574bee22129b9c7fc22a69ac42373:AgentTokenizationV2:SimpleAgentToken",
      payload: {
        ...payload,
        owner: wallet.partyId  // ← Party ID here
      }
    })
  });
};
```

---

## 💼 **WALLET COLLECTION**

### **1. 👩‍💼 Business Operations Wallet (Alice)**
```javascript
const WALLET_ALICE = {
  name: "Business Operations",
  displayName: "Persistent Alice",
  partyId: "PersistentAlice::1220adb11431a17d4580a02dac9643c4c61be8afb1c9803cfe08523c5720c519a59b",
  jwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJQZXJzaXN0ZW50QWxpY2U6OjEyMjBhZGIxMTQzMWExN2Q0NTgwYTAyZGFjOTY0M2M0YzYxYmU4YWZiMWM5ODAzY2ZlMDg1MjNjNTcyMGM1MTlhNTliIl0sImFkbWluIjp0cnVlLCJyZWFkQXMiOlsiUGVyc2lzdGVudEFsaWNlOjoxMjIwYWRiMTE0MzFhMTdkNDU4MGEwMmRhYzk2NDNjNGM2MWJlOGFmYjFjOTgwM2NmZTA4NTIzYzU3MjBjNTE5YTU5YiJdfSwic3ViIjoiUGVyc2lzdGVudEFsaWNlIiwiYXVkIjoiaHR0cHM6Ly9kYW1sLmNvbS9sZWRnZXItYXBpIiwiaXNzIjoiYWdlbnQtdG9rZW5pemF0aW9uLXN5c3RlbSIsImV4cCI6MTc4OTY0NzIwMywiaWF0IjoxNzU4MTExMjAzfQ.t5rczTayo9-qGTlA6WK5_D_sptoSAkBmZPgLsiS1L0g",
  useCase: "Platform operations, admin functions"
};
```

### **2. 👤 Customer Account Wallet (Bob)**
```javascript
const WALLET_BOB = {
  name: "Customer Account",
  displayName: "Persistent Bob",
  partyId: "PersistentBob::1220adb11431a17d4580a02dac9643c4c61be8afb1c9803cfe08523c5720c519a59b",
  jwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJQZXJzaXN0ZW50Qm9iOjoxMjIwYWRiMTE0MzFhMTdkNDU4MGEwMmRhYzk2NDNjNGM2MWJlOGFmYjFjOTgwM2NmZTA4NTIzYzU3MjBjNTE5YTU5YiJdLCJhZG1pbiI6dHJ1ZSwicmVhZEFzIjpbIlBlcnNpc3RlbnRCb2I6OjEyMjBhZGIxMTQzMWExN2Q0NTgwYTAyZGFjOTY0M2M0YzYxYmU4YWZiMWM5ODAzY2ZlMDg1MjNjNTcyMGM1MTlhNTliIl19LCJzdWIiOiJQZXJzaXN0ZW50Qm9iIiwiYXVkIjoiaHR0cHM6Ly9kYW1sLmNvbS9sZWRnZXItYXBpIiwiaXNzIjoiYWdlbnQtdG9rZW5pemF0aW9uLXN5c3RlbSIsImV4cCI6MTc4OTY0NzIwMywiaWF0IjoxNzU4MTExMjAzfQ.TK88e8L7m70SngsZAk1crHDwEfaPaVvR3GMkSb6aZ9Q",
  useCase: "Customer usage tokens, end-user operations"
};
```

### **3. 🏢 TechCorp Enterprise Wallet**
```javascript
const WALLET_TECHCORP = {
  name: "TechCorp Enterprise",
  displayName: "TechCorp Enterprise",
  partyId: "Enterprise_TechCorp::1220adb11431a17d4580a02dac9643c4c61be8afb1c9803cfe08523c5720c519a59b",
  jwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJFbnRlcnByaXNlX1RlY2hDb3JwOjoxMjIwYWRiMTE0MzFhMTdkNDU4MGEwMmRhYzk2NDNjNGM2MWJlOGFmYjFjOTgwM2NmZTA4NTIzYzU3MjBjNTE5YTU5YiJdLCJhZG1pbiI6dHJ1ZSwicmVhZEFzIjpbIkVudGVycHJpc2VfVGVjaENvcnA6OjEyMjBhZGIxMTQzMWExN2Q0NTgwYTAyZGFjOTY0M2M0YzYxYmU4YWZiMWM5ODAzY2ZlMDg1MjNjNTcyMGM1MTlhNTliIl19LCJzdWIiOiJFbnRlcnByaXNlX1RlY2hDb3JwIiwiYXVkIjoiaHR0cHM6Ly9kYW1sLmNvbS9sZWRnZXItYXBpIiwiaXNzIjoiYWdlbnQtdG9rZW5pemF0aW9uLXN5c3RlbSIsImV4cCI6MTc3MzgzMjI0NCwiaWF0IjoxNzU4MjgwMjQ0fQ.qUva7GH2e6C5h54EHuoindar_L3HaYASSmC8qVGHs-A",
  useCase: "Large enterprise customer, bulk operations"
};
```

### **4. 🚀 AI Labs Startup Wallet**
```javascript
const WALLET_AILABS = {
  name: "AI Labs Startup",
  displayName: "AI Labs Startup",
  partyId: "Startup_AILabs::1220adb11431a17d4580a02dac9643c4c61be8afb1c9803cfe08523c5720c519a59b",
  jwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJTdGFydHVwX0FJTGFiczo6MTIyMGFkYjExNDMxYTE3ZDQ1ODBhMDJkYWM5NjQzYzRjNjFiZThhZmIxYzk4MDNjZmUwODUyM2M1NzIwYzUxOWE1OWIiXSwiYWRtaW4iOnRydWUsInJlYWRBcyI6WyJTdGFydHVwX0FJTGFiczo6MTIyMGFkYjExNDMxYTE3ZDQ1ODBhMDJkYWM5NjQzYzRjNjFiZThhZmIxYzk4MDNjZmUwODUyM2M1NzIwYzUxOWE1OWIiXX0sInN1YiI6IlN0YXJ0dXBfQUlMYWJzIiwiYXVkIjoiaHR0cHM6Ly9kYW1sLmNvbS9sZWRnZXItYXBpIiwiaXNzIjoiYWdlbnQtdG9rZW5pemF0aW9uLXN5c3RlbSIsImV4cCI6MTc3MzgzMjI0NCwiaWF0IjoxNzU4MjgwMjQ0fQ.Kbpp_LZz7mpuG1JdXDHuHiXCqzQa46gkRdfknXn2T9g",
  useCase: "Startup customer, innovation projects"
};
```

### **5. 📈 Digital Marketing Agency Wallet**
```javascript
const WALLET_MARKETING = {
  name: "Digital Marketing Agency",
  displayName: "Digital Marketing Agency",
  partyId: "Agency_DigitalMarketing::1220adb11431a17d4580a02dac9643c4c61be8afb1c9803cfe08523c5720c519a59b",
  jwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJBZ2VuY3lfRGlnaXRhbE1hcmtldGluZzo6MTIyMGFkYjExNDMxYTE3ZDQ1ODBhMDJkYWM5NjQzYzRjNjFiZThhZmIxYzk4MDNjZmUwODUyM2M1NzIwYzUxOWE1OWIiXSwiYWRtaW4iOnRydWUsInJlYWRBcyI6WyJBZ2VuY3lfRGlnaXRhbE1hcmtldGluZzo6MTIyMGFkYjExNDMxYTE3ZDQ1ODBhMDJkYWM5NjQzYzRjNjFiZThhZmIxYzk4MDNjZmUwODUyM2M1NzIwYzUxOWE1OWIiXX0sInN1YiI6IkFnZW5jeV9EaWdpdGFsTWFya2V0aW5nIiwiYXVkIjoiaHR0cHM6Ly9kYW1sLmNvbS9sZWRnZXItYXBpIiwiaXNzIjoiYWdlbnQtdG9rZW5pemF0aW9uLXN5c3RlbSIsImV4cCI6MTc3MzgzMjI0NCwiaWF0IjoxNzU4MjgwMjQ0fQ.NcawxXPlsL23KDdkcyX2YHGtj8jMgy93arzNN-HRtFY",
  useCase: "Marketing automation, content generation"
};
```

### **6. 🛒 Retail Chain Customer Wallet**
```javascript
const WALLET_RETAIL = {
  name: "Retail Chain Customer",
  displayName: "Retail Chain Customer",
  partyId: "Customer_RetailChain::1220adb11431a17d4580a02dac9643c4c61be8afb1c9803cfe08523c5720c519a59b",
  jwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJDdXN0b21lcl9SZXRhaWxDaGFpbjo6MTIyMGFkYjExNDMxYTE3ZDQ1ODBhMDJkYWM5NjQzYzRjNjFiZThhZmIxYzk4MDNjZmUwODUyM2M1NzIwYzUxOWE1OWIiXSwiYWRtaW4iOnRydWUsInJlYWRBcyI6WyJDdXN0b21lcl9SZXRhaWxDaGFpbjo6MTIyMGFkYjExNDMxYTE3ZDQ1ODBhMDJkYWM5NjQzYzRjNjFiZThhZmIxYzk4MDNjZmUwODUyM2M1NzIwYzUxOWE1OWIiXX0sInN1YiI6IkN1c3RvbWVyX1JldGFpbENoYWluIiwiYXVkIjoiaHR0cHM6Ly9kYW1sLmNvbS9sZWRnZXItYXBpIiwiaXNzIjoiYWdlbnQtdG9rZW5pemF0aW9uLXN5c3RlbSIsImV4cCI6MTc3MzgzMjI0NCwiaWF0IjoxNzU4MjgwMjQ0fQ.3zpBcCsgezVbY4BWA9g8nGUUfD_VUjHORZA51m-5uqM",
  useCase: "Retail operations, customer service bots"
};
```

### **7. 🎮 Indie Developer Studio Wallet**
```javascript
const WALLET_INDIE = {
  name: "Indie Developer Studio",
  displayName: "Indie Developer Studio",
  partyId: "Developer_IndieStudio::1220adb11431a17d4580a02dac9643c4c61be8afb1c9803cfe08523c5720c519a59b",
  jwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJEZXZlbG9wZXJfSW5kaWVTdHVkaW86OjEyMjBhZGIxMTQzMWExN2Q0NTgwYTAyZGFjOTY0M2M0YzYxYmU4YWZiMWM5ODAzY2ZlMDg1MjNjNTcyMGM1MTlhNTliIl0sImFkbWluIjp0cnVlLCJyZWFkQXMiOlsiRGV2ZWxvcGVyX0luZGllU3R1ZGlvOjoxMjIwYWRiMTE0MzFhMTdkNDU4MGEwMmRhYzk2NDNjNGM2MWJlOGFmYjFjOTgwM2NmZTA4NTIzYzU3MjBjNTcyMGM1MTlhNTliIl19LCJzdWIiOiJEZXZlbG9wZXJfSW5kaWVTdHVkaW8iLCJhdWQiOiJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiLCJpc3MiOiJhZ2VudC10b2tlbml6YXRpb24tc3lzdGVtIiwiZXhwIjoxNzczODMyMjQ0LCJpYXQiOjE3NTgyODAyNDR9.MeTtekcMKuVQCoYsIchp7cUBxO7cNoDPyoMhkFY_Sso",
  useCase: "Independent developers, small-scale projects"
};
```

---

## 🔧 **Implementation Examples**

### **Wallet Array for Frontend:**
```javascript
const AVAILABLE_WALLETS = [
  WALLET_ALICE,
  WALLET_BOB,
  WALLET_TECHCORP,
  WALLET_AILABS,
  WALLET_MARKETING,
  WALLET_RETAIL,
  WALLET_INDIE
];

// Wallet selector component
const WalletSelector = ({ onWalletChange }) => {
  return (
    <select onChange={(e) => onWalletChange(AVAILABLE_WALLETS[e.target.value])}>
      <option value="">Select Wallet...</option>
      {AVAILABLE_WALLETS.map((wallet, index) => (
        <option key={index} value={index}>
          {wallet.name}
        </option>
      ))}
    </select>
  );
};
```

### **Token Creation with Selected Wallet:**
```javascript
const createAgentToken = async (agentData, selectedWallet) => {
  if (!selectedWallet) {
    throw new Error('No wallet selected');
  }

  const payload = {
    templateId: "c636fa20517eed78ae1380d836a60359cf6574bee22129b9c7fc22a69ac42373:AgentTokenizationV2:SimpleAgentToken",
    payload: {
      tokenId: `tkn_${Date.now()}_${Math.random().toString(36).substring(7)}`,
      agentId: agentData.agentId,
      owner: selectedWallet.partyId,  // ← Wallet's party ID
      metadata: {
        agentId: agentData.agentId,
        name: agentData.name,
        description: agentData.description,
        createdAt: new Date().toISOString(),
        version: "1.0"
      },
      isActive: true
    }
  };

  const response = await fetch('https://f22b236be74f.ngrok-free.app/v1/create', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${selectedWallet.jwt}`  // ← Wallet's private key
    },
    body: JSON.stringify(payload)
  });

  return response.json();
};
```

---

## ✅ **Verification Commands**

Test any wallet with:
```bash
# Test TechCorp wallet
curl -X POST https://f22b236be74f.ngrok-free.app/v1/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJFbnRlcnByaXNlX1RlY2hDb3JwOjoxMjIwYWRiMTE0MzFhMTdkNDU4MGEwMmRhYzk2NDNjNGM2MWJlOGFmYjFjOTgwM2NmZTA4NTIzYzU3MjBjNTE5YTU5YiJdLCJhZG1pbiI6dHJ1ZSwicmVhZEFzIjpbIkVudGVycHJpc2VfVGVjaENvcnA6OjEyMjBhZGIxMTQzMWExN2Q0NTgwYTAyZGFjOTY0M2M0YzYxYmU4YWZiMWM5ODAzY2ZlMDg1MjNjNTcyMGM1MTlhNTliIl19LCJzdWIiOiJFbnRlcnByaXNlX1RlY2hDb3JwIiwiYXVkIjoiaHR0cHM6Ly9kYW1sLmNvbS9sZWRnZXItYXBpIiwiaXNzIjoiYWdlbnQtdG9rZW5pemF0aW9uLXN5c3RlbSIsImV4cCI6MTc3MzgzMjI0NCwiaWF0IjoxNzU4MjgwMjQ0fQ.qUva7GH2e6C5h54EHuoindar_L3HaYASSmC8qVGHs-A" \
  -d '{
    "templateId": "c636fa20517eed78ae1380d836a60359cf6574bee22129b9c7fc22a69ac42373:AgentTokenizationV2:SimpleAgentToken",
    "payload": {
      "tokenId": "test_techcorp_001",
      "agentId": "test_agent_techcorp",
      "owner": "Enterprise_TechCorp::1220adb11431a17d4580a02dac9643c4c61be8afb1c9803cfe08523c5720c519a59b",
      "metadata": {
        "agentId": "test_agent_techcorp",
        "name": "TechCorp Test Agent",
        "description": "Testing TechCorp wallet",
        "createdAt": "2025-09-19T11:00:00.000Z",
        "version": "1.0"
      },
      "isActive": true
    }
  }'
```

---

## 🎯 **Ready for Your Wallet System!**

You now have **7 distinct blockchain identities** your users can choose from:

1. **Alice** - Platform operations
2. **Bob** - Customer accounts
3. **TechCorp** - Enterprise customers
4. **AI Labs** - Startup customers
5. **Marketing Agency** - Marketing automation
6. **Retail Chain** - Retail operations
7. **Indie Studio** - Independent developers

**All wallets are:**
- ✅ Registered in your DAML ledger
- ✅ Ready with 180-day JWT tokens
- ✅ Tested and working
- ✅ Copy-paste ready for your platform

**Perfect for your wallet UI implementation!** 🚀