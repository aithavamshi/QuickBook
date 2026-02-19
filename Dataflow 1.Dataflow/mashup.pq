[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver account_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "AccountSubType", DestinationColumnName = "AccountSubType"], [SourceColumnName = "AccountType", DestinationColumnName = "AccountType"], [SourceColumnName = "Active", DestinationColumnName = "Active"], [SourceColumnName = "Classification", DestinationColumnName = "Classification"], [SourceColumnName = "CurrentBalance", DestinationColumnName = "CurrentBalance"], [SourceColumnName = "CurrentBalanceWithSubAccounts", DestinationColumnName = "CurrentBalanceWithSubAccounts"], [SourceColumnName = "FullyQualifiedName", DestinationColumnName = "FullyQualifiedName"], [SourceColumnName = "Id", DestinationColumnName = "Id"], [SourceColumnName = "Name", DestinationColumnName = "Name"], [SourceColumnName = "SubAccount", DestinationColumnName = "SubAccount"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver account" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.account", ItemKind = "Table"]}[Data]
in
  #"Navigation 2";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver bill_header_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Balance", DestinationColumnName = "Balance"], [SourceColumnName = "DueDate", DestinationColumnName = "DueDate"], [SourceColumnName = "Bill_Id", DestinationColumnName = "Bill_Id"], [SourceColumnName = "PrivateNote", DestinationColumnName = "PrivateNote"], [SourceColumnName = "TotalAmt", DestinationColumnName = "TotalAmt"], [SourceColumnName = "TxnDate", DestinationColumnName = "TxnDate"], [SourceColumnName = "APAccountRef_name", DestinationColumnName = "APAccountRef_name"], [SourceColumnName = "APAccountRef_value", DestinationColumnName = "APAccountRef_value"], [SourceColumnName = "SalesTermRef_value", DestinationColumnName = "SalesTermRef_value"], [SourceColumnName = "VendorAddr_City", DestinationColumnName = "VendorAddr_City"], [SourceColumnName = "VendorAddr_CountrySubDivisionCode", DestinationColumnName = "VendorAddr_CountrySubDivisionCode"], [SourceColumnName = "VendorAddr_Id", DestinationColumnName = "VendorAddr_Id"], [SourceColumnName = "VendorAddr_Lat", DestinationColumnName = "VendorAddr_Lat"], [SourceColumnName = "VendorAddr_Line1", DestinationColumnName = "VendorAddr_Line1"], [SourceColumnName = "VendorAddr_Long", DestinationColumnName = "VendorAddr_Long"], [SourceColumnName = "VendorAddr_PostalCode", DestinationColumnName = "VendorAddr_PostalCode"], [SourceColumnName = "VendorRef_name", DestinationColumnName = "VendorRef_name"], [SourceColumnName = "VendorRef_value", DestinationColumnName = "VendorRef_value"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver bill_header" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.bill_header", ItemKind = "Table"]}[Data],
  #"Replaced value" = Table.ReplaceValue(#"Navigation 2", "NA", "0", Replacer.ReplaceText, {"DueDate", "Bill_Id", "SyncToken", "TxnDate", "APAccountRef_value", "SalesTermRef_value"}),
  #"Changed column type" = Table.TransformColumnTypes(#"Replaced value", {{"SalesTermRef_value", Int64.Type}}),
  #"Replaced value 1" = Table.ReplaceValue(#"Changed column type", "NA", "0", Replacer.ReplaceText, {"VendorAddr_Id"}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Replaced value 1", {{"VendorAddr_Id", Int64.Type}}),
  #"Replaced value 2" = Table.ReplaceValue(#"Changed column type 1", "NA", "0.00", Replacer.ReplaceText, {"VendorAddr_Lat"}),
  #"Changed column type 2" = Table.TransformColumnTypes(#"Replaced value 2", {{"VendorAddr_Lat", type number}}),
  #"Replaced value 3" = Table.ReplaceValue(#"Changed column type 2", "NA", "0.0", Replacer.ReplaceText, {"VendorAddr_Long"}),
  #"Changed column type 3" = Table.TransformColumnTypes(#"Replaced value 3", {{"VendorAddr_Long", type number}}),
  #"Replaced value 4" = Table.ReplaceValue(#"Changed column type 3", "NA", "00000", Replacer.ReplaceText, {"VendorAddr_PostalCode"}),
  #"Changed column type 4" = Table.TransformColumnTypes(#"Replaced value 4", {{"VendorAddr_PostalCode", Int64.Type}, {"VendorRef_value", Int64.Type}})
in
  #"Changed column type 4";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver bill_line_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Bill_Id", DestinationColumnName = "Bill_Id"], [SourceColumnName = "Line_Id", DestinationColumnName = "Line_Id"], [SourceColumnName = "Line_Num", DestinationColumnName = "Line_Num"], [SourceColumnName = "Line_DetailType", DestinationColumnName = "Line_DetailType"], [SourceColumnName = "Line_Amount", DestinationColumnName = "Line_Amount"], [SourceColumnName = "Line_Description", DestinationColumnName = "Line_Description"], [SourceColumnName = "Account_Id", DestinationColumnName = "Account_Id"], [SourceColumnName = "Account_Name", DestinationColumnName = "Account_Name"], [SourceColumnName = "Customer_Id", DestinationColumnName = "Customer_Id"], [SourceColumnName = "Customer_Name", DestinationColumnName = "Customer_Name"], [SourceColumnName = "Billable_Status", DestinationColumnName = "Billable_Status"], [SourceColumnName = "Tax_Code", DestinationColumnName = "Tax_Code"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver bill_line" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.bill_line", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"Bill_Id", Int64.Type}, {"Line_Id", Int64.Type}}),
  #"Replaced value" = Table.ReplaceValue(#"Changed column type", "NA", "0", Replacer.ReplaceText, {"Account_Id"}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Replaced value", {{"Account_Id", Int64.Type}}),
  #"Replaced value 1" = Table.ReplaceValue(#"Changed column type 1", "NA", "0", Replacer.ReplaceText, {"Customer_Id"}),
  #"Changed column type 2" = Table.TransformColumnTypes(#"Replaced value 1", {{"Customer_Id", Int64.Type}})
in
  #"Changed column type 2";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver bill_payment_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Id", DestinationColumnName = "Id"], [SourceColumnName = "PayType", DestinationColumnName = "PayType"], [SourceColumnName = "TotalAmt", DestinationColumnName = "TotalAmt"], [SourceColumnName = "TxnDate", DestinationColumnName = "TxnDate"], [SourceColumnName = "CheckPayment_PrintStatus", DestinationColumnName = "CheckPayment_PrintStatus"], [SourceColumnName = "VendorRef_name", DestinationColumnName = "VendorRef_name"], [SourceColumnName = "VendorRef_value", DestinationColumnName = "VendorRef_value"], [SourceColumnName = "CheckPayment_BankAccountRef_name", DestinationColumnName = "CheckPayment_BankAccountRef_name"], [SourceColumnName = "CheckPayment_BankAccountRef_value", DestinationColumnName = "CheckPayment_BankAccountRef_value"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver bill_payment" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.bill_payment", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"DocNumber", Int64.Type}, {"Id", Int64.Type}, {"SyncToken", Int64.Type}, {"VendorRef_value", Int64.Type}}),
  #"Replaced value" = Table.ReplaceValue(#"Changed column type", "NA", "0", Replacer.ReplaceText, {"CheckPayment_BankAccountRef_value"}),
  #"Replaced value 1" = Table.ReplaceValue(#"Replaced value", "NA", "0", Replacer.ReplaceText, {"CreditCardPayment_CCAccountRef_value"}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Replaced value 1", {{"CreditCardPayment_CCAccountRef_value", Int64.Type}}),
  #"Replaced value 2" = Table.ReplaceValue(#"Changed column type 1", "NA", "0", Replacer.ReplaceText, {"CheckPayment_BankAccountRef_value"}),
  #"Changed column type 2" = Table.TransformColumnTypes(#"Replaced value 2", {{"CheckPayment_BankAccountRef_value", Int64.Type}})
in
  #"Changed column type 2";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver customer_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Active", DestinationColumnName = "Active"], [SourceColumnName = "Balance", DestinationColumnName = "Balance"], [SourceColumnName = "BalanceWithJobs", DestinationColumnName = "BalanceWithJobs"], [SourceColumnName = "BillWithParent", DestinationColumnName = "BillWithParent"], [SourceColumnName = "ClientEntityId", DestinationColumnName = "ClientEntityId"], [SourceColumnName = "CompanyName", DestinationColumnName = "CompanyName"], [SourceColumnName = "DisplayName", DestinationColumnName = "DisplayName"], [SourceColumnName = "FamilyName", DestinationColumnName = "FamilyName"], [SourceColumnName = "FullyQualifiedName", DestinationColumnName = "FullyQualifiedName"], [SourceColumnName = "GivenName", DestinationColumnName = "GivenName"], [SourceColumnName = "Id", DestinationColumnName = "Id"], [SourceColumnName = "IsProject", DestinationColumnName = "IsProject"], [SourceColumnName = "Job", DestinationColumnName = "Job"], [SourceColumnName = "Level", DestinationColumnName = "Level"], [SourceColumnName = "MiddleName", DestinationColumnName = "MiddleName"], [SourceColumnName = "PreferredDeliveryMethod", DestinationColumnName = "PreferredDeliveryMethod"], [SourceColumnName = "PrintOnCheckName", DestinationColumnName = "PrintOnCheckName"], [SourceColumnName = "Taxable", DestinationColumnName = "Taxable"], [SourceColumnName = "BillAddr_City", DestinationColumnName = "BillAddr_City"], [SourceColumnName = "BillAddr_Country", DestinationColumnName = "BillAddr_Country"], [SourceColumnName = "BillAddr_CountrySubDivisionCode", DestinationColumnName = "BillAddr_CountrySubDivisionCode"], [SourceColumnName = "BillAddr_Id", DestinationColumnName = "BillAddr_Id"], [SourceColumnName = "BillAddr_Lat", DestinationColumnName = "BillAddr_Lat"], [SourceColumnName = "BillAddr_Line1", DestinationColumnName = "BillAddr_Line1"], [SourceColumnName = "BillAddr_Long", DestinationColumnName = "BillAddr_Long"], [SourceColumnName = "BillAddr_PostalCode", DestinationColumnName = "BillAddr_PostalCode"], [SourceColumnName = "CurrencyRef_name", DestinationColumnName = "CurrencyRef_name"], [SourceColumnName = "CurrencyRef_value", DestinationColumnName = "CurrencyRef_value"], [SourceColumnName = "Mobile_FreeFormNumber", DestinationColumnName = "Mobile_FreeFormNumber"], [SourceColumnName = "PrimaryEmailAddr_Address", DestinationColumnName = "PrimaryEmailAddr_Address"], [SourceColumnName = "PrimaryPhone_FreeFormNumber", DestinationColumnName = "PrimaryPhone_FreeFormNumber"], [SourceColumnName = "ShipAddr_City", DestinationColumnName = "ShipAddr_City"], [SourceColumnName = "ShipAddr_Country", DestinationColumnName = "ShipAddr_Country"], [SourceColumnName = "ShipAddr_CountrySubDivisionCode", DestinationColumnName = "ShipAddr_CountrySubDivisionCode"], [SourceColumnName = "ShipAddr_Id", DestinationColumnName = "ShipAddr_Id"], [SourceColumnName = "ShipAddr_Lat", DestinationColumnName = "ShipAddr_Lat"], [SourceColumnName = "ShipAddr_Line1", DestinationColumnName = "ShipAddr_Line1"], [SourceColumnName = "ShipAddr_Long", DestinationColumnName = "ShipAddr_Long"], [SourceColumnName = "ShipAddr_PostalCode", DestinationColumnName = "ShipAddr_PostalCode"], [SourceColumnName = "WebAddr_URI", DestinationColumnName = "WebAddr_URI"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver customer" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.customer", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"ClientEntityId", Int64.Type}, {"Id", Int64.Type}, {"SyncToken", Int64.Type}}),
  #"Replaced value" = Table.ReplaceValue(#"Changed column type", "NA", "0", Replacer.ReplaceText, {"BillAddr_Id"}),
  #"Replaced value 1" = Table.ReplaceValue(#"Replaced value", "NA", "0.00", Replacer.ReplaceText, {"BillAddr_Lat"}),
  #"Replaced value 2" = Table.ReplaceValue(#"Replaced value 1", "INVALID", "0.00", Replacer.ReplaceText, {"BillAddr_Lat"}),
  #"Replaced value 3" = Table.ReplaceValue(#"Replaced value 2", "INVALID", "0.00", Replacer.ReplaceText, {"BillAddr_Long"}),
  #"Replaced value 4" = Table.ReplaceValue(#"Replaced value 3", "NA", "0.00", Replacer.ReplaceText, {"BillAddr_Long"}),
  #"Replaced value 5" = Table.ReplaceValue(#"Replaced value 4", "NA", "00000", Replacer.ReplaceText, {"BillAddr_PostalCode"}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Replaced value 5", {{"BillAddr_Lat", type number}, {"BillAddr_Long", type number}, {"BillAddr_PostalCode", Int64.Type}}),
  #"Replaced value 6" = Table.ReplaceValue(#"Changed column type 1", "NA", "0", Replacer.ReplaceText, {"ShipAddr_Id"}),
  #"Replaced value 7" = Table.ReplaceValue(#"Replaced value 6", "INVALID", "0.00", Replacer.ReplaceText, {"ShipAddr_Lat"}),
  #"Replaced value 8" = Table.ReplaceValue(#"Replaced value 7", "NA", "0.00", Replacer.ReplaceText, {"ShipAddr_Lat"}),
  #"Replaced value 9" = Table.ReplaceValue(#"Replaced value 8", "INVALID", "0.00", Replacer.ReplaceText, {"ShipAddr_Long"}),
  #"Replaced value 10" = Table.ReplaceValue(#"Replaced value 9", "NA", "0.00", Replacer.ReplaceText, {"ShipAddr_Long"}),
  #"Replaced value 11" = Table.ReplaceValue(#"Replaced value 10", "NA", "00000", Replacer.ReplaceText, {"ShipAddr_PostalCode"}),
  #"Changed column type 2" = Table.TransformColumnTypes(#"Replaced value 11", {{"ShipAddr_PostalCode", Int64.Type}, {"ShipAddr_Long", type number}, {"ShipAddr_Lat", type number}, {"ShipAddr_Id", Int64.Type}, {"BillAddr_Id", Int64.Type}})
in
  #"Changed column type 2";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver employee_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Active", DestinationColumnName = "Active"], [SourceColumnName = "BillableTime", DestinationColumnName = "BillableTime"], [SourceColumnName = "DisplayName", DestinationColumnName = "DisplayName"], [SourceColumnName = "FamilyName", DestinationColumnName = "FamilyName"], [SourceColumnName = "GivenName", DestinationColumnName = "GivenName"], [SourceColumnName = "HiredDate", DestinationColumnName = "HiredDate"], [SourceColumnName = "Id", DestinationColumnName = "Id"], [SourceColumnName = "PrintOnCheckName", DestinationColumnName = "PrintOnCheckName"], [SourceColumnName = "PrimaryPhone_FreeFormNumber", DestinationColumnName = "PrimaryPhone_FreeFormNumber"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver employee" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.employee", ItemKind = "Table"]}[Data],
  #"Replaced value" = Table.ReplaceValue(#"Navigation 2", "NA", "1999-01-01", Replacer.ReplaceText, {"HiredDate"}),
  #"Changed column type" = Table.TransformColumnTypes(#"Replaced value", {{"HiredDate", type date}, {"Id", Int64.Type}, {"SyncToken", Int64.Type}})
in
  #"Changed column type";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver invoice_header_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Balance", DestinationColumnName = "Balance"], [SourceColumnName = "DueDate", DestinationColumnName = "DueDate"], [SourceColumnName = "EmailStatus", DestinationColumnName = "EmailStatus"], [SourceColumnName = "FreeFormAddress", DestinationColumnName = "FreeFormAddress"], [SourceColumnName = "Invoice_Id", DestinationColumnName = "Invoice_Id"], [SourceColumnName = "PrintStatus", DestinationColumnName = "PrintStatus"], [SourceColumnName = "PrivateNote", DestinationColumnName = "PrivateNote"], [SourceColumnName = "TotalAmt", DestinationColumnName = "TotalAmt"], [SourceColumnName = "TxnDate", DestinationColumnName = "TxnDate"], [SourceColumnName = "BillAddr_Id", DestinationColumnName = "BillAddr_Id"], [SourceColumnName = "BillAddr_Lat", DestinationColumnName = "BillAddr_Lat"], [SourceColumnName = "BillAddr_Line1", DestinationColumnName = "BillAddr_Line1"], [SourceColumnName = "BillAddr_Line2", DestinationColumnName = "BillAddr_Line2"], [SourceColumnName = "BillAddr_Line3", DestinationColumnName = "BillAddr_Line3"], [SourceColumnName = "BillAddr_Line4", DestinationColumnName = "BillAddr_Line4"], [SourceColumnName = "BillAddr_Long", DestinationColumnName = "BillAddr_Long"], [SourceColumnName = "BillEmail_Address", DestinationColumnName = "BillEmail_Address"], [SourceColumnName = "CustomerRef_name", DestinationColumnName = "CustomerRef_name"], [SourceColumnName = "CustomerRef_value", DestinationColumnName = "CustomerRef_value"], [SourceColumnName = "DeliveryInfo_DeliveryType", DestinationColumnName = "DeliveryInfo_DeliveryType"], [SourceColumnName = "SalesTermRef_name", DestinationColumnName = "SalesTermRef_name"], [SourceColumnName = "SalesTermRef_value", DestinationColumnName = "SalesTermRef_value"], [SourceColumnName = "ShipAddr_City", DestinationColumnName = "ShipAddr_City"], [SourceColumnName = "ShipAddr_CountrySubDivisionCode", DestinationColumnName = "ShipAddr_CountrySubDivisionCode"], [SourceColumnName = "ShipAddr_Id", DestinationColumnName = "ShipAddr_Id"], [SourceColumnName = "ShipAddr_Lat", DestinationColumnName = "ShipAddr_Lat"], [SourceColumnName = "ShipAddr_Line1", DestinationColumnName = "ShipAddr_Line1"], [SourceColumnName = "ShipAddr_Long", DestinationColumnName = "ShipAddr_Long"], [SourceColumnName = "ShipAddr_PostalCode", DestinationColumnName = "ShipAddr_PostalCode"], [SourceColumnName = "TxnTaxDetail_TotalTax", DestinationColumnName = "TxnTaxDetail_TotalTax"], [SourceColumnName = "TxnTaxDetail_TxnTaxCodeRef_value", DestinationColumnName = "TxnTaxDetail_TxnTaxCodeRef_value"], [SourceColumnName = "Tax_Amount", DestinationColumnName = "Tax_Amount"], [SourceColumnName = "Tax_NetAmountTaxable", DestinationColumnName = "Tax_NetAmountTaxable"], [SourceColumnName = "Tax_Percent", DestinationColumnName = "Tax_Percent"], [SourceColumnName = "Tax_Rate_Id", DestinationColumnName = "Tax_Rate_Id"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver invoice_header" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.invoice_header", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"DueDate", type date}, {"Invoice_Id", Int64.Type}, {"SyncToken", Int64.Type}, {"TxnDate", type date}, {"BillAddr_Id", Int64.Type}}),
  #"Replaced value" = Table.ReplaceValue(#"Changed column type", "INVALID", "0.00", Replacer.ReplaceText, {"BillAddr_Lat"}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Replaced value", {{"BillAddr_Lat", type number}}),
  #"Replaced value 1" = Table.ReplaceValue(#"Changed column type 1", "INVALID", "0.00", Replacer.ReplaceText, {"BillAddr_Long"}),
  #"Changed column type 2" = Table.TransformColumnTypes(#"Replaced value 1", {{"CustomerRef_value", Int64.Type}, {"SalesTermRef_value", Int64.Type}}),
  #"Replaced value 2" = Table.ReplaceValue(#"Changed column type 2", "NA", "0", Replacer.ReplaceText, {"ShipAddr_Id"}),
  #"Replaced value 3" = Table.ReplaceValue(#"Replaced value 2", "NA", "0.00", Replacer.ReplaceText, {"ShipAddr_Lat"}),
  #"Changed column type 3" = Table.TransformColumnTypes(#"Replaced value 3", {{"ShipAddr_Id", Int64.Type}}),
  #"Replaced value 4" = Table.ReplaceValue(#"Changed column type 3", "NA", "0", Replacer.ReplaceText, {"TxnTaxDetail_TxnTaxCodeRef_value"}),
  #"Changed column type 4" = Table.TransformColumnTypes(#"Replaced value 4", {{"TxnTaxDetail_TxnTaxCodeRef_value", Int64.Type}}),
  #"Replaced value 5" = Table.ReplaceValue(#"Changed column type 4", "NA", "0", Replacer.ReplaceText, {"Tax_Rate_Id"}),
  #"Changed column type 5" = Table.TransformColumnTypes(#"Replaced value 5", {{"Tax_Rate_Id", Int64.Type}})
in
  #"Changed column type 5";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver invoice_line_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Invoice_Id", DestinationColumnName = "Invoice_Id"], [SourceColumnName = "Line_Id", DestinationColumnName = "Line_Id"], [SourceColumnName = "Line_Num", DestinationColumnName = "Line_Num"], [SourceColumnName = "DetailType", DestinationColumnName = "DetailType"], [SourceColumnName = "Item_Id", DestinationColumnName = "Item_Id"], [SourceColumnName = "Item_Name", DestinationColumnName = "Item_Name"], [SourceColumnName = "Qty", DestinationColumnName = "Qty"], [SourceColumnName = "Unit_Price", DestinationColumnName = "Unit_Price"], [SourceColumnName = "Line_Amount", DestinationColumnName = "Line_Amount"], [SourceColumnName = "Line_Description", DestinationColumnName = "Line_Description"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver invoice_line" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.invoice_line", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"Invoice_Id", Int64.Type}}),
  #"Filtered rows" = Table.SelectRows(#"Changed column type", each [Line_Num] <> 0),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Filtered rows", {{"Item_Id", Int64.Type}})
in
  #"Changed column type 1";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver item_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Active", DestinationColumnName = "Active"], [SourceColumnName = "Description", DestinationColumnName = "Description"], [SourceColumnName = "FullyQualifiedName", DestinationColumnName = "FullyQualifiedName"], [SourceColumnName = "Id", DestinationColumnName = "Id"], [SourceColumnName = "InvStartDate", DestinationColumnName = "InvStartDate"], [SourceColumnName = "Name", DestinationColumnName = "Name"], [SourceColumnName = "PurchaseCost", DestinationColumnName = "PurchaseCost"], [SourceColumnName = "PurchaseDesc", DestinationColumnName = "PurchaseDesc"], [SourceColumnName = "QtyOnHand", DestinationColumnName = "QtyOnHand"], [SourceColumnName = "Taxable", DestinationColumnName = "Taxable"], [SourceColumnName = "TrackQtyOnHand", DestinationColumnName = "TrackQtyOnHand"], [SourceColumnName = "Type", DestinationColumnName = "Type"], [SourceColumnName = "UnitPrice", DestinationColumnName = "UnitPrice"], [SourceColumnName = "AssetAccountRef_name", DestinationColumnName = "AssetAccountRef_name"], [SourceColumnName = "AssetAccountRef_value", DestinationColumnName = "AssetAccountRef_value"], [SourceColumnName = "ExpenseAccountRef_name", DestinationColumnName = "ExpenseAccountRef_name"], [SourceColumnName = "ExpenseAccountRef_value", DestinationColumnName = "ExpenseAccountRef_value"], [SourceColumnName = "IncomeAccountRef_name", DestinationColumnName = "IncomeAccountRef_name"], [SourceColumnName = "IncomeAccountRef_value", DestinationColumnName = "IncomeAccountRef_value"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver item" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.item", ItemKind = "Table"]}[Data],
  #"Replaced value" = Table.ReplaceValue(#"Navigation 2", "NA", "1999-01-01", Replacer.ReplaceText, {"InvStartDate"}),
  #"Changed column type" = Table.TransformColumnTypes(#"Replaced value", {{"Id", Int64.Type}, {"InvStartDate", type date}, {"SyncToken", Int64.Type}}),
  #"Replaced value 1" = Table.ReplaceValue(#"Changed column type", "NA", "0", Replacer.ReplaceText, {"AssetAccountRef_value"}),
  #"Replaced value 2" = Table.ReplaceValue(#"Replaced value 1", "NA", "0", Replacer.ReplaceText, {"ExpenseAccountRef_value"}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Replaced value 2", {{"IncomeAccountRef_value", Int64.Type}, {"ExpenseAccountRef_value", Int64.Type}, {"AssetAccountRef_value", Int64.Type}})
in
  #"Changed column type 1";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver payment_header_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Payment_Id", DestinationColumnName = "Payment_Id"], [SourceColumnName = "PaymentRefNum", DestinationColumnName = "PaymentRefNum"], [SourceColumnName = "PrivateNote", DestinationColumnName = "PrivateNote"], [SourceColumnName = "ProcessPayment", DestinationColumnName = "ProcessPayment"], [SourceColumnName = "TotalAmt", DestinationColumnName = "TotalAmt"], [SourceColumnName = "TxnDate", DestinationColumnName = "TxnDate"], [SourceColumnName = "UnappliedAmt", DestinationColumnName = "UnappliedAmt"], [SourceColumnName = "CustomerRef_name", DestinationColumnName = "CustomerRef_name"], [SourceColumnName = "CustomerRef_value", DestinationColumnName = "CustomerRef_value"], [SourceColumnName = "DepositToAccountRef_value", DestinationColumnName = "DepositToAccountRef_value"], [SourceColumnName = "PaymentMethodRef_value", DestinationColumnName = "PaymentMethodRef_value"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver payment_header" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.payment_header", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"Payment_Id", Int64.Type}}),
  #"Replaced value" = Table.ReplaceValue(#"Changed column type", "NA", "0", Replacer.ReplaceText, {"PaymentRefNum"}),
  #"Replaced value 1" = Table.ReplaceValue(#"Replaced value", "NA", "0", Replacer.ReplaceText, {"DepositToAccountRef_value"}),
  #"Replaced value 2" = Table.ReplaceValue(#"Replaced value 1", "NA", "0", Replacer.ReplaceText, {"PaymentMethodRef_value"}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Replaced value 2", {{"SyncToken", Int64.Type}, {"TxnDate", type date}, {"CustomerRef_value", Int64.Type}, {"DepositToAccountRef_value", Int64.Type}, {"PaymentMethodRef_value", Int64.Type}})
in
  #"Changed column type 1";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver payment_line_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Payment_Id", DestinationColumnName = "Payment_Id"], [SourceColumnName = "Line_Num", DestinationColumnName = "Line_Num"], [SourceColumnName = "Line_Amount", DestinationColumnName = "Line_Amount"], [SourceColumnName = "Line_DetailType", DestinationColumnName = "Line_DetailType"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver payment_line" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.payment_line", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"Payment_Id", Int64.Type}})
in
  #"Changed column type";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver payment_method_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Active", DestinationColumnName = "Active"], [SourceColumnName = "Id", DestinationColumnName = "Id"], [SourceColumnName = "Name", DestinationColumnName = "Name"], [SourceColumnName = "Type", DestinationColumnName = "Type"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver payment_method" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.payment_method", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"Id", Int64.Type}})
in
  #"Changed column type";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver purchase_header_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Credit", DestinationColumnName = "Credit"], [SourceColumnName = "Purchase_Id", DestinationColumnName = "Purchase_Id"], [SourceColumnName = "PaymentType", DestinationColumnName = "PaymentType"], [SourceColumnName = "PrintStatus", DestinationColumnName = "PrintStatus"], [SourceColumnName = "TotalAmt", DestinationColumnName = "TotalAmt"], [SourceColumnName = "TxnDate", DestinationColumnName = "TxnDate"], [SourceColumnName = "AccountRef_name", DestinationColumnName = "AccountRef_name"], [SourceColumnName = "AccountRef_value", DestinationColumnName = "AccountRef_value"], [SourceColumnName = "EntityRef_name", DestinationColumnName = "EntityRef_name"], [SourceColumnName = "EntityRef_type", DestinationColumnName = "EntityRef_type"], [SourceColumnName = "EntityRef_value", DestinationColumnName = "EntityRef_value"], [SourceColumnName = "RemitToAddr_City", DestinationColumnName = "RemitToAddr_City"], [SourceColumnName = "RemitToAddr_CountrySubDivisionCode", DestinationColumnName = "RemitToAddr_CountrySubDivisionCode"], [SourceColumnName = "RemitToAddr_Id", DestinationColumnName = "RemitToAddr_Id"], [SourceColumnName = "RemitToAddr_Lat", DestinationColumnName = "RemitToAddr_Lat"], [SourceColumnName = "RemitToAddr_Line1", DestinationColumnName = "RemitToAddr_Line1"], [SourceColumnName = "RemitToAddr_Long", DestinationColumnName = "RemitToAddr_Long"], [SourceColumnName = "RemitToAddr_PostalCode", DestinationColumnName = "RemitToAddr_PostalCode"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver purchase_header" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.purchase_header", ItemKind = "Table"]}[Data],
  #"Replaced value" = Table.ReplaceValue(#"Navigation 2", "NA", "0", Replacer.ReplaceText, {"Purchase_Id", "TxnDate", "AccountRef_value", "EntityRef_value"}),
  #"Changed column type" = Table.TransformColumnTypes(#"Replaced value", {{"Purchase_Id", Int64.Type}, {"TxnDate", type date}, {"AccountRef_value", Int64.Type}, {"EntityRef_value", Int64.Type}}),
  #"Replaced value 1" = Table.ReplaceValue(#"Changed column type", "NA", "0", Replacer.ReplaceText, {"RemitToAddr_Id"}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Replaced value 1", {{"RemitToAddr_Id", Int64.Type}}),
  #"Replaced value 2" = Table.ReplaceValue(#"Changed column type 1", "NA", "0.00", Replacer.ReplaceText, {"RemitToAddr_Lat"}),
  #"Changed column type 2" = Table.TransformColumnTypes(#"Replaced value 2", {{"RemitToAddr_Lat", type number}}),
  #"Replaced value 3" = Table.ReplaceValue(#"Changed column type 2", "NA", "0.00", Replacer.ReplaceText, {"RemitToAddr_Long"}),
  #"Replaced value 4" = Table.ReplaceValue(#"Replaced value 3", "NA", "00000", Replacer.ReplaceText, {"RemitToAddr_PostalCode"}),
  #"Changed column type 3" = Table.TransformColumnTypes(#"Replaced value 4", {{"RemitToAddr_Long", type number}, {"RemitToAddr_PostalCode", Int64.Type}})
in
  #"Changed column type 3";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver purchase_line_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Purchase_Id", DestinationColumnName = "Purchase_Id"], [SourceColumnName = "Line_Id", DestinationColumnName = "Line_Id"], [SourceColumnName = "DetailType", DestinationColumnName = "DetailType"], [SourceColumnName = "Account_Id", DestinationColumnName = "Account_Id"], [SourceColumnName = "Account_Name", DestinationColumnName = "Account_Name"], [SourceColumnName = "Billable_Status", DestinationColumnName = "Billable_Status"], [SourceColumnName = "Tax_Code", DestinationColumnName = "Tax_Code"], [SourceColumnName = "Line_Amount", DestinationColumnName = "Line_Amount"], [SourceColumnName = "Item_Id", DestinationColumnName = "Item_Id"], [SourceColumnName = "Item_Name", DestinationColumnName = "Item_Name"], [SourceColumnName = "Qty", DestinationColumnName = "Qty"], [SourceColumnName = "Unit_Price", DestinationColumnName = "Unit_Price"], [SourceColumnName = "Line_Description", DestinationColumnName = "Line_Description"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver purchase_line" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.purchase_line", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"Purchase_Id", Int64.Type}, {"Line_Id", Int64.Type}}),
  #"Replaced value" = Table.ReplaceValue(#"Changed column type", "NA", "0", Replacer.ReplaceText, {"Account_Id"}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Replaced value", {{"Account_Id", Int64.Type}}),
  #"Replaced value 1" = Table.ReplaceValue(#"Changed column type 1", "NA", "0", Replacer.ReplaceText, {"Item_Id"}),
  #"Changed column type 2" = Table.TransformColumnTypes(#"Replaced value 1", {{"Item_Id", Int64.Type}})
in
  #"Changed column type 2";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver purchase_order_header_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "EmailStatus", DestinationColumnName = "EmailStatus"], [SourceColumnName = "PurchaseOrder_Id", DestinationColumnName = "PurchaseOrder_Id"], [SourceColumnName = "POStatus", DestinationColumnName = "POStatus"], [SourceColumnName = "TotalAmt", DestinationColumnName = "TotalAmt"], [SourceColumnName = "TxnDate", DestinationColumnName = "TxnDate"], [SourceColumnName = "APAccountRef_name", DestinationColumnName = "APAccountRef_name"], [SourceColumnName = "APAccountRef_value", DestinationColumnName = "APAccountRef_value"], [SourceColumnName = "ShipAddr_Id", DestinationColumnName = "ShipAddr_Id"], [SourceColumnName = "ShipAddr_Lat", DestinationColumnName = "ShipAddr_Lat"], [SourceColumnName = "ShipAddr_Line1", DestinationColumnName = "ShipAddr_Line1"], [SourceColumnName = "ShipAddr_Line2", DestinationColumnName = "ShipAddr_Line2"], [SourceColumnName = "ShipAddr_Line3", DestinationColumnName = "ShipAddr_Line3"], [SourceColumnName = "ShipAddr_Long", DestinationColumnName = "ShipAddr_Long"], [SourceColumnName = "VendorAddr_Id", DestinationColumnName = "VendorAddr_Id"], [SourceColumnName = "VendorAddr_Lat", DestinationColumnName = "VendorAddr_Lat"], [SourceColumnName = "VendorAddr_Line1", DestinationColumnName = "VendorAddr_Line1"], [SourceColumnName = "VendorAddr_Line2", DestinationColumnName = "VendorAddr_Line2"], [SourceColumnName = "VendorAddr_Line3", DestinationColumnName = "VendorAddr_Line3"], [SourceColumnName = "VendorAddr_Line4", DestinationColumnName = "VendorAddr_Line4"], [SourceColumnName = "VendorAddr_Long", DestinationColumnName = "VendorAddr_Long"], [SourceColumnName = "VendorRef_name", DestinationColumnName = "VendorRef_name"], [SourceColumnName = "VendorRef_value", DestinationColumnName = "VendorRef_value"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver purchase_order_header" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.purchase_order_header", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"PurchaseOrder_Id", Int64.Type}, {"TxnDate", type date}, {"APAccountRef_value", Int64.Type}, {"ShipAddr_Id", Int64.Type}, {"VendorAddr_Id", Int64.Type}}),
  #"Replaced value" = Table.ReplaceValue(#"Changed column type", "INVALID", "0.00", Replacer.ReplaceText, {"VendorAddr_Lat"}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Replaced value", {{"VendorAddr_Lat", type number}}),
  #"Replaced value 1" = Table.ReplaceValue(#"Changed column type 1", "INVALID", "0.00", Replacer.ReplaceText, {"VendorAddr_Long"}),
  #"Changed column type 2" = Table.TransformColumnTypes(#"Replaced value 1", {{"VendorRef_value", Int64.Type}})
in
  #"Changed column type 2";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver purchase_order_line_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "PurchaseOrder_Id", DestinationColumnName = "PurchaseOrder_Id"], [SourceColumnName = "Line_Id", DestinationColumnName = "Line_Id"], [SourceColumnName = "Line_Num", DestinationColumnName = "Line_Num"], [SourceColumnName = "DetailType", DestinationColumnName = "DetailType"], [SourceColumnName = "Item_Id", DestinationColumnName = "Item_Id"], [SourceColumnName = "Item_Name", DestinationColumnName = "Item_Name"], [SourceColumnName = "Qty", DestinationColumnName = "Qty"], [SourceColumnName = "Unit_Price", DestinationColumnName = "Unit_Price"], [SourceColumnName = "Line_Amount", DestinationColumnName = "Line_Amount"], [SourceColumnName = "Line_Description", DestinationColumnName = "Line_Description"], [SourceColumnName = "Billable_Status", DestinationColumnName = "Billable_Status"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver purchase_order_line" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.purchase_order_line", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"PurchaseOrder_Id", Int64.Type}, {"Line_Id", Int64.Type}, {"Item_Id", Int64.Type}})
in
  #"Changed column type";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver sales_receipt_header_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "ApplyTaxAfterDiscount", DestinationColumnName = "ApplyTaxAfterDiscount"], [SourceColumnName = "Balance", DestinationColumnName = "Balance"], [SourceColumnName = "EmailStatus", DestinationColumnName = "EmailStatus"], [SourceColumnName = "FreeFormAddress", DestinationColumnName = "FreeFormAddress"], [SourceColumnName = "SalesReceipt_Id", DestinationColumnName = "SalesReceipt_Id"], [SourceColumnName = "PaymentRefNum", DestinationColumnName = "PaymentRefNum"], [SourceColumnName = "PrintStatus", DestinationColumnName = "PrintStatus"], [SourceColumnName = "TotalAmt", DestinationColumnName = "TotalAmt"], [SourceColumnName = "TxnDate", DestinationColumnName = "TxnDate"], [SourceColumnName = "BillAddr_Id", DestinationColumnName = "BillAddr_Id"], [SourceColumnName = "BillAddr_Lat", DestinationColumnName = "BillAddr_Lat"], [SourceColumnName = "BillAddr_Line1", DestinationColumnName = "BillAddr_Line1"], [SourceColumnName = "BillAddr_Line2", DestinationColumnName = "BillAddr_Line2"], [SourceColumnName = "BillAddr_Line3", DestinationColumnName = "BillAddr_Line3"], [SourceColumnName = "BillAddr_Line4", DestinationColumnName = "BillAddr_Line4"], [SourceColumnName = "BillAddr_Long", DestinationColumnName = "BillAddr_Long"], [SourceColumnName = "BillEmail_Address", DestinationColumnName = "BillEmail_Address"], [SourceColumnName = "CurrencyRef_name", DestinationColumnName = "CurrencyRef_name"], [SourceColumnName = "CurrencyRef_value", DestinationColumnName = "CurrencyRef_value"], [SourceColumnName = "CustomerMemo_value", DestinationColumnName = "CustomerMemo_value"], [SourceColumnName = "CustomerRef_name", DestinationColumnName = "CustomerRef_name"], [SourceColumnName = "CustomerRef_value", DestinationColumnName = "CustomerRef_value"], [SourceColumnName = "DepositToAccountRef_name", DestinationColumnName = "DepositToAccountRef_name"], [SourceColumnName = "DepositToAccountRef_value", DestinationColumnName = "DepositToAccountRef_value"], [SourceColumnName = "PaymentMethodRef_name", DestinationColumnName = "PaymentMethodRef_name"], [SourceColumnName = "PaymentMethodRef_value", DestinationColumnName = "PaymentMethodRef_value"], [SourceColumnName = "ShipAddr_City", DestinationColumnName = "ShipAddr_City"], [SourceColumnName = "ShipAddr_Country", DestinationColumnName = "ShipAddr_Country"], [SourceColumnName = "ShipAddr_CountrySubDivisionCode", DestinationColumnName = "ShipAddr_CountrySubDivisionCode"], [SourceColumnName = "ShipAddr_Id", DestinationColumnName = "ShipAddr_Id"], [SourceColumnName = "ShipAddr_Lat", DestinationColumnName = "ShipAddr_Lat"], [SourceColumnName = "ShipAddr_Line1", DestinationColumnName = "ShipAddr_Line1"], [SourceColumnName = "ShipAddr_Long", DestinationColumnName = "ShipAddr_Long"], [SourceColumnName = "ShipAddr_PostalCode", DestinationColumnName = "ShipAddr_PostalCode"], [SourceColumnName = "TxnTaxDetail_TotalTax", DestinationColumnName = "TxnTaxDetail_TotalTax"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver sales_receipt_header" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.sales_receipt_header", ItemKind = "Table"]}[Data],
  #"Replaced value" = Table.ReplaceValue(#"Navigation 2", "INVALID", "0.00", Replacer.ReplaceText, {"BillAddr_Lat"}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Replaced value", {{"BillAddr_Lat", type number}}),
  #"Replaced value 1" = Table.ReplaceValue(#"Changed column type 1", "INVALID", "0", Replacer.ReplaceText, {"BillAddr_Long"}),
  #"Changed column type 2" = Table.TransformColumnTypes(#"Replaced value 1", {{"BillAddr_Long", type number}, {"CustomerRef_value", Int64.Type}, {"DepositToAccountRef_value", Int64.Type}}),
  #"Replaced value 2" = Table.ReplaceValue(#"Changed column type 2", "NA", "0", Replacer.ReplaceText, {"PaymentMethodRef_value"}),
  #"Changed column type 3" = Table.TransformColumnTypes(#"Replaced value 2", {{"PaymentMethodRef_value", Int64.Type}}),
  #"Replaced value 3" = Table.ReplaceValue(#"Changed column type 3", "NA", "0", Replacer.ReplaceText, {"ShipAddr_Id"}),
  #"Changed column type 4" = Table.TransformColumnTypes(#"Replaced value 3", {{"ShipAddr_Id", Int64.Type}}),
  #"Replaced value 4" = Table.ReplaceValue(#"Changed column type 4", "NA", "0.00", Replacer.ReplaceText, {"ShipAddr_Lat"}),
  #"Changed column type 5" = Table.TransformColumnTypes(#"Replaced value 4", {{"ShipAddr_Lat", type number}}),
  #"Replaced value 5" = Table.ReplaceValue(#"Changed column type 5", "NA", "0.00", Replacer.ReplaceText, {"ShipAddr_Long"}),
  #"Changed column type 6" = Table.TransformColumnTypes(#"Replaced value 5", {{"ShipAddr_Long", type number}}),
  #"Replaced value 6" = Table.ReplaceValue(#"Changed column type 6", "NA", "00000", Replacer.ReplaceText, {"ShipAddr_PostalCode"}),
  #"Changed column type 7" = Table.TransformColumnTypes(#"Replaced value 6", {{"ShipAddr_PostalCode", Int64.Type}, {"SalesReceipt_Id", Int64.Type}, {"TxnDate", type date}, {"BillAddr_Id", Int64.Type}})
in
  #"Changed column type 7";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver sales_receipt_line_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "SalesReceipt_Id", DestinationColumnName = "SalesReceipt_Id"], [SourceColumnName = "Line_Id", DestinationColumnName = "Line_Id"], [SourceColumnName = "Line_Num", DestinationColumnName = "Line_Num"], [SourceColumnName = "DetailType", DestinationColumnName = "DetailType"], [SourceColumnName = "Item_Id", DestinationColumnName = "Item_Id"], [SourceColumnName = "Item_Name", DestinationColumnName = "Item_Name"], [SourceColumnName = "Account_Id", DestinationColumnName = "Account_Id"], [SourceColumnName = "Account_Name", DestinationColumnName = "Account_Name"], [SourceColumnName = "Qty", DestinationColumnName = "Qty"], [SourceColumnName = "Unit_Price", DestinationColumnName = "Unit_Price"], [SourceColumnName = "Tax_Code", DestinationColumnName = "Tax_Code"], [SourceColumnName = "Line_Amount", DestinationColumnName = "Line_Amount"], [SourceColumnName = "Line_Description", DestinationColumnName = "Line_Description"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver sales_receipt_line" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.sales_receipt_line", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"SalesReceipt_Id", Int64.Type}, {"Line_Id", Int64.Type}, {"Item_Id", Int64.Type}, {"Account_Id", Int64.Type}})
in
  #"Changed column type";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver tax_code_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "TaxOrder", DestinationColumnName = "TaxOrder"], [SourceColumnName = "TaxTypeApplicable", DestinationColumnName = "TaxTypeApplicable"], [SourceColumnName = "TaxRate_Id", DestinationColumnName = "TaxRate_Id"], [SourceColumnName = "TaxRate_Name", DestinationColumnName = "TaxRate_Name"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver tax_code" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.tax_code", ItemKind = "Table"]}[Data],
  #"Filtered rows" = Table.SelectRows(#"Navigation 2", each [TaxTypeApplicable] <> "NA"),
  #"Changed column type" = Table.TransformColumnTypes(#"Filtered rows", {{"TaxRate_Id", Int64.Type}})
in
  #"Changed column type";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver term_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Active", DestinationColumnName = "Active"], [SourceColumnName = "DiscountDays", DestinationColumnName = "DiscountDays"], [SourceColumnName = "DueDays", DestinationColumnName = "DueDays"], [SourceColumnName = "Id", DestinationColumnName = "Id"], [SourceColumnName = "Name", DestinationColumnName = "Name"], [SourceColumnName = "Type", DestinationColumnName = "Type"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver term" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.term", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"Id", Int64.Type}})
in
  #"Changed column type";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver time_activity_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "BillableStatus", DestinationColumnName = "BillableStatus"], [SourceColumnName = "CostRate", DestinationColumnName = "CostRate"], [SourceColumnName = "Description", DestinationColumnName = "Description"], [SourceColumnName = "HourlyRate", DestinationColumnName = "HourlyRate"], [SourceColumnName = "Hours", DestinationColumnName = "Hours"], [SourceColumnName = "Id", DestinationColumnName = "Id"], [SourceColumnName = "Minutes", DestinationColumnName = "Minutes"], [SourceColumnName = "NameOf", DestinationColumnName = "NameOf"], [SourceColumnName = "Seconds", DestinationColumnName = "Seconds"], [SourceColumnName = "Taxable", DestinationColumnName = "Taxable"], [SourceColumnName = "TimeChargeId", DestinationColumnName = "TimeChargeId"], [SourceColumnName = "TxnDate", DestinationColumnName = "TxnDate"], [SourceColumnName = "CustomerRef_name", DestinationColumnName = "CustomerRef_name"], [SourceColumnName = "CustomerRef_value", DestinationColumnName = "CustomerRef_value"], [SourceColumnName = "EmployeeRef_name", DestinationColumnName = "EmployeeRef_name"], [SourceColumnName = "EmployeeRef_value", DestinationColumnName = "EmployeeRef_value"], [SourceColumnName = "ItemRef_name", DestinationColumnName = "ItemRef_name"], [SourceColumnName = "ItemRef_value", DestinationColumnName = "ItemRef_value"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver time_activity" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.time_activity", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"Id", Int64.Type}, {"TxnDate", type date}, {"CustomerRef_value", Int64.Type}, {"EmployeeRef_value", Int64.Type}, {"ItemRef_value", Int64.Type}})
in
  #"Changed column type";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver vendor_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Active", DestinationColumnName = "Active"], [SourceColumnName = "Balance", DestinationColumnName = "Balance"], [SourceColumnName = "BillRate", DestinationColumnName = "BillRate"], [SourceColumnName = "CompanyName", DestinationColumnName = "CompanyName"], [SourceColumnName = "DisplayName", DestinationColumnName = "DisplayName"], [SourceColumnName = "FamilyName", DestinationColumnName = "FamilyName"], [SourceColumnName = "GivenName", DestinationColumnName = "GivenName"], [SourceColumnName = "Id", DestinationColumnName = "Id"], [SourceColumnName = "MiddleName", DestinationColumnName = "MiddleName"], [SourceColumnName = "PrintOnCheckName", DestinationColumnName = "PrintOnCheckName"], [SourceColumnName = "Suffix", DestinationColumnName = "Suffix"], [SourceColumnName = "Title", DestinationColumnName = "Title"], [SourceColumnName = "Vendor1099", DestinationColumnName = "Vendor1099"], [SourceColumnName = "BillAddr_City", DestinationColumnName = "BillAddr_City"], [SourceColumnName = "BillAddr_Country", DestinationColumnName = "BillAddr_Country"], [SourceColumnName = "BillAddr_CountrySubDivisionCode", DestinationColumnName = "BillAddr_CountrySubDivisionCode"], [SourceColumnName = "BillAddr_Id", DestinationColumnName = "BillAddr_Id"], [SourceColumnName = "BillAddr_Lat", DestinationColumnName = "BillAddr_Lat"], [SourceColumnName = "BillAddr_Line1", DestinationColumnName = "BillAddr_Line1"], [SourceColumnName = "BillAddr_Long", DestinationColumnName = "BillAddr_Long"], [SourceColumnName = "BillAddr_PostalCode", DestinationColumnName = "BillAddr_PostalCode"], [SourceColumnName = "Fax_FreeFormNumber", DestinationColumnName = "Fax_FreeFormNumber"], [SourceColumnName = "Mobile_FreeFormNumber", DestinationColumnName = "Mobile_FreeFormNumber"], [SourceColumnName = "PrimaryEmailAddr_Address", DestinationColumnName = "PrimaryEmailAddr_Address"], [SourceColumnName = "PrimaryPhone_FreeFormNumber", DestinationColumnName = "PrimaryPhone_FreeFormNumber"], [SourceColumnName = "TermRef_name", DestinationColumnName = "TermRef_name"], [SourceColumnName = "TermRef_value", DestinationColumnName = "TermRef_value"], [SourceColumnName = "WebAddr_URI", DestinationColumnName = "WebAddr_URI"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver vendor" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.vendor", ItemKind = "Table"]}[Data],
  #"Replaced value" = Table.ReplaceValue(#"Navigation 2", "NA", "0", Replacer.ReplaceText, {"AcctNum"}),
  #"Changed column type" = Table.TransformColumnTypes(#"Replaced value", {{"Id", Int64.Type}}),
  #"Replaced value 1" = Table.ReplaceValue(#"Changed column type", "NA", "0", Replacer.ReplaceText, {"BillAddr_Id"}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Replaced value 1", {{"BillAddr_Id", Int64.Type}}),
  #"Replaced value 2" = Table.ReplaceValue(#"Changed column type 1", "NA", "0.00", Replacer.ReplaceText, {"BillAddr_Lat"}),
  #"Changed column type 2" = Table.TransformColumnTypes(#"Replaced value 2", {{"BillAddr_Lat", type number}}),
  #"Replaced value 3" = Table.ReplaceValue(#"Changed column type 2", "NA", "0.00", Replacer.ReplaceText, {"BillAddr_Long"}),
  #"Changed column type 3" = Table.TransformColumnTypes(#"Replaced value 3", {{"BillAddr_Long", type number}}),
  #"Replaced value 4" = Table.ReplaceValue(#"Changed column type 3", "NA", "00000", Replacer.ReplaceText, {"BillAddr_PostalCode"}),
  #"Replaced value 5" = Table.ReplaceValue(#"Replaced value 4", "NA", "0", Replacer.ReplaceText, {"TermRef_value"}),
  #"Changed column type 4" = Table.TransformColumnTypes(#"Replaced value 5", {{"AcctNum", type text}})
in
  #"Changed column type 4";
shared #"Silver bill_line_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver bill_line", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver bill_payment_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver bill_payment", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver invoice_header_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver invoice_header", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver invoice_line_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver invoice_line", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver payment_header_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver payment_header", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver payment_line_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver payment_line", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver payment_method_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver payment_method", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver account_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver account", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver bill_header_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver bill_header", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver customer_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver customer", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver employee_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver employee", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver item_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver item", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver purchase_header_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver purchase_header", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver purchase_line_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver purchase_line", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver purchase_order_header_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver purchase_order_header", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver purchase_order_line_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver purchase_order_line", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver sales_receipt_header_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver sales_receipt_header", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver sales_receipt_line_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver sales_receipt_line", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver tax_code_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver tax_code", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver term_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver term", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver time_activity_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver time_activity", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver vendor_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver vendor", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared NavigationQuery = let
  Source = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false])
in
  Source;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver credit_memo_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Balance", DestinationColumnName = "Balance"], [SourceColumnName = "EmailStatus", DestinationColumnName = "EmailStatus"], [SourceColumnName = "FreeFormAddress", DestinationColumnName = "FreeFormAddress"], [SourceColumnName = "Id", DestinationColumnName = "Id"], [SourceColumnName = "PrintStatus", DestinationColumnName = "PrintStatus"], [SourceColumnName = "RemainingCredit", DestinationColumnName = "RemainingCredit"], [SourceColumnName = "TotalAmt", DestinationColumnName = "TotalAmt"], [SourceColumnName = "TxnDate", DestinationColumnName = "TxnDate"], [SourceColumnName = "BillAddr_Id", DestinationColumnName = "BillAddr_Id"], [SourceColumnName = "BillAddr_Lat", DestinationColumnName = "BillAddr_Lat"], [SourceColumnName = "BillAddr_Line1", DestinationColumnName = "BillAddr_Line1"], [SourceColumnName = "BillAddr_Line2", DestinationColumnName = "BillAddr_Line2"], [SourceColumnName = "BillAddr_Line3", DestinationColumnName = "BillAddr_Line3"], [SourceColumnName = "BillAddr_Line4", DestinationColumnName = "BillAddr_Line4"], [SourceColumnName = "BillAddr_Long", DestinationColumnName = "BillAddr_Long"], [SourceColumnName = "BillEmail_Address", DestinationColumnName = "BillEmail_Address"], [SourceColumnName = "CustomerRef_name", DestinationColumnName = "CustomerRef_name"], [SourceColumnName = "CustomerRef_value", DestinationColumnName = "CustomerRef_value"], [SourceColumnName = "ShipAddr_City", DestinationColumnName = "ShipAddr_City"], [SourceColumnName = "ShipAddr_CountrySubDivisionCode", DestinationColumnName = "ShipAddr_CountrySubDivisionCode"], [SourceColumnName = "ShipAddr_Id", DestinationColumnName = "ShipAddr_Id"], [SourceColumnName = "ShipAddr_Lat", DestinationColumnName = "ShipAddr_Lat"], [SourceColumnName = "ShipAddr_Line1", DestinationColumnName = "ShipAddr_Line1"], [SourceColumnName = "ShipAddr_Long", DestinationColumnName = "ShipAddr_Long"], [SourceColumnName = "ShipAddr_PostalCode", DestinationColumnName = "ShipAddr_PostalCode"], [SourceColumnName = "TxnTaxDetail_TotalTax", DestinationColumnName = "TxnTaxDetail_TotalTax"], [SourceColumnName = "Line_Id", DestinationColumnName = "Line_Id"], [SourceColumnName = "Line_Num", DestinationColumnName = "Line_Num"], [SourceColumnName = "Line_Amount", DestinationColumnName = "Line_Amount"], [SourceColumnName = "Line_Description", DestinationColumnName = "Line_Description"], [SourceColumnName = "Line_DetailType", DestinationColumnName = "Line_DetailType"], [SourceColumnName = "Item_Name", DestinationColumnName = "Item_Name"], [SourceColumnName = "Item_Id", DestinationColumnName = "Item_Id"], [SourceColumnName = "Item_Account_Name", DestinationColumnName = "Item_Account_Name"], [SourceColumnName = "Item_Account_Id", DestinationColumnName = "Item_Account_Id"], [SourceColumnName = "Qty", DestinationColumnName = "Qty"], [SourceColumnName = "Unit_Price", DestinationColumnName = "Unit_Price"], [SourceColumnName = "Tax_Code", DestinationColumnName = "Tax_Code"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver credit_memo" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.credit_memo", ItemKind = "Table"]}[Data],
  #"Filtered rows" = Table.SelectRows(#"Navigation 2", each [Line_Id] <> "NA"),
  #"Changed column type" = Table.TransformColumnTypes(#"Filtered rows", {{"Item_Account_Id", Int64.Type}, {"Item_Id", Int64.Type}, {"Line_Id", Int64.Type}, {"ShipAddr_PostalCode", Int64.Type}, {"ShipAddr_Id", Int64.Type}, {"MetaData_CreateTime", type datetimezone}, {"MetaData_LastUpdatedTime", type datetimezone}, {"CustomerRef_value", Int64.Type}, {"BillAddr_Id", Int64.Type}, {"TxnDate", type date}, {"Id", Int64.Type}})
in
  #"Changed column type";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver refund_receipt_header_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Balance", DestinationColumnName = "Balance"], [SourceColumnName = "RefundReceipt_Id", DestinationColumnName = "RefundReceipt_Id"], [SourceColumnName = "PrintStatus", DestinationColumnName = "PrintStatus"], [SourceColumnName = "TotalAmt", DestinationColumnName = "TotalAmt"], [SourceColumnName = "TxnDate", DestinationColumnName = "TxnDate"], [SourceColumnName = "BillAddr_Id", DestinationColumnName = "BillAddr_Id"], [SourceColumnName = "BillAddr_Lat", DestinationColumnName = "BillAddr_Lat"], [SourceColumnName = "BillAddr_Line1", DestinationColumnName = "BillAddr_Line1"], [SourceColumnName = "BillAddr_Line2", DestinationColumnName = "BillAddr_Line2"], [SourceColumnName = "BillAddr_Line3", DestinationColumnName = "BillAddr_Line3"], [SourceColumnName = "BillAddr_Line4", DestinationColumnName = "BillAddr_Line4"], [SourceColumnName = "BillAddr_Long", DestinationColumnName = "BillAddr_Long"], [SourceColumnName = "BillEmail_Address", DestinationColumnName = "BillEmail_Address"], [SourceColumnName = "CustomerRef_name", DestinationColumnName = "CustomerRef_name"], [SourceColumnName = "CustomerRef_value", DestinationColumnName = "CustomerRef_value"], [SourceColumnName = "DepositToAccountRef_name", DestinationColumnName = "DepositToAccountRef_name"], [SourceColumnName = "DepositToAccountRef_value", DestinationColumnName = "DepositToAccountRef_value"], [SourceColumnName = "PaymentMethodRef_name", DestinationColumnName = "PaymentMethodRef_name"], [SourceColumnName = "PaymentMethodRef_value", DestinationColumnName = "PaymentMethodRef_value"], [SourceColumnName = "TxnTaxDetail_TotalTax", DestinationColumnName = "TxnTaxDetail_TotalTax"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver refund_receipt_header" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.refund_receipt_header", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"RefundReceipt_Id", Int64.Type}, {"TxnDate", type date}, {"BillAddr_Id", Int64.Type}, {"BillAddr_Lat", type number}, {"BillAddr_Long", type number}, {"CustomerRef_value", Int64.Type}, {"DepositToAccountRef_value", Int64.Type}, {"PaymentMethodRef_value", Int64.Type}})
in
  #"Changed column type";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Silver refund_receipt_line_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "RefundReceipt_Id", DestinationColumnName = "RefundReceipt_Id"], [SourceColumnName = "Line_Id", DestinationColumnName = "Line_Id"], [SourceColumnName = "Line_Num", DestinationColumnName = "Line_Num"], [SourceColumnName = "DetailType", DestinationColumnName = "DetailType"], [SourceColumnName = "Item_Id", DestinationColumnName = "Item_Id"], [SourceColumnName = "Item_Name", DestinationColumnName = "Item_Name"], [SourceColumnName = "Account_Id", DestinationColumnName = "Account_Id"], [SourceColumnName = "Account_Name", DestinationColumnName = "Account_Name"], [SourceColumnName = "Qty", DestinationColumnName = "Qty"], [SourceColumnName = "Unit_Price", DestinationColumnName = "Unit_Price"], [SourceColumnName = "Tax_Code", DestinationColumnName = "Tax_Code"], [SourceColumnName = "Line_Amount", DestinationColumnName = "Line_Amount"], [SourceColumnName = "Line_Description", DestinationColumnName = "Line_Description"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared #"Silver refund_receipt_line" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "5f09e7f0-5c8f-4629-ba3e-f8c598c0e023"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Silver.refund_receipt_line", ItemKind = "Table"]}[Data],
  #"Filtered rows" = Table.SelectRows(#"Navigation 2", each [Line_Id] <> "NA"),
  #"Changed column type" = Table.TransformColumnTypes(#"Filtered rows", {{"Line_Id", Int64.Type}, {"RefundReceipt_Id", Int64.Type}, {"Item_Id", Int64.Type}, {"Account_Id", Int64.Type}})
in
  #"Changed column type";
shared #"Silver credit_memo_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver credit_memo", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver refund_receipt_header_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver refund_receipt_header", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
shared #"Silver refund_receipt_line_DataDestination" = let
  Pattern = Lakehouse.Contents([HierarchicalNavigation = null, CreateNavigationProperties = false, EnableFolding = false]),
  Navigation_1 = Pattern{[workspaceId = "e48ce691-a973-4d48-98ac-e161282245c3"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "85782608-1fda-4e56-8860-ae5a4f5b48e1"]}[Data],
  TableNavigation = Navigation_2{[Id = "Silver refund_receipt_line", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
