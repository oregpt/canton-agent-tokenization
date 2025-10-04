@echo off
echo Clearing Canton Agent Tokenization Database...

set PGPASSWORD=canton123

echo Dropping existing database...
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -c "DROP DATABASE IF EXISTS canton_agent_tokenization;"

echo Creating fresh database...
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -c "CREATE DATABASE canton_agent_tokenization;"

echo Database reset complete!
pause