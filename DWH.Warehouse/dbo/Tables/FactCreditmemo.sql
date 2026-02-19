CREATE TABLE [dbo].[FactCreditmemo] (

	[CreditmemoFactKey] int NULL, 
	[Balance] int NULL, 
	[EmailStatus] varchar(30) NULL, 
	[FreeFormAddress] varchar(30) NULL, 
	[Id] int NULL, 
	[PrintStatus] varchar(30) NULL, 
	[RemainingCredit] int NULL, 
	[TotalAmt] float NULL, 
	[TxnDate] date NULL, 
	[TxnTaxDetail_TotalTax] float NULL, 
	[Line_Id] int NULL, 
	[Line_Num] int NULL, 
	[Line_Amount] float NULL, 
	[Line_Description] varchar(30) NULL, 
	[Line_DetailType] varchar(30) NULL, 
	[Tax_Code] varchar(30) NULL, 
	[CustomerKey] int NULL, 
	[AccountKey] int NULL, 
	[ItemKey] int NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);