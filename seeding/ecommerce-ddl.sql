SELECT 'CREATE DATABASE ecommerce_db'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'ecommerce_db')\gexec