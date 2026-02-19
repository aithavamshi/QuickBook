CREATE TABLE [dbo].[FactTimeActivity] (

	[TimeActivityKey] int NULL, 
	[BillableStatus] varchar(30) NULL, 
	[CostRate] float NULL, 
	[HourlyRate] int NULL, 
	[Hours] int NULL, 
	[Id] int NULL, 
	[Minutes] int NULL, 
	[NameOf] varchar(30) NULL, 
	[Seconds] int NULL, 
	[Taxable] bit NULL, 
	[TimeChargeId] int NULL, 
	[TxnDate] date NULL, 
	[CustomerKey] int NULL, 
	[EmployeeKey] int NULL, 
	[ItemKey] int NULL, 
	[InsertDate] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL
);