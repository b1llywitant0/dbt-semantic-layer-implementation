SELECT 'CREATE DATABASE ecommerce'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'ecommerce')\gexec