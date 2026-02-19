CREATE TABLE [dbo].[DimPaymentMethod] (

	[PaymentMethodKey] int NULL, 
	[Active] bit NULL, 
	[Id] int NULL, 
	[Name] varchar(40) NULL, 
	[Type] varchar(40) NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);