# automatic-potato
SQL demo for job applications

# Portfolio Database Project: MySQL Demonstration

This project sets up a multi-table MySQL database designed to showcase core SQL proficiency. It initializes the database schema, populates it with sample data, and provides 10–15 practice queries demonstrating essential data manipulation and analysis skills.

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
   ```sql
   CREATE DATABASE maven_advanced_sql;
   EXIT;
   ```
4. Import the script file (`create_statements_mysql.sql`) into your new database:
   ```bash
   mysql -u root -p maven_advanced_sql < create_statements_mysql.sql
   ```

### Option 2: Via MySQL Workbench
1. Open MySQL Workbench and connect to your database instance.
2. Go to the top menu and select **File** ➔ **Open SQL Script...**
3. Select `create_statements_mysql.sql` from your local machine.
4. If the script does not contain a `CREATE DATABASE` statement at the top, add this to the very first line of the query editor:
   ```sql
   CREATE DATABASE IF NOT EXISTS maven_advanced_sql;
   USE maven_advanced_sql;
   ```
5. Click the **Lightning Bolt icon** (Execute) to run the entire script.

## Database Schema Overview

The imported database consists of the following tables, built to demonstrate standard relational database design (including primary and foreign key constraints):

* **`table_name_1`** - [Brief description, e.g., Stores customer profile information.]
* **`table_name_2`** - [Brief description, e.g., Tracks transactional order details linked to customers.]
* **`table_name_3`** - [Brief description, e.g., Contains product inventory and pricing records.]

## Demonstration Queries

Below are the 10–15 core queries included in this project, categorized by complexity. They demonstrate proficiency in data retrieval, filtering, multi-table joins, and aggregations.

### Basic Data Retrieval (SELECT, WHERE, ORDER BY)
* **Query 1:** [Goal of query, e.g., Retrieve all active customers sorted by registration date.]
* **Query 2:** [Goal of query, e.g., Find all products priced over \$50.]

### Aggregations & Grouping (GROUP BY, HAVING, Aggregate Functions)
* **Query 3:** [Goal of query, e.g., Calculate total sales revenue per product category.]
* **Query 4:** [Goal of query, e.g., Find customers who have placed more than 5 orders.]

### Multi-Table Relations (INNER JOIN, LEFT JOIN)
* **Query 5:** [Goal of query, e.g., Combine order data with customer details to view purchasing behavior.]
* **Query 6:** [Goal of query, e.g., Identify products that have never been ordered using a LEFT JOIN.]

### Text & Date Manipulation (LIKE, Date Functions)
* **Query 7:** [Goal of query, e.g., Filter transactions that occurred strictly within the last quarter.]

*(Tip for the user: Paste your exact SQL query code blocks beneath each bullet point to show off your code directly in the README!)*
