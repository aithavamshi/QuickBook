CREATE TABLE [dbo].[FactInvoiceHerader] (

	[InvoiceHeaderFactKey] int NULL, 
	[Balance] float NULL, 
	[DueDate] date NULL, 
	[EmailStatus] varchar(40) NULL, 
	[FreeFormAddress] bit NULL, 
	[Invoice_Id] int NULL, 
	[PrintStatus] varchar(40) NULL, 
	[PrivateNote] varchar(40) NULL, 
	[TotalAmt] float NULL, 
	[TxnDate] date NULL, 
	[DeliveryInfo_DeliveryType] varchar(40) NULL, 
	[TxnTaxDetail_TotalTax] float NULL, 
	[Tax_Amount] float NULL, 
	[Tax_NetAmountTaxable] float NULL, 
	[Tax_Percent] float NULL, 
	[TaxcodeKey] int NULL, 
	[CustomerKey] int NULL, 
	[TermKey] int NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);