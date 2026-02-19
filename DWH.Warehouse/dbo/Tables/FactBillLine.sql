CREATE TABLE [dbo].[FactBillLine] (

	[BillLineFactKey] int NULL, 
	[Line_Id] int NULL, 
	[Line_Num] int NULL, 
	[Line_DetailType] varchar(50) NULL, 
	[Line_Amount] float NULL, 
	[Line_Description] varchar(60) NULL, 
	[Billable_Status] varchar(60) NULL, 
	[Tax_Code] varchar(30) NULL, 
	[CustomerKey] int NULL, 
	[BillHeaderFactKey] int NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);