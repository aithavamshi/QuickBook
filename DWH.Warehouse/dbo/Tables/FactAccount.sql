CREATE TABLE [dbo].[FactAccount] (

	[AccountFactKey] int NULL, 
	[CurrentBalance] int NULL, 
	[CurrentBalanceWithSubAccounts] float NULL, 
	[ClassificationKey] float NULL, 
	[AccountTypeKey] int NULL, 
	[AccountKey] int NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);