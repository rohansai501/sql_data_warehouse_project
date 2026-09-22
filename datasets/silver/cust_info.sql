------------------ main source code for transfomation -------------------------------------------
-- transformation code for silver schema in customer_info
INSERT INTO silver.cust_info(
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_material_status,
    cst_gndr,
    cst_create_date
)
SELECT 
cst_id,
cst_key,
-- triming the name so ther any spaces at the begining of the name
TRIM(cst_firstname),
TRIM(cst_lastname),
-- using case to make sure the null values are n/a and s/m or f/m are propely spelled out and using upper() to make sure case in uppercaseand trim() ther are no spaces in front of letteres
CASE WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
     WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
     ELSE 'n/a'
END cst_material_status, 
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
     WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
     ELSE 'n/a'
END cst_gndr,     
cst_create_date
FROM (
-- using window function so full values are in number one order comparted to other null values and selecting the them by using where funstion and row_number are discried as flag_last
SELECT 
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
from BRONZE.cust_info) t
WHERE flag_last = 1 and cst_id != 0;
------------------ main source code for transfomation -------------------------------------------


-- checking if there is any null or unwanted value
USE silver;
SELECT 
cst_id,
COUNT(*)
from cust_info
GROUP BY cst_id
HAVING count(*) > 1 or cst_id IS NULL;

-- check unwanted spaces
-- expection is no result
USE silver;
select cst_firstname
FROM cust_info
WHERE cst_firstname != TRIM(cst_firstname) ;
select cst_lastname
FROM cust_info
WHERE cst_lastname!= TRIM(cst_lastname) ;
select cst_gndr
FROM cust_info
WHERE cst_gndr!= TRIM(cst_gndr);

select DISTINCT cst_gndr
FROM .cust_info;

select DISTINCT cst_material_status
FROM .cust_info;

SELECT * 
from silver.cust_info;
