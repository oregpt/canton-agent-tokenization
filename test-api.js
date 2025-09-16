// Test script to find correct template IDs for Agent Tokenization
const fetch = require('node-fetch');

const API_BASE = 'http://localhost:7575';
const ALICE_TOKEN = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJBbGljZSJdLCJhZG1pbiI6dHJ1ZSwicmVhZEFzIjpbIkFsaWNlIl19LCJzdWIiOiJBbGljZSIsImF1ZCI6Imh0dHBzOi8vZGFtbC5jb20vbGVkZ2VyLWFwaSIsImlzcyI6ImFnZW50LXRva2VuaXphdGlvbi1zeXN0ZW0iLCJleHAiOjE3NzM1ODg0NzEsImlhdCI6MTc1ODAzNjQ3MX0.q6AKXC_wmN6QKCME21XlH_3wWuQo6PN0gt48Za8F4mE';

const headers = {
  'Content-Type': 'application/json',
  'Authorization': `Bearer ${ALICE_TOKEN}`
};

async function testAPI() {
  console.log('🧪 Testing DAML Agent Tokenization API\n');

  // 1. Health check
  console.log('1️⃣ Health Check...');
  try {
    const health = await fetch(`${API_BASE}/readyz`);
    console.log(`✅ Health: ${health.status} ${health.statusText}\n`);
  } catch (error) {
    console.log(`❌ Health check failed: ${error.message}\n`);
    return;
  }

  // 2. Get package list
  console.log('2️⃣ Getting packages...');
  try {
    const packages = await fetch(`${API_BASE}/v1/packages`, { headers });
    const packageData = await packages.json();

    if (packageData.result) {
      console.log(`✅ Found ${packageData.result.length} packages`);
      console.log('📦 Last few packages (likely our custom packages):');
      packageData.result.slice(-3).forEach((pkg, i) => {
        console.log(`   ${packageData.result.length - 3 + i + 1}. ${pkg}`);
      });

      // Try different template ID formats with the last package
      const lastPackage = packageData.result[packageData.result.length - 1];
      console.log(`\n3️⃣ Testing template formats with package: ${lastPackage.substring(0, 16)}...`);

      const templateFormats = [
        `${lastPackage}:AgentTokenizationV2:AgentRegistration`,
        `${lastPackage}:AgentTokenizationV2:AgentUsageToken`,
        `${lastPackage}:Main:AgentRegistration`,
        `${lastPackage}:Main:AgentUsageToken`
      ];

      for (const templateId of templateFormats) {
        console.log(`\n🔍 Trying: ${templateId.substring(0, 50)}...`);
        try {
          const query = await fetch(`${API_BASE}/v1/query`, {
            method: 'POST',
            headers,
            body: JSON.stringify({ templateIds: [templateId] })
          });

          const result = await query.json();

          if (query.status === 200 && result.result) {
            console.log(`✅ SUCCESS! Found contracts: ${result.result.length}`);
            if (result.result.length > 0) {
              console.log(`📄 Sample contract: ${JSON.stringify(result.result[0], null, 2).substring(0, 200)}...`);
            }
          } else {
            console.log(`❌ Failed: ${result.errors ? result.errors[0] : 'Unknown error'}`);
          }
        } catch (error) {
          console.log(`❌ Error: ${error.message}`);
        }
      }
    } else {
      console.log(`❌ Package request failed: ${JSON.stringify(packageData)}`);
    }
  } catch (error) {
    console.log(`❌ Package list failed: ${error.message}`);
  }
}

testAPI().catch(console.error);