from cube import TemplateContext
from cube_dbt import Dbt

template = TemplateContext()

dbt = Dbt.from_file('../../dbt/manifest.json')

for model in dbt.models:
  print(model.name)

@template.function('dbt_models')
def dbt_models():
  return dbt.models

@template.function('dbt_model')
def dbt_model(name):
  return dbt.model(name)