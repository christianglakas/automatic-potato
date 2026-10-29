# automatic-potato
## MySQL Portfolio Project: Commercial Operations & Database Optimization  
by **Christian Glakas**

A comprehensive, production-ready SQL portfolio spanning five architectural domains. This repository showcases how targeted database engineering, query optimization, and advanced analytics transform raw relational schemas into highly performant, executive-ready commercial business intelligence.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Database Setup & Installation](#database-setup--installation)
- [Database Schema Overview](#database-schema-overview)
- [Demonstration Queries](#demonstration-queries)

## Prerequisites

Before running this project, ensure you have the following installed:
* **Database Engine:** MySQL 8.0 or higher
* **Interface:** MySQL Command Line Client or a GUI client (e.g., MySQL Workbench, DBeaver, VS Code MySQL Extension)

## Database Setup & Installation

Follow these steps to import the database structure and sample data.

### Option 1: Via the MySQL Command Line Client
1. Open your terminal or command prompt.
2. Connect to your MySQL server:
   ```bash
   mysql -u root -p
   ```
3. Create the target database and exit:
   ```mysql
   CREATE DATABASE classicmodels;
   EXIT;
   ```
4. Import the script file (`01_classicmodels_schema.sql`) into your new database:
   ```bash
   mysql -u root -p classicmodels < 01_classicmodels_schema.sql
   ```

### Option 2: Via MySQL Workbench
1. From the FILES menu on this GitHub page, download the file `01_classicmodels_schema.sql` to your local machine. 
2. Open MySQL Workbench and connect to your database instance.
3. Go to the top menu and select **File** ➔ **Open SQL Script...**
4. Select `01_classicmodels_schema.sql` from your local machine.
5. The script contains a `CREATE DATABASE` statement at the top on line 8:
   ```sql
   CREATE DATABASE IF NOT EXISTS classicmodels;
   USE classicmodels;
   ```
6. Click the **Lightning Bolt icon** (Execute) to run the entire script.

## Database Schema Overview

The imported database consists of the following tables, built to demonstrate standard relational database design (including primary and foreign key constraints):

* **`customers`** - Stores data on buyers including contact info, address, credit limits, and sales representatives.
* **`employees`** - Holds staff details, email addresses, job titles, and the internal reporting hierarchy.
* **`offices`** - Contains data on physical office locations, phone numbers, addresses, and territories.
* **`orders`** - Records details of sales transactions like order dates, delivery dates, and shipping status.
* **`orderdetails`** - Stores the specific quantity, pricing, and products for individual sales orders.
* **`payments`** - Tracks monetary transactions, check numbers, payment dates, and outstanding balance credits.
* **`products`** - A catalog of inventory with stock numbers, vendor names, buy prices, and MSRP prices.
* **`product lines`** - Defines product categories alongside text or HTML descriptions and images.

## Demonstration Queries

### Project Architecture & Framework

Below are the queries included in this project, categorized by purpose. They demonstrate proficiency in data query performance engineering, dynamic executive dashboarding, advanced data governance, program performance evaluation, and zero-footprint risk management.

To view these queries with additional information on the business goals prompting them and the SQL commands they include, along with formatted results and analysis, download the file `02_demo_SQL_queries.sql` from the FILES menu.

### Category 1: Environment Setup & Lookup Architecture

* **Query 1:** System Initialization - Establish workspace
```mysql
USE classicmodels;
```

* **Query 2:** Base structural audit - Verify table presence
```mysql
SHOW TABLES;
```

* **Query 3:** Basic Lookups - Customer profiles
```mysql
SELECT * 
FROM customers
LIMIT 5;
```

* **Query 4:** Product & inventory tracking structure
```mysql
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
```

* **Query 5:** Order history
```mysql
SELECT *
FROM orders
LIMIT 5;
```

* **Query 6:** Order details
```mysql
SELECT *
FROM orderdetails
LIMIT 5;
```

### Category 2: Business Aggregations & Descriptive Statistics

* **Query 1: Basic Summary Metrics**
```mysql
SELECT 
    COUNT(orderNumber) AS total_orders_processed,
    SUM(quantityOrdered) AS total_items_sold,
    MIN(priceEach) AS cheapest_item_sold,
    MAX(priceEach) AS most_expensive_item_sold,
    AVG(priceEach) AS overall_average_item_price
FROM orderdetails;
```

* **Query 2: Customer Credit Report**
```mysql
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
```

* **Query 3: Customer Order Tracking**
```mysql
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
```

* **Query 4: Inventory Outlier Filtering**
```mysql
SELECT
    productCode,
    productName,
    productLine,
    quantityinStock
FROM products
WHERE quantityinStock > (SELECT AVG(quantityinStock) FROM products)
ORDER BY quantityinStock DESC
LIMIT 10;
```

* **Query 5: Inventory Outlier Filtering (CEO Variant with Subquery)**
```mysql
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
```

* **Query 6: Customer Peak Payments**
```mysql
SELECT
    c.customerName,
    c.customerNumber,
    (SELECT MAX(p.amount)
     FROM payments p 
     WHERE p.customerNumber = c.customerNumber) AS max_amount_paid
FROM customers c
ORDER BY max_amount_paid DESC
LIMIT 5;
```

### Category 3: Higher Order Business Intersections & Data Manipulation

* **Query 1: Total Payments & Items Ordered**
```mysql
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
        INNER JOIN orderdetails od
            ON o.orderNumber = od.orderNumber
    GROUP BY o.customerNumber
    ) order_summary
    ON pay_summary.customerNumber = order_summary.customerNumber
LIMIT 10;
```

* **Query 2: Identify High Volatility Accounts**
```mysql
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
GROUP BY
    o.customerNumber,
    c.customerName
HAVING total_cancelled_value > (total_spend * .20)   
ORDER BY total_cancelled_value DESC;
```

* **Query 3: Corporate Hierarchical Reporting Matrix**
```mysql
SELECT
    emp.employeeNumber AS staff_id,
    CONCAT(emp.firstName, ' ', emp.lastName) AS staff_name,
    emp.jobTitle AS staff_title,
    CONCAT(mgr.firstName, ' ', mgr.lastName) AS supervisor_name,
    mgr.employeeNumber AS supervisor_id
FROM employees emp
    LEFT JOIN employees mgr
        ON emp.reportsTo = mgr.employeeNumber
LIMIT 10;
```

* **Query 4: Pricing Integrity Strategy Audits: Rogue Discounter Exception Report**
```mysql
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
```

* **Query 5: Global Supply Chain Footprint & Logistics Mapping**
```mysql
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
ORDER BY continent, country, contact_type DESC
LIMIT 15;
```

* **Query 6: Strategic Commercial Expansion & VIP Credit Loyalty Simulation**
```mysql
START TRANSACTION;

SET SQL_SAFE_UPDATES = 0;

INSERT INTO offices (officeCode, city, phone, addressLine1, country, postalCode, territory)
VALUES ('8', 'Austin', '+1 512 555 0199', '101 Woodstream Blvd', 'USA', '78756', 'NA');

UPDATE customers
SET creditLimit = creditLimit * 1.15
WHERE customerNumber IN (
	SELECT DISTINCT customerNumber
    FROM payments
    WHERE amount > 50000
); 	

SET SQL_SAFE_UPDATES = 1;

ROLLBACK;
```

### Category 4: Database Objects & Complex Conditional Pivots

* **Query 1: Sovereign Market Fulfillment & Operational Risk Performance Indices**
```mysql
SELECT
    c.country
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
```

* **Query 2: Order Basket Density & Fulfillment Complexity Analysis**
```mysql
SELECT num_unique_products_in_order,
    COUNT(num_unique_products_in_order) AS count_orders_this_num_uniq_prod
FROM (
    SELECT
        orderNumber,
        COUNT(productCode) AS num_unique_products_in_order
    FROM orderDetails
    GROUP BY orderNumber
    ) order_manifest_count
GROUP BY num_unique_products_in_order
ORDER BY num_unique_products_in_order DESC
LIMIT 10;
```

* **Query 3: Enterprise Revenue Reporting Layer & Global Account Index**
```mysql
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
```

* **Query 4: Reporting Layer Validation & Base Architecture Audit**
```mysql
SELECT * FROM revenue_reporting_layer
WHERE total_orders_placed > 2
LIMIT 10;

SHOW INDEX FROM customers;
```

* **Query 5: Global Market Index Engineering & Performance Simulation**
```mysql
CREATE INDEX idx_customer_location ON customers (country, city);

EXPLAIN SELECT customerNumber, customerName FROM customers WHERE country = 'USA' AND city = 'NYC';

DROP INDEX idx_customer_location ON customers;
```


### Category 5: String & Date Manipulation

* **Query 1: Unified Staff Directory & Security Handle Mapping**
```mysql
SELECT
    UPPER(CONCAT(lastName, ', ', firstname)) AS standardized_staff_name,
    jobTitle,
    SUBSTRING_INDEX(email, '@', 1) AS internal_system_handle,
    officeCode
FROM employees
ORDER BY standardized_staff_name
LIMIT 10;
```

* **Query 2: Customer Database Integrity & Text Wrap Audit**
```mysql
SELECT
    LEFT(customerName, 20) AS short_customer_name,
    LENGTH(customerName) AS exact_byte_length
FROM customers
WHERE LENGTH(customerName) > 30;
```

* **Query 3: Multi-Year Order Fulfillment Speed & Efficiency Analysis**
```mysql
SELECT
    YEAR(orderDate) AS calendar_year,
    COUNT(orderNumber) AS total_shipped_orders,
    ROUND(AVG(DATEDIFF(shippedDate, orderDate)), 1) AS avg_days_to_ship
FROM orders
WHERE status = 'Shipped'
GROUP BY YEAR(orderDate)
ORDER BY calendar_year;
```

* **Query 4: Holiday Season Sales & Fulfillment Audit**
```mysql
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
```

* **Query 4, Part B: Holiday Season Sales & Fulfillment Audit - Pivot Table**
```mysql
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
```
