create schema delta.bronze with (location='abfss://bronze@adlsthuehomelakehousedev.dfs.core.windows.net/delta')

CALL delta.system.register_table(schema_name => 'bronze', table_name => 'energi_data_service', table_location => 'abfss://bronze@adlsthuehomelakehousedev.dfs.core.windows.net/delta/energi_data_service')



