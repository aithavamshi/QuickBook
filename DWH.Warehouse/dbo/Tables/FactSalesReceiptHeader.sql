CREATE TABLE [dbo].[FactSalesReceiptHeader] (

	[SalesReceiptHeaderFactKey] int NULL, 
	[ApplyTaxAfterDiscount] bit NULL, 
	[Balance] int NULL, 
	[EmailStatus] varchar(40) NULL, 
	[FreeFormAddress] bit NULL, 
	[SalesReceipt_Id] int NULL, 
	[PaymentRefNum] varchar(40) NULL, 
	[PrintStatus] varchar(40) NULL, 
	[TotalAmt] float NULL, 
	[TxnDate] date NULL, 
	[TxnTaxDetail_TotalTax] float NULL, 
	[CustomerKey] int NULL, 
	[PaymentMethodKey] int NULL, 
	[AccountKey] int NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);