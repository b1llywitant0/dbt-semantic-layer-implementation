include .env

docker-build:
	@docker network inspect ${NETWORK_NAME} >/dev/null 2>&1 || docker network create ${NETWORK_NAME}
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
		echo 'Postgres DB		: ${POSTGRES_DB}'
	@echo '==========================================================='
	@sleep 5

postgres-create-warehouse:
	@echo '__________________________________________________________'
	@echo 'Creating Ecommerce DB...'
	@echo '__________________________________________________________'
	@docker exec -it ${POSTGRES_CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${AIRFLOW_DB} -f sql/ecommerce-ddl.sql
	@echo '==========================================================='

postgres-create-table:
	@echo '__________________________________________________________'
	@echo 'Creating Tables...'
	@echo '__________________________________________________________'
	@docker exec -it ${POSTGRES_CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -f sql/tables-ddl.sql
	@echo '==========================================================='

postgres-ingest-csv:
	@echo '__________________________________________________________'
	@echo 'Ingesting CSV...'
	@echo '__________________________________________________________'
	@docker exec -it ${POSTGRES_CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -f sql/ingest.sql
	@echo '==========================================================='

postgres: postgres-create postgres-create-warehouse postgres-create-table postgres-ingest-csv

airflow:
	@echo '__________________________________________________________'
	@echo 'Creating Airflow Instance ...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/docker-compose-airflow.yml --env-file .env up -d
	@echo '==========================================================='

airflow-bash:
	@docker exec -it finpro-airflow-webserver bash

postgres-bash:
	@docker exec -it finpro-postgres bash