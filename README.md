# Semantic Layer Implementation using DBT

This project demonstrates the end-to-end implementation of ELT data pipeline using dbt and semantic layer using Cube. Moreover, this project separated OLTP as data source and OLAP as data warehouse to simulate the real-world data pipeline.

The tech stack includes:
- [PostgreSQL](https://www.postgresql.org/) for OLTP database, 
- [Adminer](https://www.adminer.org/) for PostgreSQL UI (You can also use [Dbeaver](https://dbeaver.io/) if you like),
- [ClickHouse](https://clickhouse.com/) for OLAP database,
- [Tabix](https://tabix.io/) for ClickHouse UI,
- [Zookeeper](https://zookeeper.apache.org/) + [Kafka](https://kafka.apache.org/) + [Debezium](https://debezium.io/) for real-time data streaming using CDC,
- [Kowl](https://github.com/theurichde/kowl) for Kafka UI,
- [Airflow](https://airflow.apache.org/) + [dbt](https://www.getdbt.com/) to transform data inside OLAP database,
- [Cube](https://cube.dev/) as semantic layer,
- [Metabase](https://www.metabase.com/) as BI visualization tool.

All of the components used are containerized in [Docker](https://www.docker.com/) for ease of setup.

The datasets used are [Olist e-commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) and [marketing](https://www.kaggle.com/datasets/olistbr/marketing-funnel-olist) datasets obtained from Kaggle.

## Design

![ELT Architecture](etc/img/ELT%20Project%20Architecture.png)

## Prerequisites

All you need to do is [installing Docker](https://docs.docker.com/engine/install/). After that, clone this repository by running:
```
git clone https://github.com/b1llywitant0/dbt-semantic-layer-implementation.git
```

## Getting Started

1. <strong>Important:</strong> All scripts using [Shebang](https://linuxhandbook.com/shebang/) should be in LF format, not CRLF. Please run if you use Windows:
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

## Data Load & Transformation

### Crosschecking

Before we begin, it is important to check whether the data exists or not inside the ClickHouse.

1. Open [Kowl](http://localhost:8088/topics) to see whether the streaming data from PostgreSQL are successfully received by Kafka. Topics should appear, i.e. cdc_closed_deals, cdc_customers, etc. In consumer groups, connect-clickhouse-sinker should appear as well.
> When creating cdc container for the first time, please wait all of the data consumed (lag=0 in connect-clickhouse-sinker) before proceeding to the next step. 
2. Open [Airflow](http://localhost:8081/home) and run `reference_tables_postgres_to_clickhouse` DAG manually to load data from PostgreSQL to ClickHouse. 
> This DAG had been set to run with dbt transformation using `TriggerDagRunOperator`, this step only to crosscheck the DAG and the data.
> Moreover, the first time you run this DAG, it will be triggered twice and resulting in duplicate data inside datawarehouse (full refresh group). Please run again once after that to remove duplicates.
3. Open [Tabix](http://localhost:8082/#!/login) and login using:
    - Name: <anything_you_like>
    - http://host:port: http://localhost:8123
    - Login: clickhouse
    - Password: root
4. Check the presence of data in ClickHouse inside 'raw' schema/database using SELECT statement.

### Running dbt

<strong>Note:</strong> dbt is installed inside Airflow.

1. Open [Airflow](http://localhost:8081/home) and run `dbt_transformation` DAG. 

### Generating Data Catalog

1. Accessing the Airflow container:
```
make airflow-bash
```
2. Change directory to dbt project folder inside the container:
```
cd dbt
```
3. Generating dbt docs:
```
dbt docs generate
```
4. Serving dbt docs:
```
dbt docs serve --port 8001 --host 0.0.0.0
```
> You can see data lineage by clicking button on bottom right of the screen.
> The preview:
> ![dbt Lineage](./etc/img/dbt%20Lineage%20Peek.png)

## Semantic Layer and Data Visualization

### Setup

1. Creating Cube container. Please run:
```
make cube
```
2. Creating metabase container. Please run:
```
make metabase
```

### Accessing Cube

1. Open [Cube Playground](http://localhost:4000/#/build?query={%22timezone%22:%22Asia/Jakarta%22}) and see Cubes/Views created.
> When querying, since we are using ClickHouse, there's still integration issue (at least, when I finished this project), such as: [Cube Issue #9383](https://github.com/cube-js/cube/issues/9383)

### Accessing Metabase

1. Open [Metabase](http://localhost:3000/auth/login) and login using email in .env. To access admin, please use `billywitanto@gmail.com`. To see the access control created for dashboards, you can either use `marketing@example.com` or `ecommerce@example.com`.
> To edit, you need Admin privilege. When accessing Cube in Metabase, there may be error to display the data. But, we still can query most of the needed data in that state. So, just go create or edit the questions and see whether the query works or not. I assume that the problem lies with the ClickHouse integration, such as issue stated above.

### Dashboard Previews
![Marketing Dashboard](./etc/img/Marketing%20Dashboard.png)
![Ecommerce Dashboard](./etc/img/Ecommerce%20Dashboard.png)

## Other References

### About ClickHouse

- [ReplacingMergeTree Table Engine](https://clickhouse.com/docs/guides/replacing-merge-tree)
- [Materialized View](https://clickhouse.com/docs/materialized-view)
- [Using dbt-ClickHouse with examples](https://clickhouse.com/docs/integrations/dbt)
- [Datetime functions](https://clickhouse.com/docs/sql-reference/functions/date-time-functions)
- [Connecting ClickHouse with Airflow for Batch Job](https://github.com/bryzgaloff/airflow-clickhouse-plugin)
- [User Defined Functions](https://clickhouse.com/docs/sql-reference/functions/udf#executable-user-defined-functions)

### About dbt

- [Best Practice of Structuring dbt Project](https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview)
- [Configuration of ClickHouse in dbt](https://docs.getdbt.com/reference/resource-configs/clickhouse-configs)
- [Snapshot Model for Generating SCD2 Tables](https://docs.getdbt.com/docs/build/snapshots)
- [Incremental Model](https://docs.getdbt.com/docs/build/incremental-models-overview)
- [dbt utils Package](https://github.com/dbt-labs/dbt-utils)

### About Cube
- [Using Cube with dbt](https://cube.dev/docs/guides/dbt)
- [Cohort Analysis](https://cube.dev/docs/guides/recipes/analytics/cohort-retention)
- [Many-to-many joins](https://cube.dev/docs/product/data-modeling/concepts/working-with-joins#many-to-many-joins)
- [Using Cube with Metabase](https://cube.dev/docs/product/configuration/visualization-tools/metabase)
- [Preaggregation for data caching (Not used in this project, but interesting to read)](https://cube.dev/docs/reference/data-model/pre-aggregations)

### About Strategies

- [Strategies for Change Data Capture in dbt](https://docs.getdbt.com/blog/change-data-capture)
- [Data Warehouse Guideline: SCD2](https://appflowy.com/41518cd2-22c3-48b9-bd3e-9ffeac63d8d0/2025-02-21-SC-feb534c3-477a-4d2b-9345-047777925a47)
- [Data Modeling Techniques for More Modularity](https://www.getdbt.com/blog/modular-data-modeling-techniques)
- [Decimal Types](https://debezium.io/documentation/reference/stable/connectors/postgresql.html#postgresql-decimal-types)
- [Dead Letter Queue](https://medium.com/snowflake/snowflake-kafka-connector-and-dead-letter-queues-fb7f8e0cc5ef)