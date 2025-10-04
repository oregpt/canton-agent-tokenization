#!/usr/bin/env python3
"""
Test script to verify Railway deployment of Canton Agent Tokenization
"""

import requests
import time
import json

RAILWAY_URL = "https://canton-agent-tokenization-production.up.railway.app"

def test_health_endpoint():
    """Test the health endpoint"""
    print("🏥 Testing health endpoint...")
    try:
        response = requests.get(f"{RAILWAY_URL}/readyz", timeout=10)
        if response.status_code == 200:
            print("✅ Health check passed!")
            return True
        else:
            print(f"❌ Health check failed with status {response.status_code}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"❌ Health check failed: {e}")
        return False

def test_packages_endpoint():
    """Test the packages endpoint"""
    print("📦 Testing packages endpoint...")
    try:
        response = requests.get(f"{RAILWAY_URL}/v1/packages", timeout=10)
        if response.status_code == 200:
            packages = response.json()
            print(f"✅ Packages endpoint working! Found {len(packages)} packages")
            return True
        else:
            print(f"❌ Packages endpoint failed with status {response.status_code}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"❌ Packages endpoint failed: {e}")
        return False

def test_port_variations():
    """Test different port configurations"""
    ports_to_test = ["", ":7575", ":80", ":443"]

    for port in ports_to_test:
        url = f"{RAILWAY_URL}{port}"
        print(f"🔍 Testing URL: {url}")
        try:
            response = requests.get(f"{url}/readyz", timeout=5)
            if response.status_code == 200:
                print(f"✅ Found working endpoint: {url}")
                return url
        except:
            pass

    print("❌ No working endpoints found")
    return None

def main():
    print("🚀 Testing Railway Deployment of Canton Agent Tokenization")
    print("=" * 60)

    # Wait a bit for the deployment to be ready
    print("⏳ Waiting 30 seconds for deployment to be ready...")
    time.sleep(30)

    # Test different port configurations
    working_url = test_port_variations()

    if working_url:
        print(f"\n🎯 Found working URL: {working_url}")
        print("🔄 Running comprehensive tests...")

        # Update the global URL for further tests
        global RAILWAY_URL
        RAILWAY_URL = working_url

        # Run tests
        health_ok = test_health_endpoint()
        packages_ok = test_packages_endpoint()

        if health_ok and packages_ok:
            print("\n🎉 Railway deployment is working perfectly!")
            print(f"🌐 Your production URL is: {RAILWAY_URL}")
            print("\n📋 Next steps:")
            print("1. Update your frontend to use this URL")
            print("2. Test agent registration and token creation")
            print("3. Verify all 7 business wallets are accessible")
        else:
            print("\n⚠️  Deployment partially working - some endpoints failed")
    else:
        print("\n❌ Railway deployment not yet ready or has issues")
        print("💡 Suggestions:")
        print("1. Check Railway logs for errors")
        print("2. Verify the build completed successfully")
        print("3. Wait a few more minutes and run this test again")

if __name__ == "__main__":
    main()