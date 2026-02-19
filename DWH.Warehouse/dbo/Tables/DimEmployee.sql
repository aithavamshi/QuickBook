CREATE TABLE [dbo].[DimEmployee] (

	[EmployeeKey] int NULL, 
	[Active] bit NULL, 
	[BillableTime] bit NULL, 
	[DisplayName] varchar(30) NULL, 
	[FamilyName] varchar(30) NULL, 
	[GivenName] varchar(30) NULL, 
	[HiredDate] date NULL, 
	[Id] int NULL, 
	[PrintOnCheckName] varchar(30) NULL, 
	[PrimaryPhone_FreeFormNumber] varchar(30) NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);