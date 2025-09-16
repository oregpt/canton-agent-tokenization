// Frontend SDK for Agent Tokenization with Auto-Authentication
class AgentTokenizationClient {
  constructor(config = {}) {
    this.authBaseUrl = config.authBaseUrl || 'http://localhost:8080';
    this.damlBaseUrl = config.damlBaseUrl || 'http://localhost:7575';
    this.token = null;
    this.tokenExpiry = null;
    this.user = null;
    this.refreshPromise = null;
  }

  // Authentication Methods
  async login(username, password) {
    try {
      const response = await fetch(`${this.authBaseUrl}/auth/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ username, password })
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || 'Authentication failed');
      }

      // Store token and user info
      this.token = data.token;
      this.user = data.user;
      this.tokenExpiry = this.parseTokenExpiry(data.token);

      // Store in localStorage for persistence
      localStorage.setItem('agent_token', data.token);
      localStorage.setItem('agent_user', JSON.stringify(data.user));

      return {
        success: true,
        user: data.user
      };

    } catch (error) {
      console.error('Login failed:', error);
      throw error;
    }
  }

  async logout() {
    this.token = null;
    this.user = null;
    this.tokenExpiry = null;
    localStorage.removeItem('agent_token');
    localStorage.removeItem('agent_user');
  }

  // Auto-restore session on page load
  async restoreSession() {
    const storedToken = localStorage.getItem('agent_token');
    const storedUser = localStorage.getItem('agent_user');

    if (storedToken && storedUser) {
      this.token = storedToken;
      this.user = JSON.parse(storedUser);
      this.tokenExpiry = this.parseTokenExpiry(storedToken);

      // Validate token is still valid
      try {
        await this.validateToken();
        return true;
      } catch (error) {
        // Token expired or invalid, clear storage
        this.logout();
        return false;
      }
    }
    return false;
  }

  // Token management
  parseTokenExpiry(token) {
    try {
      const payload = JSON.parse(atob(token.split('.')[1]));
      return new Date(payload.exp * 1000);
    } catch (error) {
      return null;
    }
  }

  isTokenExpiring() {
    if (!this.tokenExpiry) return true;
    const fiveMinutesFromNow = new Date(Date.now() + 5 * 60 * 1000);
    return this.tokenExpiry < fiveMinutesFromNow;
  }

  async ensureValidToken() {
    if (!this.token) {
      throw new Error('Not authenticated. Please login first.');
    }

    if (this.isTokenExpiring()) {
      if (!this.refreshPromise) {
        this.refreshPromise = this.refreshToken();
      }
      await this.refreshPromise;
      this.refreshPromise = null;
    }
  }

  async refreshToken() {
    try {
      const response = await fetch(`${this.authBaseUrl}/auth/refresh`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${this.token}`
        }
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || 'Token refresh failed');
      }

      this.token = data.token;
      this.tokenExpiry = this.parseTokenExpiry(data.token);
      localStorage.setItem('agent_token', data.token);

      return data.token;

    } catch (error) {
      console.error('Token refresh failed:', error);
      this.logout();
      throw new Error('Session expired. Please login again.');
    }
  }

  async validateToken() {
    const response = await fetch(`${this.authBaseUrl}/auth/validate`, {
      headers: {
        'Authorization': `Bearer ${this.token}`
      }
    });

    if (!response.ok) {
      throw new Error('Token validation failed');
    }

    return await response.json();
  }

  // DAML API Methods with Auto-Authentication
  async makeDAMLRequest(endpoint, options = {}) {
    await this.ensureValidToken();

    const response = await fetch(`${this.damlBaseUrl}${endpoint}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.token}`,
        ...options.headers
      }
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.errors ? data.errors[0] : 'DAML API request failed');
    }

    return data;
  }

  // Agent Tokenization Specific Methods
  async viewRegistry() {
    return await this.makeDAMLRequest('/v1/query', {
      method: 'POST',
      body: JSON.stringify({
        templateIds: ["671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentRegistration"]
      })
    });
  }

  async createOwnershipToken(agentData) {
    if (!this.user.permissions.includes('create_agents')) {
      throw new Error('Insufficient permissions to create ownership tokens');
    }

    return await this.makeDAMLRequest('/v1/create', {
      method: 'POST',
      body: JSON.stringify({
        templateId: "671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentRegistration",
        argument: {
          operator: this.user.damlParty,
          agentId: `agent-${Date.now()}`,
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
    if (!this.user.permissions.includes('create_usage_tokens')) {
      throw new Error('Insufficient permissions to create usage tokens');
    }

    return await this.makeDAMLRequest('/v1/create', {
      method: 'POST',
      body: JSON.stringify({
        templateId: "671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentUsageToken",
        argument: {
          operator: this.user.damlParty,
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

  async recordUsage(usageContractId, usageAmount, eventData = {}) {
    return await this.makeDAMLRequest('/v1/exercise', {
      method: 'POST',
      body: JSON.stringify({
        templateId: "671ba5c19c9df53e9d1d3025b3edb2186a687b1a75331e88a1119bfaed27fd4b:AgentTokenizationV2:AgentUsageToken",
        contractId: usageContractId,
        choice: "RecordUsage",
        argument: {
          usageAmount: usageAmount,
          timestamp: new Date().toISOString(),
          eventData: eventData
        }
      })
    });
  }

  // Utility methods
  isAuthenticated() {
    return !!this.token && !!this.user;
  }

  getCurrentUser() {
    return this.user;
  }

  hasPermission(permission) {
    return this.user && this.user.permissions.includes(permission);
  }
}

// Export for both browser and Node.js
if (typeof module !== 'undefined' && module.exports) {
  module.exports = AgentTokenizationClient;
} else {
  window.AgentTokenizationClient = AgentTokenizationClient;
}