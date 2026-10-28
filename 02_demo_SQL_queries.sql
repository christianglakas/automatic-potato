-- 	SQL queries to demonstrate proficiency - Christian Glakas

-- 	===========================================================================
-- 	Category 1: ENVIRONMENT SETUP & LOOKUP ARCHITECTURE
--  Focus:		Establishing database context and inspecting system entities
-- 	===========================================================================   

-- 	1) System Initialization - Establish workspace . 
USE classicmodels;

-- 	2) Base structural audit - Verify table presence.
SHOW TABLES;

-- 	3) Basic Lookups - Visual inspection of tables.
-- 	Customer profiles
SELECT * 
FROM customers
LIMIT 5;			
/* 	
| customerNumber | customerName                 | contactLastName | contactFirstName | phone             | addressLine1                 | addressLine2 | city          | state    | postalCode | country   | salesRepEmployeeNumber | creditLimit |
|----------------|------------------------------|-----------------|------------------|-------------------|------------------------------|--------------|---------------|----------|------------|-----------|------------------------|-------------|
| 103            | Atelier graphique            | Schmitt         | Carine           | 40.32.2555        | 54, rue Royale               | NULL         | Nantes        | NULL     | 44000      | France    | 1370                   | 21000.00    |
| 112            | Signal Gift Stores           | King            | Jean             | 7025551838        | 8489 Strong St.              | NULL         | Las Vegas     | NV       | 83030      | USA       | 1166                   | 71800.00    |
| 114            | Australian Collectors, Co.   | Ferguson        | Peter            | 03 9520 4555      | 636 St Kilda Road            | Level 3      | Melbourne     | Victoria | 3004       | Australia | 1611                   | 117300.00   |
| 119            | La Rochelle Gifts            | Labrune         | Janine           | 40.67.8555        | 67, rue des Cinquante Otages | NULL         | Nantes        | NULL     | 44000      | France    | 1370                   | 118200.00   |
| 121            | Baane Mini Imports           | Bergulfsen      | Jonas            | 07-98 9555        | Erling Skakkes gate 78       | NULL         | Stavern       | NULL     | 4110       | Norway    | 1504                   | 81700.00    |
*/

-- 	Product & inventory tracking structure
SELECT 	 
	productCode,
    productName,
    productLine,
    productScale,
    productVendor,
    LEFT(productDescription, 30) AS short_description,
    quantityinStock,
    buyPrice,
    MSRP
FROM products
LIMIT 5; 		
/*
| productCode | productName                           | productLine  | productScale | productVendor            | short_description              | quantityinStock | buyPrice | MSRP   |
|-------------|---------------------------------------|--------------|--------------|--------------------------|--------------------------------|-----------------|----------|--------|
| S10_1678    | 1969 Harley Davidson Ultimate Chopper | Motorcycles  | 1:10         | Min Lin Diecast          | This replica features working  | 7933            | 48.81    | 95.70  |
| S10_1949    | 1952 Alpine Renault 1300              | Classic Cars | 1:10         | Classic Metal Creations  | Turnable front wheels; steerin | 7305            | 98.58    | 214.30 |
| S10_2016    | 1996 Moto Guzzi 1100i                 | Motorcycles  | 1:10         | Highway 66 Mini Classics | Official Moto Guzzi logos and  | 6625            | 68.99    | 118.94 |
| S10_4698    | 2003 Harley-Davidson Eagle Drag Bike  | Motorcycles  | 1:10         | Red Start Diecast        | Model features, official Harle | 5582            | 91.02    | 193.66 |
| S10_4757    | 1972 Alfa Romeo GTA                   | Classic Cars | 1:10         | Motor City Art Classics  | Features include: Turnable fro | 3252            | 85.68    | 136.00 |
*/

-- 	Order history
SELECT *
FROM orders
LIMIT 5;			
/*
| orderNumber | orderDate  | requiredDate | shippedDate | status  | comments               | customerNumber |
|-------------|------------|--------------|-------------|---------|------------------------|----------------|
| 10100       | 2003-01-06 | 2003-01-13   | 2003-01-10  | Shipped | NULL                   | 363            |
| 10101       | 2003-01-09 | 2003-01-18   | 2003-01-11  | Shipped | Check on availability. | 128            |
| 10102       | 2003-01-10 | 2003-01-18   | 2003-01-14  | Shipped | NULL                   | 181            |
| 10103       | 2003-01-29 | 2003-02-07   | 2003-02-02  | Shipped | NULL                   | 121            |
| 10104       | 2003-01-31 | 2003-02-09   | 2003-02-01  | Shipped | NULL                   | 141            |
*/

--  Order details
SELECT *
FROM orderdetails
LIMIT 5;
/*
| orderNumber | productCode | quantityOrdered | priceEach | orderLineNumber |
|-------------|-------------|-----------------|-----------|-----------------|
| 10100       | S18_1749    | 30              | 136.00    | 3               |
| 10100       | S18_2248    | 50              | 55.09     | 2               |
| 10100       | S18_4409    | 22              | 75.46     | 4               |
| 10100       | S24_3969    | 49              | 35.29     | 1               |
| 10101       | S18_2325    | 25              | 108.06    | 4               |
*/

-- 	===========================================================================
-- 	Category 2: BUSINESS AGGREGATIONS & DESCRIPTIVE STATISTICS
--  Focus:		Understanding dataset boundaries, volume metrics, and groupings
-- 	===========================================================================   

-- 	--- PART A: BASE DESCRIPTIVE STATISTICS ---

-- 	1) Basic Summary Metrics
--  Goal: Find total order volume, total items sold, price ranges and average item price. 
--  Requires: Standard aggregations.
SELECT 
	COUNT(orderNumber) AS total_orders_processed,
    SUM(quantityOrdered) AS total_items_sold,
    MIN(priceEach) AS cheapest_item_sold,
    MAX(priceEach) AS most_expensive_item_sold,
    AVG(priceEach) AS overall_average_item_price
FROM orderdetails;
/*
| total_orders_processed | total_items_sold | cheapest_item_sold | most_expensive_item_sold | overall_average_item_price |
|------------------------|------------------|--------------------|--------------------------|----------------------------|
| 2996                   | 105516           | 26.55              | 214.30                   | 90.769499                  |
*/

--  2) Customer Credit Report
-- 	Goal: Find our highest, lowest and average credit limits, by country. 
--  Requires: GROUP BY and HAVING clauses.
SELECT
	country,
    COUNT(customerNumber) AS total_customers,
    MAX(creditLimit) AS max_credit,
    AVG(creditLimit) AS avg_credit
FROM customers
GROUP BY country
HAVING max_credit > 0
ORDER BY total_customers DESC
LIMIT 5;  

/*
| country   | total_customers | max_credit | avg_credit   |
|-----------|-----------------|------------|--------------|
| USA       | 36              | 210500.00  | 78102.777778 |
| Germany   | 13              | 120400.00  | 19776.923077 |
| France    | 12              | 123900.00  | 77691.666667 |
| Spain     | 7               | 227600.00  | 73971.428571 |
| Australia | 5               | 117300.00  | 86060.000000 |
*/
	-- All customers shown have average credit lines ~ $70-80K except for Germany, an outlier with average credit under $20k. 
    
    
-- 	--- PART B: JOINS & BASIC SUBQUERIES  ---

--  3) Customer Order Tracking
--  Goal: Show customers with their orders, with order dates and specific line items.
--  Requires: Multi-table INNER JOIN of 3 tables
SELECT
	c.customerNumber,
    c.customerName,
    o.orderNumber,
    o.orderDate,
    od.productCode,
    od.quantityOrdered
FROM customers c 
	INNER JOIN orders o 
		ON c.customerNumber = o.customerNumber
	INNER JOIN orderdetails od 
		ON o.orderNumber = od.orderNumber
ORDER BY c.customerNumber
LIMIT 10;
/*
| customerNumber | customerName       | orderNumber | orderDate  | productCode | quantityOrdered |
|----------------|--------------------|-------------|------------|-------------|-----------------|
| 103            | Atelier graphique  | 10123       | 2003-05-20 | S18_1589    | 26              |
| 103            | Atelier graphique  | 10123       | 2003-05-20 | S18_2870    | 46              |
| 103            | Atelier graphique  | 10123       | 2003-05-20 | S18_3685    | 34              |
| 103            | Atelier graphique  | 10123       | 2003-05-20 | S24_1628    | 50              |
| 103            | Atelier graphique  | 10298       | 2004-09-27 | S10_2016    | 39              |
| 103            | Atelier graphique  | 10298       | 2004-09-27 | S18_2625    | 32              |
| 103            | Atelier graphique  | 10345       | 2004-11-25 | S24_2022    | 43              |
| 112            | Signal Gift Stores | 10124       | 2003-05-21 | S18_1749    | 21              |
| 112            | Signal Gift Stores | 10124       | 2003-05-21 | S18_2248    | 42              |
| 112            | Signal Gift Stores | 10124       | 2003-05-21 | S18_2325    | 42              |
*/

-- 	4) Inventory Outlier Filtering
--  Goal: Identify warehouses holding inventory above standard company averages.
--  Requires: a simple subquery in the WHERE clause.
SELECT
	productCode,
    productName,
    productLine,
    quantityinStock
FROM products
WHERE quantityinStock > (SELECT AVG(quantityinStock) FROM products)
ORDER BY quantityinStock DESC
LIMIT 10;
/*
| productCode | productName                      | productLine  | quantityinStock |
|-------------|----------------------------------|--------------|-----------------|
| S12_2823    | 2002 Suzuki XREO                 | Motorcycles  | 9997            |
| S18_1984    | 1995 Honda Civic                 | Classic Cars | 9772            |
| S700_2466   | America West Airlines B757-200   | Planes       | 9653            |
| S24_3432    | 2002 Chevy Corvette              | Classic Cars | 9446            |
| S18_2325    | 1932 Model A Ford J-Coupe        | Vintage Cars | 9354            |
| S32_2206    | 1982 Ducati 996 R                | Motorcycles  | 9241            |
| S24_3151    | 1912 Ford Model T Delivery Wagon | Vintage Cars | 9173            |
| S18_3482    | 1976 Ford Gran Torino            | Classic Cars | 9127            |
| S12_3380    | 1968 Dodge Charger               | Classic Cars | 9123            |
| S18_1589    | 1965 Aston Martin DB5            | Classic Cars | 9042            |
*/
	--  Good. But The CEO wants to see what our average quantity in stock is, on this report.
	--  Requires: another simple subquery in the SELECT clause
SELECT
	productCode,
    productName,
    productLine,
    quantityinStock,
    (SELECT AVG(quantityinStock) FROM products) AS avg_quantityinStock
FROM products
WHERE quantityinStock > (SELECT AVG(quantityinStock) FROM products)
ORDER BY quantityinStock DESC
LIMIT 10;
/*
| productCode | productName                      | productLine  | quantityinStock | avg_quantityinStock |
|-------------|----------------------------------|--------------|-----------------|---------------------|
| S12_2823    | 2002 Suzuki XREO                 | Motorcycles  | 9997            | 5046.6455           |
| S18_1984    | 1995 Honda Civic                 | Classic Cars | 9772            | 5046.6455           |
| S700_2466   | America West Airlines B757-200   | Planes       | 9653            | 5046.6455           |
| S24_3432    | 2002 Chevy Corvette              | Classic Cars | 9446            | 5046.6455           |
| S18_2325    | 1932 Model A Ford J-Coupe        | Vintage Cars | 9354            | 5046.6455           |
| S32_2206    | 1982 Ducati 996 R                | Motorcycles  | 9241            | 5046.6455           |
| S24_3151    | 1912 Ford Model T Delivery Wagon | Vintage Cars | 9173            | 5046.6455           |
| S18_3482    | 1976 Ford Gran Torino            | Classic Cars | 9127            | 5046.6455           |
| S12_3380    | 1968 Dodge Charger               | Classic Cars | 9123            | 5046.6455           |
| S18_1589    | 1965 Aston Martin DB5            | Classic Cars | 9042            | 5046.6455           |
*/

-- 	--- PART C: EXPANDED LOOKUPS ---

--  5) Customer Peak Payments
--  Goal: Show customers' names & ID numbers with their largest individual payment amounts.   
--  Requires: Subquery in the SELECT clause. 
SELECT
	c.customerName,
    c.customerNumber,
    (SELECT MAX(p.amount)
     FROM payments p 
     WHERE p.customerNumber = c.customerNumber) AS max_amount_paid
FROM customers c
ORDER BY max_amount_paid DESC
LIMIT 5;
/*
| customerName                 | customerNumber | max_amount_paid |
|------------------------------|----------------|-----------------|
| Euro+ Shopping Channel       | 141            | 120166.58       |
| Mini Gifts Distributors Ltd. | 124            | 111654.40       |
| Dragon Souveniers, Ltd.      | 148            | 105743.00       |
| Corporate Gift Ideas Co.     | 321            | 85559.12        |
| Herkku Gifts                 | 167            | 85024.46        |
*/

-- 	================================================================================
-- 	Category 3: HIGHER ORDER BUSINESS INTERSECTIONS & DATA MANIPULATION
--  Focus:		Advanced multi-table intersections, nested sets, and safe mutations
-- 	================================================================================  

-- --- PART A: ADVANCED SUBQUERIES & JOINS

--  1) Total Payments & Items Ordered
--  Goal: Show total payments, and total quantity of items ordered, per customer.
-- 	Requires: A subquery in the FROM clause; JOIN to bridge unrelated tables.

--  First, find the sum of all amounts paid by each customer, in the payments table. 
SELECT 
	customerNumber, SUM(amount) AS total_paid
FROM payments
GROUP BY customerNumber;

--  Next, find the total number of items ordered, in the orderdetails table.
SELECT 
	orderNumber, SUM(quantityOrdered) AS total_items_ordered
FROM orderdetails
GROUP BY orderNumber;

--  These 2 tables aren't related.
--  So we must bridge the tables by joining them with a 3rd table that is related to both.
--  The orders table has the 2 keys we'll need: orderNumber (PK for orderdetails table) and customerNumber (PK for payments table).
SELECT
	pay_summary.customerNumber,
    pay_summary.total_paid,
    order_summary.total_items_ordered
FROM (
	SELECT customerNumber, SUM(amount) AS total_paid
	FROM payments 
	GROUP BY customerNumber
) pay_summary 
INNER JOIN (
	SELECT o.customerNumber, SUM(quantityOrdered) AS total_items_ordered
    FROM orders o
    INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
    GROUP BY o.customerNumber
) order_summary ON pay_summary.customerNumber = order_summary.customerNumber
LIMIT 10;
/* 
| customerNumber | total_paid | total_items_ordered |
|----------------|------------|---------------------|
| 103            | 22314.36   | 270                 |
| 112            | 80180.98   | 929                 |
| 114            | 180585.07  | 1926                |
| 119            | 116949.68  | 1832                |
| 121            | 104224.79  | 1082                |
| 124            | 584188.24  | 6366                |
| 128            | 75937.76   | 811                 |
| 129            | 66710.56   | 692                 |
| 131            | 107639.94  | 1631                |
| 141            | 715738.98  | 9327                |
*/

-- 	2) Identify High Volatility Accounts
--  Goal: Flag accounts where cancelled order value > 20% of the lifetime spend. 
--  Requires: Conditional aggregation (CASE WHEN) paired with a percentage threshold filter.

SELECT
	o.customerNumber,
    c.customerName,
    SUM(CASE WHEN o.status = "Shipped" THEN od.quantityOrdered * od.priceEach ELSE 0 END) AS total_spend,
	SUM(CASE WHEN o.status = "Cancelled" THEN od.quantityOrdered * od.priceEach ELSE 0 END) AS total_cancelled_value
FROM orders o
	INNER JOIN orderDetails od
		ON od.orderNumber = o.orderNumber
	INNER JOIN customers c
		ON c.customerNumber = o.customerNumber
GROUP BY o.customerNumber,
		 c.customerName
HAVING total_cancelled_value > (total_spend * .20) -- Cancelled order value > 20% successful order value   
ORDER BY total_cancelled_value DESC;

/*
| customerNumber | customerName            | total_spend | total_cancelled_value |
|----------------|-------------------------|-------------|-----------------------|
| 201            | UK Collectables, Ltd.   | 61167.18    | 45443.54              |
| 448            | Scandinavian Gift Ideas | 76776.44    | 44167.09              |
| 131            | Land of Toys Inc.       | 107639.94   | 41445.21              |
| 357            | GiftsForHim.com         | 56662.38    | 37769.38              |
| 496            | Kelly's Gift Shop       | 114497.19   | 22963.60              |
*/


-- --- PART B: SPECIALIZED MATRIX JOINS & SET OPERATORS ---

-- 3) Corporate Hierarchical Reporting Matrix
-- Goal: Walk the internal labor chain to match staff names with their precise supervisors.
-- Requires: A table Self-Join utilizing mismatched matching keys.

SELECT
	emp.employeeNumber AS staff_id,
    CONCAT(emp.firstName, ' ', emp.lastName) AS staff_name,
    emp.jobTitle AS staff_title,
    CONCAT(mgr.firstName, ' ', mgr.lastName) AS supervisor_name,
    mgr.employeeNumber AS supervisor_id
FROM employees emp
	LEFT JOIN employees mgr ON emp.reportsTo = mgr.employeeNumber
LIMIT 10;
/*
| staff_id | staff_name        | staff_title          | supervisor_name | supervisor_id |
|----------|-------------------|----------------------|-----------------|---------------|
| 1002     | Diane Murphy      | President            | NULL            | NULL          |
| 1056     | Mary Patterson    | VP Sales             | Diane Murphy    | 1002          |
| 1076     | Jeff Firrelli     | VP Marketing         | Diane Murphy    | 1002          |
| 1088     | William Patterson | Sales Manager (APAC) | Mary Patterson  | 1056          |
| 1102     | Gerard Bondur     | Sale Manager (EMEA)  | Mary Patterson  | 1056          |
| 1143     | Anthony Bow       | Sales Manager (NA)   | Mary Patterson  | 1056          |
| 1165     | Leslie Jennings   | Sales Rep            | Anthony Bow     | 1143          |
| 1166     | Leslie Thompson   | Sales Rep            | Anthony Bow     | 1143          |
| 1188     | Julie Firrelli    | Sales Rep            | Anthony Bow     | 1143          |
| 1216     | Steve Patterson   | Sales Rep            | Anthony Bow     | 1143          |
*/
    
-- 4) Pricing Integrity Strategy Audits: Rogue Discounter Exception Report
-- Goal: Isolate unauthorized sales where final discount exceeded the corporate MSRP discount boundary of 20%.
-- Requires: Multi-condition JOIN syntax with math formulas to calculate percentages.

SELECT * FROM products;
SELECT * FROM orderDetails;

SELECT
	od.orderNumber,
    c.customerName,
    p.productCode,
    LEFT(p.productName, 25) AS product_name,
    p.MSRP,
    od.priceEach AS final_sale_price,
    ROUND((1 - (od.priceEach / p.MSRP)) * 100, 5) AS exact_discount_percent
FROM orderDetails od
	INNER JOIN products p
		ON od.productCode = p.productCode
        AND od.priceEach < (p.MSRP * 0.80)
	INNER JOIN orders o 
		ON o.orderNumber = od.orderNumber
    INNER JOIN customers c 
		ON c.customerNumber = o.customerNumber
ORDER BY exact_discount_percent DESC
LIMIT 10;
/*
| orderNumber | customerName                 | productCode | product_name              | MSRP  | final_sale_price | exact_discount_percent |
|-------------|------------------------------|-------------|---------------------------|-------|------------------|------------------------|
| 10162       | Corporate Gift Ideas Co.     | S24_3969    | 1936 Mercedes Benz 500k R | 41.03 | 32.82            | 20.00975               |
| 10138       | Kelly's Gift Shop            | S24_3969    | 1936 Mercedes Benz 500k R | 41.03 | 32.82            | 20.00975               |
| 10380       | Euro+ Shopping Channel       | S24_3969    | 1936 Mercedes Benz 500k R | 41.03 | 32.82            | 20.00975               |
| 10185       | Mini Creations Ltd.          | S50_1514    | 1962 City of Detroit Stre | 58.58 | 46.86            | 20.00683               |
| 10147       | Collectables For Less Inc.   | S24_3371    | 1971 Alpine Renault 1600s | 61.23 | 48.98            | 20.00653               |
| 10322       | Online Diecast Creations Co. | S24_1937    | 1939 Chevrolet Deluxe Cou | 33.19 | 26.55            | 20.00603               |
| 10391       | Anna's Decorations, Ltd      | S24_1937    | 1939 Chevrolet Deluxe Cou | 33.19 | 26.55            | 20.00603               |
| 10273       | Petit Auto                   | S700_2610   | The USS Constitution Ship | 72.28 | 57.82            | 20.00553               |
| 10386       | Euro+ Shopping Channel       | S700_4002   | American Airlines: MD-11S | 74.03 | 59.22            | 20.00540               |
| 10263       | Gift Depot Inc.              | S18_2581    | P-51-D Mustang            | 84.48 | 67.58            | 20.00473               |
*/

-- 5) Global Supply Chain Footprint & Logistics Mapping (Executive Regional View)
-- Goal: Combine customer and office footprints into one logistics index; add categorization by global continent.
-- Requires: Set operators (UNION) embedded with conditional CASE mapping logic.

SELECT
	CASE
		WHEN country IN('France', 'Germany', 'UK', 'Spain', 'Italy', 'Austria', 'Belgium', 'Norway', 'Sweden', 'Switzerland', 'Finland', 'Denmark', 'Ireland', 'Netherlands', 'Portugal', 'Poland') THEN 'Europe'
		WHEN country IN('USA', 'Canada') THEN 'North America'
		WHEN country IN('Australia', 'New Zealand', 'Singapore', 'Japan', 'Hong Kong') THEN 'Asia-Pacific'        	
        ELSE 'Other Regions'
	END AS continent,
    country,
    city,
    'Customer Contact' AS contact_type
FROM customers

UNION

SELECT
	CASE
		WHEN country IN('France', 'Germany', 'UK', 'Spain', 'Italy', 'Austria', 'Belgium', 'Norway', 'Sweden', 'Switzerland', 'Finland', 'Denmark', 'Ireland', 'Netherlands', 'Portugal', 'Poland') THEN 'Europe'
		WHEN country IN('USA', 'Canada') THEN 'North America'
		WHEN country IN('Australia', 'New Zealand', 'Singapore', 'Japan', 'Hong Kong') THEN 'Asia-Pacific'        	
        ELSE 'Other Regions'
	END AS continent,
    country,
    city,
    'Corporate Office' AS contact_type
FROM offices

-- Heavily optimized sorting for Executive review
ORDER BY continent, country, contact_type DESC
LIMIT 15;
/*
| continent    | country     | city              | contact_type     |
|--------------|-------------|-------------------|------------------|
| Asia-Pacific | Australia   | South Brisbane    | Customer Contact |
| Asia-Pacific | Australia   | Melbourne         | Customer Contact |
| Asia-Pacific | Australia   | Chatswood         | Customer Contact |
| Asia-Pacific | Australia   | Glen Waverly      | Customer Contact |
| Asia-Pacific | Australia   | North Sydney      | Customer Contact |
| Asia-Pacific | Australia   | Sydney            | Corporate Office |
| Asia-Pacific | Hong Kong   | Central Hong Kong | Customer Contact |
| Asia-Pacific | Japan       | Kita-ku           | Customer Contact |
| Asia-Pacific | Japan       | Minato-ku         | Customer Contact |
| Asia-Pacific | Japan       | Tokyo             | Corporate Office |
| Asia-Pacific | New Zealand | Wellington        | Customer Contact |
| Asia-Pacific | New Zealand | Auckland          | Customer Contact |
| Asia-Pacific | New Zealand | Auckland          | Customer Contact |
| Asia-Pacific | Singapore   | Singapore         | Customer Contact |
| Europe       | Austria     | Salzburg          | Customer Contact |
*/
	-- Executives can instantly see there are only 2 Corporate Offices in the entire Asia-Pacific region: Tokyo and Sydney. 
    

-- --- PART C: CONDITIONAL DATA MANIPULATION (DML) & SAFETY ---

-- 6) Strategic Commercial Expansion & Credit Loyalty Simulation
-- Goal: Model a multi-phase corporate expansion and VIP credit incentive program within a risk-free testing boundary; return database to original state.
-- Requires: Transaction control scripts (START TRANSACTION, INSERT, UPDATE with subqueries, DELETE, ROLLBACK).

-- First, enable temporary mode:
START TRANSACTION;

-- Drop 'Safe Updates' mode for this active session to bypass Error 1175
SET SQL_SAFE_UPDATES = 0;

-- Data Mutation Goal #1: Create new record in 'offices' table
-- Inspect table for original number of records
SELECT * FROM offices ORDER BY city;  -- 7 records
/*
| officeCode | city          | phone            | addressLine1             | addressLine2 | state      | country   | postalCode | territory |
|------------|---------------|------------------|--------------------------|--------------|------------|-----------|------------|-----------|
| 2          | Boston        | +1 215 837 0825  | 1550 Court Place         | Suite 102    | MA         | USA       | 02107      | NA        |
| 7          | London        | +44 20 7877 2041 | 25 Old Broad Street      | Level 7      | NULL       | UK        | EC2N 1HN   | EMEA      |
| 3          | NYC           | +1 212 555 3000  | 523 East 53rd Street     | apt. 5A      | NY         | USA       | 10022      | NA        |
| 4          | Paris         | +33 14 723 4404  | 43 Rue Jouffroy D'abbans | NULL         | NULL       | France    | 75017      | EMEA      |
| 1          | San Francisco | +1 650 219 4782  | 100 Market Street        | Suite 300    | CA         | USA       | 94080      | NA        |
| 6          | Sydney        | +61 2 9264 2451  | 5-11 Wentworth Avenue    | Floor #2     | NULL       | Australia | NSW 2010   | APAC      |
| 5          | Tokyo         | +81 33 224 5000  | 4-1 Kioicho              | NULL         | Chiyoda-Ku | Japan     | 102-8578   | Japan     |
*/
 
-- Inserting values for 8th office
INSERT INTO offices (officeCode, city, phone, addressLine1, country, postalCode, territory)
VALUES ('8', 'Austin', '+1 512 555 0199', '101 Woodstream Blvd', 'USA', '78756', 'NA');

-- Inspect table to verify new record creation
SELECT * FROM offices ORDER BY city;  -- 8 records
/*
| officeCode | city          | phone            | addressLine1             | addressLine2 | state      | country   | postalCode | territory |
|------------|---------------|------------------|--------------------------|--------------|------------|-----------|------------|-----------|
| 8          | Austin        | +1 512 555 0199  | 101 Woodstream Blvd      | NULL         | NULL       | USA       | 78756      | NA        |
| 2          | Boston        | +1 215 837 0825  | 1550 Court Place         | Suite 102    | MA         | USA       | 02107      | NA        |
| 7          | London        | +44 20 7877 2041 | 25 Old Broad Street      | Level 7      | NULL       | UK        | EC2N 1HN   | EMEA      |
| 3          | NYC           | +1 212 555 3000  | 523 East 53rd Street     | apt. 5A      | NY         | USA       | 10022      | NA        |
| 4          | Paris         | +33 14 723 4404  | 43 Rue Jouffroy D'abbans | NULL         | NULL       | France    | 75017      | EMEA      |
| 1          | San Francisco | +1 650 219 4782  | 100 Market Street        | Suite 300    | CA         | USA       | 94080      | NA        |
| 6          | Sydney        | +61 2 9264 2451  | 5-11 Wentworth Avenue    | Floor #2     | NULL       | Australia | NSW 2010   | APAC      |
| 5          | Tokyo         | +81 33 224 5000  | 4-1 Kioicho              | NULL         | Chiyoda-Ku | Japan     | 102-8578   | Japan     |
*/

-- Data Mutation Goal #2: Increase credit limit by 15% for customers who've made a payment > $50,000
-- Inspect existing credit limit for customers with top 5 payment amounts

SELECT  p.customerNumber,
		creditLimit
FROM payments p
	LEFT JOIN customers c 
		ON p.customerNumber = c.customerNumber
WHERE amount > 50000
ORDER BY amount DESC
LIMIT 5;
/*
| customerNumber | creditLimit |
|----------------|-------------|
| 141            | 227600.00   |
| 141            | 227600.00   |
| 124            | 210500.00   |
| 148            | 103800.00   |
| 124            | 210500.00   |
*/ 

-- count # of payments > $50,000
SELECT COUNT(DISTINCT customerNumber)
FROM payments
WHERE amount > 50000;  -- 32 records returned

-- Conditional Modification via Subquery - increase credit limit by 15% for customers with a payment > $50,000
UPDATE customers
SET creditLimit = creditLimit * 1.15
WHERE customerNumber IN (
	SELECT DISTINCT customerNumber
    FROM payments
    WHERE amount > 50000
); 	-- excellent: 32 rows updated

-- Verify credit limits have been modified for customers with top 5 payments, all > $50,000
SELECT  p.customerNumber,
		creditLimit
FROM payments p
	LEFT JOIN customers c 
		ON p.customerNumber = c.customerNumber
WHERE amount > 50000
ORDER BY amount DESC
LIMIT 5;
/*
| customerNumber | creditLimit |
|----------------|-------------|
| 141            | 261740.00   |
| 141            | 261740.00   |
| 124            | 242075.00   |
| 148            | 119370.00   |
| 124            | 242075.00   |
*/	
	-- Confirmed: all credit limits 15% higher than listed above	

-- Restore Safe Updates mode to protect subsequent workflows
SET SQL_SAFE_UPDATES = 1;

-- Clean unwind
ROLLBACK;

-- Confirm ROLLBACK: offices table
SELECT * FROM offices ORDER BY city;
/*
| officeCode | city          | phone            | addressLine1             | addressLine2 | state      | country   | postalCode | territory |
|------------|---------------|------------------|--------------------------|--------------|------------|-----------|------------|-----------|
| 2          | Boston        | +1 215 837 0825  | 1550 Court Place         | Suite 102    | MA         | USA       | 02107      | NA        |
| 7          | London        | +44 20 7877 2041 | 25 Old Broad Street      | Level 7      | NULL       | UK        | EC2N 1HN   | EMEA      |
| 3          | NYC           | +1 212 555 3000  | 523 East 53rd Street     | apt. 5A      | NY         | USA       | 10022      | NA        |
| 4          | Paris         | +33 14 723 4404  | 43 Rue Jouffroy D'abbans | NULL         | NULL       | France    | 75017      | EMEA      |
| 1          | San Francisco | +1 650 219 4782  | 100 Market Street        | Suite 300    | CA         | USA       | 94080      | NA        |
| 6          | Sydney        | +61 2 9264 2451  | 5-11 Wentworth Avenue    | Floor #2     | NULL       | Australia | NSW 2010   | APAC      |
| 5          | Tokyo         | +81 33 224 5000  | 4-1 Kioicho              | NULL         | Chiyoda-Ku | Japan     | 102-8578   | Japan     |
*/
	-- Austin office removed

-- Confirm ROLLBACK: Credit limits of customers with top 5 payments
SELECT  p.customerNumber,
		creditLimit
FROM payments p
	LEFT JOIN customers c 
		ON p.customerNumber = c.customerNumber
WHERE amount > 50000
ORDER BY amount DESC
LIMIT 5;
/*
| customerNumber | creditLimit |
|----------------|-------------|
| 141            | 227600.00   |
| 141            | 227600.00   |
| 124            | 210500.00   |
| 148            | 103800.00   |
| 124            | 210500.00   |
*/
	-- Confirmed: All credit limits returned to original values


-- =========================================================================
-- CATEGORY 4: DATABASE OBJECTS & COMPLEX CONDITIONAL PIVOTS
-- Focus: Columnar reporting, frequency distributions, and semantic layers
-- =========================================================================

-- 1) Sovereign Market Fulfillment & Operational Risk Performance Indices
-- Goal: Evaluate international logistics channels by quantifying successful delivery pipelines against active friction points across unique geographic territories.
-- Requires: 
--   1. An INNER JOIN to combine tables.
--   2. A GROUP BY clause to analyze shipping outcomes by country.
--   3. Nested conditional CASE statements inside a COUNT aggregate to construct dynamic, columnar status tracking fields.

-- Identify all shipping status values.
SELECT DISTINCT status
FROM orders;
/*
| status     |
|------------|
| Shipped    |
| Resolved   |
| Cancelled  |
| On Hold    |
| Disputed   |
| In Process |
*/

-- COUNT & CASE to create Pivot table with rows for each country, and columns for each shipping status.
SELECT
	c.country,
    COUNT(CASE WHEN o.status IS NOT NULL THEN 1 END) AS total_shipped,
    COUNT(CASE WHEN o.status = 'Shipped' THEN 1 END) AS status_shipped,
    COUNT(CASE WHEN o.status = 'In Process' THEN 1 END) AS status_in_process,
    COUNT(CASE WHEN o.status = 'Disputed' THEN 1 END) AS status_disputed,
    COUNT(CASE WHEN o.status = 'Resolved' THEN 1 END) AS status_resolved,
    COUNT(CASE WHEN o.status = 'On Hold' THEN 1 END) AS status_on_hold, 
    COUNT(CASE WHEN o.status = 'Cancelled' THEN 1 END) AS status_cancelled,
    COUNT(CASE WHEN o.status NOT IN ('Shipped', 'In Process', 'Disputed', 'Resolved', 'On Hold', 'Cancelled') THEN 1 END) AS status_unknown_or_error
FROM
	customers c 
	INNER JOIN orders o 
		ON c.customerNumber = o.customerNumber
GROUP BY c.country
ORDER BY total_shipped DESC
LIMIT 10;
/*
| country     | total_shipped | status_shipped | status_in_process | status_disputed | status_resolved | status_on_hold | status_cancelled | status_unknown_or_error |
|-------------|---------------|----------------|-------------------|-----------------|-----------------|----------------|------------------|-------------------------|
| USA         | 112           | 105            | 2                 | 0               | 1               | 3              | 1                | 0                       |
| France      | 37            | 36             | 1                 | 0               | 0               | 0              | 0                | 0                       |
| Spain       | 36            | 32             | 1                 | 1               | 1               | 0              | 1                | 0                       |
| Australia   | 19            | 17             | 1                 | 1               | 0               | 0              | 0                | 0                       |
| New Zealand | 15            | 13             | 0                 | 0               | 0               | 0              | 2                | 0                       |
| UK          | 13            | 12             | 0                 | 0               | 0               | 0              | 1                | 0                       |
| Italy       | 10            | 10             | 0                 | 0               | 0               | 0              | 0                | 0                       |
| Finland     | 9             | 9              | 0                 | 0               | 0               | 0              | 0                | 0                       |
| Singapore   | 9             | 9              | 0                 | 0               | 0               | 0              | 0                | 0                       |
| Germany     | 7             | 7              | 0                 | 0               | 0               | 0              | 0                | 0                       |
*/

-- 2) Order Basket Density & Fulfillment Complexity Analysis
-- Goal: Profile corporate order sizes to establish an operational workload blueprint for warehouse labor allocation and inventory layout strategies.
-- Requires: 
--   1. Calculate the initial volume density by using COUNT(productCode) grouped by individual orderNumber in a nested FROM subquery.
--   2. Aggregate those nested results a second time (a "count of a count") by grouping by the calculated basket sizes.
--   3. Sort the final output sequentially by bundle size to clearly map small vs. complex orders.

-- Perform the nested query by itself to count the number of unique products in each order.
SELECT 	orderNumber,
		COUNT(productCode) AS num_unique_products_in_order
FROM 	orderDetails
GROUP BY orderNumber
ORDER BY num_unique_products_in_order DESC
LIMIT 5;
/*
| orderNumber | num_unique_products_in_order |
|-------------|------------------------------|
| 10168       | 18                           |
| 10165       | 18                           |
| 10106       | 18                           |
| 10159       | 18                           |
| 10222       | 18                           |
*/
	-- The MAX number of unique products in an order is 18.  

-- Now we want to know how many orders had X number of items, how many had Y number of items, etc. 
-- Turn the previous query into a subquery nested in the FROM clause to run a "count of a count."

SELECT num_unique_products_in_order,
	COUNT(num_unique_products_in_order) AS count_orders_this_num_uniq_prod
FROM (
	SELECT 	orderNumber,
		COUNT(productCode) AS num_unique_products_in_order
	FROM 	orderDetails
	GROUP BY orderNumber
	) order_manifest_count
GROUP BY num_unique_products_in_order
ORDER BY num_unique_products_in_order DESC
LIMIT 10;
/*
| num_unique_products_in_order | count_orders_this_num_uniq_prod |
|------------------------------|---------------------------------|
| 18                           | 11                              |
| 17                           | 15                              |
| 16                           | 17                              |
| 15                           | 14                              |
| 14                           | 25                              |
| 13                           | 19                              |
| 12                           | 13                              |
| 11                           | 20                              |
| 10                           | 15                              |
| 9                            | 28                              |
*/
	-- We've had 11 orders with 18 unique items, 15 orders with 17 unique items, etc.
	-- That's a lot of order fullfilment complexity for our warehouse workers.


-- 3) Enterprise Revenue Reporting Layer & Global Account Index
-- Goal: Establish a permanent, standardized cross-functional data asset that tracks international customer purchase volume and lifetime revenue contributions for business intelligence tools.
-- Requires: 
--   1. Direct the schema to instantiate a reusable, virtual calculation table using the CREATE OR REPLACE VIEW architecture.
--   2. Consolidate relational customer, order registry, and item ledger tables via a series of horizontal LEFT JOIN operations.
--   3. Apply multi-column grouping logic to aggregate total volume transactions and calculate total financial lifetime value on the fly.

CREATE OR REPLACE VIEW revenue_reporting_layer AS
SELECT
	c.customerName,
    c.customerNumber,
    c.country,
    COUNT(DISTINCT o.orderNumber) AS total_orders_placed,
    SUM(od.quantityOrdered * od.priceEach) AS customer_lifetime_revenue 
FROM customers c
	LEFT JOIN orders o
		ON c.customerNumber = o.customerNumber
	LEFT JOIN orderdetails od
		ON o.orderNumber = od.orderNumber
GROUP BY 
	c.customerName,
    c.customerNumber,
    c.country
ORDER BY 
	customer_lifetime_revenue DESC;
	-- That created our enterprise view of our customers' lifetime orders and our resulting revenue.  
    -- Now let's inspect the newly created view.


-- 4) Reporting Layer Validation & Base Architecture Audit
-- Goal: Verify the newly created enterprise view by extracting high-volume active accounts, then inspect existing system shortcuts to audit default query performance.
-- Requires: 
--   1. Query the virtual view using a WHERE filter to isolate high-volume accounts (accounts with more than 2 orders).
--   2. Use the SHOW INDEX command on the customer registry table to view existing data-retrieval pathways.

SELECT * FROM revenue_reporting_layer
WHERE total_orders_placed > 2
LIMIT 10;
/*
| customerName                 | customerNumber | country     | total_orders_placed | customer_lifetime_revenue |
|------------------------------|----------------|-------------|---------------------|---------------------------|
| Euro+ Shopping Channel       | 141            | Spain       | 26                  | 820689.54                 |
| Mini Gifts Distributors Ltd. | 124            | USA         | 17                  | 591827.34                 |
| Australian Collectors, Co.   | 114            | Australia   | 5                   | 180585.07                 |
| Muscle Machine Inc           | 151            | USA         | 4                   | 177913.95                 |
| La Rochelle Gifts            | 119            | France      | 4                   | 158573.12                 |
| Dragon Souveniers, Ltd.      | 148            | Singapore   | 5                   | 156251.03                 |
| Down Under Souveniers, Inc   | 323            | New Zealand | 5                   | 154622.08                 |
| Land of Toys Inc.            | 131            | USA         | 4                   | 149085.15                 |
| AV Stores, Co.               | 187            | UK          | 3                   | 148410.09                 |
| The Sharp Gifts Warehouse    | 450            | USA         | 4                   | 143536.27                 |
*/
	-- The highest and 2nd-highest revenue-generating customers have generated over 4x ($820k) and 3x ($591k) as much revenue, respectively, as any other customer (all under $181k).
    
SHOW INDEX FROM customers;
/*
| Table     | Non_unique | Key_name               | Seq_in_index | Column_name            | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
|-----------|------------|------------------------|--------------|------------------------|-----------|-------------|----------|--------|------|------------|---------|---------------|---------|------------|
| customers | 0          | PRIMARY                | 1            | customerNumber         | A         | 122         | NULL     | NULL   |      | BTREE      |         |               | YES     | NULL       |
| customers | 1          | salesRepEmployeeNumber | 1            | salesRepEmployeeNumber | A         | 16          | NULL     | NULL   | YES  | BTREE      |         |               | YES     | NULL       |
*/
	-- Here we see the architecture for our customers table.
    

-- 5) Global Market Index Engineering & Performance Simulation
-- Goal: Design a custom, multi-column search shortcut for regional sales reporting; validate the reduction in system workload; safely clean up the test environment.
-- Requires: 
--   1. Instantiate a new performance shortcut using the CREATE INDEX syntax targeting geographic columns.
--   2. Use the EXPLAIN optimization tool to simulate a targeted regional query and verify that the database reads fewer rows.
--   3. Use the DROP INDEX command to remove the test index and restore the database to its baseline configuration.

-- Creating the index to run quicker, regionally targeted queries
CREATE INDEX idx_customer_location ON customers (country, city);

-- Verify the database is actually using the new index shortcut
EXPLAIN SELECT customerNumber, customerName FROM customers WHERE country = 'USA' AND city = 'NYC';
/*
| id | select_type | table     | partitions | type | possible_keys         | key                   | key_len | ref         | rows | filtered | Extra |
|----|-------------|-----------|------------|------|-----------------------|-----------------------|---------|-------------|------|----------|-------|
| 1  | SIMPLE      | customers | NULL       | ref  | idx_customer_location | idx_customer_location | 404     | const,const | 5    | 100.00   | NULL  |
*/

-- Remove the new index, return database to original configuration
DROP INDEX idx_customer_location ON customers;


-- =======================================================================
-- CATEGORY 5: STRING & DATE MANIPULATION
-- Focus: Text sanitization, truncation, and fiscal temporal operations
-- =======================================================================

-- 1) Unified Staff Directory & Security Handle Mapping
-- Goal: Clean up and format staff directory; automatically generate a unique system ID for each employee based on their email.
-- Requires: Core string manipulation functions (UPPER, CONCAT, SUBSTRING_INDEX).
SELECT
	UPPER(CONCAT(lastName, ', ', firstname)) AS standardized_staff_name,
    jobTitle,
    SUBSTRING_INDEX(email, '@', 1) AS internal_system_handle,
    officeCode
FROM employees
ORDER BY standardized_staff_name
LIMIT 10;
/*
| standardized_staff_name | jobTitle            | internal_system_handle | officeCode |
|-------------------------|---------------------|------------------------|------------|
| BONDUR, GERARD          | Sale Manager (EMEA) | gbondur                | 4          |
| BONDUR, LOUI            | Sales Rep           | lbondur                | 4          |
| BOTT, LARRY             | Sales Rep           | lbott                  | 7          |
| BOW, ANTHONY            | Sales Manager (NA)  | abow                   | 1          |
| CASTILLO, PAMELA        | Sales Rep           | pcastillo              | 4          |
| FIRRELLI, JEFF          | VP Marketing        | jfirrelli              | 1          |
| FIRRELLI, JULIE         | Sales Rep           | jfirrelli              | 2          |
| FIXTER, ANDY            | Sales Rep           | afixter                | 6          |
| GERARD, MARTIN          | Sales Rep           | mgerard                | 4          |
| HERNANDEZ, GERARD       | Sales Rep           | ghernande              | 4          |
*/


-- 2) Customer Database Integrity & Text Wrap Audit
-- Goal: Identify customer names that are too long for standard display constraints; test how they would look if neatly trimmed to fit a character limit.
-- Requires: String length evaluation and text truncations (LENGTH, LEFT).
SELECT
	LEFT(customerName, 20) AS short_customer_name,
    LENGTH(customerName) AS exact_byte_length
FROM customers
WHERE LENGTH(customerName) > 30;
/*
| short_customer_name  | exact_byte_length |
|----------------------|-------------------|
| Royal Canadian Colle | 33                |
| Bavarian Collectable | 34                |
*/


-- 3) Multi-Year Order Fulfillment Speed & Efficiency Analysis
-- Goal: Calculate historical  shipping speed year-over-year by measuring average time between purchase & shipping dates. 
-- Requires: Date difference calculations paired with calendar transformations (YEAR, DATEDIFF).
SELECT
	YEAR(orderDate) AS calendar_year,
    COUNT(orderNumber) AS total_shipped_orders,
    ROUND(AVG(DATEDIFF(shippedDate, orderDate)), 1) AS avg_days_to_ship
FROM orders
WHERE status = 'Shipped'
GROUP BY YEAR(orderDate)
ORDER BY calendar_year;
/*
| calendar_year | total_shipped_orders | avg_days_to_ship |
|---------------|----------------------|------------------|
| 2003          | 108                  | 4.3              |
| 2004          | 145                  | 3.5              |
| 2005          | 50                   | 3.3              |
*/


-- 4) Holiday Season Sales & Fulfillment Audit
-- Goal: Extract granular pipeline report of sales activity from Q4; evaluate peak-season operational performance.
-- Requires: Numeric calendar grouping transformations (YEAR, QUARTER, MONTHNAME).
SELECT
	orderNumber,
    customerNumber,
    orderDate,
    MONTHNAME(orderDate) AS order_month,
    status
FROM orders
WHERE YEAR(orderDate) = 2004 AND QUARTER(orderDate) = 4
ORDER BY orderDate
LIMIT 10;
/*
| orderNumber | customerNumber | orderDate  | order_month | status  |
|-------------|----------------|------------|-------------|---------|
| 10303       | 484            | 2004-10-06 | October     | Shipped |
| 10304       | 256            | 2004-10-11 | October     | Shipped |
| 10305       | 286            | 2004-10-13 | October     | Shipped |
| 10306       | 187            | 2004-10-14 | October     | Shipped |
| 10307       | 339            | 2004-10-14 | October     | Shipped |
| 10308       | 319            | 2004-10-15 | October     | Shipped |
| 10309       | 121            | 2004-10-15 | October     | Shipped |
| 10310       | 259            | 2004-10-16 | October     | Shipped |
| 10311       | 141            | 2004-10-16 | October     | Shipped |
| 10312       | 124            | 2004-10-21 | October     | Shipped |
*/
	-- Great. But the CEO doesn't want to scroll through the whole list.
    -- New Goal: Create quick pivot table with total orders and all current statuses.
    -- Requires: Using the previous query as a subquery; COUNT & CASE for pivot table 
SELECT 
	COUNT(orderNumber) AS total_Q4_orders,
    COUNT(CASE WHEN status = 'Shipped' THEN 1 END) AS status_shipped,
    COUNT(CASE WHEN status = 'In Process' THEN 1 END) AS status_in_process,
    COUNT(CASE WHEN status = 'Disputed' THEN 1 END) AS status_disputed,
    COUNT(CASE WHEN status = 'Resolved' THEN 1 END) AS status_resolved,
    COUNT(CASE WHEN status = 'On Hold' THEN 1 END) AS status_on_hold, 
    COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) AS status_cancelled,
    COUNT(CASE WHEN status NOT IN ('Shipped', 'In Process', 'Disputed', 'Resolved', 'On Hold', 'Cancelled') THEN 1 END) AS status_unknown_or_error
FROM (
	SELECT
		orderNumber,
		customerNumber,
		orderDate,
		MONTHNAME(orderDate) AS order_month,
		status
	FROM orders
	WHERE YEAR(orderDate) = 2004 AND QUARTER(orderDate) = 4
	ORDER BY orderDate
	) Q4_orders
;
/*
| total_Q4_orders | status_shipped | status_in_process | status_disputed | status_resolved | status_on_hold | status_cancelled | status_unknown_or_error |
|-----------------|----------------|-------------------|-----------------|-----------------|----------------|------------------|-------------------------|
| 59              | 57             | 0                 | 0               | 1               | 1              | 0                | 0                       |
*/