CREATE TABLE [dbo].[FactPaymentLine] (

	[PaymentLineFactKey] int NULL, 
	[Line_Num] int NULL, 
	[Line_Amount] float NULL, 
	[Line_DetailType] varchar(40) NULL, 
	[PaymentHeaderKey] int NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);