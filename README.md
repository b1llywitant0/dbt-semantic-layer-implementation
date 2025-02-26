# Semantic Layer Implementation using DBT

The current project demonstrates the end-to-end implementation of semantic layer feature of dbt.

The tech stack includes:
- [PostgreSQL](https://www.postgresql.org/) for OLTP database, 
- [Adminer](https://www.adminer.org/) for PostgreSQL UI,
- [ClickHouse](https://clickhouse.com/) for OLAP database,
- [Tabix](https://tabix.io/) for ClickHouse UI,
- [Zookeeper](https://zookeeper.apache.org/) + [Kafka](https://kafka.apache.org/) + [Debezium](https://debezium.io/) for real-time data streaming using CDC,
- [Kowl](https://github.com/theurichde/kowl) for Kafka UI,
- [Airflow](https://airflow.apache.org/) + [dbt](https://www.getdbt.com/) to transform data inside OLAP database.

All of the components used are containerized in [Docker](https://www.docker.com/) for ease of setup.

## Prerequisites

All you need to do is [installing Docker](https://docs.docker.com/engine/install/). After that, clone this repository by running:
```
git clone https://github.com/b1llywitant0/dbt-semantic-layer-implementation.git
```

## Getting Started
1. <strong>Important:</strong> entrypoint.sh should be in LF format, not CRLF. Please run:
```
git config --global core.autocrlf false
```
2. Create .env file. Please run:
```
cp .env.example .env
```
3. Creating network for containers and installing images. Please run:
```
make docker-build
```
> <strong>Note:</strong> I separated the docker compose file for better understanding of each service.
4. Creating PostgreSQL (also Adminer) as OLTP data source and ingesting data into it. Please run:
```
make postgres
```
> In postgres folder, there are config and script folders but they are not used. To make it simple, we directly get the Postgres image from [Debezium](https://github.com/debezium/container-images/tree/main/postgres), which <strong>stated</strong> inside the docker-compose file.
5. Creating ClickHouse (also Tabix) as OLAP for data warehouse and creating CDC tables. Please run:
```
make clickhouse
```
6. Creating CDC pipeline between OLTP and OLAP using Kafka and Debezium. Please run:
```
make cdc
```
> Data inside [Write-Ahead Logging](https://www.postgresql.org/docs/current/wal-intro.html) of PostgreSQL will be decoded by Debezium and will be stored inside Kafka as message queue, then will be consumed by OLAP into CDC tables created before. Read more:
> - [ClickHouse PostgreSQL CDC Part 1](https://clickhouse.com/blog/clickhouse-postgresql-change-data-capture-cdc-part-1)
> - [ClickHouse PostgreSQL CDC Part 2](https://clickhouse.com/blog/clickhouse-postgresql-change-data-capture-cdc-part-2)
7. Creating Airflow and dbt. Please run:
```
make airflow
```
<strong>Note:</strong> dbt is installed inside Airflow. To run the dbt project:
```
make airflow-bash
```
```
cd dbt && dbt run
```
