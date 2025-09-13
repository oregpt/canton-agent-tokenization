@echo off
set PGPASSWORD=canton123
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -l | findstr canton_agent_tokenization