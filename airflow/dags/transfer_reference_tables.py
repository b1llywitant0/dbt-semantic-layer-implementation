from airflow.decorators import dag, task
from airflow_clickhouse_plugin.hooks.clickhouse import ClickHouseHook
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago
from airflow.operators.empty import EmptyOperator
import datetime
from airflow.utils.task_group import TaskGroup

# Connection ID from entrypoint
POSTGRES_CONN_ID = 'postgres_ecommerce_db'
CLICKHOUSE_CONN_ID = 'clickhouse_ecommerce_dw'

# Tables
FULL_REFRESH_TABLES = [
    'product_categories',
    'order_status',
    'order_payment_methods',
    'qualified_lead_origins',
    'lead_business_segments',
    'lead_business_types'
    ]

INCREMENTAL_LOAD_TABLES = [
    'geolocations'
    ]

# DAG settings
@dag(
     dag_id='reference_tables_postgres_to_clickhouse',
     schedule_interval='@daily',
     start_date=days_ago(1),
     catchup=False
     )    

def reference_table_dag():
    # Indicating start and end
    start_task = EmptyOperator(task_id="start_task")
    end_task   = EmptyOperator(task_id="end_task")

    # Full refresh task
    def create_full_refresh_task(table_name):
        @task(task_id=f'full_refresh_{table_name}')
        def full_refresh():
            postgres_hook = PostgresHook(postgres_conn_id=POSTGRES_CONN_ID)
            ch_hook = ClickHouseHook(clickhouse_conn_id=CLICKHOUSE_CONN_ID)
            
            records = postgres_hook.get_records(f'SELECT * FROM {table_name}')
            if records:
                ch_hook.execute(f'TRUNCATE TABLE {table_name}')
                ch_hook.execute(f'INSERT INTO {table_name} VALUES', records)

        return full_refresh
    
    # Incremental load task
    def create_incremental_load_task(table_name):
        @task(task_id=f'incremental_load_{table_name}')
        def incremental_load():
            postgres_hook = PostgresHook(postgres_conn_id=POSTGRES_CONN_ID)
            ch_hook = ClickHouseHook(clickhouse_conn_id=CLICKHOUSE_CONN_ID)
            
            last_updated_query = f"SELECT MAX(updated_at) FROM {table_name}"
            last_updated_result = ch_hook.execute(last_updated_query)
            last_updated = last_updated_result[0][0] if last_updated_result and last_updated_result[0] else datetime.datetime(2000, 1, 1)
            last_updated_str = last_updated.strftime('%Y-%m-%d %H:%M:%S')

            print(f"Last updated timestamp for {table_name}: {last_updated_str}")

            new_records = postgres_hook.get_records(f"SELECT * FROM {table_name} WHERE updated_at > '{last_updated_str}' ORDER BY updated_at ASC")
            if new_records:
                ch_hook.execute(f'INSERT INTO {table_name} VALUES', new_records)
            else:
                print('No new data')
        
        return incremental_load
    
    with TaskGroup('full_refresh_group') as full_refresh_group:
        for table in FULL_REFRESH_TABLES:
            create_full_refresh_task(table)()
    
    with TaskGroup('incremental_load_group') as incremental_load_group:
        for table in INCREMENTAL_LOAD_TABLES:
            create_incremental_load_task(table)()
    
    start_task >> full_refresh_group >> end_task
    start_task >> incremental_load_group >> end_task

reference_table_dag()