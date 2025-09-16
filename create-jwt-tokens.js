// Simple JWT token generator for DAML parties
const jwt = require('jsonwebtoken');

// Secret key (use a strong secret in production)
const SECRET = 'daml-agent-tokenization-secret-2024';

// Create tokens for each party
const parties = ['SystemOrchestrator', 'Alice', 'Bob', 'Enterprise'];

console.log('🔐 DAML JWT Tokens for Agent Tokenization\n');

parties.forEach(party => {
  const payload = {
    "https://daml.com/ledger-api": {
      "ledgerId": "agent-tokenization-ledger",
      "applicationId": "agent-tokenization-app",
      "actAs": [party],
      "admin": true,
      "readAs": [party]
    },
    "sub": party,
    "aud": "https://daml.com/ledger-api",
    "iss": "agent-tokenization-system",
    "exp": Math.floor(Date.now() / 1000) + (60 * 60 * 24 * 30) // 30 days
  };

  const token = jwt.sign(payload, SECRET, { algorithm: 'HS256' });

  console.log(`📝 ${party}:`);
  console.log(`Bearer ${token}`);
  console.log('');
});

console.log('💡 Usage in your frontend:');
console.log(`
const headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer <TOKEN_FROM_ABOVE>'
};
`);