CREATE TABLE [dbo].[FactRefundReceiptHeader] (

	[RefundReceiptHeaderKey] int NULL, 
	[Balance] int NULL, 
	[RefundReceipt_Id] int NULL, 
	[PrintStatus] varchar(30) NULL, 
	[TotalAmt] float NULL, 
	[TxnDate] date NULL, 
	[CustomerKey] int NULL, 
	[AccountKey] int NULL, 
	[PaymentMethodKey] int NULL, 
	[TxnTaxDetail_TotalTax] int NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);