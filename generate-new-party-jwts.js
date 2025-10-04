const jwt = require('jsonwebtoken');

// JWT secret (same as existing tokens)
const JWT_SECRET = 'daml-agent-tokenization-secret-2024';

// New party IDs created
const NEW_PARTIES = [
  {
    name: 'TechCorp Enterprise',
    id: 'Enterprise_TechCorp::1220adb11431a17d4580a02dac9643c4c61be8afb1c9803cfe08523c5720c519a59b'
  },
  {
    name: 'AI Labs Startup',
    id: 'Startup_AILabs::1220adb11431a17d4580a02dac9643c4c61be8afb1c9803cfe08523c5720c519a59b'
  },
  {
    name: 'Digital Marketing Agency',
    id: 'Agency_DigitalMarketing::1220adb11431a17d4580a02dac9643c4c61be8afb1c9803cfe08523c5720c519a59b'
  },
  {
    name: 'Retail Chain Customer',
    id: 'Customer_RetailChain::1220adb11431a17d4580a02dac9643c4c61be8afb1c9803cfe08523c5720c519a59b'
  },
  {
    name: 'Indie Developer Studio',
    id: 'Developer_IndieStudio::1220adb11431a17d4580a02dac9643c4c61be8afb1c9803cfe08523c5720c519a59b'
  }
];

// Generate JWT tokens (180-day expiry like existing ones)
const generateJWTTokens = () => {
  const now = Math.floor(Date.now() / 1000);
  const expiry = now + (180 * 24 * 60 * 60); // 180 days from now

  console.log('🔑 NEW PARTY JWT TOKENS (180-day expiry)\n');
  console.log('Generated:', new Date().toISOString());
  console.log('Expires:', new Date(expiry * 1000).toISOString());
  console.log('=' * 80, '\n');

  NEW_PARTIES.forEach((party, index) => {
    const payload = {
      "https://daml.com/ledger-api": {
        "ledgerId": "sandbox",
        "applicationId": "agent-tokenization-app",
        "actAs": [party.id],
        "admin": true,
        "readAs": [party.id]
      },
      "sub": party.id.split('::')[0], // Extract party name before ::
      "aud": "https://daml.com/ledger-api",
      "iss": "agent-tokenization-system",
      "exp": expiry,
      "iat": now
    };

    const token = jwt.sign(payload, JWT_SECRET);

    console.log(`## ${index + 1}. ${party.name}`);
    console.log(`**Party ID:** \`${party.id}\``);
    console.log(`**JWT Token:**`);
    console.log(`\`\`\``);
    console.log(token);
    console.log(`\`\`\``);
    console.log('');
  });
};

generateJWTTokens();