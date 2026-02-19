CREATE TABLE [dbo].[FactSalesReceiptLine] (

	[SalesReceiptLineFactKey] int NULL, 
	[Line_Id] int NULL, 
	[Line_Num] int NULL, 
	[DetailType] varchar(40) NULL, 
	[Line_Amount] float NULL, 
	[Line_Description] varchar(40) NULL, 
	[ItemKey] int NULL, 
	[SalesReceiptHeaderFactKey] int NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);