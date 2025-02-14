# Semantic Layer Implementation using DBT

The current project demonstrates the implementation of semantic layer feature of DBT. The tech stack includes PostgreSQL for databases, Airflow to orchestrating the workflows, DBT for data transformation. All of the components used is containerized in Docker for ease of setup.

## Prerequisites

All you need to do is [installing Docker](https://docs.docker.com/engine/install/). All of the dependencies are already in the Docker image.

## Getting Started

To setup this project, as simple as running the commands in your terminal.
```
make docker-build
make postgres
make airflow
```

To run the dbt project which mounted in docker volume, you can run:
```
make airflow-bash
cd dbt
dbt run
```