.PHONY: airflow clickhouse
include .env

docker-build: 
	@docker network inspect ${NETWORK_NAME} >/dev/null 2>&1 || docker network create ${NETWORK_NAME}
	@chmod +x ./airflow/scripts/entrypoint.sh
	@echo '__________________________________________________________'
	@docker build -t finpro/airflow -f ./docker/Dockerfile.airflow .
	@echo '==========================================================='

postgres-create:
	@docker compose -f ./docker/docker-compose-postgres.yml --env-file .env up -d
	@echo '__________________________________________________________'
	@echo 'Postgres Container Created at Port ${POSTGRES_PORT}...'
	@echo '__________________________________________________________'
	@echo 'Postgres Docker Host	: ${POSTGRES_CONTAINER_NAME}' &&\
		echo 'Postgres Account	: ${POSTGRES_USER}' &&\
		echo 'Postgres Password	: ${POSTGRES_PASSWORD}' &&\
		echo 'Postgres DB		: ${POSTGRES_OLTP_DB}'
	@echo '==========================================================='
	@sleep 5

postgres-create-warehouse:
	@echo '__________________________________________________________'
	@echo 'Creating Ecommerce DB...'
	@echo '__________________________________________________________'
	@docker exec -it ${POSTGRES_CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_AIRFLOW_DB} -f seeding/ecommerce-ddl.sql
	@echo '==========================================================='

postgres-create-table:
	@echo '__________________________________________________________'
	@echo 'Creating Tables...'
	@echo '__________________________________________________________'
	@docker exec -it ${POSTGRES_CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_OLTP_DB} -f seeding/tables-ddl.sql
	@echo '==========================================================='

postgres-ingest-csv:
	@echo '__________________________________________________________'
	@echo 'Ingesting CSV...'
	@echo '__________________________________________________________'
	@docker exec -it ${POSTGRES_CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_OLTP_DB} -f seeding/ingest.sql
	@echo '==========================================================='

postgres: postgres-create postgres-create-warehouse postgres-create-table postgres-ingest-csv

airflow: 
	@echo '__________________________________________________________'
	@echo 'Creating Airflow Instance ...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/docker-compose-airflow.yml --env-file .env up -d
	@echo '==========================================================='

clickhouse:
	@echo '__________________________________________________________'
	@echo 'Creating ClickHouse Instance ...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/docker-compose-clickhouse.yml --env-file .env up -d
	@echo '==========================================================='

cdc:
	@echo '__________________________________________________________'
	@echo 'Creating Kafka+Debezium Instance ...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/docker-compose-cdc.yml --env-file .env up -d
	@echo '==========================================================='	

airflow-bash:
	@docker exec -it ${AIRFLOW_WEBSERVER_CONTAINER_NAME} bash

postgres-bash:
	@docker exec -it ${POSTGRES_CONTAINER_NAME} bash

psql:
	@docker exec -it ${POSTGRES_CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_OLTP_DB}