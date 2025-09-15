#!/usr/bin/env python3
"""
Test script for FULL DAML Agent Tokenization API
This tests real blockchain contracts vs mock responses
"""

import requests
import json
import time

# Update this URL when your full DAML service is deployed
FULL_DAML_URL = 'https://agent-tokenization-full-daml.onrender.com'
MOCK_API_URL = 'https://agent-tokenization-canton.onrender.com'

def test_api_comparison():
    print('🧪 Testing Full DAML vs Mock API...\n')

    print('1️⃣ Testing Health Check:')

    # Test mock API
    try:
        response = requests.get(f'{MOCK_API_URL}/readyz', timeout=10)
        mock_health = response.json()
        print(f'Mock API: {mock_health}')
    except Exception as e:
        print(f'Mock API Error: {e}')

    # Test full DAML (update URL when deployed)
    try:
        response = requests.get(f'{FULL_DAML_URL}/readyz', timeout=10)
        full_health = response.json()
        print(f'Full DAML: {full_health}')
    except Exception as e:
        print(f'Full DAML: Not deployed yet or error: {e}')

    print('')

    print('2️⃣ Testing Query Ownership Contracts:')

    # Test mock API
    try:
        response = requests.post(f'{MOCK_API_URL}/v1/query',
            headers={'Content-Type': 'application/json'},
            json={'templateIds': ['ComprehensiveV3Test:AIAgentOwnershipToken']},
            timeout=10
        )
        mock_query = response.json()
        print(f'Mock API: {mock_query}')
    except Exception as e:
        print(f'Mock API Error: {e}')

    # Test full DAML
    try:
        response = requests.post(f'{FULL_DAML_URL}/v1/query',
            headers={'Content-Type': 'application/json'},
            json={'templateIds': ['ComprehensiveV3Test:AIAgentOwnershipToken']},
            timeout=10
        )
        full_query = response.json()
        print(f'Full DAML: {full_query}')

        # Check if we got real contracts
        if 'result' in full_query and isinstance(full_query['result'], list):
            if len(full_query['result']) > 0:
                contract = full_query['result'][0]
                if 'contractId' in contract and 'payload' in contract:
                    print('✅ SUCCESS: Real blockchain contracts found!')
                    print(f'   Contract ID: {contract["contractId"]}')
                    if 'agentName' in contract.get('payload', {}):
                        print(f'   Agent Name: {contract["payload"]["agentName"]}')
                else:
                    print('⚠️ WARNING: Response format unexpected')
            else:
                print('⚠️ WARNING: No contracts found (may still be deploying)')
        else:
            print('⚠️ WARNING: No result field found')

    except Exception as e:
        print(f'Full DAML: Not deployed yet or error: {e}')

    print('')

    print('3️⃣ Testing Create Ownership Contract:')

    test_agent_data = {
        'templateId': 'ComprehensiveV3Test:AIAgentOwnershipToken',
        'payload': {
            'agentName': 'TestAgent123',
            'agentDescription': 'Test agent created via API',
            'agentCreator': 'Alice',
            'owner': 'Alice',
            'issuer': 'SystemOrchestrator',
            'totalSupply': '100.0',
            'tokenAmount': '100.0',
            'status': 'Active',
            'version': '1.0.0',
            'attributes': {
                'industry': 'test',
                'created_via': 'api_test'
            },
            'privacyLevel': 'Low'
        }
    }

    # Test full DAML create
    try:
        response = requests.post(f'{FULL_DAML_URL}/v1/create',
            headers={'Content-Type': 'application/json'},
            json=test_agent_data,
            timeout=15
        )
        create_result = response.json()
        print(f'Full DAML Create: {create_result}')

        # Check if we got a real contract ID back
        if 'result' in create_result and 'contractId' in create_result.get('result', {}):
            print('✅ SUCCESS: Real ownership contract created!')
            print(f'   New Contract ID: {create_result["result"]["contractId"]}')
        else:
            print('⚠️ WARNING: Contract creation response unexpected')

    except Exception as e:
        print(f'Full DAML Create: Not deployed yet or error: {e}')

    print('')
    print('🎯 Comparison Summary:')
    print('Mock API: Returns generic "received: true" responses')
    print('Full DAML: Returns real contract IDs and blockchain data')
    print('')
    print('When Full DAML is deployed, you\'ll see:')
    print('• Real contract IDs (not mock responses)')
    print('• Actual agent data in contract payloads')
    print('• Persistent contracts that survive restarts')
    print('• True blockchain immutability and audit trails')

if __name__ == '__main__':
    test_api_comparison()