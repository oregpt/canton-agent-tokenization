@echo off
echo 🚀 Starting Local Canton Network with Agent Tokenization...

cd /d "C:\Users\oreph\Documents\Canton\DAML Projects\CantonAgentTokenization"

echo.
echo 🔧 Building DAML project...
"C:\Users\oreph\AppData\Roaming\daml\bin\daml.cmd" build

if %errorlevel% neq 0 (
    echo ❌ DAML build failed!
    pause
    exit /b 1
)

echo.
echo ✅ DAML build successful!
echo.
echo 🔧 Starting Canton with persistent PostgreSQL storage...
echo   - Participant API: localhost:6866
echo   - Admin API: localhost:6865
echo   - Database: canton_agent_tokenization
echo.

rem Start Canton with our configuration
"C:\Users\oreph\AppData\Roaming\daml\bin\daml.cmd" sandbox ^
  --port 6866 ^
  --admin-api-port 6865 ^
  --canton-config canton-local.conf ^
  .daml/dist/*.dar

echo.
echo 🚀 Canton is running with real DAML blockchain!
echo   - Test at: http://localhost:6866
echo   - Admin API: http://localhost:6865
pause