CREATE TABLE [dbo].[DimTaxcode] (

	[TaxcodeKey] int NULL, 
	[TaxTypeApplicable] varchar(40) NULL, 
	[TaxRate_Id] int NULL, 
	[TaxRate_Name] varchar(40) NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);