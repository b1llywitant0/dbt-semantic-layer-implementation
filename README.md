# Semantic Layer Implementation using DBT

The current project demonstrates the end-to-end implementation of semantic layer feature of dbt, from ingesting data in OLTP to visualizing the data in Dashboard.

The tech stack includes:
- [PostgreSQL](https://www.postgresql.org/) for OLTP database, 
- [Adminer](https://www.adminer.org/) for PostgreSQL UI,
- [ClickHouse](https://clickhouse.com/) for OLAP database,
- [Tabix](https://tabix.io/) for ClickHouse UI,
- [Zookeeper](https://zookeeper.apache.org/) + [Kafka](https://kafka.apache.org/) + [Debezium](https://debezium.io/) for real-time data streaming using CDC,
- [Kowl](https://github.com/theurichde/kowl) for Kafka UI,
- [Airflow](https://airflow.apache.org/) + [dbt](https://www.getdbt.com/) to transform data inside OLAP database.

All of the components used are containerized in [Docker](https://www.docker.com/) for ease of setup.

## Design

1. Ingesting data to OLTP manually.
2. Extract and load phases from OLTP to OLAP, using Kafka+Debezium for stream jobs (for important tables, i.e. orders, customers, etc.) and using Airflow for batch job (mostly for reference tables, i.e. product categories, order status, etc.).
3. Running dbt manually or by using Airflow to transform data inside OLAP. The transformed data will be given to data marts.
4. Visualizing data in the dashboard, including metrics (the implementation of semantic layer).

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

## Simulation

<strong>Important:</strong> Do this sequentially.

### Loading Reference Tables to OLAP

1. Open [Airflow](http://localhost:8081/home) and run reference_tables_postgres_to_clickhouse DAG to load data from PostgreSQL to ClickHouse.
2. Open [Tabix](http://localhost:8082/#!/login) and login using:
    - Name: <anything_you_like>
    - http://host:port: http://localhost:8123
    - Login: clickhouse
    - Password: root
3. Check the presence of data in ClickHouse inside 'raw' database. 

### Running dbt

<strong>Note:</strong> dbt is installed inside Airflow. To run the dbt project:
```
make airflow-bash
```
```
cd dbt && dbt build
```

## Other References

### About ClickHouse

- [ReplacingMergeTree Table Engine](https://clickhouse.com/docs/guides/replacing-merge-tree)
- [Materialized View](https://clickhouse.com/docs/materialized-view)
- [Using dbt-ClickHouse with examples](https://clickhouse.com/docs/integrations/dbt)
- [Datetime functions](https://clickhouse.com/docs/sql-reference/functions/date-time-functions)
- [Connecting ClickHouse with Airflow for Batch Job](https://github.com/bryzgaloff/airflow-clickhouse-plugin)
- UDF

### About dbt

- [Best practice of structuring dbt project](https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview)
- [Configuration of ClickHouse in dbt](https://docs.getdbt.com/reference/resource-configs/clickhouse-configs)
- [Snapshot model for generating SCD2 tables](https://docs.getdbt.com/docs/build/snapshots)
- [dbt utils package](https://github.com/dbt-labs/dbt-utils)

### About Strategies

- [Strategies for change data capture in dbt](https://docs.getdbt.com/blog/change-data-capture)
- [Data Warehouse Guideline: SCD2](https://appflowy.com/41518cd2-22c3-48b9-bd3e-9ffeac63d8d0/2025-02-21-SC-feb534c3-477a-4d2b-9345-047777925a47)
- [Data modeling techniques for more modularity](https://www.getdbt.com/blog/modular-data-modeling-techniques)
