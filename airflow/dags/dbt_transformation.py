from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
import pytz

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 3, 6, tzinfo=pytz.timezone("Asia/Jakarta")),
    # 'retries': 1,
    # 'retry_delay': timedelta(minutes=5),
}

dag = DAG (
    'dbt_transformation', 
    default_args=default_args, 
    schedule_interval='0 0 * * *',
    catchup=False
)

dbt_deps = BashOperator(
    task_id='dbt_deps',
    bash_command='cd /opt/airflow/dbt && dbt deps',
    dag=dag,
)

dbt_build = BashOperator(
    task_id='dbt_build',
    bash_command='cd /opt/airflow/dbt && dbt build',
    dag=dag,
)

load_reference_tables = TriggerDagRunOperator(
    task_id='load_reference_tables',
    trigger_dag_id='reference_tables_postgres_to_clickhouse',
    wait_for_completion=True,
)

dbt_deps >> load_reference_tables >> dbt_build