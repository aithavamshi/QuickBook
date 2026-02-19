CREATE TABLE [dbo].[FactPaymentHeader] (

	[PaymentHeaderFactKey] int NULL, 
	[Payment_Id] int NULL, 
	[PaymentRefNum] int NULL, 
	[PrivateNote] varchar(50) NULL, 
	[ProcessPayment] bit NULL, 
	[TotalAmt] float NULL, 
	[TxnDate] date NULL, 
	[CustomerKey] int NULL, 
	[PaymentMethodKey] int NULL, 
	[AccountKey] int NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);