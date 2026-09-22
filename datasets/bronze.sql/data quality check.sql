--check data quality---

USE BRONZE;
SELECT 
cst_id,
COUNT(*)
from cust_info
GROUP BY cst_id
HAVING count(*) > 1 or cst_id IS NULL;

-- check unwanted spaces
-- expection is no result
USE BRONZE;
select cst_firstname
FROM cust_info
WHERE cst_firstname != TRIM(cst_firstname) ;


USE BRONZE;
select cst_lastname
FROM BRONZE.cust_info
WHERE cst_lastname!= TRIM(cst_lastname) ;


USE BRONZE;
select cst_gndr
FROM BRONZE.cust_info
WHERE cst_gndr!= TRIM(cst_gndr);


USE BRONZE;
select DISTINCT cst_gndr
FROM cust_info;


USE BRONZE;
select DISTINCT cst_material_status
FROM cust_info;
