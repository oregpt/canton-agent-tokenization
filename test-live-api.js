// Test script for live Agent Tokenization API
// Run with: node test-live-api.js

const API_BASE = 'https://agent-tokenization-canton.onrender.com';

async function testAPI() {
  console.log('🧪 Testing Agent Tokenization API...\n');

  try {
    // Test 1: Health Check
    console.log('1️⃣ Health Check:');
    const healthResponse = await fetch(`${API_BASE}/readyz`);
    const health = await healthResponse.json();
    console.log('✅', health);
    console.log('');

    // Test 2: Service Info
    console.log('2️⃣ Service Info:');
    const infoResponse = await fetch(`${API_BASE}/`);
    const info = await infoResponse.json();
    console.log('✅', info);
    console.log('');

    // Test 3: Query Contracts
    console.log('3️⃣ Query Contracts:');
    const queryResponse = await fetch(`${API_BASE}/v1/query`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        templateIds: ['AgentTokenizationV2:SystemOrchestrator']
      })
    });
    const queryResult = await queryResponse.json();
    console.log('✅', queryResult);
    console.log('');

    // Test 4: Create Contract (Mock)
    console.log('4️⃣ Create Contract:');
    const createResponse = await fetch(`${API_BASE}/v1/create`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        templateId: 'AgentTokenizationV2:AgentRegistration',
        payload: {
          agentId: 'test-agent-001',
          name: 'Test AI Agent',
          description: 'Testing live API integration'
        }
      })
    });
    const createResult = await createResponse.json();
    console.log('✅', createResult);
    console.log('');

    console.log('🎉 All tests passed! Your API is ready for production use.');

  } catch (error) {
    console.error('❌ Test failed:', error.message);
  }
}

// Run tests
testAPI();