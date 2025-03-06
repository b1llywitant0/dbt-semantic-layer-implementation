from airflow import DAG
from airflow_clickhouse_plugin.operators.clickhouse import ClickHouseOperator
from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago

with DAG(
        dag_id='testing_connection',
        start_date=days_ago(2),
) as dag:
    ClickHouseOperator(
        task_id='select_5_product_categories',
        database='ecommerce_dw',
        sql=(
            '''
                SELECT after.customer_unique_id FROM cdc_customers LIMIT 5
            ''',
            # result of the last query is pushed to XCom
        ),
        # query_id is templated and allows to quickly identify query in ClickHouse logs
        query_id='{{ ti.dag_id }}-{{ ti.task_id }}-{{ ti.run_id }}-{{ ti.try_number }}',
        clickhouse_conn_id='clickhouse_ecommerce_dw',
    ) >> PythonOperator(
        task_id='print_month_income',
        python_callable=lambda task_instance:
            # pulling XCom value and printing it
            print(task_instance.xcom_pull(task_ids='select_5_product_categories')),
    )