CREATE TABLE [dbo].[DimAccount] (

	[AccountKey] int NULL, 
	[Id] int NULL, 
	[Name] varchar(50) NULL, 
	[FullyQualifiedName] varchar(100) NULL, 
	[AccountSubType] varchar(80) NULL, 
	[SubAccount] bit NULL, 
	[Active] bit NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);