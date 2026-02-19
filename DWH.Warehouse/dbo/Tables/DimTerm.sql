CREATE TABLE [dbo].[DimTerm] (

	[TermKey] int NULL, 
	[Active] bit NULL, 
	[DueDays] int NULL, 
	[Id] int NULL, 
	[Name] varchar(40) NULL, 
	[Type] varchar(40) NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);