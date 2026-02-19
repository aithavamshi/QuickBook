CREATE TABLE [dbo].[FactPurchaseOrderHeader] (

	[PurchaseOrderHeaderFactKey] int NULL, 
	[EmailStatus] varchar(20) NULL, 
	[PurchaseOrder_Id] int NULL, 
	[POStatus] varchar(20) NULL, 
	[TotalAmt] float NULL, 
	[TxnDate] date NULL, 
	[VendorKey] int NULL, 
	[AccountKey] int NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);