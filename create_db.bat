@echo off
set PGPASSWORD=canton123
"C:\Program Files\PostgreSQL\17\bin\createdb.exe" -U postgres canton_agent_tokenization
echo Database creation completed