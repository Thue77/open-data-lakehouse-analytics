CALL delta.system.register_table(schema_name => 'myschema', table_name => 'energi_data_service', table_location => 'abfss://bronze@adlsthuehomelakehousedev.dfs.core.windows.net/delta/energi_data_service')

select *
from delta.myschema.energi_data_service
--where dk19code = 'A'

