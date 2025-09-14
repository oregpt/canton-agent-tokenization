# 🚀 Native Java Deployment Guide

## Manual Deployment Steps

Since render.yaml blueprint is having validation issues, here's how to deploy manually:

### Step 1: Create PostgreSQL Database
1. **Render Dashboard** → **New +** → **PostgreSQL**
2. **Name**: `agent-tokenization-db`
3. **Plan**: Starter ($7/month)
4. **Create Database**
5. **Note the connection details** (you'll need them)

### Step 2: Create Web Service
1. **Render Dashboard** → **New +** → **Web Service**
2. **Connect GitHub** → Select `CantonAgentTokenization` repo
3. **Configure**:
   - **Name**: `agent-tokenization-api`
   - **Runtime**: `Node`
   - **Build Command**: `chmod +x build.sh && ./build.sh`
   - **Start Command**: `chmod +x start.sh && ./start.sh`
   - **Plan**: Starter ($7/month)

### Step 3: Environment Variables
Add these in the web service settings:
```
PORT=8080
DATABASE_URL=[paste your database connection string]
DATABASE_HOST=[paste your database host]
DATABASE_PORT=5432
DATABASE_NAME=postgres
DATABASE_USER=postgres
DATABASE_PASSWORD=[paste your database password]
```

### Step 4: Deploy
Click **Create Web Service** and wait for deployment.

## What Happens
1. **Build**: Installs Java + DAML SDK, builds DAR files
2. **Start**: Runs DAML Sandbox + JSON API on port 8080
3. **Result**: Your API is available at `https://your-service-name.onrender.com`

## Alternative: Docker Deployment
If you prefer, you can also:
1. Set **Runtime**: `Docker`
2. **Build Command**: `docker build -t agent-tokenization .`
3. **Start Command**: `/app/start.sh`

This uses our existing Dockerfile (which should work now with the latest fixes).