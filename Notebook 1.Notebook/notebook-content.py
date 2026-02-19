# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023",
# META       "default_lakehouse_name": "DLH",
# META       "default_lakehouse_workspace_id": "e48ce691-a973-4d48-98ac-e161282245c3",
# META       "known_lakehouses": [
# META         {
# META           "id": "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

# MAGIC %%sql
# MAGIC select * from  Silver.account


# METADATA ********************

# META {
# META   "language": "sparksql",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# MAGIC %%sql
# MAGIC 
# MAGIC 
# MAGIC SELECT * FROM DLH.Silver.bill_header 

# METADATA ********************

# META {
# META   "language": "sparksql",
# META   "language_group": "synapse_pyspark"
# META }
