// Generate JWT tokens with 180-day expiry for Agent Tokenization
const jwt = require('jsonwebtoken');

// Secret key (use a strong secret in production)
const SECRET = 'daml-agent-tokenization-secret-2024';

// Create tokens for each party with 180 days expiry
const parties = ['SystemOrchestrator', 'Alice', 'Bob', 'Enterprise'];

console.log('🔐 DAML JWT Tokens for Agent Tokenization (180 Days Valid)\n');

parties.forEach(party => {
  const payload = {
    "https://daml.com/ledger-api": {
      "ledgerId": "sandbox",
      "applicationId": "agent-tokenization-app",
      "actAs": [party],
      "admin": true,
      "readAs": [party]
    },
    "sub": party,
    "aud": "https://daml.com/ledger-api",
    "iss": "agent-tokenization-system",
    "exp": Math.floor(Date.now() / 1000) + (60 * 60 * 24 * 180) // 180 days
  };

  const token = jwt.sign(payload, SECRET, { algorithm: 'HS256' });

  console.log(`📝 ${party}:`);
  console.log(`${token}`);
  console.log('');
});

console.log('💡 Expiry: 180 days from now');
console.log('💡 Valid until:', new Date(Date.now() + (60 * 60 * 24 * 180 * 1000)).toISOString());