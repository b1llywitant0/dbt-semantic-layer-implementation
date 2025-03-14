from airflow.decorators import dag, task
from airflow_clickhouse_plugin.hooks.clickhouse import ClickHouseHook
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.operators.empty import EmptyOperator
import datetime
from airflow.utils.task_group import TaskGroup
from airflow.models.variable import Variable
import pytz

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
    'lead_business_types',
    'lead_behaviour_profiles'
    ]

INCREMENTAL_LOAD_TABLES = [
    'geolocations',
    'bridge_lead_behaviour_profiles'
    ]

# DAG settings
@dag(
     dag_id='reference_tables_postgres_to_clickhouse',
     schedule_interval='0 0 * * *',
     start_date=datetime.datetime(2025, 3, 6, tzinfo=pytz.timezone("Asia/Jakarta")),
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
            else:
                print(f'Table: {table_name} not exists')

        return full_refresh
    
    # Incremental load task
    def create_incremental_load_task(table_name):
        @task(task_id=f'incremental_load_{table_name}')
        def incremental_load():
            postgres_hook = PostgresHook(postgres_conn_id=POSTGRES_CONN_ID)
            ch_hook = ClickHouseHook(clickhouse_conn_id=CLICKHOUSE_CONN_ID)
            
            stored_last_updated = f'last_updated_{table_name}'
            last_updated = Variable.get(key=stored_last_updated, default_var='1970-01-01 07:00:00.000000')
                
            print(f"Last updated timestamp for {table_name}: {last_updated}")

            new_records = postgres_hook.get_records(f'''
                                                    SELECT *
                                                    FROM {table_name}
                                                    WHERE updated_at > '{last_updated}'
                                                    ORDER BY updated_at ASC
                                                    ''')
            
            if new_records:
                ch_hook.execute(f'INSERT INTO {table_name} VALUES', new_records)
                ch_hook.execute(f'OPTIMIZE TABLE {table_name} FINAL')
                
                last_updated_query = f"SELECT MAX(updated_at) FROM {table_name}"
                last_updated_result = ch_hook.execute(last_updated_query)
                last_updated = last_updated_result[0][0] if last_updated_result and last_updated_result[0] else datetime.datetime(1970, 1, 1, 7, 0, tzinfo=pytz.timezone("Asia/Jakarta")).strftime('%Y-%m-%d %H:%M:%S.%f')
                if isinstance(last_updated, str) == False:
                    last_updated = last_updated.strftime('%Y-%m-%d %H:%M:%S.%f')
                Variable.set(key=stored_last_updated,value=last_updated)

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