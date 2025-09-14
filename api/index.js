// Vercel serverless function - main API endpoint
export default function handler(req, res) {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  const response = {
    service: 'Agent Tokenization Platform',
    status: 'ready',
    version: 'v3.0.0',
    timestamp: new Date().toISOString(),
    deployment: 'vercel',
    message: 'Agent Tokenization API is running on Vercel'
  };

  res.status(200).json(response);
}