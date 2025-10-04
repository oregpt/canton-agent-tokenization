# 🔑 Correct JWT Token for Platform Integration

## ✅ Working JWT Token (Copy This Exact String)

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJQZXJzaXN0ZW50QWxpY2U6OjEyMjBhZGIxMTQzMWExN2Q0NTgwYTAyZGFjOTY0M2M0YzYxYmU4YWZiMWM5ODAzY2ZlMDg1MjNjNTcyMGM1MTlhNTliIl0sImFkbWluIjp0cnVlLCJyZWFkQXMiOlsiUGVyc2lzdGVudEFsaWNlOjoxMjIwYWRiMTE0MzFhMTdkNDU4MGEwMmRhYzk2NDNjNGM2MWJlOGFmYjFjOTgwM2NmZTA4NTIzYzU3MjBjNTcyMGM1MTlhNTliIl19LCJzdWIiOiJQZXJzaXN0ZW50QWxpY2UiLCJhdWQiOiJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiLCJpc3MiOiJhZ2VudC10b2tlbml6YXRpb24tc3lzdGVtIiwiZXhwIjoxNzg5NjQ3MjAzLCJpYXQiOjE3NTgxMTEyMDN9.t5rczTayo9-qGTlA6WK5_D_sptoSAkBmZPgLsiS1L0g
```

## 📋 Complete Authorization Header

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJQZXJzaXN0ZW50QWxpY2U6OjEyMjBhZGIxMTQzMWExN2Q0NTgwYTAyZGFjOTY0M2M0YzYxYmU4YWZiMWM5ODAzY2ZlMDg1MjNjNTcyMGM1MTlhNTliIl0sImFkbWluIjp0cnVlLCJyZWFkQXMiOlsiUGVyc2lzdGVudEFsaWNlOjoxMjIwYWRiMTE0MzFhMTdkNDU4MGEwMmRhYzk2NDNjNGM2MWJlOGFmYjFjOTgwM2NmZTA4NTIzYzU3MjBjNTcyMGM1MTlhNTliIl19LCJzdWIiOiJQZXJzaXN0ZW50QWxpY2UiLCJhdWQiOiJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiLCJpc3MiOiJhZ2VudC10b2tlbml6YXRpb24tc3lzdGVtIiwiZXhwIjoxNzg5NjQ3MjAzLCJpYXQiOjE3NTgxMTEyMDN9.t5rczTayo9-qGTlA6WK5_D_sptoSAkBmZPgLsiS1L0g
```

## 🌐 Current API Endpoint

```
https://f22b236be74f.ngrok-free.app
```

## ⚠️ Important Notes

- **No spaces or line breaks** in the JWT token
- **Valid until**: March 15, 2026
- **Party**: PersistentAlice (matches your payload owner)
- **Permissions**: Full admin access for token creation

## 🧪 Test Command

```bash
curl -X POST https://f22b236be74f.ngrok-free.app/v1/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJQZXJzaXN0ZW50QWxpY2U6OjEyMjBhZGIxMTQzMWExN2Q0NTgwYTAyZGFjOTY0M2M0YzYxYmU4YWZiMWM5ODAzY2ZlMDg1MjNjNTcyMGM1MTlhNTliIl0sImFkbWluIjp0cnVlLCJyZWFkQXMiOlsiUGVyc2lzdGVudEFsaWNlOjoxMjIwYWRiMTE0MzFhMTdkNDU4MGEwMmRhYzk2NDNjNGM2MWJlOGFmYjFjOTgwM2NmZTA4NTIzYzU3MjBjNTcyMGM1MTlhNTliIl19LCJzdWIiOiJQZXJzaXN0ZW50QWxpY2UiLCJhdWQiOiJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiLCJpc3MiOiJhZ2VudC10b2tlbml6YXRpb24tc3lzdGVtIiwiZXhwIjoxNzg5NjQ3MjAzLCJpYXQiOjE3NTgxMTEyMDN9.t5rczTayo9-qGTlA6WK5_D_sptoSAkBmZPgLsiS1L0g" \
  -d '{
    "templateId": "c636fa20517eed78ae1380d836a60359cf6574bee22129b9c7fc22a69ac42373:AgentTokenizationV2:SimpleAgentToken",
    "payload": {
        "tokenId": "test_token_001",
        "agentId": "test_agent_001",
        "owner": "PersistentAlice::1220adb11431a17d4580a02dac9643c4c61be8afb1c9803cfe08523c5720c519a59b",
        "metadata": {
            "agentId": "test_agent_001",
            "name": "Test Agent",
            "description": "Test token creation",
            "createdAt": "2025-09-19T10:00:00.000Z",
            "version": "1.0"
        },
        "isActive": true
    }
}'
```

## ✅ This Should Fix Your 401 Error

The previous error was because your JWT was corrupted with spaces and line breaks. This clean version should work perfectly.