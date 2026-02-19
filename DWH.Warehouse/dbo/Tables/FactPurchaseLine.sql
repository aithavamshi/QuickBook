CREATE TABLE [dbo].[FactPurchaseLine] (

	[PurchaseLineFactKey] int NULL, 
	[Line_Id] int NULL, 
	[DetailType] varchar(40) NULL, 
	[Billable_Status] varchar(40) NULL, 
	[Tax_Code] varchar(20) NULL, 
	[Line_Amount] float NULL, 
	[Line_Description] varchar(40) NULL, 
	[ItemKey] int NULL, 
	[Qty] int NULL, 
	[PurchaseHeaderFactKey] int NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);