CREATE TABLE [dbo].[FactBillHeader] (

	[BillHeaderFactKey] int NULL, 
	[Balance] float NULL, 
	[DueDate] date NULL, 
	[Bill_Id] int NULL, 
	[PrivateNote] varchar(40) NULL, 
	[TotalAmt] float NULL, 
	[TxnDate] date NULL, 
	[VendorKey] int NULL, 
	[AccountKey] int NULL, 
	[TermKey] int NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);