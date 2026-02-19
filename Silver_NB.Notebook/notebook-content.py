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
# MAGIC Create Schema Silver
# MAGIC 


# METADATA ********************

# META {
# META   "language": "sparksql",
# META   "language_group": "synapse_pyspark",
# META   "frozen": true,
# META   "editable": false
# META }

# CELL ********************

from pyspark.sql.types import StructType
from pyspark.sql.functions import col
def standardize_nulls(df):
    for f in df.schema.fields:
        c = f.name
        dt = f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), "NA")
                .when(trim(col(c)) == "", "NA")
                .when(col(c).isin("{}", "[]"), "NA")
                .otherwise(col(c))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), 0).otherwise(col(c))
            )
        elif isinstance(dt, BooleanType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), False).otherwise(col(c))
            )
    return df


df_silver = flatten_structs(df)

for f in df_silver.schema.fields:
    if isinstance(f.dataType, ArrayType):
        df_silver = df_silver.withColumn(f.name, to_json(col(f.name)))

df_silver = standardize_nulls(df_silver)


df_silver.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_TABLE)

print("Silver table:", SILVER_TABLE)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType


LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.bill_payment_raw"
SILVER_TABLE = f"{LAKEHOUSE}.Silver.Bill_Payment"


df = spark.table(BRONZE_TABLE)

def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    while struct_cols:
        field = struct_cols.pop(0)
        col_name = field.name

        expanded_cols = [
            col(f"{col_name}.{subfield.name}").alias(f"{col_name}_{subfield.name}")
            for subfield in field.dataType.fields
        ]

        df = df.select("*", *expanded_cols).drop(col_name)
        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    return df


df_flat = flatten_structs(df)

df_exploded = df_flat.withColumn(
    "Line_exploded",
    explode(col("Line"))
)


df_exploded = df_exploded.withColumn(
    "Amount",
    col("Line_exploded.Amount")
)


df_exploded = df_exploded.withColumn(
    "LinkedTxn_exploded",
    explode(col("Line_exploded.LinkedTxn"))
)

df_exploded = df_exploded \
    .withColumn("Linked_TxnId", col("LinkedTxn_exploded.TxnId")) \
    .withColumn("Linked_TxnType", col("LinkedTxn_exploded.TxnType"))

df_exploded = df_exploded.drop(
    "Line",
    "Line_exploded",
    "LinkedTxn_exploded"
)


def standardize_nulls(df):
    for f in df.schema.fields:
        c = f.name
        dt = f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), "NA")
                .when(trim(col(c)) == "", "NA")
                .when(col(c).isin("{}", "[]"), "NA")
                .otherwise(col(c))
            )

        elif isinstance(dt, NumericType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), 0).otherwise(col(c))
            )

        elif isinstance(dt, BooleanType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), False).otherwise(col(c))
            )

    return df


df_silver = standardize_nulls(df_exploded)

df_silver.write \
    .mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_TABLE)

print("Silver table :", SILVER_TABLE)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.bill_raw"

SILVER_HEADER = f"{LAKEHOUSE}.Silver.bill_header"
SILVER_LINE   = f"{LAKEHOUSE}.Silver.bill_line"


df = spark.table(BRONZE_TABLE)


def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    while struct_cols:
        field = struct_cols.pop(0)
        parent = field.name
        expanded = [
            col(f"{parent}.{sub.name}").alias(f"{parent}_{sub.name}")
            for sub in field.dataType.fields
        ]
        df = df.select("*", *expanded).drop(parent)
        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    return df


def standardize_nulls(df):
    for f in df.schema.fields:
        c, dt = f.name, f.dataType
        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(
                    col(c).isNull() |
                    (trim(col(c)) == "") |
                    (trim(col(c)).isin("[]", "{}")),
                    "NA"
                ).otherwise(col(c))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(c, when(col(c).isNull(), 0).otherwise(col(c)))
        elif isinstance(dt, BooleanType):
            df = df.withColumn(c, when(col(c).isNull(), False).otherwise(col(c)))
    return df


df_flat = flatten_structs(df)


cols_to_exclude = ["Line", "LinkedTxn"]

df_header = (
    df_flat
    .select(*[c for c in df_flat.columns if c not in cols_to_exclude])
    .dropDuplicates(["Id"])
    .withColumnRenamed("Id", "Bill_Id")
)


df_header = standardize_nulls(df_header)

df_header.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_HEADER)

print(" bill_header created")


df_line = df_flat.withColumn(
    "Line_exploded",
    explode_outer(col("Line"))
)

df_line = df_line \
    .withColumn("Bill_Id", col("Id")) \
    .withColumn("Line_Id", col("Line_exploded.Id")) \
    .withColumn("Line_Num", col("Line_exploded.LineNum")) \
    .withColumn("Line_Amount", col("Line_exploded.Amount")) \
    .withColumn("Line_Description", col("Line_exploded.Description")) \
    .withColumn("Line_DetailType", col("Line_exploded.DetailType")) \
    .withColumn(
        "Account_Id",
        col("Line_exploded.AccountBasedExpenseLineDetail.AccountRef.value")
    ) \
    .withColumn(
        "Account_Name",
        col("Line_exploded.AccountBasedExpenseLineDetail.AccountRef.name")
    ) \
    .withColumn(
        "Customer_Id",
        col("Line_exploded.AccountBasedExpenseLineDetail.CustomerRef.value")
    ) \
    .withColumn(
        "Customer_Name",
        col("Line_exploded.AccountBasedExpenseLineDetail.CustomerRef.name")
    ) \
    .withColumn(
        "Billable_Status",
        col("Line_exploded.AccountBasedExpenseLineDetail.BillableStatus")
    ) \
    .withColumn(
        "Tax_Code",
        col("Line_exploded.AccountBasedExpenseLineDetail.TaxCodeRef.value")
    )

if "LinkedTxn" in df_flat.columns:

    linked_schema = ArrayType(
        StructType([
            StructField("TxnId", StringType(), True),
            StructField("TxnType", StringType(), True)
        ])
    )

    linked_type = df_flat.schema["LinkedTxn"].dataType

    if isinstance(linked_type, StringType):
        df_line = df_line.withColumn(
            "Linked_arr",
            from_json(col("LinkedTxn"), linked_schema)
        )
    else:
        df_line = df_line.withColumn(
            "Linked_arr",
            col("LinkedTxn")
        )

    df_line = df_line.withColumn(
        "Linked_exploded",
        explode_outer(col("Linked_arr"))
    ).withColumn(
        "Linked_TxnId",
        col("Linked_exploded.TxnId")
    ).withColumn(
        "Linked_TxnType",
        col("Linked_exploded.TxnType")
    )


df_line = df_line.filter(col("Line_Id").isNotNull())

df_line = df_line.select(
    "Bill_Id",
    "Line_Id",
    "Line_Num",
    "Line_DetailType",
    "Line_Amount",
    "Line_Description",
    "Account_Id",
    "Account_Name",
    "Customer_Id",
    "Customer_Name",
    "Billable_Status",
    "Tax_Code",
    "Linked_TxnId",
    "Linked_TxnType"
)

df_line = standardize_nulls(df_line)

df_line.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_LINE)

print(" bill_line created")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *


spark = SparkSession.builder.getOrCreate()


LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.company_info_raw"
SILVER_TABLE = f"{LAKEHOUSE}.Silver.company_info"


df = spark.table(BRONZE_TABLE)


def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    while struct_cols:
        field = struct_cols.pop(0)
        name = field.name
        expanded = [
            col(f"{name}.{sub.name}").alias(f"{name}_{sub.name}")
            for sub in field.dataType.fields
        ]
        df = df.select("*", *expanded).drop(name)
        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    return df

df_flat = flatten_structs(df)


namevalue_field = next(f for f in df_flat.schema.fields if f.name == "NameValue")


namevalue_schema = ArrayType(
    StructType([
        StructField("Name", StringType(), True),
        StructField("Value", StringType(), True)
    ])
)


if isinstance(namevalue_field.dataType, StringType):
    df_nv = df_flat.withColumn(
        "NameValue_arr",
        from_json(col("NameValue"), namevalue_schema)
    )

else:
    df_nv = df_flat.withColumn("NameValue_arr", col("NameValue"))


df_nv = df_nv.withColumn(
    "NV",
    explode_outer(col("NameValue_arr"))
)

df_nv = df_nv \
    .withColumn("NV_Name", col("NV.Name")) \
    .withColumn("NV_Value", col("NV.Value"))


pivot_cols = ["NeoEnabled","NonTracking","IsQbdtMigrated","CompanyType",
              "SubscriptionStatus","OfferingSku","PayrollFeature",
              "AccountantFeature","QBOIndustryType",
              "ItemCategoriesFeature","AssignedTime"]

df_pivot = (
    df_nv
    .groupBy("Id")   
    .pivot("NV_Name", pivot_cols)
    .agg(first("NV_Value"))
)


base_cols = [c for c in df_flat.columns if c not in ["NameValue"]]

df_base = df_flat.select(*base_cols).dropDuplicates(["Id"])

df_silver = df_base.join(df_pivot, on="Id", how="left")


df_silver = df_silver.drop("NameValue_arr")


df_silver.write \
    .mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_TABLE)

print("Silver table :", SILVER_TABLE)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType


spark = SparkSession.builder.getOrCreate()


LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.credit_memo_raw"
SILVER_TABLE = f"{LAKEHOUSE}.Silver.credit_memo"


df = spark.table(BRONZE_TABLE)


def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    while struct_cols:
        field = struct_cols.pop(0)
        name = field.name
        expanded = [
            col(f"{name}.{sub.name}").alias(f"{name}_{sub.name}")
            for sub in field.dataType.fields
        ]
        df = df.select("*", *expanded).drop(name)
        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    return df

df_flat = flatten_structs(df)

df_line = df_flat.withColumn(
    "Line_exploded",
    explode_outer(col("Line"))
)


df_line = df_line \
    .withColumn("Line_Id", col("Line_exploded.Id")) \
    .withColumn("Line_Num", col("Line_exploded.LineNum")) \
    .withColumn("Line_Amount", col("Line_exploded.Amount")) \
    .withColumn("Line_Description", col("Line_exploded.Description")) \
    .withColumn("Line_DetailType", col("Line_exploded.DetailType"))


df_line = df_line \
    .withColumn(
        "Item_Name",
        when(
            col("Line_DetailType") == "SalesItemLineDetail",
            col("Line_exploded.SalesItemLineDetail.ItemRef.name")
        )
    ) \
    .withColumn(
        "Item_Id",
        when(
            col("Line_DetailType") == "SalesItemLineDetail",
            col("Line_exploded.SalesItemLineDetail.ItemRef.value")
        )
    ) \
    .withColumn(
        "Item_Account_Name",
        when(
            col("Line_DetailType") == "SalesItemLineDetail",
            col("Line_exploded.SalesItemLineDetail.ItemAccountRef.name")
        )
    ) \
    .withColumn(
        "Item_Account_Id",
        when(
            col("Line_DetailType") == "SalesItemLineDetail",
            col("Line_exploded.SalesItemLineDetail.ItemAccountRef.value")
        )
    ) \
    .withColumn(
        "Qty",
        when(
            col("Line_DetailType") == "SalesItemLineDetail",
            col("Line_exploded.SalesItemLineDetail.Qty")
        )
    ) \
    .withColumn(
        "Unit_Price",
        when(
            col("Line_DetailType") == "SalesItemLineDetail",
            col("Line_exploded.SalesItemLineDetail.UnitPrice")
        )
    ) \
    .withColumn(
        "Tax_Code",
        when(
            col("Line_DetailType") == "SalesItemLineDetail",
            col("Line_exploded.SalesItemLineDetail.TaxCodeRef.value")
        )
    )


df_clean = df_line.drop("Line", "Line_exploded")


from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType


def standardize_nulls(df):
    for f in df.schema.fields:
        c = f.name
        dt = f.dataType

       
        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(
                    col(c).isNull() |
                    (trim(col(c)) == "") |
                    (trim(col(c)).isin("[]", "{}", "[ ]", "{ }")),
                    "NA"
                ).otherwise(col(c))
            )

      
        elif isinstance(dt, ArrayType):
            df = df.withColumn(
                c,
                when(
                    col(c).isNull() | (size(col(c)) == 0),
                    lit("NA")
                ).otherwise(to_json(col(c)))
            )

        
        elif isinstance(dt, StructType):
            df = df.withColumn(
                c,
                when(
                    col(c).isNull(),
                    lit("NA")
                ).otherwise(to_json(col(c)))
            )

       
        elif isinstance(dt, NumericType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), 0).otherwise(col(c))
            )

      
        elif isinstance(dt, BooleanType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), False).otherwise(col(c))
            )

    return df


df_silver = standardize_nulls(df_clean)

df_silver.write \
    .mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_TABLE)

print(" Silver table:", SILVER_TABLE)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.customer_raw"
SILVER_TABLE = f"{LAKEHOUSE}.Silver.customer"

df = spark.table(BRONZE_TABLE)

def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    while struct_cols:
        field = struct_cols.pop(0)
        col_name = field.name

        expanded = [
            col(f"{col_name}.{sub.name}").alias(f"{col_name}_{sub.name}")
            for sub in field.dataType.fields
        ]

        df = df.select("*", *expanded).drop(col_name)

        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    return df


def standardize_nulls(df):
    for f in df.schema.fields:
        c = f.name
        dt = f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), "NA")
                .when(trim(col(c)) == "", "NA")
                .when(col(c).isin("{}", "[]"), "NA")
                .otherwise(col(c))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), 0).otherwise(col(c))
            )
        elif isinstance(dt, BooleanType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), False).otherwise(col(c))
            )
    return df


df_silver = flatten_structs(df)

for f in df_silver.schema.fields:
    if isinstance(f.dataType, ArrayType):
        df_silver = df_silver.withColumn(f.name, to_json(col(f.name)))

df_silver = standardize_nulls(df_silver)


df_silver.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_TABLE)

print("Silver table:", SILVER_TABLE)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType


LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.deposit_raw"
SILVER_TABLE = f"{LAKEHOUSE}.Silver.deposit"


df = spark.table(BRONZE_TABLE)

def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    while struct_cols:
        field = struct_cols.pop(0)
        col_name = field.name

        expanded_cols = [
            col(f"{col_name}.{subfield.name}").alias(f"{col_name}_{subfield.name}")
            for subfield in field.dataType.fields
        ]

        df = df.select("*", *expanded_cols).drop(col_name)
        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    return df


df_flat = flatten_structs(df)

df_exploded = df_flat.withColumn(
    "Line_exploded",
    explode(col("Line"))
)


df_exploded = df_exploded.withColumn(
    "Amount",
    col("Line_exploded.Amount")
)


df_exploded = df_exploded.withColumn(
    "LinkedTxn_exploded",
    explode(col("Line_exploded.LinkedTxn"))
)

df_exploded = df_exploded \
    .withColumn("Linked_TxnId", col("LinkedTxn_exploded.TxnId")) \
    .withColumn("Linked_TxnType", col("LinkedTxn_exploded.TxnType"))

df_exploded = df_exploded.drop(
    "Line",
    "Line_exploded",
    "LinkedTxn_exploded"
)


def standardize_nulls(df):
    for f in df.schema.fields:
        c = f.name
        dt = f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), "NA")
                .when(trim(col(c)) == "", "NA")
                .when(col(c).isin("{}", "[]"), "NA")
                .otherwise(col(c))
            )

        elif isinstance(dt, NumericType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), 0).otherwise(col(c))
            )

        elif isinstance(dt, BooleanType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), False).otherwise(col(c))
            )

    return df


df_silver = standardize_nulls(df_exploded)

df_silver.write \
    .mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_TABLE)

print("Silver table :", SILVER_TABLE)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.employee_raw"
SILVER_TABLE = f"{LAKEHOUSE}.Silver.employee"

df = spark.table(BRONZE_TABLE)

def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    while struct_cols:
        field = struct_cols.pop(0)
        col_name = field.name

        expanded = [
            col(f"{col_name}.{sub.name}").alias(f"{col_name}_{sub.name}")
            for sub in field.dataType.fields
        ]

        df = df.select("*", *expanded).drop(col_name)

        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    return df


def standardize_nulls(df):
    for f in df.schema.fields:
        c = f.name
        dt = f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), "NA")
                .when(trim(col(c)) == "", "NA")
                .when(col(c).isin("{}", "[]"), "NA")
                .otherwise(col(c))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), 0).otherwise(col(c))
            )
        elif isinstance(dt, BooleanType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), False).otherwise(col(c))
            )
    return df


df_silver = flatten_structs(df)

for f in df_silver.schema.fields:
    if isinstance(f.dataType, ArrayType):
        df_silver = df_silver.withColumn(f.name, to_json(col(f.name)))

df_silver = standardize_nulls(df_silver)


df_silver.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_TABLE)

print("Silver table:", SILVER_TABLE)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.estimate_raw"
SILVER_TABLE = f"{LAKEHOUSE}.Silver.estimate"


df = spark.table(BRONZE_TABLE)


def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    while struct_cols:
        field = struct_cols.pop(0)
        name = field.name
        expanded = [
            col(f"{name}.{sub.name}").alias(f"{name}_{sub.name}")
            for sub in field.dataType.fields
        ]
        df = df.select("*", *expanded).drop(name)
        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    return df

df_flat = flatten_structs(df)


df_line = df_flat.withColumn("Line_exploded", explode_outer(col("Line")))

df_line = df_line \
    .withColumn("Line_Id", col("Line_exploded.Id")) \
    .withColumn("Line_Num", col("Line_exploded.LineNum")) \
    .withColumn("Line_Amount", col("Line_exploded.Amount")) \
    .withColumn("Line_Description", col("Line_exploded.Description")) \
    .withColumn("Line_DetailType", col("Line_exploded.DetailType")) \
    .withColumn("Item_Name",
        when(col("Line_DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.ItemRef.name"))) \
    .withColumn("Item_Id",
        when(col("Line_DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.ItemRef.value"))) \
    .withColumn("Item_Account_Name",
        when(col("Line_DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.ItemAccountRef.name"))) \
    .withColumn("Item_Account_Id",
        when(col("Line_DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.ItemAccountRef.value"))) \
    .withColumn("Qty",
        when(col("Line_DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.Qty"))) \
    .withColumn("Unit_Price",
        when(col("Line_DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.UnitPrice"))) \
    .withColumn("Tax_Code",
        when(col("Line_DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.TaxCodeRef.value")))


linkedtxn_field = next(f for f in df_line.schema.fields if f.name == "LinkedTxn")

if isinstance(linkedtxn_field.dataType, ArrayType):
    df_line = df_line.withColumn("LinkedTxn_exploded", explode_outer(col("LinkedTxn")))
else:
    linkedtxn_schema = ArrayType(
        StructType([
            StructField("TxnId", StringType(), True),
            StructField("TxnType", StringType(), True)
        ])
    )
    df_line = df_line \
        .withColumn("LinkedTxn_arr", from_json(col("LinkedTxn"), linkedtxn_schema)) \
        .withColumn("LinkedTxn_exploded", explode_outer(col("LinkedTxn_arr")))

df_line = df_line \
    .withColumn("Linked_TxnId", col("LinkedTxn_exploded.TxnId")) \
    .withColumn("Linked_TxnType", col("LinkedTxn_exploded.TxnType"))


taxline_field = next(
    (f for f in df_line.schema.fields if f.name == "TxnTaxDetail_TaxLine"),
    None
)

if taxline_field is not None:
    df_line = df_line.withColumn(
        "TaxLine_exploded",
        explode_outer(col("TxnTaxDetail_TaxLine"))
    )

    df_line = df_line \
        .withColumn("Tax_Amount", col("TaxLine_exploded.Amount")) \
        .withColumn("Tax_DetailType", col("TaxLine_exploded.DetailType")) \
        .withColumn("Tax_NetAmountTaxable",
            col("TaxLine_exploded.TaxLineDetail.NetAmountTaxable")) \
        .withColumn("Tax_PercentBased",
            col("TaxLine_exploded.TaxLineDetail.PercentBased")) \
        .withColumn("Tax_Percent",
            col("TaxLine_exploded.TaxLineDetail.TaxPercent")) \
        .withColumn("Tax_Rate_Id",
            col("TaxLine_exploded.TaxLineDetail.TaxRateRef.value"))


df_clean = df_line.drop(
    "Line",
    "Line_exploded",
    "LinkedTxn",
    "LinkedTxn_arr",
    "LinkedTxn_exploded",
    "TxnTaxDetail_TaxLine",
    "TaxLine_exploded"
)

def standardize_nulls_dynamic(df):
    for f in df.schema.fields:
        c, dt = f.name, f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(
                    col(c).isNull() |
                    (trim(col(c)) == "") |
                    (trim(col(c)).isin("[]", "{}")),
                    "NA"
                ).otherwise(col(c))
            )
        elif isinstance(dt, ArrayType):
            df = df.withColumn(
                c,
                when(col(c).isNull() | (size(col(c)) == 0), "NA")
                .otherwise(to_json(col(c)))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(c, when(col(c).isNull(), 0).otherwise(col(c)))
        elif isinstance(dt, BooleanType):
            df = df.withColumn(c, when(col(c).isNull(), False).otherwise(col(c)))

    return df

df_silver = standardize_nulls_dynamic(df_clean)


df_silver.write \
    .mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_TABLE)

print("Silver table :", SILVER_TABLE)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.exchange_rate_raw"
SILVER_TABLE = f"{LAKEHOUSE}.Silver.exchange_rate"

df = spark.table(BRONZE_TABLE)

def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    while struct_cols:
        field = struct_cols.pop(0)
        col_name = field.name

        expanded = [
            col(f"{col_name}.{sub.name}").alias(f"{col_name}_{sub.name}")
            for sub in field.dataType.fields
        ]

        df = df.select("*", *expanded).drop(col_name)

        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    return df


def standardize_nulls(df):
    for f in df.schema.fields:
        c = f.name
        dt = f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), "NA")
                .when(trim(col(c)) == "", "NA")
                .when(col(c).isin("{}", "[]"), "NA")
                .otherwise(col(c))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), 0).otherwise(col(c))
            )
        elif isinstance(dt, BooleanType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), False).otherwise(col(c))
            )
    return df


df_silver = flatten_structs(df)

for f in df_silver.schema.fields:
    if isinstance(f.dataType, ArrayType):
        df_silver = df_silver.withColumn(f.name, to_json(col(f.name)))

df_silver = standardize_nulls(df_silver)


df_silver.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_TABLE)

print("Silver table:", SILVER_TABLE)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.invoice_raw"

SILVER_HEADER = f"{LAKEHOUSE}.Silver.invoice_header"
SILVER_LINE   = f"{LAKEHOUSE}.Silver.invoice_line"


df = spark.table(BRONZE_TABLE)


def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    while struct_cols:
        field = struct_cols.pop(0)
        parent = field.name
        expanded = [
            col(f"{parent}.{sub.name}").alias(f"{parent}_{sub.name}")
            for sub in field.dataType.fields
        ]
        df = df.select("*", *expanded).drop(parent)
        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    return df


def standardize_nulls(df):
    for f in df.schema.fields:
        c = f.name
        dt = f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), "NA")
                .when(trim(col(c)) == "", "NA")
                .when(col(c).isin("{}", "[]"), "NA")
                .otherwise(col(c))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), 0).otherwise(col(c))
            )
        elif isinstance(dt, BooleanType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), False).otherwise(col(c))
            )
    return df


df_flat = flatten_structs(df)


if "LinkedTxn" in df_flat.columns:

    linked_schema = ArrayType(
        StructType([
            StructField("TxnId", StringType(), True),
            StructField("TxnType", StringType(), True)
        ])
    )

    linked_type = df_flat.schema["LinkedTxn"].dataType

    if isinstance(linked_type, StringType):
        df_flat = df_flat.withColumn(
            "Linked_arr",
            from_json(col("LinkedTxn"), linked_schema)
        )
    else:
        df_flat = df_flat.withColumn(
            "Linked_arr",
            col("LinkedTxn")
        )

    df_flat = df_flat \
        .withColumn("Linked_first", col("Linked_arr")[0]) \
        .withColumn("Linked_TxnId", col("Linked_first.TxnId")) \
        .withColumn("Linked_TxnType", col("Linked_first.TxnType")) \
        .drop("LinkedTxn", "Linked_arr", "Linked_first")


if "TxnTaxDetail_TaxLine" in df_flat.columns:

    tax_schema = ArrayType(
        StructType([
            StructField("Amount", DoubleType(), True),
            StructField("DetailType", StringType(), True),
            StructField("TaxLineDetail", StructType([
                StructField("NetAmountTaxable", DoubleType(), True),
                StructField("PercentBased", BooleanType(), True),
                StructField("TaxPercent", DoubleType(), True),
                StructField("TaxRateRef", StructType([
                    StructField("value", StringType(), True)
                ]))
            ]))
        ])
    )

    tax_type = df_flat.schema["TxnTaxDetail_TaxLine"].dataType

    if isinstance(tax_type, StringType):
        df_flat = df_flat.withColumn(
            "Tax_arr",
            from_json(col("TxnTaxDetail_TaxLine"), tax_schema)
        )
    else:
        df_flat = df_flat.withColumn(
            "Tax_arr",
            col("TxnTaxDetail_TaxLine")
        )

    df_flat = df_flat \
        .withColumn("Tax_first", col("Tax_arr")[0]) \
        .withColumn("Tax_Amount", col("Tax_first.Amount")) \
        .withColumn("Tax_NetAmountTaxable", col("Tax_first.TaxLineDetail.NetAmountTaxable")) \
        .withColumn("Tax_Percent", col("Tax_first.TaxLineDetail.TaxPercent")) \
        .withColumn("Tax_Rate_Id", col("Tax_first.TaxLineDetail.TaxRateRef.value")) \
        .drop("TxnTaxDetail_TaxLine", "Tax_arr", "Tax_first")

cols_to_exclude = ["Line", "CustomField"]

df_header = (
    df_flat
    .select(*[c for c in df_flat.columns if c not in cols_to_exclude])
    .dropDuplicates(["Id"])
    .withColumnRenamed("Id", "Invoice_Id")
)

df_header = standardize_nulls_dynamic(df_header)

df_header.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_HEADER)

print("invoice_header")


df_line = df_flat.withColumn(
    "Line_exploded",
    explode_outer(col("Line"))
)

df_line = df_line \
    .withColumn("Invoice_Id", col("Id")) \
    .withColumn("Line_Id", col("Line_exploded.Id")) \
    .withColumn("Line_Num", col("Line_exploded.LineNum")) \
    .withColumn("DetailType", col("Line_exploded.DetailType")) \
    .withColumn("Line_Amount", col("Line_exploded.Amount")) \
    .withColumn("Line_Description", col("Line_exploded.Description")) \
    .withColumn(
        "Item_Id",
        when(col("DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.ItemRef.value"))
    ) \
    .withColumn(
        "Item_Name",
        when(col("DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.ItemRef.name"))
    ) \
    .withColumn(
        "Qty",
        when(col("DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.Qty"))
    ) \
    .withColumn(
        "Unit_Price",
        when(col("DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.UnitPrice"))
    )

df_line = df_line.select(
    "Invoice_Id",
    "Line_Id",
    "Line_Num",
    "DetailType",
    "Item_Id",
    "Item_Name",
    "Qty",
    "Unit_Price",
    "Line_Amount",
    "Line_Description"
)

df_line = standardize_nulls(df_line)

df_line.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_LINE)

print("invoice_line")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.item_raw"
SILVER_TABLE = f"{LAKEHOUSE}.Silver.item"

df = spark.table(BRONZE_TABLE)

def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    while struct_cols:
        field = struct_cols.pop(0)
        col_name = field.name

        expanded = [
            col(f"{col_name}.{sub.name}").alias(f"{col_name}_{sub.name}")
            for sub in field.dataType.fields
        ]

        df = df.select("*", *expanded).drop(col_name)

        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    return df


def standardize_nulls(df):
    for f in df.schema.fields:
        c = f.name
        dt = f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), "NA")
                .when(trim(col(c)) == "", "NA")
                .when(col(c).isin("{}", "[]"), "NA")
                .otherwise(col(c))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), 0).otherwise(col(c))
            )
        elif isinstance(dt, BooleanType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), False).otherwise(col(c))
            )
    return df


df_silver = flatten_structs(df)

for f in df_silver.schema.fields:
    if isinstance(f.dataType, ArrayType):
        df_silver = df_silver.withColumn(f.name, to_json(col(f.name)))

df_silver = standardize_nulls(df_silver)


df_silver.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_TABLE)

print("Silver table:", SILVER_TABLE)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

df = spark.sql("SELECT * FROM DLH.Bronze.bill_payment_raw LIMIT 1000")
display(df)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType


spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.journal_entry_raw"

SILVER_HEADER = f"{LAKEHOUSE}.Silver.journal_entry_header"
SILVER_LINE   = f"{LAKEHOUSE}.Silver.journal_entry_line"


df = spark.table(BRONZE_TABLE)


def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    while struct_cols:
        field = struct_cols.pop(0)
        parent = field.name
        expanded = [
            col(f"{parent}.{sub.name}").alias(f"{parent}_{sub.name}")
            for sub in field.dataType.fields
        ]
        df = df.select("*", *expanded).drop(parent)
        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    return df


def standardize_nulls_dynamic(df):
    for f in df.schema.fields:
        c, dt = f.name, f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(
                    col(c).isNull() |
                    (trim(col(c)) == "") |
                    (trim(col(c)).isin("[]", "{}", "[ ]", "{ }")),
                    "NA"
                ).otherwise(col(c))
            )

        elif isinstance(dt, ArrayType):
            df = df.withColumn(
                c,
                when(col(c).isNull() | (size(col(c)) == 0), "NA")
                .otherwise(to_json(col(c)))
            )

        elif isinstance(dt, NumericType):
            df = df.withColumn(c, when(col(c).isNull(), 0).otherwise(col(c)))

        elif isinstance(dt, BooleanType):
            df = df.withColumn(c, when(col(c).isNull(), False).otherwise(col(c)))

    return df


df_flat = flatten_structs(df)


array_cols = [
    f.name for f in df_flat.schema.fields
    if isinstance(f.dataType, ArrayType)
]

header_cols = [c for c in df_flat.columns if c not in array_cols]

df_header = (
    df_flat
    .select(*header_cols)
    .dropDuplicates(["Id"])
    .withColumnRenamed("Id", "JournalEntry_Id")
)

df_header = standardize_nulls_dynamic(df_header)

df_header.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_HEADER)

print(" journal_entry_header created")



df_line = df_flat.withColumn(
    "Line_exploded",
    explode_outer(col("Line"))
)

df_line = df_line \
    .withColumn("JournalEntry_Id", col("Id")) \
    .withColumn("Line_Id", col("Line_exploded.Id")) \
    .withColumn("Line_Description", col("Line_exploded.Description")) \
    .withColumn("Line_Amount", col("Line_exploded.Amount")) \
    .withColumn("DetailType", col("Line_exploded.DetailType")) \
    .withColumn(
        "Account_Id",
        col("Line_exploded.JournalEntryLineDetail.AccountRef.value")
    ) \
    .withColumn(
        "Account_Name",
        col("Line_exploded.JournalEntryLineDetail.AccountRef.name")
    ) \
    .withColumn(
        "PostingType",
        col("Line_exploded.JournalEntryLineDetail.PostingType")
    )

df_line = df_line.select(
    "JournalEntry_Id",
    "Line_Id",
    "DetailType",
    "Line_Description",
    "Line_Amount",
    "Account_Id",
    "Account_Name",
    "PostingType"
)

df_line = standardize_nulls_dynamic(df_line)

df_line.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_LINE)

print("journal_entry_line created")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.payment_method_raw"
SILVER_TABLE = f"{LAKEHOUSE}.Silver.payment_method"

df = spark.table(BRONZE_TABLE)

def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    while struct_cols:
        field = struct_cols.pop(0)
        col_name = field.name

        expanded = [
            col(f"{col_name}.{sub.name}").alias(f"{col_name}_{sub.name}")
            for sub in field.dataType.fields
        ]

        df = df.select("*", *expanded).drop(col_name)

        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    return df


def standardize_nulls(df):
    for f in df.schema.fields:
        c = f.name
        dt = f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), "NA")
                .when(trim(col(c)) == "", "NA")
                .when(col(c).isin("{}", "[]"), "NA")
                .otherwise(col(c))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), 0).otherwise(col(c))
            )
        elif isinstance(dt, BooleanType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), False).otherwise(col(c))
            )
    return df


df_silver = flatten_structs(df)

for f in df_silver.schema.fields:
    if isinstance(f.dataType, ArrayType):
        df_silver = df_silver.withColumn(f.name, to_json(col(f.name)))

df_silver = standardize_nulls(df_silver)


df_silver.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_TABLE)

print("Silver table:", SILVER_TABLE)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType
from pyspark.sql.window import Window

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.payment_raw"

SILVER_HEADER = f"{LAKEHOUSE}.Silver.payment_header"
SILVER_LINE   = f"{LAKEHOUSE}.Silver.payment_line"


df = spark.table(BRONZE_TABLE)

def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    while struct_cols:
        field = struct_cols.pop(0)
        parent = field.name
        expanded = [
            col(f"{parent}.{sub.name}").alias(f"{parent}_{sub.name}")
            for sub in field.dataType.fields
        ]
        df = df.select("*", *expanded).drop(parent)
        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    return df

def standardize_nulls_dynamic(df):
    for f in df.schema.fields:
        c, dt = f.name, f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(
                    col(c).isNull()
                    | (trim(col(c)) == "")
                    | (trim(col(c)).isin("[]", "{}", "[ ]", "{ }")),
                    "NA"
                ).otherwise(col(c))
            )
        elif isinstance(dt, ArrayType):
            df = df.withColumn(
                c,
                when(col(c).isNull() | (size(col(c)) == 0), "NA")
                .otherwise(to_json(col(c)))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(c, when(col(c).isNull(), 0).otherwise(col(c)))
        elif isinstance(dt, BooleanType):
            df = df.withColumn(c, when(col(c).isNull(), False).otherwise(col(c)))
    return df


df_flat = flatten_structs(df)


if "LinkedTxn" in df_flat.columns:

    linked_schema = ArrayType(
        StructType([
            StructField("TxnId", StringType(), True),
            StructField("TxnType", StringType(), True)
        ])
    )

    linked_type = df_flat.schema["LinkedTxn"].dataType

    if isinstance(linked_type, StringType):
        df_flat = df_flat.withColumn(
            "Linked_arr",
            from_json(col("LinkedTxn"), linked_schema)
        )
    else:
        df_flat = df_flat.withColumn(
            "Linked_arr",
            col("LinkedTxn")
        )

    df_flat = df_flat \
        .withColumn("Linked_first", col("Linked_arr")[0]) \
        .withColumn("Linked_TxnId", col("Linked_first.TxnId")) \
        .withColumn("Linked_TxnType", col("Linked_first.TxnType")) \
        .drop("LinkedTxn", "Linked_arr", "Linked_first")

df_header = (
    df_flat
    .select(*[c for c in df_flat.columns if c != "Line"])
    .dropDuplicates(["Id"])
    .withColumnRenamed("Id", "Payment_Id")
)

df_header = standardize_nulls_dynamic(df_header)

df_header.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_HEADER)

print(" payment_header ")


df_line = df_flat.withColumn(
    "Line_exploded",
    explode_outer(col("Line"))
)

w = Window.partitionBy("Id").orderBy(monotonically_increasing_id())

df_line = df_line \
    .withColumn("Payment_Id", col("Id")) \
    .withColumn("Line_Num", row_number().over(w)) \
    .withColumn("Line_Amount", col("Line_exploded.Amount")) \
    .withColumn("Line_DetailType", lit("PaymentLine")) \
    .select(
        "Payment_Id",
        "Line_Num",
        "Line_Amount",
        "Line_DetailType"
    )

df_line = standardize_nulls_dynamic(df_line)

df_line.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_LINE)

print(" payment_line ")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.preferences_raw"
SILVER_TABLE = f"{LAKEHOUSE}.Silver.preferences"

df = spark.table(BRONZE_TABLE)

def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    while struct_cols:
        field = struct_cols.pop(0)
        col_name = field.name

        expanded = [
            col(f"{col_name}.{sub.name}").alias(f"{col_name}_{sub.name}")
            for sub in field.dataType.fields
        ]

        df = df.select("*", *expanded).drop(col_name)

        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    return df


def standardize_nulls(df):
    for f in df.schema.fields:
        c = f.name
        dt = f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), "NA")
                .when(trim(col(c)) == "", "NA")
                .when(col(c).isin("{}", "[]"), "NA")
                .otherwise(col(c))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), 0).otherwise(col(c))
            )
        elif isinstance(dt, BooleanType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), False).otherwise(col(c))
            )
    return df


df_silver = flatten_structs(df)

for f in df_silver.schema.fields:
    if isinstance(f.dataType, ArrayType):
        df_silver = df_silver.withColumn(f.name, to_json(col(f.name)))

df_silver = standardize_nulls(df_silver)


df_silver.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_TABLE)

print("Silver table:", SILVER_TABLE)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.purchase_order_raw"

SILVER_HEADER = f"{LAKEHOUSE}.Silver.purchase_order_header"
SILVER_LINE   = f"{LAKEHOUSE}.Silver.purchase_order_line"


df = spark.table(BRONZE_TABLE)


def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    while struct_cols:
        field = struct_cols.pop(0)
        parent = field.name
        expanded = [
            col(f"{parent}.{sub.name}").alias(f"{parent}_{sub.name}")
            for sub in field.dataType.fields
        ]
        df = df.select("*", *expanded).drop(parent)
        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    return df


def standardize_nulls_dynamic(df):
    for f in df.schema.fields:
        c, dt = f.name, f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(
                    col(c).isNull()
                    | (trim(col(c)) == "")
                    | (trim(col(c)).isin("[]", "{}", "[ ]", "{ }")),
                    "NA"
                ).otherwise(col(c))
            )
        elif isinstance(dt, ArrayType):
            df = df.withColumn(
                c,
                when(col(c).isNull() | (size(col(c)) == 0), "NA")
                .otherwise(to_json(col(c)))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(c, when(col(c).isNull(), 0).otherwise(col(c)))
        elif isinstance(dt, BooleanType):
            df = df.withColumn(c, when(col(c).isNull(), False).otherwise(col(c)))
    return df


df_flat = flatten_structs(df)

if "LinkedTxn" in df_flat.columns:

    linked_schema = ArrayType(
        StructType([
            StructField("TxnId", StringType(), True),
            StructField("TxnType", StringType(), True)
        ])
    )

    linked_type = df_flat.schema["LinkedTxn"].dataType

    if isinstance(linked_type, StringType):
        df_flat = df_flat.withColumn(
            "Linked_arr",
            from_json(col("LinkedTxn"), linked_schema)
        )
    else:
        df_flat = df_flat.withColumn(
            "Linked_arr",
            col("LinkedTxn")
        )

    df_flat = df_flat \
        .withColumn("Linked_first", col("Linked_arr")[0]) \
        .withColumn("Linked_TxnId", col("Linked_first.TxnId")) \
        .withColumn("Linked_TxnType", col("Linked_first.TxnType")) \
        .drop("LinkedTxn", "Linked_arr", "Linked_first")


df_header = (
    df_flat
    .select(*[c for c in df_flat.columns if c != "Line"])
    .dropDuplicates(["Id"])
    .withColumnRenamed("Id", "PurchaseOrder_Id")
)

df_header = standardize_nulls_dynamic(df_header)

df_header.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_HEADER)

print("purchase_order_header")


df_line = df_flat.withColumn(
    "Line_exploded",
    explode_outer(col("Line"))
)

df_line = df_line \
    .withColumn("PurchaseOrder_Id", col("Id")) \
    .withColumn("Line_Id", col("Line_exploded.Id")) \
    .withColumn("Line_Num", col("Line_exploded.LineNum")) \
    .withColumn("DetailType", col("Line_exploded.DetailType")) \
    .withColumn("Line_Description", col("Line_exploded.Description")) \
    .withColumn("Line_Amount", col("Line_exploded.Amount")) \
    .withColumn(
        "Item_Id",
        col("Line_exploded.ItemBasedExpenseLineDetail.ItemRef.value")
    ) \
    .withColumn(
        "Item_Name",
        col("Line_exploded.ItemBasedExpenseLineDetail.ItemRef.name")
    ) \
    .withColumn(
        "Qty",
        col("Line_exploded.ItemBasedExpenseLineDetail.Qty")
    ) \
    .withColumn(
        "Unit_Price",
        col("Line_exploded.ItemBasedExpenseLineDetail.UnitPrice")
    ) \
    .withColumn(
        "Billable_Status",
        col("Line_exploded.ItemBasedExpenseLineDetail.BillableStatus")
    )

df_line = df_line.select(
    "PurchaseOrder_Id",
    "Line_Id",
    "Line_Num",
    "DetailType",
    "Item_Id",
    "Item_Name",
    "Qty",
    "Unit_Price",
    "Line_Amount",
    "Line_Description",
    "Billable_Status"
)

df_line = standardize_nulls_dynamic(df_line)

df_line.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_LINE)

print("purchase_order_line")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.purchase_raw"

SILVER_HEADER    = f"{LAKEHOUSE}.Silver.purchase_header"
SILVER_LINE      = f"{LAKEHOUSE}.Silver.purchase_line"



df = spark.table(BRONZE_TABLE)


def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    while struct_cols:
        field = struct_cols.pop(0)
        parent = field.name
        expanded = [
            col(f"{parent}.{sub.name}").alias(f"{parent}_{sub.name}")
            for sub in field.dataType.fields
        ]
        df = df.select("*", *expanded).drop(parent)
        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    return df

def standardize_nulls_dynamic(df):
    for f in df.schema.fields:
        c, dt = f.name, f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(
                    col(c).isNull()
                    | (trim(col(c)) == "")
                    | (trim(col(c)).isin("[]", "{}", "[ ]", "{ }")),
                    "NA"
                ).otherwise(col(c))
            )
        elif isinstance(dt, ArrayType):
            df = df.withColumn(
                c,
                when(col(c).isNull() | (size(col(c)) == 0), "NA")
                .otherwise(to_json(col(c)))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(c, when(col(c).isNull(), 0).otherwise(col(c)))
        elif isinstance(dt, BooleanType):
            df = df.withColumn(c, when(col(c).isNull(), False).otherwise(col(c)))
    return df


df_flat = flatten_structs(df)

# Only exclude Line array from header
cols_to_exclude = ["Line"]

df_header = (
    df_flat
    .select(*[c for c in df_flat.columns if c not in cols_to_exclude])
    .dropDuplicates(["Id"])
    .withColumnRenamed("Id", "Purchase_Id")
)


df_header = standardize_nulls_dynamic(df_header)

df_header.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_HEADER)

print(" purchase_header ")


df_line = df_flat.withColumn(
    "Line_exploded",
    explode_outer(col("Line"))
)

df_line = df_line \
    .withColumn("Purchase_Id", col("Id")) \
    .withColumn("Line_Id", col("Line_exploded.Id")) \
    .withColumn("DetailType", col("Line_exploded.DetailType")) \
    .withColumn("Line_Amount", col("Line_exploded.Amount")) \
    .withColumn("Line_Description", col("Line_exploded.Description")) \
    .withColumn(
        "Account_Id",
        when(
            col("DetailType") == "AccountBasedExpenseLineDetail",
            col("Line_exploded.AccountBasedExpenseLineDetail.AccountRef.value")
        )
    ) \
    .withColumn(
        "Account_Name",
        when(
            col("DetailType") == "AccountBasedExpenseLineDetail",
            col("Line_exploded.AccountBasedExpenseLineDetail.AccountRef.name")
        )
    ) \
    .withColumn(
        "Item_Id",
        when(
            col("DetailType") == "ItemBasedExpenseLineDetail",
            col("Line_exploded.ItemBasedExpenseLineDetail.ItemRef.value")
        )
    ) \
    .withColumn(
        "Item_Name",
        when(
            col("DetailType") == "ItemBasedExpenseLineDetail",
            col("Line_exploded.ItemBasedExpenseLineDetail.ItemRef.name")
        )
    ) \
    .withColumn(
        "Qty",
        when(
            col("DetailType") == "ItemBasedExpenseLineDetail",
            col("Line_exploded.ItemBasedExpenseLineDetail.Qty")
        )
    ) \
    .withColumn(
        "Unit_Price",
        when(
            col("DetailType") == "ItemBasedExpenseLineDetail",
            col("Line_exploded.ItemBasedExpenseLineDetail.UnitPrice")
        )
    ) \
    .withColumn(
        "Billable_Status",
        when(
            col("DetailType") == "AccountBasedExpenseLineDetail",
            col("Line_exploded.AccountBasedExpenseLineDetail.BillableStatus")
        ).otherwise(
            col("Line_exploded.ItemBasedExpenseLineDetail.BillableStatus")
        )
    ) \
    .withColumn(
        "Tax_Code",
        when(
            col("DetailType") == "AccountBasedExpenseLineDetail",
            col("Line_exploded.AccountBasedExpenseLineDetail.TaxCodeRef.value")
        ).otherwise(
            col("Line_exploded.ItemBasedExpenseLineDetail.TaxCodeRef.value")
        )
    )

df_line = df_line.select(
    "Purchase_Id",
    "Line_Id",
    "DetailType",
    "Account_Id",
    "Account_Name",
    "Item_Id",
    "Item_Name",
    "Qty",
    "Unit_Price",
    "Billable_Status",
    "Tax_Code",
    "Line_Amount",
    "Line_Description"
)

df_line = standardize_nulls_dynamic(df_line)

df_line.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_LINE)

print(" purchase_line ")




# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.refund_receipt_raw"

SILVER_HEADER = f"{LAKEHOUSE}.Silver.refund_receipt_header"
SILVER_LINE   = f"{LAKEHOUSE}.Silver.refund_receipt_line"


df = spark.table(BRONZE_TABLE)


def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    while struct_cols:
        field = struct_cols.pop(0)
        parent = field.name
        expanded = [
            col(f"{parent}.{sub.name}").alias(f"{parent}_{sub.name}")
            for sub in field.dataType.fields
        ]
        df = df.select("*", *expanded).drop(parent)
        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    return df


def standardize_nulls_dynamic(df):
    for f in df.schema.fields:
        c, dt = f.name, f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(
                    col(c).isNull()
                    | (trim(col(c)) == "")
                    | (trim(col(c)).isin("[]", "{}", "[ ]", "{ }")),
                    "NA"
                ).otherwise(col(c))
            )
        elif isinstance(dt, ArrayType):
            df = df.withColumn(
                c,
                when(col(c).isNull() | (size(col(c)) == 0), "NA")
                .otherwise(to_json(col(c)))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(c, when(col(c).isNull(), 0).otherwise(col(c)))
        elif isinstance(dt, BooleanType):
            df = df.withColumn(c, when(col(c).isNull(), False).otherwise(col(c)))
    return df

df_flat = flatten_structs(df)



cols_to_exclude = ["Line"]

df_header = (
    df_flat
    .select(*[c for c in df_flat.columns if c not in cols_to_exclude])
    .dropDuplicates(["Id"])
    .withColumnRenamed("Id", "RefundReceipt_Id")
)


df_header = standardize_nulls_dynamic(df_header)

df_header.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_HEADER)

print(" refund_receipt_header")


df_line = df_flat.withColumn(
    "Line_exploded",
    explode_outer(col("Line"))
)

df_line = df_line \
    .withColumn("RefundReceipt_Id", col("Id")) \
    .withColumn("Line_Id", col("Line_exploded.Id")) \
    .withColumn("Line_Num", col("Line_exploded.LineNum")) \
    .withColumn("DetailType", col("Line_exploded.DetailType")) \
    .withColumn("Line_Amount", col("Line_exploded.Amount")) \
    .withColumn("Line_Description", col("Line_exploded.Description")) \
    .withColumn(
        "Item_Id",
        when(
            col("DetailType") == "SalesItemLineDetail",
            col("Line_exploded.SalesItemLineDetail.ItemRef.value")
        )
    ) \
    .withColumn(
        "Item_Name",
        when(
            col("DetailType") == "SalesItemLineDetail",
            col("Line_exploded.SalesItemLineDetail.ItemRef.name")
        )
    ) \
    .withColumn(
        "Account_Id",
        when(
            col("DetailType") == "SalesItemLineDetail",
            col("Line_exploded.SalesItemLineDetail.ItemAccountRef.value")
        )
    ) \
    .withColumn(
        "Account_Name",
        when(
            col("DetailType") == "SalesItemLineDetail",
            col("Line_exploded.SalesItemLineDetail.ItemAccountRef.name")
        )
    ) \
    .withColumn(
        "Qty",
        when(
            col("DetailType") == "SalesItemLineDetail",
            col("Line_exploded.SalesItemLineDetail.Qty")
        )
    ) \
    .withColumn(
        "Unit_Price",
        when(
            col("DetailType") == "SalesItemLineDetail",
            col("Line_exploded.SalesItemLineDetail.UnitPrice")
        )
    ) \
    .withColumn(
        "Tax_Code",
        when(
            col("DetailType") == "SalesItemLineDetail",
            col("Line_exploded.SalesItemLineDetail.TaxCodeRef.value")
        )
    )

df_line = df_line.select(
    "RefundReceipt_Id",
    "Line_Id",
    "Line_Num",
    "DetailType",
    "Item_Id",
    "Item_Name",
    "Account_Id",
    "Account_Name",
    "Qty",
    "Unit_Price",
    "Tax_Code",
    "Line_Amount",
    "Line_Description"
)

df_line = standardize_nulls_dynamic(df_line)

df_line.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_LINE)

print(" refund_receipt_line ")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.sales_receipt_raw"

SILVER_HEADER = f"{LAKEHOUSE}.Silver.sales_receipt_header"
SILVER_LINE   = f"{LAKEHOUSE}.Silver.sales_receipt_line"


df = spark.table(BRONZE_TABLE)


def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    while struct_cols:
        field = struct_cols.pop(0)
        parent = field.name
        expanded = [
            col(f"{parent}.{sub.name}").alias(f"{parent}_{sub.name}")
            for sub in field.dataType.fields
        ]
        df = df.select("*", *expanded).drop(parent)
        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    return df


def standardize_nulls_dynamic(df):
    for f in df.schema.fields:
        c, dt = f.name, f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(
                    col(c).isNull()
                    | (trim(col(c)) == "")
                    | (trim(col(c)).isin("[]", "{}", "[ ]", "{ }")),
                    "NA"
                ).otherwise(col(c))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(c, when(col(c).isNull(), 0).otherwise(col(c)))
        elif isinstance(dt, BooleanType):
            df = df.withColumn(c, when(col(c).isNull(), False).otherwise(col(c)))
    return df


df_flat = flatten_structs(df)

if "LinkedTxn" in df_flat.columns:

    linked_schema = ArrayType(
        StructType([
            StructField("TxnId", StringType(), True),
            StructField("TxnType", StringType(), True)
        ])
    )

    linked_type = df_flat.schema["LinkedTxn"].dataType

    if isinstance(linked_type, StringType):
        df_flat = df_flat.withColumn(
            "Linked_arr",
            from_json(col("LinkedTxn"), linked_schema)
        )
    else:
        df_flat = df_flat.withColumn(
            "Linked_arr",
            col("LinkedTxn")
        )

    df_flat = df_flat \
        .withColumn("Linked_first", col("Linked_arr")[0]) \
        .withColumn("Linked_TxnId", col("Linked_first.TxnId")) \
        .withColumn("Linked_TxnType", col("Linked_first.TxnType")) \
        .drop("LinkedTxn", "Linked_arr", "Linked_first")

df_header = (
    df_flat
    .select(*[c for c in df_flat.columns if c != "Line"])
    .dropDuplicates(["Id"])
    .withColumnRenamed("Id", "SalesReceipt_Id")
)

df_header = standardize_nulls_dynamic(df_header)

df_header.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_HEADER)

print("sales_receipt_header")


df_line = df_flat.withColumn(
    "Line_exploded",
    explode_outer(col("Line"))
)

df_line = df_line \
    .withColumn("SalesReceipt_Id", col("Id")) \
    .withColumn("Line_Id", col("Line_exploded.Id")) \
    .withColumn("Line_Num", col("Line_exploded.LineNum")) \
    .withColumn("DetailType", col("Line_exploded.DetailType")) \
    .withColumn("Line_Amount", col("Line_exploded.Amount")) \
    .withColumn("Line_Description", col("Line_exploded.Description")) \
    .withColumn(
        "Item_Id",
        when(col("DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.ItemRef.value"))
    ) \
    .withColumn(
        "Item_Name",
        when(col("DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.ItemRef.name"))
    ) \
    .withColumn(
        "Account_Id",
        when(col("DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.ItemAccountRef.value"))
    ) \
    .withColumn(
        "Account_Name",
        when(col("DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.ItemAccountRef.name"))
    ) \
    .withColumn(
        "Qty",
        when(col("DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.Qty"))
    ) \
    .withColumn(
        "Unit_Price",
        when(col("DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.UnitPrice"))
    ) \
    .withColumn(
        "Tax_Code",
        when(col("DetailType") == "SalesItemLineDetail",
             col("Line_exploded.SalesItemLineDetail.TaxCodeRef.value"))
    )

df_line = df_line.filter(col("Line_Id").isNotNull())

df_line = df_line.select(
    "SalesReceipt_Id",
    "Line_Id",
    "Line_Num",
    "DetailType",
    "Item_Id",
    "Item_Name",
    "Account_Id",
    "Account_Name",
    "Qty",
    "Unit_Price",
    "Tax_Code",
    "Line_Amount",
    "Line_Description"
)

df_line = standardize_nulls_dynamic(df_line)

df_line.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_LINE)

print("sales_receipt_line")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.tax_code_raw"
SILVER_TABLE = f"{LAKEHOUSE}.Silver.tax_code"


df = spark.table(BRONZE_TABLE)


def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    while struct_cols:
        field = struct_cols.pop(0)
        parent = field.name
        expanded = [
            col(f"{parent}.{sub.name}").alias(f"{parent}_{sub.name}")
            for sub in field.dataType.fields
        ]
        df = df.select("*", *expanded).drop(parent)
        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]
    return df


def standardize_nulls_dynamic(df):
    for f in df.schema.fields:
        c, dt = f.name, f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(
                    col(c).isNull()
                    | (trim(col(c)) == "")
                    | (trim(col(c)).isin("[]", "{}", "[ ]", "{ }")),
                    "NA"
                ).otherwise(col(c))
            )
        elif isinstance(dt, ArrayType):
            df = df.withColumn(
                c,
                when(col(c).isNull() | (size(col(c)) == 0), "NA")
                .otherwise(to_json(col(c)))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(c, when(col(c).isNull(), 0).otherwise(col(c)))
        elif isinstance(dt, BooleanType):
            df = df.withColumn(c, when(col(c).isNull(), False).otherwise(col(c)))
    return df


df_flat = flatten_structs(df)


df_tax = df_flat.withColumn(
    "TaxRateDetail_exploded",
    explode_outer(col("SalesTaxRateList_TaxRateDetail"))
)


df_tax = df_tax.select(
    col("TaxRateDetail_exploded.TaxOrder").alias("TaxOrder"),
    col("TaxRateDetail_exploded.TaxTypeApplicable").alias("TaxTypeApplicable"),
    col("TaxRateDetail_exploded.TaxRateRef.value").alias("TaxRate_Id"),
    col("TaxRateDetail_exploded.TaxRateRef.name").alias("TaxRate_Name")
)


df_tax = standardize_nulls_dynamic(df_tax)


df_tax = df_tax.filter(col("TaxRate_Id").isNotNull()) 
    



df_tax.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_TABLE)

print("silver.tax_code ")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.term_raw"
SILVER_TABLE = f"{LAKEHOUSE}.Silver.term"

df = spark.table(BRONZE_TABLE)

def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    while struct_cols:
        field = struct_cols.pop(0)
        col_name = field.name

        expanded = [
            col(f"{col_name}.{sub.name}").alias(f"{col_name}_{sub.name}")
            for sub in field.dataType.fields
        ]

        df = df.select("*", *expanded).drop(col_name)

        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    return df


def standardize_nulls(df):
    for f in df.schema.fields:
        c = f.name
        dt = f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), "NA")
                .when(trim(col(c)) == "", "NA")
                .when(col(c).isin("{}", "[]"), "NA")
                .otherwise(col(c))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), 0).otherwise(col(c))
            )
        elif isinstance(dt, BooleanType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), False).otherwise(col(c))
            )
    return df


df_silver = flatten_structs(df)

for f in df_silver.schema.fields:
    if isinstance(f.dataType, ArrayType):
        df_silver = df_silver.withColumn(f.name, to_json(col(f.name)))

df_silver = standardize_nulls(df_silver)


df_silver.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_TABLE)

print("Silver table:", SILVER_TABLE)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.time_activity_raw"
SILVER_TABLE = f"{LAKEHOUSE}.Silver.time_activity"

df = spark.table(BRONZE_TABLE)

def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    while struct_cols:
        field = struct_cols.pop(0)
        col_name = field.name

        expanded = [
            col(f"{col_name}.{sub.name}").alias(f"{col_name}_{sub.name}")
            for sub in field.dataType.fields
        ]

        df = df.select("*", *expanded).drop(col_name)

        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    return df


def standardize_nulls(df):
    for f in df.schema.fields:
        c = f.name
        dt = f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), "NA")
                .when(trim(col(c)) == "", "NA")
                .when(col(c).isin("{}", "[]"), "NA")
                .otherwise(col(c))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), 0).otherwise(col(c))
            )
        elif isinstance(dt, BooleanType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), False).otherwise(col(c))
            )
    return df


df_silver = flatten_structs(df)

for f in df_silver.schema.fields:
    if isinstance(f.dataType, ArrayType):
        df_silver = df_silver.withColumn(f.name, to_json(col(f.name)))

df_silver = standardize_nulls(df_silver)


df_silver.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_TABLE)

print("Silver table:", SILVER_TABLE)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
from pyspark.sql.types import NumericType

spark = SparkSession.builder.getOrCreate()

LAKEHOUSE = "DLH"
BRONZE_TABLE = f"{LAKEHOUSE}.Bronze.vendor_raw"
SILVER_TABLE = f"{LAKEHOUSE}.Silver.vendor"

df = spark.table(BRONZE_TABLE)

def flatten_structs(df):
    struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    while struct_cols:
        field = struct_cols.pop(0)
        col_name = field.name

        expanded = [
            col(f"{col_name}.{sub.name}").alias(f"{col_name}_{sub.name}")
            for sub in field.dataType.fields
        ]

        df = df.select("*", *expanded).drop(col_name)

        struct_cols = [f for f in df.schema.fields if isinstance(f.dataType, StructType)]

    return df


def standardize_nulls(df):
    for f in df.schema.fields:
        c = f.name
        dt = f.dataType

        if isinstance(dt, StringType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), "NA")
                .when(trim(col(c)) == "", "NA")
                .when(col(c).isin("{}", "[]"), "NA")
                .otherwise(col(c))
            )
        elif isinstance(dt, NumericType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), 0).otherwise(col(c))
            )
        elif isinstance(dt, BooleanType):
            df = df.withColumn(
                c,
                when(col(c).isNull(), False).otherwise(col(c))
            )
    return df


df_silver = flatten_structs(df)

for f in df_silver.schema.fields:
    if isinstance(f.dataType, ArrayType):
        df_silver = df_silver.withColumn(f.name, to_json(col(f.name)))

df_silver = standardize_nulls(df_silver)


df_silver.write.mode("overwrite") \
    .option("overwriteSchema", "true") \
    .saveAsTable(SILVER_TABLE)

print("Silver table:", SILVER_TABLE)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
