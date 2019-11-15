/*
	IST 659 Data Admin Concepts &Db Mgmt
	Date: 9/30/2018
	Project Deliverable 2: INSERTS
	
*/

-- DELETE all the records from contact_channel_preference
--DELETE FROM contact_channel_preference
-- 1: Add Rows to the Contact Channel Preference Table
INSERT INTO contact_channel_preference(cc_preference_type)
	VALUES('EMAIL'),('PHONE'),('SMS')


-- Test Insert
SELECT * FROM contact_channel_preference

-- DELETE all the records then insert new set
--DELETE FROM employee
-- 2: Add Rows to the Employee Table
INSERT INTO employee(first_name,last_name,title,phone,email,cc_preference_id)
	VALUES 
		('Ryan','Timbrook','Manager, Software Development','206-516-9956','Ryan.Timbrook1@T-Mobile.com',(SELECT cc_preference_id FROM contact_channel_preference WHERE cc_preference_type='EMAIL')),
		('Kristy','Gillis','Sr Engineer, Software','612-799-8100','Kristy.Gillis1@T-Mobile.com',(SELECT cc_preference_id FROM contact_channel_preference WHERE cc_preference_type='PHONE')),
		('Edjan','Preut','Sr Engineer, Systems Reliability','206-696-0656','Edjan.Preut@T-Mobile.com',(SELECT cc_preference_id FROM contact_channel_preference WHERE cc_preference_type='SMS')),
		('Phoebe','Parsons','Engineer, Software','425-499-7542','Phoebe.Parsons2@T-Mobile.com',(SELECT cc_preference_id FROM contact_channel_preference WHERE cc_preference_type='SMS')),
		('Paul','James','Sr Analyst, Technical','206-819-9955','Paul.James@T-Mobile.com',(SELECT cc_preference_id FROM contact_channel_preference WHERE cc_preference_type='EMAIL')),
		('David','Marshall','Manager, Project Management Technical','206-226-9532','David.Marshall@T-Mobile.com',(SELECT cc_preference_id FROM contact_channel_preference WHERE cc_preference_type='EMAIL')),
		('Rob','Stamm','Sr Manager, Software Development','425-383-2919','Robert.Stamm@T-Mobile.com',(SELECT cc_preference_id FROM contact_channel_preference WHERE cc_preference_type='SMS')),
		('Leigh','Gower','Sr Director, Software Development','206-940-0657','Leigh.Gower@T-Mobile.com',(SELECT cc_preference_id FROM contact_channel_preference WHERE cc_preference_type='SMS')),
		('Matthew','Davis','VP, IT Development','425-383-6242','Matthew.Davis@T-Mobile.com',(SELECT cc_preference_id FROM contact_channel_preference WHERE cc_preference_type='SMS')),
		('Trevor','Malmos','Sr Manager, Product Management','425-383-5309','Trevor.Malmos@T-Mobile.com',(SELECT cc_preference_id FROM contact_channel_preference WHERE cc_preference_type='EMAIL')),
		('Ryan','Yokal','Sr Manager, Product Management','425-383-8366','Ryan.Yokel@T-mobile.com',(SELECT cc_preference_id FROM contact_channel_preference WHERE cc_preference_type='SMS'))

-- Test Insert
SELECT * FROM employee

-- 3: Add Rows to the department table
INSERT INTO department(department_name, description)
	VALUES
		('Voice Services','Contact Center, Inbound Voice IVR Development Team'),
		('SMPD','Social Media Product Development'),
		('Connected Customer','Combined SMPD and Voice Services Teams'),
		('Digital Business Connected Customer','Combined Connected Customer Teams and Digital Business Teams'),
		('Frontline Care','Parent Organization of all Frontline Care Applications'),
		('B2B And Commissions','Business to Business Teams and Commissions Teams')
-- Test department
SELECT * FROM department

-- Update Department Parent Child Relationship
UPDATE department
SET department_parent_id = (SELECT department_id FROM department WHERE department_name = 'Connected Customer')
WHERE department_name = 'Voice Services'

UPDATE department
SET department_parent_id = (SELECT department_id FROM department WHERE department_name = 'Connected Customer')
WHERE department_name = 'SMPD'

UPDATE department
SET department_parent_id = (SELECT department_id FROM department WHERE department_name = 'Digital Business Connected Customer')
WHERE department_name = 'Connected Customer'

UPDATE department
SET department_parent_id = (SELECT department_id FROM department WHERE department_name = 'Digital Business Connected Customer')
WHERE department_name = 'B2B And Commissions'

UPDATE department
SET department_parent_id = (SELECT department_id FROM department WHERE department_name = 'Frontline Care')
WHERE department_name = 'Digital Business Connected Customer'

UPDATE department
SET department_parent_id = (SELECT department_id FROM department WHERE department_name = 'Frontline Care')
WHERE department_name = 'Frontline Care'

SELECT * FROM department


-- 4: Add Rows to the role table
INSERT INTO role(role_name, description)
	VALUES
		('VP, IT Development','Vice Precident of IT Development'),
		('Sr Director, Software Development','Senior Director of Software Development'),
		('Director, Software Development','Director of Software Development'),
		('Sr Manager, Software Development','Senior Manager of Software Development'),
		('Manager, Software Development','Manager of Software Development'),
		('Sr Manager, Product Management','Senior Manager of Product Management'),
		('Tech. Product Owner','Technical Product Owner'),
		('AppOps Engineer','Application Operations Engineer'),
		('Scrum Master','Agile Software Delivery Scrum Master'),
		('Tech. Delivery Mgr','Technical Delivery Manager'),
		('Technical Analyst','Technical Systems Analyst'),
		('Software Engineer','Software Engineer'),
		('SDET','Software Engineer in Test')
-- Test role
SELECT * FROM role

-- 5: Add Rows to the team table
INSERT INTO team(team_name, description, department_id)
	VALUES
		('Voice Portal Product','SIVR Business Product Owner Team',(SELECT department_id FROM department WHERE department_name='Voice Services')),
		('Voice Portal Delivery','SIVR DevOps Software Delivery Team',(SELECT department_id FROM department WHERE department_name='Voice Services')),
		('Voice Services Gamma Delivery','SIVR Agile DevTeam that supports the SIVR Postpaid voice experience application',(SELECT department_id FROM department WHERE department_name='Voice Services')),
		('Voice Services Gamma Support','SIVR Kanban Non-Dev team that supports the SIVR Postpaid voice experience application',(SELECT department_id FROM department WHERE department_name='Voice Services')),
		('Voice Services Gamma AppOps','SIVR Application Opperations Production Support team that supports the SIVR Postpaid voice',(SELECT department_id FROM department WHERE department_name='Voice Services')),
		('Voice Services Omega Delivery ','SIVR Agile DevTeam that supports the SIVR Prepaid voice experience application',(SELECT department_id FROM department WHERE department_name='Voice Services')),
		('Voice Services Omega Support','SIVR Kanban Non-Dev team that supports the SIVR Prepaid voice experience application',(SELECT department_id FROM department WHERE department_name='Voice Services')),
		('Voice Services Omega AppOps','SIVR Application Opperations Production Support team that supports the SIVR Prepaid voice experience ',(SELECT department_id FROM department WHERE department_name='Voice Services')),
		('SpaceBear','SMPD DevOps Team, Focus area is Auth, Shopping, iFrame',(SELECT department_id FROM department WHERE department_name='SMPD')),
		('HuggyBear','SMPD DevOps Team, Focus area is OPEX',(SELECT department_id FROM department WHERE department_name='SMPD'))

-- Test team
SELECT * FROM team
-- Update Team Parent Child Relationship
UPDATE team
SET team_parent_id = (SELECT team_id FROM team WHERE team_name = 'Voice Portal Product')
WHERE team_name = 'Voice Portal Product'

UPDATE team
SET team_parent_id = (SELECT team_id FROM team WHERE team_name = 'Voice Portal Product')
WHERE team_name = 'Voice Portal Delivery'

UPDATE team
SET team_parent_id = (SELECT team_id FROM team WHERE team_name = 'Voice Portal Delivery')
WHERE team_name = 'Voice Services Gamma Delivery'

UPDATE team
SET team_parent_id = (SELECT team_id FROM team WHERE team_name = 'Voice Services Gamma Delivery')
WHERE team_name = 'Voice Services Gamma Support'

UPDATE team
SET team_parent_id = (SELECT team_id FROM team WHERE team_name = 'Voice Services Gamma Delivery')
WHERE team_name = 'Voice Services Gamma AppOps'

UPDATE team
SET team_parent_id = (SELECT team_id FROM team WHERE team_name = 'Voice Portal Delivery')
WHERE team_name = 'Voice Services Omega Delivery'

UPDATE team
SET team_parent_id = (SELECT team_id FROM team WHERE team_name = 'Voice Services Omega Delivery')
WHERE team_name = 'Voice Services Omega Support'

UPDATE team
SET team_parent_id = (SELECT team_id FROM team WHERE team_name = 'Voice Services Omega Delivery')
WHERE team_name = 'Voice Services Omega AppOps'

UPDATE team
SET team_parent_id = (SELECT team_id FROM team WHERE team_name = 'SpaceBear')
WHERE team_name = 'SpaceBear'

UPDATE team
SET team_parent_id = (SELECT team_id FROM team WHERE team_name = 'HuggyBear')
WHERE team_name = 'HuggyBear'

SELECT * FROM team

-- 6: Add Rows to the application table

INSERT INTO application(app_name, description)
	VALUES
		('SIVR Postpaid','Speech Self-Service Application supporting the Postpaid product'),
		('SIVR Prepaid','Speech Self-Service Application supporting the Prepaid product'),
		('SIVR U2 Prepaid','Speech Self-Service Application supporting the U2 Prepaid product'),
		('Lithium','SMPD - Social Messaging (Twitter, Facebook)'),
		('Live Engage','SMPD - Messaging (Async, Sync, iMessage, SMS)'),
		('CCS','Commissions')

-- Test application
SELECT * FROM application

-- 7: Add Rows to the kpi_type table
INSERT INTO kpi_type(kpi_type, description)
	VALUES
		('Quantitative','indicators that can be presented with a number'),
		('Qualitative','indicators that cant be presented as a number'),
		('Leading','indicators that can predict the outcome of a process'),
		('Lagging','indicators that present the success or failure post hoc'),
		('Input','indicators that measure the amount of resources consumed during the generation of the outcome'),
		('Process','indicators that represent the efficiency or the productivity of the process'),
		('Output','indicators that reflect the outcome or results of the process activities'),
		('Practical','indicators that interface with existing company processes'),
		('Directional','indicators specifying whether or not an organization is getting better'),
		('Actionable','indicators are sufficiently in an organizations control to effect change'),
		('Financial','indicators used in performance measurement and when looking at an operating index')

-- Test kpi_type
SELECT * FROM kpi_type

-- 8: Add Rows to the kpi table
INSERT INTO kpi(kpi_name,description,url_endpoint,kpi_type_id)
	VALUES
		('CPA','Frontline calls per account','https://dummy.com/kpi/care/voice/cpa/1',(SELECT kpi_type_id from kpi_type WHERE kpi_type='Quantitative')),
		('CPC','Frontline inbound calls per customer','https://dummy.com/kpi/care/voice/cpc/1',(SELECT kpi_type_id from kpi_type WHERE kpi_type='Quantitative')),
		('Call Length','duration of customer inbound call','https://dummy.com/kpi/care/voice/cl/1',(SELECT kpi_type_id from kpi_type WHERE kpi_type='Quantitative')),
		('Transfer Percent','percent of inbound customers transferred to an agent','https://dummy.com/kpi/care/voice/tp/1',(SELECT kpi_type_id from kpi_type WHERE kpi_type='Quantitative')),
		('Deflection Rate','SIVR inbound calls contained within the system','https://dummy.com/kpi/care/voice/dr/1',(SELECT kpi_type_id from kpi_type WHERE kpi_type='Quantitative')),
		('CSAT','Customer Satisfaction Score','https://dummy.com/kpi/care/voice/csat/1',(SELECT kpi_type_id from kpi_type WHERE kpi_type='Quantitative')),
		('CPH','Messenging Conversations Per Hour','https://dummy.com/kpi/care/messaging/cph/1',(SELECT kpi_type_id from kpi_type WHERE kpi_type='Quantitative')),
		('TTFR','Messenging Time to First Response by Care','https://dummy.com/kpi/care/messaging/ttfr/1',(SELECT kpi_type_id from kpi_type WHERE kpi_type='Quantitative')),
		('VOC','Voice of the Customer','https://dummy.com/kpi/care/voc/1',(SELECT kpi_type_id from kpi_type WHERE kpi_type='Quantitative'))

-- Test kpi
SELECT * FROM kpi

-- 9: Add Rows to the product table
INSERT INTO product(product_name, description)
	VALUES
		('SIVR Postpaid','Speech Self-Service IVR System for the Postpaid Customer'),
		('SIVR Prepaid','Speech Self-Service IVR System for the Prepaid Customer'),
		('SIVR U2 Prepaid','Speech Self-Service IVR System for the U2 Prepaid Customer'),
		('Messaging','Social Messaging Channel Connecting Customers to Care Agents through SMS and Social Technology Channels'),
		('Commissions','Commissions payment systems for Retaila and Care Agents')
-- Test product
SELECT * FROM product

-- 10: Add Rows to the capability table
INSERT INTO capability(capability_name, description)
	VALUES
		('Make a Payment','Automation self-service feature allowing a customer to make bill payment'),
		('Make Payment Arrangements','Automation self-service feature allowing a customer to configure automated scheduled payments to a bill'),
		('Usage','Automated self-service feature allowing a customer to make inquires about their phone usage'),
		('Account Balance Lookup','Automated self-service feature allowing a customer to lookup their account balance'),
		('Order Status','Automated self-service feature allowing a customer to inquire about the status of their purchase order'),
		('Store Locator','Automated self-service feature allowing a customer to inquire location of retail stores'),
		('PIN Validation','Automated self-service feature allowing a customer to set or update their security PIN'),
		('Authentication','Automated self-service feature allowing a customer to authenticate themselves'),
		('Add A Line','Automated self-service feature allowing a customer to add additional lines to their service')

-- Test capability
SELECT * FROM capability
