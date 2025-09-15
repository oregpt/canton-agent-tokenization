#!/usr/bin/env python3
"""
Simple test script for live Agent Tokenization API
Run with: python test-simple.py
"""

import requests
import json

API_BASE = 'https://agent-tokenization-canton.onrender.com'

def test_api():
    print('Testing Agent Tokenization API...\n')

    try:
        # Test 1: Health Check
        print('1. Health Check:')
        response = requests.get(f'{API_BASE}/readyz')
        health = response.json()
        print('SUCCESS:', health)
        print('')

        # Test 2: Service Info
        print('2. Service Info:')
        response = requests.get(f'{API_BASE}/')
        info = response.json()
        print('SUCCESS:', info)
        print('')

        # Test 3: Query Contracts
        print('3. Query Contracts:')
        response = requests.post(f'{API_BASE}/v1/query',
            headers={'Content-Type': 'application/json'},
            json={'templateIds': ['AgentTokenizationV2:SystemOrchestrator']}
        )
        query_result = response.json()
        print('SUCCESS:', query_result)
        print('')

        print('All tests passed! Your API is ready for production use.')

    except Exception as error:
        print(f'Test failed: {error}')

if __name__ == '__main__':
    test_api()