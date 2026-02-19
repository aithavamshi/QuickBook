CREATE TABLE [dbo].[DimItem] (

	[ItemKey] int NULL, 
	[Active] bit NULL, 
	[Description] varchar(80) NULL, 
	[FullyQualifiedName] varchar(60) NULL, 
	[Id] int NULL, 
	[Name] varchar(40) NULL, 
	[PurchaseCost] float NULL, 
	[PurchaseDesc] varchar(70) NULL, 
	[Taxable] bit NULL, 
	[Type] varchar(40) NULL, 
	[UnitPrice] int NULL, 
	[AssetAccountRef_name] varchar(40) NULL, 
	[AssetAccountRef_value] int NULL, 
	[ExpenseAccountRef_name] varchar(40) NULL, 
	[ExpenseAccountRef_value] int NULL, 
	[IncomeAccountRef_name] varchar(40) NULL, 
	[IncomeAccountRef_value] int NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);