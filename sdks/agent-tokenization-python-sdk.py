"""
Agent Tokenization Python SDK

Easy-to-use Python library for integrating with the Agent Tokenization platform.
Compatible with Python 3.7+ and popular frameworks like Flask, Django, FastAPI.

Version: 1.0.0
Author: Agent Tokenization Platform
"""

import json
import time
import requests
from typing import Dict, List, Optional, Any, Union
from dataclasses import dataclass, asdict
from datetime import datetime, timezone
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class AgentTokenizationError(Exception):
    """Custom exception for Agent Tokenization API errors"""
    
    def __init__(self, message: str, code: Optional[str] = None, details: Optional[Dict] = None):
        super().__init__(message)
        self.code = code
        self.details = details or {}


@dataclass
class Agent:
    """Agent data structure"""
    agent_id: str
    name: str
    description: str
    agent_type: str
    capabilities: List[str]
    attributes: Dict[str, Any]
    is_active: bool = True
    created_at: Optional[str] = None


@dataclass
class UsageToken:
    """Usage token data structure"""
    agent_id: str
    token_id: str
    usage_type: str
    max_usage: int
    current_usage: int = 0
    metadata: Dict[str, Any] = None
    is_active: bool = True
    created_at: Optional[str] = None
    
    def __post_init__(self):
        if self.metadata is None:
            self.metadata = {}


@dataclass
class UsageSummary:
    """Usage summary data structure"""
    agent_id: str
    total_tokens: int
    active_tokens: int
    total_max_usage: int
    total_current_usage: int
    usage_by_type: Dict[str, Dict[str, Union[int, float]]]
    utilization_rate: float


class AgentTokenizationSDK:
    """
    Python SDK for the Agent Tokenization platform
    
    Provides easy-to-use methods for managing AI agents, usage tokens,
    and system interactions through the DAML JSON API.
    """
    
    def __init__(
        self,
        base_url: str = "http://localhost:7575",
        party: str = "Alice", 
        package_id: str = "your-package-id",
        timeout: int = 30,
        headers: Optional[Dict[str, str]] = None
    ):
        """
        Initialize the SDK
        
        Args:
            base_url: Base URL of the DAML JSON API
            party: Default party for transactions
            package_id: Package ID of deployed DAR
            timeout: Request timeout in seconds
            headers: Additional headers for requests
        """
        self.base_url = base_url.rstrip('/')
        self.party = party
        self.package_id = package_id
        self.timeout = timeout
        self.session = requests.Session()
        
        default_headers = {'Content-Type': 'application/json'}
        if headers:
            default_headers.update(headers)
        self.session.headers.update(default_headers)

    def _make_request(
        self, 
        endpoint: str, 
        method: str = "GET", 
        data: Optional[Dict] = None,
        party: Optional[str] = None
    ) -> Dict:
        """Make HTTP request to DAML JSON API"""
        url = f"{self.base_url}{endpoint}"
        request_party = party or self.party
        
        headers = {'Authorization': f'Bearer {request_party}'}
        
        try:
            if method.upper() == "GET":
                response = self.session.get(url, headers=headers, timeout=self.timeout)
            elif method.upper() == "POST":
                response = self.session.post(url, headers=headers, json=data, timeout=self.timeout)
            else:
                response = self.session.request(method, url, headers=headers, json=data, timeout=self.timeout)
            
            response.raise_for_status()
            
            # Handle different content types
            content_type = response.headers.get('content-type', '')
            if 'application/json' in content_type:
                return response.json()
            else:
                return {'result': response.text}
                
        except requests.exceptions.RequestException as e:
            logger.error(f"API request failed: {str(e)}")
            raise AgentTokenizationError(f"Network error: {str(e)}", "NETWORK_ERROR", {"url": url})
        except json.JSONDecodeError as e:
            logger.error(f"Invalid JSON response: {str(e)}")
            raise AgentTokenizationError(f"Invalid JSON response: {str(e)}", "JSON_ERROR")

    def health_check(self) -> Dict:
        """Check if the API is ready"""
        return self._make_request('/readyz')

    def get_parties(self) -> List[str]:
        """Get list of parties in the system"""
        result = self._make_request('/v1/parties')
        return result.get('result', result)

    # ========== AGENT MANAGEMENT ==========

    def register_agent(self, agent: Union[Agent, Dict], party: Optional[str] = None) -> Dict:
        """
        Register a new AI agent
        
        Args:
            agent: Agent object or dictionary with agent data
            party: Party to create agent for (optional)
            
        Returns:
            Created agent contract
        """
        if isinstance(agent, Agent):
            agent_data = asdict(agent)
        else:
            agent_data = agent
            
        # Ensure required fields
        required_fields = ['agent_id', 'name', 'agent_type']
        for field in required_fields:
            if field not in agent_data:
                raise AgentTokenizationError(f"Missing required field: {field}", "VALIDATION_ERROR")
        
        # Set defaults
        agent_data.setdefault('description', '')
        agent_data.setdefault('capabilities', [])
        agent_data.setdefault('attributes', {})
        agent_data.setdefault('is_active', True)
        agent_data.setdefault('created_at', datetime.now(timezone.utc).isoformat())
        
        payload = {
            "templateId": {
                "packageId": self.package_id,
                "moduleName": "AgentTokenizationV2",
                "entityName": "AgentRegistration"
            },
            "argument": {
                "operator": party or self.party,
                "agentId": agent_data['agent_id'],
                "name": agent_data['name'],
                "description": agent_data['description'],
                "agentType": agent_data['agent_type'],
                "capabilities": agent_data['capabilities'],
                "attributes": agent_data['attributes'],
                "isActive": agent_data['is_active'],
                "createdAt": agent_data['created_at']
            }
        }
        
        return self._make_request('/v1/create', 'POST', payload, party)

    def query_agents(self, filter_criteria: Optional[Dict] = None, party: Optional[str] = None) -> List[Dict]:
        """
        Query agents by criteria
        
        Args:
            filter_criteria: Dictionary of filter conditions
            party: Party to query for (optional)
            
        Returns:
            List of matching agent contracts
        """
        payload = {
            "templateIds": [f"{self.package_id}:AgentTokenizationV2:AgentRegistration"],
            "query": filter_criteria or {}
        }
        
        result = self._make_request('/v1/query', 'POST', payload, party)
        return result.get('result', result)

    def get_agent(self, contract_id: str, party: Optional[str] = None) -> Optional[Dict]:
        """Get a specific agent by contract ID"""
        agents = self.query_agents(party=party)
        for agent in agents:
            if agent.get('contractId') == contract_id:
                return agent
        return None

    def get_agent_by_id(self, agent_id: str, party: Optional[str] = None) -> Optional[Dict]:
        """Get a specific agent by agent ID"""
        agents = self.query_agents({'agentId': agent_id}, party)
        return agents[0] if agents else None

    def update_agent_status(self, contract_id: str, is_active: bool, party: Optional[str] = None) -> Dict:
        """Update agent status (activate/deactivate)"""
        payload = {
            "templateId": {
                "packageId": self.package_id,
                "moduleName": "AgentTokenizationV2",
                "entityName": "AgentRegistration"
            },
            "contractId": contract_id,
            "choice": "Activate" if is_active else "Deactivate",
            "argument": {}
        }
        
        return self._make_request('/v1/exercise', 'POST', payload, party)

    # ========== USAGE TOKEN MANAGEMENT ==========

    def create_usage_token(self, token: Union[UsageToken, Dict], party: Optional[str] = None) -> Dict:
        """
        Create a usage token for an agent
        
        Args:
            token: UsageToken object or dictionary with token data
            party: Party to create token for (optional)
            
        Returns:
            Created usage token contract
        """
        if isinstance(token, UsageToken):
            token_data = asdict(token)
        else:
            token_data = token
            
        # Ensure required fields
        required_fields = ['agent_id', 'usage_type', 'max_usage']
        for field in required_fields:
            if field not in token_data:
                raise AgentTokenizationError(f"Missing required field: {field}", "VALIDATION_ERROR")
        
        # Set defaults
        token_data.setdefault('token_id', f"token-{int(time.time())}-{hash(str(token_data)) % 10000}")
        token_data.setdefault('current_usage', 0)
        token_data.setdefault('metadata', {})
        token_data.setdefault('is_active', True)
        token_data.setdefault('created_at', datetime.now(timezone.utc).isoformat())
        
        payload = {
            "templateId": {
                "packageId": self.package_id,
                "moduleName": "AgentTokenizationV2", 
                "entityName": "AgentUsageToken"
            },
            "argument": {
                "operator": party or self.party,
                "agentId": token_data['agent_id'],
                "tokenId": token_data['token_id'],
                "usageType": token_data['usage_type'],
                "maxUsage": token_data['max_usage'],
                "currentUsage": token_data['current_usage'],
                "metadata": token_data['metadata'],
                "isActive": token_data['is_active'],
                "createdAt": token_data['created_at']
            }
        }
        
        return self._make_request('/v1/create', 'POST', payload, party)

    def query_usage_tokens(self, filter_criteria: Optional[Dict] = None, party: Optional[str] = None) -> List[Dict]:
        """Query usage tokens by criteria"""
        payload = {
            "templateIds": [f"{self.package_id}:AgentTokenizationV2:AgentUsageToken"],
            "query": filter_criteria or {}
        }
        
        result = self._make_request('/v1/query', 'POST', payload, party)
        return result.get('result', result)

    def record_usage(self, contract_id: str, usage_amount: int, party: Optional[str] = None) -> Dict:
        """Record usage against a token"""
        payload = {
            "templateId": {
                "packageId": self.package_id,
                "moduleName": "AgentTokenizationV2",
                "entityName": "AgentUsageToken"
            },
            "contractId": contract_id,
            "choice": "RecordUsage",
            "argument": {
                "usageAmount": usage_amount,
                "timestamp": datetime.now(timezone.utc).isoformat()
            }
        }
        
        return self._make_request('/v1/exercise', 'POST', payload, party)

    # ========== SYSTEM QUERIES ==========

    def get_system_stats(self, party: Optional[str] = None) -> Optional[Dict]:
        """Get system statistics and metrics"""
        payload = {
            "templateIds": [f"{self.package_id}:AgentTokenizationV2:SystemOrchestrator"]
        }
        
        result = self._make_request('/v1/query', 'POST', payload, party)
        contracts = result.get('result', result)
        return contracts[0]['argument'] if contracts else None

    # ========== CONVENIENCE METHODS ==========

    def get_agent_data(self, agent_id: str, party: Optional[str] = None) -> Optional[Dict]:
        """Get all data for an agent (agent + tokens + usage)"""
        agents = self.query_agents({'agentId': agent_id}, party)
        if not agents:
            return None
            
        agent = agents[0]
        tokens = self.query_usage_tokens({'agentId': agent_id}, party)
        
        token_data = []
        total_usage = 0
        max_usage = 0
        
        for token in tokens:
            arg = token['argument']
            token_data.append({
                **arg,
                'contractId': token['contractId']
            })
            total_usage += arg.get('currentUsage', 0)
            max_usage += arg.get('maxUsage', 0)
        
        return {
            'agent': agent['argument'],
            'contractId': agent['contractId'],
            'tokens': token_data,
            'totalUsage': total_usage,
            'maxUsage': max_usage
        }

    def bulk_register_agents(self, agents: List[Union[Agent, Dict]], party: Optional[str] = None) -> List[Dict]:
        """Bulk register multiple agents"""
        results = []
        for agent in agents:
            try:
                result = self.register_agent(agent, party)
                results.append(result)
            except Exception as e:
                logger.error(f"Failed to register agent: {str(e)}")
                results.append({'error': str(e)})
        return results

    def get_usage_summary(self, agent_id: str, party: Optional[str] = None) -> UsageSummary:
        """Get usage summary for an agent"""
        tokens = self.query_usage_tokens({'agentId': agent_id}, party)
        
        total_max_usage = 0
        total_current_usage = 0
        usage_by_type = {}
        active_tokens = 0
        
        for token in tokens:
            arg = token['argument']
            
            if arg.get('isActive', True):
                active_tokens += 1
            
            max_usage = arg.get('maxUsage', 0)
            current_usage = arg.get('currentUsage', 0)
            usage_type = arg.get('usageType', 'unknown')
            
            total_max_usage += max_usage
            total_current_usage += current_usage
            
            if usage_type not in usage_by_type:
                usage_by_type[usage_type] = {
                    'maxUsage': 0,
                    'currentUsage': 0,
                    'tokenCount': 0
                }
            
            usage_by_type[usage_type]['maxUsage'] += max_usage
            usage_by_type[usage_type]['currentUsage'] += current_usage
            usage_by_type[usage_type]['tokenCount'] += 1
        
        utilization_rate = (total_current_usage / total_max_usage * 100) if total_max_usage > 0 else 0
        
        return UsageSummary(
            agent_id=agent_id,
            total_tokens=len(tokens),
            active_tokens=active_tokens,
            total_max_usage=total_max_usage,
            total_current_usage=total_current_usage,
            usage_by_type=usage_by_type,
            utilization_rate=utilization_rate
        )

    # ========== CONTEXT MANAGER SUPPORT ==========

    def __enter__(self):
        """Context manager entry"""
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager exit"""
        if hasattr(self.session, 'close'):
            self.session.close()


# Usage Examples:
if __name__ == "__main__":
    # Initialize SDK
    sdk = AgentTokenizationSDK(
        base_url="http://localhost:7575",
        party="Alice",
        package_id="your-package-id"
    )
    
    # Example usage with context manager
    with AgentTokenizationSDK() as sdk:
        # Register an agent using dataclass
        agent = Agent(
            agent_id="python-gpt-001",
            name="Python GPT Assistant",
            description="AI assistant for Python development",
            agent_type="LLM",
            capabilities=["code_generation", "debugging", "documentation"],
            attributes={
                "language": "python",
                "model": "gpt-4",
                "provider": "OpenAI"
            }
        )
        
        try:
            result = sdk.register_agent(agent)
            print(f"Agent registered: {result}")
            
            # Create usage token
            token = UsageToken(
                agent_id="python-gpt-001",
                token_id="python-token-001",
                usage_type="API_CALLS",
                max_usage=5000,
                metadata={"billing_tier": "developer"}
            )
            
            token_result = sdk.create_usage_token(token)
            print(f"Token created: {token_result}")
            
            # Record some usage
            usage_result = sdk.record_usage(token_result['result']['contractId'], 10)
            print(f"Usage recorded: {usage_result}")
            
            # Get usage summary
            summary = sdk.get_usage_summary("python-gpt-001")
            print(f"Usage summary: {summary}")
            
        except AgentTokenizationError as e:
            print(f"Error: {e}")
            print(f"Code: {e.code}")
            print(f"Details: {e.details}")