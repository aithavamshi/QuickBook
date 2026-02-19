CREATE TABLE [dbo].[FactRefundReceiptLine] (

	[RefundReceiptLineKey] int NULL, 
	[Line_Id] int NULL, 
	[Line_Num] int NULL, 
	[DetailType] varchar(40) NULL, 
	[ItemKey] int NULL, 
	[AccountKey] int NULL, 
	[RefundReceiptHeaderKey] int NULL, 
	[Tax_Code] varchar(30) NULL, 
	[Line_Amount] float NULL, 
	[Line_Description] varchar(40) NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);