from airflow import DAG
from airflow_clickhouse_plugin.hooks.clickhouse import ClickHouseHook
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago


def sqlite_to_clickhouse():
    postgres_hook = PostgresHook(postgres_conn_id='postgres_ecommerce_db')
    ch_hook = ClickHouseHook()
    records = postgres_hook.get_records('SELECT * FROM product_categories')
    print(records)

with DAG(
        dag_id='sqlite_to_clickhouse',
        start_date=days_ago(2),
) as dag:
    PythonOperator(
        task_id='sqlite_to_clickhouse',
        python_callable=sqlite_to_clickhouse,
    )