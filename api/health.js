// Vercel serverless function - health check endpoint
module.exports = (req, res) => {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  const response = {
    status: 'ready',
    service: 'Agent Tokenization API',
    healthy: true,
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  };

  res.status(200).json(response);
};