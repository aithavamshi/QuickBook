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

import json
import requests
import base64
from pyspark.sql.functions import current_timestamp, lit


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************



CLIENT_ID = "AB9ZiXcwHxLTXPcQfhROmlhLmz3KFeOYiRX0V62Dwjxv8ACN9u"
CLIENT_SECRET = "n5uhhx2iKDLcIaTmjy0SFHW0ociTNJHFcpStomcS"

ACCESS_TOKEN = "eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwieC5vcmciOiJIMCJ9..mv6vb5dS83Jy4VjjMaZyOg.hZO9rRz2vc9G2dd9EOsp_givlLIVdS6MNrVRafPVy10vKRrBk8N5xpHfMbEkG1kegt_XbJQHVdGrKzfZuzngsDMDdWlFHE8x2xlzWWi2_IxonYATbiJQmxh6Ibh2pDvbLiVnCSezFAuGYWE3XlLVn3VVPoPB4_jVERqBwuBlSSnUgxyS2sEZHqaP1pjqXF4Zy1Fhc6blrhgq-JnCpqZ4EgOMzXTjLE77Qfx9jEa3jFIrUKdBqirlksAHJmvh08sREc8zu3NGP6Gr1mIzFvcw0nuh8LdaqWOcxzLKI5TUNUNGFKPG5ybkSqg5xNVruERCGNaz81CoRC-yUiRmew8MVAkiHxLDSPRg-C9FCFaRjgmNsJeHu9rODb3tKH9XRSJgXRv9laxE6NaWtb2q6rEIaW301lFzGdlcCg3QojDSoNBqPteGcFtbVekOf8ovNc5K1xvnLFiPIPq7uWpCOtJkB_TYKSOuOcsxjtptb10-f7wDFJqzw0DIm8nfpYGwKxpb.m21rZUqUFDK7hDdGhosAyQ"    
REFRESH_TOKEN = "RT1-250-H0-17765939691yvd4mh452syse2snoja"


COMPANY_ID = "9341456053311766"


LAKEHOUSE_NAME = "DLH"
BRONZE_SCHEMA = "Bronze"


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

def bronze_table(table_name):
    return f"{LAKEHOUSE_NAME}.{BRONZE_SCHEMA}.{table_name}"


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

def refresh_access_token(client_id, client_secret, refresh_token):
    token_url = "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer"

    auth_string = f"{client_id}:{client_secret}"
    auth_encoded = base64.b64encode(auth_string.encode()).decode()

    headers = {
        "Authorization": f"Basic {auth_encoded}",
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "application/json"
    }

    data = {
        "grant_type": "refresh_token",
        "refresh_token": refresh_token
    }

    response = requests.post(token_url, headers=headers, data=data)

    if response.status_code != 200:
        raise Exception(f"Token refresh failed: {response.text}")

    return response.json()


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

token_response = refresh_access_token(
    CLIENT_ID,
    CLIENT_SECRET,
    REFRESH_TOKEN
)

ACCESS_TOKEN = token_response["access_token"]
REFRESH_TOKEN = token_response["refresh_token"]

BASE_URL = f"https://sandbox-quickbooks.api.intuit.com/v3/company/{COMPANY_ID}"

HEADERS = {
    "Authorization": f"Bearer {ACCESS_TOKEN}",
    "Accept": "application/json",
    "Content-Type": "application/json"
}

print("Access token refreshed successfully")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

def qb_query(query):
    url = f"{BASE_URL}/query"
    params = {"query": query}

    response = requests.get(url, headers=HEADERS, params=params)

    if response.status_code != 200:
        raise Exception(f"QuickBooks API Error: {response.status_code} - {response.text}")

    return response.json()


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

def ingest_qb_entity(entity_name, query, target_table):
    qb_json = qb_query(query)
    records = qb_json["QueryResponse"].get(entity_name, [])

    if not records:
        print(f"No records found for {entity_name}")
        return

    
    json_str = json.dumps(records)

    df = spark.read.json(
        spark.sparkContext.parallelize([json_str])
    )

    df = (
        df
        .withColumn("ingestion_timestamp", current_timestamp())
        .withColumn("source_system", lit("QuickBooks"))
    )

    (
        df.write
        .format("delta")
        .mode("overwrite")  
        .saveAsTable(bronze_table(target_table))
    )

    print(f" Loaded {entity_name} → {bronze_table(target_table)}")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

ingest_qb_entity(
    entity_name="Customer",
    query="select * from Customer",
    target_table="customer_raw"
)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

ingest_qb_entity(
    entity_name="Vendor",
    query="select * from Vendor",
    target_table="vendor_raw"
)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

ingest_qb_entity(
    entity_name="Invoice",
    query="select * from Invoice",
    target_table="invoice_raw"
)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

ingest_qb_entity(
    entity_name="Payment",
    query="select * from Payment",
    target_table="payment_raw"
)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

ingest_qb_entity(
    entity_name="Account",
    query="select * from Account",
    target_table="account_raw"
)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

ingest_qb_entity(
    entity_name="Bill",
    query="select * from Bill",
    target_table="bill_raw"
)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

ingest_qb_entity(
    entity_name="Item",
    query="select * from Item",
    target_table="item_raw"
)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

ingest_qb_entity(
    entity_name="JournalEntry",
    query="select * from JournalEntry",
    target_table="journal_entry_raw"
)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************



qb_entities = [
    # Master Data 
    ("Customer", "select * from Customer", "customer_raw"),
    ("Vendor", "select * from Vendor", "vendor_raw"),
    ("Employee", "select * from Employee", "employee_raw"),
    ("Account", "select * from Account", "account_raw"),
    ("Item", "select * from Item", "item_raw"),
    ("Class", "select * from Class", "class_raw"),
    ("Department", "select * from Department", "department_raw"),
    ("Term", "select * from Term", "term_raw"),
    ("PaymentMethod", "select * from PaymentMethod", "payment_method_raw"),

    # Sales / AR 
    ("Invoice", "select * from Invoice", "invoice_raw"),
    ("Payment", "select * from Payment", "payment_raw"),
    ("SalesReceipt", "select * from SalesReceipt", "sales_receipt_raw"),
    ("CreditMemo", "select * from CreditMemo", "credit_memo_raw"),
    ("Estimate", "select * from Estimate", "estimate_raw"),
    ("RefundReceipt", "select * from RefundReceipt", "refund_receipt_raw"),

    # Purchasing / AP 
    ("Bill", "select * from Bill", "bill_raw"),
    ("BillPayment", "select * from BillPayment", "bill_payment_raw"),
    ("VendorCredit", "select * from VendorCredit", "vendor_credit_raw"),
    ("Purchase", "select * from Purchase", "purchase_raw"),
    ("PurchaseOrder", "select * from PurchaseOrder", "purchase_order_raw"),

    # Accounting / GL 
    ("JournalEntry", "select * from JournalEntry", "journal_entry_raw"),
    ("TaxCode", "select * from TaxCode", "tax_code_raw"),
    ("Budget", "select * from Budget", "budget_raw"),

    # Banking
    ("Deposit", "select * from Deposit", "deposit_raw"),
    ("Transfer", "select * from Transfer", "transfer_raw"),

    # Company / Metadata 
    ("CompanyInfo", "select * from CompanyInfo", "company_info_raw"),
    ("Preferences", "select * from Preferences", "preferences_raw"),
    ("TimeActivity", "select * from TimeActivity", "time_activity_raw"),
    ("Attachable", "select * from Attachable", "attachable_raw"),
    ("ExchangeRate", "select * from ExchangeRate", "exchange_rate_raw"),
]


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************



for entity_name, query, table_name in qb_entities:
    try:
        ingest_qb_entity(
            entity_name=entity_name,
            query=query,
            target_table=table_name
        )
    except Exception as e:
        print(f"Skipped {entity_name}: {str(e)}")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
