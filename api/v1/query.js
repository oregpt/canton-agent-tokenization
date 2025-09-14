// Vercel serverless function - query endpoint
export default function handler(req, res) {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  let response;

  if (req.method === 'GET') {
    response = {
      result: [],
      status: 'ok',
      message: 'Query endpoint ready'
    };
  } else if (req.method === 'POST') {
    response = {
      result: {
        received: true,
        query: req.body || {},
        status: 'processed'
      },
      status: 'ok',
      message: 'Query processed successfully'
    };
  } else {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  res.status(200).json(response);
}