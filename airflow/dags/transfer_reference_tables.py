from airflow.decorators import dag, task
from airflow_clickhouse_plugin.hooks.clickhouse import ClickHouseHook
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago
from airflow.operators.empty import EmptyOperator

POSTGRES_CONN_ID = 'postgres_ecommerce_db'
CLICKHOUSE_CONN_ID = 'clickhouse_ecommerce_dw'

REFERENCE_TABLES = [
    'product_categories',
    'geolocations',
    'order_status',
    'order_payment_methods',
    'qualified_lead_origins',
    'lead_business_segments',
    'lead_business_types'
    ]

@dag(
     dag_id='reference_tables_postgres_to_clickhouse',
     schedule_interval='@daily',
     start_date=days_ago(1),
     catchup=False
     )    

def reference_table_dag():
    start_task = EmptyOperator(task_id="start_task")
    end_task   = EmptyOperator(task_id="end_task")

    def create_el_process_task(table_name):
        @task(task_id=f'el_{table_name}')
        def full_refresh():
            postgres_hook = PostgresHook(postgres_conn_id=POSTGRES_CONN_ID)
            ch_hook = ClickHouseHook(clickhouse_conn_id=CLICKHOUSE_CONN_ID)
            
            records = postgres_hook.get_records(f'SELECT * FROM {table_name}')
            if records:
                ch_hook.execute(f'TRUNCATE TABLE {table_name}')
                ch_hook.execute(f'INSERT INTO {table_name} VALUES', records)

        return full_refresh

    el_tasks = {}

    for table in REFERENCE_TABLES:
        transfer_tasks = create_el_process_task(table)
        el_tasks[table] = transfer_tasks()

    for table in REFERENCE_TABLES:
        start_task >> el_tasks[table] >> end_task

reference_table_dag()