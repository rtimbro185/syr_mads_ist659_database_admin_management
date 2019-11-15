--CREATE DATABASE RadChad_72411
--GO
--USE RadChad_72411
--GO
-- Class 72410 DDL Week 5

-- Older versions of SQL Server (<= 2014)
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'OrderItem')
BEGIN
	DROP TABLE OrderItem
END

-- SQL Server 2017+
DROP TABLE IF EXISTS Item
DROP TABLE IF EXISTS ItemCategory
DROP TABLE IF EXISTS SalesOrder
DROP TABLE IF EXISTS CustomerAddress
DROP TABLE IF EXISTS Customer
DROP TABLE IF EXISTS Account

-- Create tables starts here
CREATE TABLE Account (
	AccountID int identity primary key
	, AccountNumber varchar(20) not null
	, AccountName varchar(50) not null
	, CONSTRAINT U1_AccountNumber UNIQUE(AccountNumber)
)
Go

Create table Customer (
	CustomerNumber int identity primary key
	, CustomerFirstName varchar(50) 
	, CustomerLastName varchar(50) 
	, CustomerCompanyName varchar(50)
	, CustomerContactName varchar(30)
	, CustomerPhoneNumber varchar(15) 
	, Constraint  U1_Cust Unique (CustomerFirstName, CustomerLastName)
)

Create table CustomerAddress(
	CustomerAddressID int identity primary key
	, Address_1 varchar(50) not null
	, Address_2 varchar(50) 
	, City varchar(50) not null
	, State varchar(50) not null
	, ZipCode varchar(50) not null
	, CustomerID int Foreign key  references Customer(CustomerNumber)
)

create table SalesOrder (
   SalesOrderID int identity primary key, 
   OrderDate datetime not null default GetDate(),
   CustomerID int not null foreign key references Customer(CustomerNumber), 
   OrderStatus varchar(50)
)

CREATE TABLE ItemCategory (
	ItemCategoryID int identity,
	CategoryText varchar(50) not null,
	InventoryAccountID int not null,
	SalesAccountId int not null,
	CONSTRAINT PK_ItemCategory PRIMARY KEY (ItemCategoryID),
	CONSTRAINT U1_ItemCategory UNIQUE (CategoryText),
	CONSTRAINT FK1_ItemCategory FOREIGN KEY (InventoryAccountID) REFERENCES Account(AccountID),
	CONSTRAINT FK2_ItemCategory FOREIGN KEY (SalesAccountId) REFERENCES Account(AccountID)
)

Create Table Item(
	-- Columns for the Item Table
	ItemNumber int identity,
	ItemName varchar(30) not null,
	ItemDescription varchar(100),
	StandardCost money,
	ListPrice money,
	QtyOnHand int default(0),
	ItemCategoryID int not null,
	-- Constraints on the Item Table
	CONSTRAINT PK_ItemNumber PRIMARY KEY(ItemNumber),
	CONSTRAINT U1_ItemName UNIQUE(ItemName),
	CONSTRAINT FK1_ItemCategoryID FOREIGN KEY(ItemCategoryID) REFERENCES ItemCategory(ItemCategoryID)
 )

create table OrderItem (
   OrderItemID int identity primary key,
   SalesOrderID int not null foreign key references SalesOrder(SalesOrderID),
   ItemNumber int not null foreign key references Item(ItemNumber),
   QuantityOrdered int not null,
   QuantityShipped int not null,
   UnitPrice money not null
)

SELECT 
	*
FROM OrderItem
JOIN SalesOrder ON SalesOrder.salesorderID = OrderItem.salesorderID
JOIN Customer ON SalesOrder.customerID  = Customer.customernumber
JOIN CustomerAddress ON CustomerAddress.customerid = Customer.customernumber
JOIN Item ON Item.ItemNumber = OrderItem.itemnumber
JOIN ItemCategory ON ItemCategory.ItemCategoryID = Item.ItemCategoryID
JOIN Account on ItemCategory.SalesAccountID = Account.AccountID

/*
Alter table examples
More at https://www.w3schools.com/sql/sql_alter.asp

SalesorderID    ItemNumber  UnitPrice QtyOrdered
4               402         5.00      4
4               402         2.50      1
4               402         5.00      3  <<<---- ERROR!

ALTER TABLE OrderItem
	ADD QuantityInvoiced int not null default 0

ALTER TABLE OrderItem
	ADD CONSTRAINT U1_OrderItem UNIQUE(SalesOrderID, ItemNumber, UnitPrice)
	SELECT * FROM OrderItem


INSERT INTO Account (AccountNumber, AccountName)
	VALUES ('12000', 'Inventory'), ('40000', 'Revenue Account')

SELECT * FROM Account
*/