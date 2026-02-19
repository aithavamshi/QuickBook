CREATE TABLE [dbo].[FactPurchaseHeader] (

	[PurchaseHeaderFactKey] int NULL, 
	[Credit] bit NULL, 
	[Purchase_Id] int NULL, 
	[PaymentType] varchar(30) NULL, 
	[PrintStatus] varchar(30) NULL, 
	[TotalAmt] float NULL, 
	[TxnDate] date NULL, 
	[VendorKey] int NULL, 
	[AccountKey] int NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);