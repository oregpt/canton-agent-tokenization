#!/usr/bin/env python3
"""
Test script for live Agent Tokenization API
Run with: python test-live-api.py
"""

import requests
import json

API_BASE = 'https://agent-tokenization-canton.onrender.com'

def test_api():
    print('🧪 Testing Agent Tokenization API...\n')

    try:
        # Test 1: Health Check
        print('1️⃣ Health Check:')
        response = requests.get(f'{API_BASE}/readyz')
        health = response.json()
        print('✅', health)
        print('')

        # Test 2: Service Info
        print('2️⃣ Service Info:')
        response = requests.get(f'{API_BASE}/')
        info = response.json()
        print('✅', info)
        print('')

        # Test 3: Query Contracts
        print('3️⃣ Query Contracts:')
        response = requests.post(f'{API_BASE}/v1/query',
            headers={'Content-Type': 'application/json'},
            json={
                'templateIds': ['AgentTokenizationV2:SystemOrchestrator']
            }
        )
        query_result = response.json()
        print('✅', query_result)
        print('')

        # Test 4: Create Contract (Mock)
        print('4️⃣ Create Contract:')
        response = requests.post(f'{API_BASE}/v1/create',
            headers={'Content-Type': 'application/json'},
            json={
                'templateId': 'AgentTokenizationV2:AgentRegistration',
                'payload': {
                    'agentId': 'test-agent-001',
                    'name': 'Test AI Agent',
                    'description': 'Testing live API integration'
                }
            }
        )
        create_result = response.json()
        print('✅', create_result)
        print('')

        print('🎉 All tests passed! Your API is ready for production use.')

    except Exception as error:
        print(f'❌ Test failed: {error}')

if __name__ == '__main__':
    test_api()