# 🔑 **Agent Tokenization Platform - Account List**

## 📋 **Ready-to-Use Accounts (180-day tokens)**

Here are the pre-configured accounts you can use immediately. **No setup required** - just pick a username/password and start testing!

---

## 🚀 **For Full Access (Recommended for Testing)**

| Username | Password | Access Level | Use Case |
|----------|----------|--------------|----------|
| **demo** | **demo** | ✅ **Full Access** | **Quick demo/testing** |
| **test** | **test** | ✅ **Full Access** | **Development testing** |
| **alice** | **demo123** | ✅ **Full Access** | **Primary agent owner** |
| **admin** | **admin123** | ✅ **Full Access** | **Administrator account** |

**Full Access means:** Create agents, create usage tokens, view everything

---

## 🏢 **For Enterprise Users**

| Username | Password | Access Level | Use Case |
|----------|----------|--------------|----------|
| **enterprise** | **enterprise123** | 🔶 **Create Tokens** | **Enterprise customer** |
| **company** | **company123** | 🔶 **Create Tokens** | **Company account** |
| **business** | **business123** | 🔶 **Create Tokens** | **Business account** |

**Create Tokens means:** Can create usage licenses, view own data

---

## 👤 **For End Users**

| Username | Password | Access Level | Use Case |
|----------|----------|--------------|----------|
| **user** | **user123** | 🔍 **View Only** | **Regular user** |
| **guest** | **guest123** | 🔍 **View Only** | **Guest account** |
| **bob** | **bob123** | 🔍 **View Only** | **End user example** |

**View Only means:** Can view registry, cannot create anything

---

## 🔗 **API Endpoints**

### **Authentication:**
```
POST http://localhost:8080/auth/login

Body:
{
  "username": "demo",
  "password": "demo"
}
```

### **DAML Blockchain API:**
```
http://localhost:7575
```
*(For external access, you'll need to set up an ngrok tunnel: `ngrok http 7575`)*

---

## 🧪 **Super Quick Test**

**1. Login and get a token:**
```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"demo","password":"demo"}'
```

**2. Use token with DAML API:**
```bash
curl -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  https://27524c709935.ngrok-free.app/readyz
```

**3. View all accounts and their tokens:**
```bash
curl http://localhost:8080/accounts
```

---

## 📱 **For Your Web App**

```javascript
// Simple login
const response = await fetch('http://localhost:8080/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ username: 'demo', password: 'demo' })
});

const { token } = await response.json();

// Use with DAML API
fetch('https://27524c709935.ngrok-free.app/v1/query', {
  headers: { 'Authorization': `Bearer ${token}` }
});
```

---

## ⭐ **Recommendations**

### **For Quick Testing:**
- Use `demo` / `demo` - simplest and fastest

### **For Development:**
- Use `test` / `test` - easy to remember

### **For Demos:**
- Use `alice` / `demo123` - more professional looking

### **For Enterprise Scenarios:**
- Use `enterprise` / `enterprise123` - shows restricted permissions

---

## 🔄 **Token Expiry**

- **All tokens last 180 days** (6 months)
- **No refresh needed** during this period
- **Same username/password always works**

---

## 🎯 **What You Can Do**

### **With Full Access Accounts:**
✅ Create AI agent ownership tokens
✅ Create usage licenses for customers
✅ View complete agent registry
✅ All blockchain operations

### **With Enterprise Accounts:**
✅ Create usage licenses only
✅ View own data
❌ Cannot create new agents

### **With View-Only Accounts:**
✅ View agent registry
❌ Cannot create anything

---

## 🚀 **Ready to Go!**

Just pick any account from the list above and start using the platform immediately. No additional setup required!

**Questions?** Check `http://localhost:8080` for live service info.