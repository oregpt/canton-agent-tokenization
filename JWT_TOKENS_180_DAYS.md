# 🔑 JWT Tokens for Agent Tokenization API

**Valid for 180 days - Expires: March 15, 2026**

---

## 📋 **Authentication Tokens**

### **🎯 Alice Token (Agent Owner - Recommended)**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJhZ2VudC10b2tlbml6YXRpb24tbGVkZ2VyIiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJBbGljZSJdLCJhZG1pbiI6dHJ1ZSwicmVhZEFzIjpbIkFsaWNlIl19LCJzdWIiOiJBbGljZSIsImF1ZCI6Imh0dHBzOi8vZGFtbC5jb20vbGVkZ2VyLWFwaSIsImlzcyI6ImFnZW50LXRva2VuaXphdGlvbi1zeXN0ZW0iLCJleHAiOjE3NzM1ODQ5OTksImlhdCI6MTc1ODAzMjk5OX0.FcCjPha-xkZyke8skDyez39ET0eguEqiJ41MomblyxY
```

### **🏢 SystemOrchestrator Token (Admin Access)**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJhZ2VudC10b2tlbml6YXRpb24tbGVkZ2VyIiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJTeXN0ZW1PcmNoZXN0cmF0b3IiXSwiYWRtaW4iOnRydWUsInJlYWRBcyI6WyJTeXN0ZW1PcmNoZXN0cmF0b3IiXX0sInN1YiI6IlN5c3RlbU9yY2hlc3RyYXRvciIsImF1ZCI6Imh0dHBzOi8vZGFtbC5jb20vbGVkZ2VyLWFwaSIsImlzcyI6ImFnZW50LXRva2VuaXphdGlvbi1zeXN0ZW0iLCJleHAiOjE3NzM1ODQ5OTksImlhdCI6MTc1ODAzMjk5OX0.zEtQlasFFLgmQ57kvTz7wcsTtFfHCX7qAVJGntIWvVo
```

### **👤 Bob Token (End User)**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJhZ2VudC10b2tlbml6YXRpb24tbGVkZ2VyIiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJCb2IiXSwiYWRtaW4iOnRydWUsInJlYWRBcyI6WyJCb2IiXX0sInN1YiI6IkJvYiIsImF1ZCI6Imh0dHBzOi0vZGFtbC5jb20vbGVkZ2VyLWFwaSIsImlzcyI6ImFnZW50LXRva2VuaXphdGlvbi1zeXN0ZW0iLCJleHAiOjE3NzM1ODQ5OTksImlhdCI6MTc1ODAzMjk5OX0.1EkaxNSpUgFoVpB4JhL2ex8daLPYe7MH9Oih0HZkfY0
```

### **🏢 Enterprise Token (Enterprise User)**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJhZ2VudC10b2tlbml6YXRpb24tbGVkZ2VyIiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJFbnRlcnByaXNlIl0sImFkbWluIjp0cnVlLCJyZWFkQXMiOlsiRW50ZXJwcmlzZSJdfSwic3ViIjoiRW50ZXJwcmlzZSIsImF1ZCI6Imh0dHBzOi8vZGFtbC5jb20vbGVkZ2VyLWFwaSIsImlzcyI6ImFnZW50LXRva2VuaXphdGlvbi1zeXN0ZW0iLCJleHAiOjE3NzM1ODQ5OTksImlhdCI6MTc1ODAzMjk5OX0.Bk46hAkSywfW7_00IPe2Ga8DH19kdZ_0QFJFD5F5Kvo
```

---

## 🌐 **API Endpoint**
```
Base URL: https://27524c709935.ngrok-free.app
```

## 🧪 **Test Your Integration**

Use this curl command to verify the token works:

```bash
curl -X POST https://27524c709935.ngrok-free.app/v1/query \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJhZ2VudC10b2tlbml6YXRpb24tbGVkZ2VyIiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJBbGljZSJdLCJhZG1pbiI6dHJ1ZSwicmVhZEFzIjpbIkFsaWNlIl19LCJzdWIiOiJBbGljZSIsImF1ZCI6Imh0dHBzOi0vZGFtbC5jb20vbGVkZ2VyLWFwaSIsImlzcyI6ImFnZW50LXRva2VuaXphdGlvbi1zeXN0ZW0iLCJleHAiOjE3NzM1ODQ5OTksImlhdCI6MTc1ODAzMjk5OX0.FcCjPha-xkZyke8skDyez39ET0eguEqiJ41MomblyxY" \
  -d '{"templateIds": ["AgentTokenizationV2:AgentRegistration"]}'
```

## 📋 **Token Details**

- **Expiry**: 180 days (March 15, 2026)
- **Algorithm**: HS256
- **Secret**: `daml-agent-tokenization-secret-2024`
- **Permissions**: Full admin access to all operations
- **Scope**: Complete access to Agent Tokenization contracts

## 🎯 **Recommended Usage**

**For most integrations, use the Alice token** - it has the right permissions for:
- Creating ownership tokens
- Creating usage tokens
- Querying all agent data
- Managing token lifecycle

## 🚀 **Ready for Integration**

These tokens provide full access to your real DAML blockchain with:
- ✅ Immediate transaction processing
- ✅ Real contract storage in PostgreSQL
- ✅ Multi-party privacy controls
- ✅ Smart contract business logic
- ✅ Complete audit trails

**Start building with real blockchain contracts now!** 🎉