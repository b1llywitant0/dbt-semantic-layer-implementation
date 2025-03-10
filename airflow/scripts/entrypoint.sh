#!/bin/bash
airflow db init
echo "AUTH_ROLE_PUBLIC = 'Admin'" >> webserver_config.py
airflow connections add 'postgres_main' \
--conn-type 'postgres' \
--conn-login $POSTGRES_USER \
--conn-password $POSTGRES_PASSWORD \
--conn-host $POSTGRES_CONTAINER_NAME \
--conn-port 5432 \
--conn-schema $POSTGRES_AIRFLOW_DB
airflow connections add 'postgres_ecommerce_db' \
--conn-type 'postgres' \
--conn-login $POSTGRES_USER \
--conn-password $POSTGRES_PASSWORD \
--conn-host $POSTGRES_CONTAINER_NAME \
--conn-port 5432 \
--conn-schema $POSTGRES_OLTP_DB
airflow connections add 'clickhouse_ecommerce_dw' \
--conn-type 'sqlite' \
--conn-login $CLICKHOUSE_USER \
--conn-password $CLICKHOUSE_PASSWORD \
--conn-host $CLICKHOUSE_CONTAINER_NAME \
--conn-port 9000 \
--conn-schema 'raw'
airflow webserver
