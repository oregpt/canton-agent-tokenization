/**
 * Agent Tokenization JavaScript SDK
 * 
 * Easy-to-use JavaScript library for integrating with the Agent Tokenization platform.
 * Works in browsers, Node.js, React, Vue, Angular, and other JavaScript environments.
 * 
 * @version 1.0.0
 * @author Agent Tokenization Platform
 */

class AgentTokenizationError extends Error {
  constructor(message, code = null, details = null) {
    super(message);
    this.name = 'AgentTokenizationError';
    this.code = code;
    this.details = details;
  }
}

class AgentTokenizationSDK {
  /**
   * Initialize the SDK
   * @param {Object} config - Configuration options
   * @param {string} config.baseUrl - Base URL of the DAML JSON API (default: http://localhost:7575)
   * @param {string} config.party - Default party for transactions (default: 'Alice')
   * @param {string} config.packageId - Package ID of deployed DAR (required for production)
   * @param {Object} config.headers - Additional headers to send with requests
   * @param {number} config.timeout - Request timeout in milliseconds (default: 30000)
   */
  constructor(config = {}) {
    this.baseUrl = config.baseUrl || 'http://localhost:7575';
    this.party = config.party || 'Alice';
    this.packageId = config.packageId || 'your-package-id';
    this.timeout = config.timeout || 30000;
    this.defaultHeaders = {
      'Content-Type': 'application/json',
      ...config.headers
    };
  }

  /**
   * Make HTTP request to DAML JSON API
   * @private
   */
  async _request(endpoint, options = {}) {
    const url = `${this.baseUrl}${endpoint}`;
    const party = options.party || this.party;
    
    const config = {
      method: options.method || 'GET',
      headers: {
        ...this.defaultHeaders,
        'Authorization': `Bearer ${party}`,
        ...options.headers
      },
      ...options
    };

    if (options.body) {
      config.body = JSON.stringify(options.body);
    }

    try {
      const response = await fetch(url, config);
      
      if (!response.ok) {
        const errorText = await response.text();
        let errorData;
        try {
          errorData = JSON.parse(errorText);
        } catch {
          errorData = { message: errorText };
        }
        throw new AgentTokenizationError(
          `API request failed: ${response.status} ${response.statusText}`,
          response.status,
          errorData
        );
      }

      const contentType = response.headers.get('content-type');
      if (contentType && contentType.includes('application/json')) {
        return await response.json();
      }
      return await response.text();
    } catch (error) {
      if (error instanceof AgentTokenizationError) {
        throw error;
      }
      throw new AgentTokenizationError(`Network error: ${error.message}`, 'NETWORK_ERROR', error);
    }
  }

  /**
   * Check if the API is ready
   * @returns {Promise<Object>} Health status
   */
  async healthCheck() {
    return await this._request('/readyz');
  }

  /**
   * Get list of parties in the system
   * @returns {Promise<string[]>} Array of party identifiers
   */
  async getParties() {
    const result = await this._request('/v1/parties');
    return result.result || result;
  }

  // ========== AGENT MANAGEMENT ==========

  /**
   * Register a new AI agent
   * @param {Object} agentData - Agent information
   * @param {string} agentData.agentId - Unique agent identifier
   * @param {string} agentData.name - Human-readable agent name
   * @param {string} agentData.description - Agent description
   * @param {string} agentData.agentType - Type of agent (e.g., 'LLM', 'ML_MODEL', 'CHATBOT')
   * @param {string[]} agentData.capabilities - Array of agent capabilities
   * @param {Object} agentData.attributes - Key-value attributes
   * @param {boolean} agentData.isActive - Whether agent is active (default: true)
   * @param {Object} options - Request options
   * @param {string} options.party - Party to create agent for
   * @returns {Promise<Object>} Created agent contract
   */
  async registerAgent(agentData, options = {}) {
    const payload = {
      templateId: {
        packageId: this.packageId,
        moduleName: 'AgentTokenizationV2',
        entityName: 'AgentRegistration'
      },
      argument: {
        operator: options.party || this.party,
        agentId: agentData.agentId,
        name: agentData.name,
        description: agentData.description || '',
        agentType: agentData.agentType,
        capabilities: agentData.capabilities || [],
        attributes: agentData.attributes || {},
        isActive: agentData.isActive !== undefined ? agentData.isActive : true,
        createdAt: new Date().toISOString()
      }
    };

    return await this._request('/v1/create', {
      method: 'POST',
      body: payload,
      party: options.party
    });
  }

  /**
   * Query agents by criteria
   * @param {Object} filter - Filter criteria
   * @param {string} filter.agentType - Filter by agent type
   * @param {boolean} filter.isActive - Filter by active status
   * @param {string} filter.agentId - Filter by specific agent ID
   * @param {Object} options - Request options
   * @param {string} options.party - Party to query for
   * @returns {Promise<Object[]>} Array of matching agent contracts
   */
  async queryAgents(filter = {}, options = {}) {
    const payload = {
      templateIds: [`${this.packageId}:AgentTokenizationV2:AgentRegistration`],
      query: filter
    };

    const result = await this._request('/v1/query', {
      method: 'POST',
      body: payload,
      party: options.party
    });

    return result.result || result;
  }

  /**
   * Get a specific agent by contract ID
   * @param {string} contractId - Contract ID of the agent
   * @param {Object} options - Request options
   * @returns {Promise<Object|null>} Agent contract or null if not found
   */
  async getAgent(contractId, options = {}) {
    const agents = await this.queryAgents({}, options);
    return agents.find(agent => agent.contractId === contractId) || null;
  }

  /**
   * Update agent status (activate/deactivate)
   * @param {string} contractId - Contract ID of the agent
   * @param {boolean} isActive - New active status
   * @param {Object} options - Request options
   * @returns {Promise<Object>} Updated agent contract
   */
  async updateAgentStatus(contractId, isActive, options = {}) {
    const payload = {
      templateId: {
        packageId: this.packageId,
        moduleName: 'AgentTokenizationV2',
        entityName: 'AgentRegistration'
      },
      contractId: contractId,
      choice: isActive ? 'Activate' : 'Deactivate',
      argument: {}
    };

    return await this._request('/v1/exercise', {
      method: 'POST',
      body: payload,
      party: options.party
    });
  }

  // ========== USAGE TOKEN MANAGEMENT ==========

  /**
   * Create a usage token for an agent
   * @param {Object} tokenData - Token information
   * @param {string} tokenData.agentId - Agent ID this token is for
   * @param {string} tokenData.tokenId - Unique token identifier
   * @param {string} tokenData.usageType - Type of usage (e.g., 'API_CALLS', 'COMPUTE_TIME', 'STORAGE')
   * @param {number} tokenData.maxUsage - Maximum allowed usage
   * @param {Object} tokenData.metadata - Additional token metadata
   * @param {Object} options - Request options
   * @returns {Promise<Object>} Created usage token contract
   */
  async createUsageToken(tokenData, options = {}) {
    const payload = {
      templateId: {
        packageId: this.packageId,
        moduleName: 'AgentTokenizationV2',
        entityName: 'AgentUsageToken'
      },
      argument: {
        operator: options.party || this.party,
        agentId: tokenData.agentId,
        tokenId: tokenData.tokenId || `token-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
        usageType: tokenData.usageType,
        maxUsage: tokenData.maxUsage,
        currentUsage: 0,
        metadata: tokenData.metadata || {},
        isActive: true,
        createdAt: new Date().toISOString()
      }
    };

    return await this._request('/v1/create', {
      method: 'POST',
      body: payload,
      party: options.party
    });
  }

  /**
   * Query usage tokens
   * @param {Object} filter - Filter criteria
   * @param {string} filter.agentId - Filter by agent ID
   * @param {string} filter.usageType - Filter by usage type
   * @param {boolean} filter.isActive - Filter by active status
   * @param {Object} options - Request options
   * @returns {Promise<Object[]>} Array of matching usage token contracts
   */
  async queryUsageTokens(filter = {}, options = {}) {
    const payload = {
      templateIds: [`${this.packageId}:AgentTokenizationV2:AgentUsageToken`],
      query: filter
    };

    const result = await this._request('/v1/query', {
      method: 'POST',
      body: payload,
      party: options.party
    });

    return result.result || result;
  }

  /**
   * Record usage against a token
   * @param {string} contractId - Contract ID of the usage token
   * @param {number} usageAmount - Amount of usage to record
   * @param {Object} options - Request options
   * @returns {Promise<Object>} Updated usage token contract
   */
  async recordUsage(contractId, usageAmount, options = {}) {
    const payload = {
      templateId: {
        packageId: this.packageId,
        moduleName: 'AgentTokenizationV2',
        entityName: 'AgentUsageToken'
      },
      contractId: contractId,
      choice: 'RecordUsage',
      argument: {
        usageAmount: usageAmount,
        timestamp: new Date().toISOString()
      }
    };

    return await this._request('/v1/exercise', {
      method: 'POST',
      body: payload,
      party: options.party
    });
  }

  // ========== SYSTEM QUERIES ==========

  /**
   * Get system statistics and metrics
   * @param {Object} options - Request options
   * @returns {Promise<Object>} System statistics
   */
  async getSystemStats(options = {}) {
    const payload = {
      templateIds: [`${this.packageId}:AgentTokenizationV2:SystemOrchestrator`]
    };

    const result = await this._request('/v1/query', {
      method: 'POST',
      body: payload,
      party: options.party
    });

    return result.result && result.result[0] ? result.result[0].argument : null;
  }

  // ========== CONVENIENCE METHODS ==========

  /**
   * Get all data for an agent (agent + tokens + usage)
   * @param {string} agentId - Agent ID
   * @param {Object} options - Request options
   * @returns {Promise<Object>} Complete agent data
   */
  async getAgentData(agentId, options = {}) {
    const [agents, tokens] = await Promise.all([
      this.queryAgents({ agentId }, options),
      this.queryUsageTokens({ agentId }, options)
    ]);

    const agent = agents[0] || null;
    if (!agent) {
      return null;
    }

    return {
      agent: agent.argument,
      contractId: agent.contractId,
      tokens: tokens.map(token => ({
        ...token.argument,
        contractId: token.contractId
      })),
      totalUsage: tokens.reduce((sum, token) => sum + (token.argument.currentUsage || 0), 0),
      maxUsage: tokens.reduce((sum, token) => sum + (token.argument.maxUsage || 0), 0)
    };
  }

  /**
   * Bulk register multiple agents
   * @param {Object[]} agentsData - Array of agent data objects
   * @param {Object} options - Request options
   * @returns {Promise<Object[]>} Array of created agent contracts
   */
  async bulkRegisterAgents(agentsData, options = {}) {
    const promises = agentsData.map(agentData => this.registerAgent(agentData, options));
    return await Promise.all(promises);
  }

  /**
   * Get usage summary for an agent
   * @param {string} agentId - Agent ID
   * @param {Object} options - Request options  
   * @returns {Promise<Object>} Usage summary
   */
  async getUsageSummary(agentId, options = {}) {
    const tokens = await this.queryUsageTokens({ agentId }, options);
    
    const summary = {
      agentId,
      totalTokens: tokens.length,
      activeTokens: tokens.filter(t => t.argument.isActive).length,
      totalMaxUsage: 0,
      totalCurrentUsage: 0,
      usageByType: {},
      utilizationRate: 0
    };

    tokens.forEach(token => {
      const arg = token.argument;
      summary.totalMaxUsage += arg.maxUsage || 0;
      summary.totalCurrentUsage += arg.currentUsage || 0;
      
      if (!summary.usageByType[arg.usageType]) {
        summary.usageByType[arg.usageType] = {
          maxUsage: 0,
          currentUsage: 0,
          tokenCount: 0
        };
      }
      
      summary.usageByType[arg.usageType].maxUsage += arg.maxUsage || 0;
      summary.usageByType[arg.usageType].currentUsage += arg.currentUsage || 0;
      summary.usageByType[arg.usageType].tokenCount++;
    });

    summary.utilizationRate = summary.totalMaxUsage > 0 
      ? (summary.totalCurrentUsage / summary.totalMaxUsage) * 100 
      : 0;

    return summary;
  }
}

// Export for different environments
if (typeof module !== 'undefined' && module.exports) {
  // Node.js
  module.exports = { AgentTokenizationSDK, AgentTokenizationError };
} else if (typeof window !== 'undefined') {
  // Browser
  window.AgentTokenizationSDK = AgentTokenizationSDK;
  window.AgentTokenizationError = AgentTokenizationError;
}

// Usage Examples:
/*

// Initialize SDK
const sdk = new AgentTokenizationSDK({
  baseUrl: 'http://localhost:7575',
  party: 'Alice',
  packageId: 'your-package-id'
});

// Register an agent
const agent = await sdk.registerAgent({
  agentId: 'gpt-4-assistant',
  name: 'GPT-4 Financial Assistant',
  description: 'AI assistant for financial analysis',
  agentType: 'LLM',
  capabilities: ['analysis', 'reporting', 'forecasting'],
  attributes: {
    model: 'gpt-4',
    provider: 'OpenAI',
    version: '2024-03'
  }
});

// Create usage token
const token = await sdk.createUsageToken({
  agentId: 'gpt-4-assistant',
  usageType: 'API_CALLS',
  maxUsage: 1000,
  metadata: { billing_tier: 'premium' }
});

// Record usage
await sdk.recordUsage(token.result.contractId, 5);

// Query agents
const activeAgents = await sdk.queryAgents({ isActive: true });

// Get complete agent data
const agentData = await sdk.getAgentData('gpt-4-assistant');

*/