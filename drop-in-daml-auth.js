// 🚀 Drop-in DAML Authentication for Your Existing Frontend
// Just include this file and map your existing user roles to DAML permissions

class DamlAuthBridge {
  constructor(config = {}) {
    this.damlApiUrl = config.damlApiUrl || 'http://localhost:7575';

    // Pre-generated DAML tokens (180-day expiry)
    this.tokens = {
      // Full access - can create agents and usage tokens
      admin: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJBbGljZSJdLCJhZG1pbiI6dHJ1ZSwicmVhZEFzIjpbIkFsaWNlIl19LCJzdWIiOiJBbGljZSIsImF1ZCI6Imh0dHBzOi8vZGFtbC5jb20vbGVkZ2VyLWFwaSIsImlzcyI6ImFnZW50LXRva2VuaXphdGlvbi1zeXN0ZW0iLCJ1c2VySWQiOiJhbGljZSIsInJvbGUiOiJhZ2VudF9vd25lciIsInBlcm1pc3Npb25zIjpbImNyZWF0ZV9hZ2VudHMiLCJjcmVhdGVfdXNhZ2VfdG9rZW5zIiwidmlld19hbGwiXSwiaWF0IjoxNzU4MDYwNzU1LCJleHAiOjE3NzM2MTI3NTV9.8hV4fs36H73ZOEpCGNxJ0W7z2kUDU8JK7CqO8tZGNuI",

      // Enterprise access - can create usage tokens only
      enterprise: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJFbnRlcnByaXNlIl0sImFkbWluIjpmYWxzZSwicmVhZEFzIjpbIkVudGVycHJpc2UiXX0sInN1YiI6IkVudGVycHJpc2UiLCJhdWQiOiJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiLCJpc3MiOiJhZ2VudC10b2tlbml6YXRpb24tc3lzdGVtIiwidXNlcklkIjoiZW50ZXJwcmlzZSIsInJvbGUiOiJlbnRlcnByaXNlIiwicGVybWlzc2lvbnMiOlsiY3JlYXRlX3VzYWdlX3Rva2VucyIsInZpZXdfb3duIl0sImlhdCI6MTc1ODA2MDc1NSwiZXhwIjoxNzczNjEyNzU1fQ.nZZvW_7tGE6aVWgpX6Pu8E6iHJKlMzWNg8mGRIGGKek",

      // View only access
      basic: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiOnsibGVkZ2VySWQiOiJzYW5kYm94IiwiYXBwbGljYXRpb25JZCI6ImFnZW50LXRva2VuaXphdGlvbi1hcHAiLCJhY3RBcyI6WyJCb2IiXSwiYWRtaW4iOmZhbHNlLCJyZWFkQXMiOlsiQm9iIl19LCJzdWIiOiJCb2IiLCJhdWQiOiJodHRwczovL2RhbWwuY29tL2xlZGdlci1hcGkiLCJpc3MiOiJhZ2VudC10b2tlbml6YXRpb24tc3lzdGVtIiwidXNlcklkIjoidXNlciIsInJvbGUiOiJjb25zdW1lciIsInBlcm1pc3Npb25zIjpbInZpZXdfb3duIl0sImlhdCI6MTc1ODA2MDc1NSwiZXhwIjoxNzczNjEyNzU1fQ.q1LX3JRRl3-ZPmWnKv8oWHY82Z0KSLsOY3bA9-o5m8Q"
    };

    // Map your app's user roles to DAML access levels
    this.roleMapping = config.roleMapping || {
      // Your role → DAML access level
      'admin': 'admin',
      'owner': 'admin',
      'moderator': 'admin',
      'premium': 'enterprise',
      'pro': 'enterprise',
      'enterprise': 'enterprise',
      'paid': 'enterprise',
      'business': 'enterprise',
      'basic': 'basic',
      'free': 'basic',
      'user': 'basic',
      'guest': 'basic'
    };

    // How to get current user from your app (customize this)
    this.getCurrentUser = config.getCurrentUser || (() => {
      // Default: try common patterns
      if (window.currentUser) return window.currentUser;
      if (window.user) return window.user;

      // Try localStorage
      const stored = localStorage.getItem('user') || localStorage.getItem('currentUser');
      if (stored) return JSON.parse(stored);

      // Try global state (Redux, Vuex, etc.)
      if (window.__app__ && window.__app__.user) return window.__app__.user;

      return null;
    });
  }

  // Get DAML token for current user
  getDamlToken() {
    const user = this.getCurrentUser();
    if (!user) {
      console.warn('No user found - using basic access');
      return this.tokens.basic;
    }

    // Determine access level based on user properties
    let accessLevel = 'basic'; // default

    // Check various user properties to determine access
    if (user.role) {
      accessLevel = this.roleMapping[user.role.toLowerCase()] || 'basic';
    } else if (user.isAdmin || user.admin) {
      accessLevel = 'admin';
    } else if (user.isPremium || user.premium || user.subscription === 'pro') {
      accessLevel = 'enterprise';
    } else if (user.subscription && user.subscription !== 'free') {
      accessLevel = 'enterprise';
    }

    return this.tokens[accessLevel];
  }

  // Check what permissions current user has
  getUserPermissions() {
    const token = this.getDamlToken();

    if (token === this.tokens.admin) {
      return ['create_agents', 'create_usage_tokens', 'view_all'];
    } else if (token === this.tokens.enterprise) {
      return ['create_usage_tokens', 'view_own'];
    } else {
      return ['view_own'];
    }
  }

  // Check if user can perform specific action
  canUserPerform(action) {
    const permissions = this.getUserPermissions();
    return permissions.includes(action);
  }

  // Make authenticated DAML API call
  async damlRequest(endpoint, options = {}) {
    const token = this.getDamlToken();

    return fetch(`${this.damlApiUrl}${endpoint}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
        ...options.headers
      }
    });
  }

  // High-level DAML operations
  async viewAgentRegistry() {
    return this.damlRequest('/v1/query', {
      method: 'POST',
      body: JSON.stringify({
        templateIds: ["671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentRegistration"]
      })
    });
  }

  async createAgent(agentData) {
    if (!this.canUserPerform('create_agents')) {
      throw new Error('User does not have permission to create agents');
    }

    return this.damlRequest('/v1/create', {
      method: 'POST',
      body: JSON.stringify({
        templateId: "671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentRegistration",
        argument: {
          operator: "Alice", // This would be dynamic based on user
          agentId: agentData.id || `agent-${Date.now()}`,
          name: agentData.name,
          description: agentData.description,
          agentType: agentData.type || "LLM",
          capabilities: agentData.capabilities || [],
          attributes: agentData.attributes || {},
          isActive: true
        }
      })
    });
  }

  async createUsageToken(agentId, usageData) {
    if (!this.canUserPerform('create_usage_tokens')) {
      throw new Error('User does not have permission to create usage tokens');
    }

    return this.damlRequest('/v1/create', {
      method: 'POST',
      body: JSON.stringify({
        templateId: "671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentUsageToken",
        argument: {
          operator: this.getUserDamlParty(),
          agentId: agentId,
          tokenId: `usage-${Date.now()}`,
          usageType: usageData.type,
          maxUsage: usageData.maxUsage,
          currentUsage: 0,
          metadata: usageData.metadata || {},
          isActive: true
        }
      })
    });
  }

  getUserDamlParty() {
    const permissions = this.getUserPermissions();
    if (permissions.includes('create_agents')) return 'Alice';
    if (permissions.includes('create_usage_tokens')) return 'Enterprise';
    return 'Bob';
  }

  // Debug info
  getDebugInfo() {
    const user = this.getCurrentUser();
    const permissions = this.getUserPermissions();
    const party = this.getUserDamlParty();

    return {
      user: user,
      damlParty: party,
      permissions: permissions,
      canCreateAgents: this.canUserPerform('create_agents'),
      canCreateTokens: this.canUserPerform('create_usage_tokens'),
      canViewAll: this.canUserPerform('view_all')
    };
  }
}

// 🚀 Usage Examples:

// Basic setup - auto-detects your user
const daml = new DamlAuthBridge();

// Custom setup
const daml = new DamlAuthBridge({
  damlApiUrl: 'https://your-ngrok-url.ngrok-free.app', // For external access
  getCurrentUser: () => window.myApp.currentUser, // Your custom user getter
  roleMapping: {
    'superadmin': 'admin',
    'vip': 'enterprise',
    'member': 'basic'
  }
});

// Use in your app
async function showAgentDashboard() {
  try {
    // Check permissions
    if (!daml.canUserPerform('view_own')) {
      alert('You need to be logged in to view agents');
      return;
    }

    // Get agents
    const response = await daml.viewAgentRegistry();
    const agents = await response.json();

    // Show in your UI
    displayAgents(agents.result);

    // Show what user can do
    console.log('User permissions:', daml.getDebugInfo());

  } catch (error) {
    console.error('Error:', error);
  }
}

// Create agent (only for admin users)
async function createNewAgent(agentData) {
  try {
    const response = await daml.createAgent(agentData);
    const result = await response.json();

    if (response.ok) {
      alert('Agent created successfully!');
      showAgentDashboard(); // Refresh
    } else {
      alert('Error: ' + result.errors[0]);
    }
  } catch (error) {
    alert('Error: ' + error.message);
  }
}

// Auto-expose to global scope for easy access
if (typeof window !== 'undefined') {
  window.DamlAuth = DamlAuthBridge;
  window.daml = new DamlAuthBridge();
}

// Export for modules
if (typeof module !== 'undefined' && module.exports) {
  module.exports = DamlAuthBridge;
}