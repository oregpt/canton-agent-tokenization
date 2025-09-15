#!/usr/bin/env python3
"""
Simple deployment test for Full DAML API
"""

import requests
import json

# URLs to test
FULL_DAML_URL = 'https://canton-agent-tokenization-full.onrender.com'

def test_deployment():
    print('Testing Full DAML deployment...')

    # Test health check
    print('\n1. Health Check:')
    try:
        response = requests.get(f'{FULL_DAML_URL}/readyz', timeout=10)
        print(f'Status: {response.status_code}')
        print(f'Response: {response.text}')
    except Exception as e:
        print(f'Health check error: {e}')

    # Test query
    print('\n2. Query Ownership Contracts:')
    try:
        response = requests.post(f'{FULL_DAML_URL}/v1/query',
            headers={'Content-Type': 'application/json'},
            json={'templateIds': ['ComprehensiveV3Test:AIAgentOwnershipToken']},
            timeout=10
        )
        print(f'Status: {response.status_code}')
        print(f'Response: {response.text}')
    except Exception as e:
        print(f'Query error: {e}')

    # Test create contract
    print('\n3. Create Ownership Contract:')
    test_data = {
        'templateId': 'ComprehensiveV3Test:AIAgentOwnershipToken',
        'payload': {
            'agentName': 'TestAgent123',
            'agentDescription': 'Test agent via API',
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

    try:
        response = requests.post(f'{FULL_DAML_URL}/v1/create',
            headers={'Content-Type': 'application/json'},
            json=test_data,
            timeout=15
        )
        print(f'Status: {response.status_code}')
        print(f'Response: {response.text}')
    except Exception as e:
        print(f'Create error: {e}')

if __name__ == '__main__':
    test_deployment()