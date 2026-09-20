/*
Purpose:
Create the Bronze, Silver, and Gold databases for a data
warehouse using the Medallion Architecture.

Bronze: Raw data
Silver: Cleaned and transformed data
Gold: Business-ready data for analytics and reporting
*/



--create datwahrehouse--

CREATE DATABASE DataWarehouse;
--create schema for datawarehouse--
CREATE SCHEMA BRONZE;

CREATE SCHEMA silver;

CREATE SCHEMA gold;
