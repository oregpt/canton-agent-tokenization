-- Setup script for Canton Agent Tokenization PostgreSQL database
-- Run this with: psql -U postgres -f setup-database.sql

-- Create the database for Canton
CREATE DATABASE canton_agent_tokenization;

-- Connect to the database
\c canton_agent_tokenization

-- Create a dedicated user for Canton (optional, but recommended for production)
-- CREATE USER canton WITH PASSWORD 'canton_secure_password_123';
-- GRANT ALL PRIVILEGES ON DATABASE canton_agent_tokenization TO canton;

-- Show confirmation
SELECT 'Database canton_agent_tokenization created successfully!' as status;