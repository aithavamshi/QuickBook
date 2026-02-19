CREATE TABLE [dbo].[FactBillPayment] (

	[BillPaymentFactKey] int NULL, 
	[Id] int NULL, 
	[PayType] varchar(30) NULL, 
	[TotalAmt] float NULL, 
	[TxnDate] date NULL, 
	[CheckPayment_PrintStatus] varchar(30) NULL, 
	[VendorKey] int NULL, 
	[AccountKey] int NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);