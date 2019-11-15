/*
	IST 659 Data Admin Concepts &Db Mgmt
	Date: 9/30/2018
	Project Deliverable 2: DDL
	
*/

-- DROP TABLES IF THEY EXIST --
DROP TABLE IF EXISTS team_application
DROP TABLE IF EXISTS team_lead
DROP TABLE IF EXISTS team_employee
DROP TABLE IF EXISTS employee_role
DROP TABLE IF EXISTS department_supervisor
DROP TABLE IF EXISTS team
DROP TABLE IF EXISTS department
DROP TABLE IF EXISTS employee
DROP TABLE IF EXISTS contact_channel_preference
DROP TABLE IF EXISTS application_kpi
DROP TABLE IF EXISTS product_kpi
DROP TABLE IF EXISTS capability_kpi
DROP TABLE IF EXISTS kpi
DROP TABLE IF EXISTS kpi_type
DROP TABLE IF EXISTS product_capability
DROP TABLE IF EXISTS capability_application
DROP TABLE IF EXISTS role
DROP TABLE IF EXISTS application
DROP TABLE IF EXISTS product
DROP TABLE IF EXISTS capability



-- Create Tables --

-- 1 --
Create Table department(
	-- Columns for the department Table
	department_id int identity,
	department_parent_id int,
	department_name varchar(50) not null,
	description varchar(200),
	is_active char(1) default 'T'
	-- Constraints on the department Table
	CONSTRAINT PK_department PRIMARY KEY(department_id),
	CONSTRAINT U1_department_name UNIQUE(department_name)
)
-- 3 --
Create Table contact_channel_preference(
	-- Columns for the contact_channel_preference Table
	cc_preference_id int identity,
	cc_preference_type varchar(5) not null,
	is_active char(1) default 'T'
	-- Constraints on the contact_channel_preference Table
	CONSTRAINT PK_cc_preference PRIMARY KEY(cc_preference_id)
)
-- 4 --
Create Table employee(
	-- Columns for the employee Table
	employee_id int identity,
	first_name varchar(50) not null,
	first_name2 varchar(50),
	last_name varchar(50) not null,
	title varchar(100),
	phone varchar(13) not null,
	email varchar(50) not null,
	cc_preference_id int,
	is_active char(1) default 'T'
	-- Constraints on the employee Table
	CONSTRAINT PK_employee PRIMARY KEY(employee_id),
	CONSTRAINT FK1_cc_preference FOREIGN KEY(cc_preference_id) REFERENCES contact_channel_preference(cc_preference_id),
	CONSTRAINT U1_phone UNIQUE(phone),
	CONSTRAINT U2_email UNIQUE(email)
)
-- 5 --
-- Composit Primary Key, different departments can have the same team names, but team names must be unique within the same department
Create Table team(
	-- Columns for the team Table
	team_id int identity,
	team_name varchar(50) not null,
	department_id int not null,
	team_parent_id int,
	description varchar(200),
	is_active char(1) default 'T'
	-- Constraints on the team Table
	CONSTRAINT PK_team PRIMARY KEY(team_id),
	CONSTRAINT U1_team UNIQUE(team_name,department_id)
	
)
-- 6 --
Create Table role(
	-- Columns for the role Table
	role_id int identity,
	role_name varchar(50) not null,
	description varchar(200),
	is_active char(1) default 'T'
	-- Constraints on the role Table
	CONSTRAINT PK_role PRIMARY KEY(role_id)
)

-- 7 --
Create Table application(
	-- Columns for the application Table
	application_id int identity,
	app_name varchar(20) not null,
	description varchar(200),
	is_active char(1) default 'T'
	-- Constraints on the application Table
	CONSTRAINT PK_application PRIMARY KEY(application_id)
)

-- 8 --
Create Table product(
	-- Columns for the product Table
	product_id int identity,
	product_name varchar(50) not null,
	description varchar(200),
	is_active char(1) default 'T'
	-- Constraints on the product Table
	CONSTRAINT PK_product PRIMARY KEY(product_id)
)

-- 9 --
Create Table capability(
	-- Columns for the capability Table
	capability_id int identity,
	capability_name varchar(50) not null,
	description varchar(200),
	is_active char(1) default 'T'
	-- Constraints on the capability Table
	CONSTRAINT PK_capability PRIMARY KEY(capability_id)
)

-- 10 --
Create Table kpi_type(
	-- Columns for the x Table
	kpi_type_id int identity,
	kpi_type varchar(20) not null,
	description varchar(200),
	is_active char(1) default 'T'
	-- Constraints on the x Table
	CONSTRAINT PK_kpi_type PRIMARY KEY(kpi_type_id)
)

-- 11 --
Create Table team_application(
	-- Columns for the team_application Table
	team_application_id int identity,
	team_id int not null,
	application_id int not null,
	is_active char(1) default 'T'
	-- Constraints on the team_application Table
	CONSTRAINT PK_team_application PRIMARY KEY(team_application_id),
	CONSTRAINT U1_team_application UNIQUE(team_id,application_id),
	CONSTRAINT FK1_team_application FOREIGN KEY(team_id) REFERENCES team(team_id),
	CONSTRAINT FK2_team_application FOREIGN KEY(application_id) REFERENCES application(application_id)
)

-- 12 --
Create Table team_lead(
	-- Columns for the team_lead Table
	team_lead_id int identity,
	team_id int not null,
	employee_id int not null,
	is_active char(1) default 'T'
	-- Constraints on the team_lead Table
	CONSTRAINT PK_team_lead PRIMARY KEY(team_lead_id),
	CONSTRAINT U1_team_lead UNIQUE(team_id,employee_id),
	CONSTRAINT FK1_team_lead FOREIGN KEY(team_id) REFERENCES team(team_id),
	CONSTRAINT FK2_team_lead FOREIGN KEY(employee_id) REFERENCES employee(employee_id)
)

-- 13 --
Create Table team_employee(
	-- Columns for the team_employee Table
	team_employee_id int identity,
	team_id int not null,
	employee_id int not null,
	is_active char(1) default 'T'
	-- Constraints on the team_employee Table
	CONSTRAINT PK_team_employee PRIMARY KEY(team_employee_id),
	CONSTRAINT U1_team_employee UNIQUE(team_id, employee_id),
	CONSTRAINT FK1_team_employee FOREIGN KEY(team_id) REFERENCES team(team_id),
	CONSTRAINT FK2_team_employee FOREIGN KEY(employee_id) REFERENCES employee(employee_id)
)

-- 14 --
Create Table employee_role(
	-- Columns for the employee_role Table
	employee_role_id int identity,
	employee_id int not null,
	role_id int not null,
	is_active char(1) default 'T'
	-- Constraints on the employee_role Table
	CONSTRAINT PK_employee_role PRIMARY KEY(employee_role_id),
	CONSTRAINT FK1_employee_role FOREIGN KEY(employee_id) REFERENCES employee(employee_id),
	CONSTRAINT FK2_employee_role FOREIGN KEY(role_id) REFERENCES role(role_id)
)

-- 15 --
Create Table department_supervisor(
	-- Columns for the department_supervisor Table
	department_supervisor_id int identity,
	department_id int not null,
	employee_id int not null,
	is_active char(1) default 'T'
	-- Constraints on the department_supervisor Table
	CONSTRAINT PK_department_supervisor PRIMARY KEY(department_supervisor_id),
	CONSTRAINT U1_department_supervisor UNIQUE(department_id),
	CONSTRAINT FK1_department_supervisor FOREIGN KEY(department_id) REFERENCES department(department_id),
	CONSTRAINT FK2_department_supervisor FOREIGN KEY(employee_id) REFERENCES employee(employee_id)
)

-- 16 --
	Create Table kpi(
	-- Columns for the kpi Table
	kpi_id int identity,
	kpi_name varchar(20) not null,
	description varchar(200),
	url_endpoint varchar(200),
	kpi_type_id int not null,
	is_active char(1) default 'T'
	-- Constraints on the kpi Table
	CONSTRAINT PK_kpi PRIMARY KEY(kpi_id),
	CONSTRAINT FK1_kpi FOREIGN KEY(kpi_type_id) REFERENCES kpi_type(kpi_type_id)
)

-- 17 --
Create Table application_kpi(
	-- Columns for the application_kpi Table
	application_kpi_id int identity,
	application_id int not null,
	kpi_id int not null,
	is_active char(1) default 'T'
	-- Constraints on the application_kpi Table
	CONSTRAINT PK_application_kpi PRIMARY KEY(application_kpi_id),
	CONSTRAINT U1_application_KPI UNIQUE(application_id,kpi_id),
	CONSTRAINT FK1_application_kpi FOREIGN KEY(application_id) REFERENCES application(application_id),
	CONSTRAINT FK2_application_kpi FOREIGN KEY(kpi_id) REFERENCES kpi(kpi_id)
)

-- 18 --
Create Table product_kpi(
	-- Columns for the product_kpi Table
	product_kpi_id int identity,
	product_id int not null,
	kpi_id int not null,
	is_active char(1) default 'T'
	-- Constraints on the product_kpi Table
	CONSTRAINT PK_product_kpi PRIMARY KEY(product_kpi_id),
	CONSTRAINT U1_product_kpi UNIQUE(product_id,kpi_id),
	CONSTRAINT FK1_product_kpi FOREIGN KEY(product_id) REFERENCES product(product_id),
	CONSTRAINT FK2_product_kpi FOREIGN KEY(kpi_id) REFERENCES kpi(kpi_id)
)

-- 19 --
Create Table capability_kpi(
	-- Columns for the capability_kpi Table
	capability_kpi_id int identity,
	capability_id int not null,
	kpi_id int not null,
	is_active char(1) default 'T'
	-- Constraints on the capability_kpi Table
	CONSTRAINT PK_capability_kpi PRIMARY KEY(capability_kpi_id),
	CONSTRAINT U1_capability_kpi UNIQUE(capability_id,kpi_id),
	CONSTRAINT FK1_capability_kpi FOREIGN KEY(capability_id) REFERENCES capability(capability_id),
	CONSTRAINT FK2_capability_kpi FOREIGN KEY(kpi_id) REFERENCES kpi(kpi_id)
)

-- 20 --
Create Table product_capability(
	-- Columns for the product_capability Table
	product_capability_id int identity,
	product_id int not null,
	capability_id int not null,
	is_active char(1) default 'T'
	-- Constraints on the product_capability Table
	CONSTRAINT PK_product_capability PRIMARY KEY(product_capability_id),
	CONSTRAINT U1_product_capability UNIQUE(product_id,capability_id),
	CONSTRAINT FK1_product_capability FOREIGN KEY(product_id) REFERENCES product(product_id),
	CONSTRAINT FK2_product_capability FOREIGN KEY(capability_id) REFERENCES capability(capability_id)
)

-- 21 --
Create Table capability_application(
	-- Columns for the capability_application Table
	capability_app_id int identity,
	capability_id int not null,
	application_id int not null,
	is_active char(1) default 'T'
	-- Constraints on the capability_application Table
	CONSTRAINT PK_capability_application PRIMARY KEY(capability_app_id),
	CONSTRAINT U1_capability_application UNIQUE(capability_id,application_id),
	CONSTRAINT FK1_capability_application FOREIGN KEY(capability_id) REFERENCES capability(capability_id),
	CONSTRAINT FK2_capability_application FOREIGN KEY(application_id) REFERENCES application(application_id)
)
