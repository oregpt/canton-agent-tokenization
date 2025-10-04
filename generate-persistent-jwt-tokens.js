const jwt = require('jsonwebtoken');

// Use persistent party IDs allocated via JSON API
const persistentParties = [
  'PersistentAlice::1220adb11431a17d4580a02dac9643c4c61be8afb1c9803cfe08523c5720c519a59b',
  'PersistentBob::1220adb11431a17d4580a02dac9643c4c61be8afb1c9803cfe08523c5720c519a59b'
];

const secretKey = 'development-secret-key-not-for-production';

console.log('🔑 Generating JWT Tokens for Persistent Parties\n');

persistentParties.forEach((party, index) => {
  const partyName = party.split('::')[0];

  const payload = {
    "https://daml.com/ledger-api": {
      "ledgerId": "sandbox",
      "applicationId": "agent-tokenization-app",
      "actAs": [party],
      "admin": true,
      "readAs": [party]
    },
    "sub": partyName,
    "aud": "https://daml.com/ledger-api",
    "iss": "agent-tokenization-system",
    "exp": Math.floor(Date.now() / 1000) + (365 * 24 * 60 * 60), // 1 year
    "iat": Math.floor(Date.now() / 1000)
  };

  const token = jwt.sign(payload, secretKey, { algorithm: 'HS256' });

  console.log(`=== ${partyName.toUpperCase()} TOKEN ===`);
  console.log(`Party ID: ${party}`);
  console.log(`JWT Token: ${token}`);
  console.log('');
});

console.log('✅ All JWT tokens generated successfully!');
console.log('📋 Ready for JSON API create operations with persistent parties');