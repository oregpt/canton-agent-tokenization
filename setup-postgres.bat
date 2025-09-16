@echo off
echo 🔧 Setting up PostgreSQL for Canton Agent Tokenization...

rem Set PostgreSQL password
set PGPASSWORD=canton123

rem Create the database
echo Creating database canton_agent_tokenization...
"C:\Program Files\PostgreSQL\17\bin\createdb.exe" -U postgres canton_agent_tokenization

if %errorlevel% equ 0 (
    echo ✅ Database created successfully!
    echo.
    echo 📊 Connection details:
    echo   Database: canton_agent_tokenization
    echo   User: postgres
    echo   Password: canton123
    echo   Host: localhost
    echo   Port: 5432
    echo.
    echo ✅ Ready to start Canton with persistent storage!
) else (
    echo ❌ Database creation failed. Make sure PostgreSQL is running.
    echo.
    echo 🔧 To start PostgreSQL service:
    echo   net start postgresql-x64-17
)

pause