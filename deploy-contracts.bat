@echo off
echo 🚀 Deploying Agent Tokenization Contracts to Local Canton...

cd /d "C:\Users\oreph\Documents\Canton\DAML Projects\CantonAgentTokenization"

echo.
echo 🔧 Waiting for Canton to be ready...
timeout /t 10 /nobreak > nul

echo.
echo 🔧 Deploying comprehensive test with 2 ownership + 6 usage contracts...

"C:\Users\oreph\AppData\Roaming\daml\bin\daml.cmd" script ^
  --dar .daml/dist/agent-tokenization-v3-3.0.0.dar ^
  --script-name ComprehensiveV3Test:comprehensiveV3Test ^
  --ledger-host localhost ^
  --ledger-port 6866

if %errorlevel% equ 0 (
    echo.
    echo ✅ CONTRACTS DEPLOYED SUCCESSFULLY!
    echo.
    echo 📊 What was created:
    echo   • 2 Ownership Contracts: MarketingGuru AI ^& FinanceWizard AI
    echo   • 6 Usage Contracts: 3 per agent ^(Basic/Advanced/Enterprise^)
    echo   • System Orchestrator with metrics
    echo.
    echo 🌐 Test your API:
    echo   curl -X POST http://localhost:7575/v1/query \
    echo     -H "Content-Type: application/json" \
    echo     -d "{\"templateIds\": [\"ComprehensiveV3Test:AIAgentOwnershipToken\"]}"
    echo.
    echo 🎉 REAL DAML BLOCKCHAIN IS RUNNING WITH YOUR CONTRACTS!
) else (
    echo ❌ Contract deployment failed!
    echo Make sure Canton is running first.
)

pause