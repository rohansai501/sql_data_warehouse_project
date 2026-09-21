-- i had use this load the data into data base through the terminal bash in mac
## Data Loading Error & Troubleshooting

### MySQL Error 2068 — `LOAD DATA LOCAL INFILE`

During the initial Bronze-layer data ingestion process, I attempted to load CSV source files into MySQL using `LOAD DATA LOCAL INFILE`.

The following error occurred:

```text
MySQL Error (2068):
LOAD DATA LOCAL INFILE file request rejected due to restrictions on access.
```

### Initial Approach

I initially used `LOAD DATA LOCAL INFILE` to bulk-load CSV files into the Bronze tables.

Example:

```sql
LOAD DATA LOCAL INFILE '/path/to/file.csv'
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;
```

The command was rejected by the MySQL client because local file loading was restricted.

### Troubleshooting Process

I investigated the issue systematically rather than assuming the CSV files were corrupted.

#### 1. Verified the MySQL installation

I checked the MySQL executable location:

```bash
which mysql
```

The system returned:

```text
/opt/homebrew/bin/mysql
```

This confirmed that MySQL was installed through Homebrew on macOS.

#### 2. Verified the CSV file

I confirmed that the source CSV file existed and was readable.

Example:

```bash
ls -l "/Users/rohansaialahari/Downloads/sql-data-warehouse-project/datasets/source_crm/cust_info.csv"
```

The file had read permissions, confirming that the problem was not caused by a missing or inaccessible CSV file.

#### 3. Tested MySQL client-side local file loading

I started the MySQL client with local file loading enabled:

```bash
/opt/homebrew/bin/mysql --local-infile=1 -u root -p
```

I then checked the MySQL configuration:

```sql
SHOW VARIABLES LIKE 'local_infile';
```

This helped distinguish between the MySQL server configuration and the client-side restrictions.

#### 4. Tested `mysqlimport`

I also attempted to use the MySQL command-line bulk import utility:

```bash
/opt/homebrew/bin/mysqlimport --local=1 \
--ignore-lines=1 \
--fields-terminated-by=',' \
--fields-enclosed-by='"' \
--user=root \
--password \
bronze "/path/to/file.csv"
```

The same Error 2068 occurred:

```text
Error: 2068,
LOAD DATA LOCAL INFILE file request rejected due to restrictions on access.
```

### Root Cause

The investigation showed that the problem was not the CSV file itself.

The issue was related to the **client-side restrictions surrounding MySQL `LOCAL INFILE` file requests**.

Both:

* `LOAD DATA LOCAL INFILE`
* `mysqlimport --local=1`

depend on the local-file loading mechanism, so changing from one command to the other did not bypass the r


--main file path i used--
/opt/homebrew/bin/mysqlimport --local=1 --ignore-lines=1 --fields-terminated-by=',' --fields-enclosed-by='"' --user=root --password bronze "/Users/rohansaialahari/Downloads/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv"
/opt/homebrew/bin/mysqlimport --local=1 --ignore-lines=1 --fields-terminated-by=',' --fields-enclosed-by='"' --user=root --password bronze "/Users/rohansaialahari/Downloads/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv"


/opt/homebrew/bin/mysqlimport --local=1 --ignore-lines=1 --fields-terminated-by=',' --fields-enclosed-by='"' --user=root --password bronze "/Users/rohansaialahari/Downloads/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv"
/opt/homebrew/bin/mysqlimport --local=1 --ignore-lines=1 --fields-terminated-by=',' --fields-enclosed-by='"' --user=root --password bronze "/Users/rohansaialahari/Downloads/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv"
/opt/homebrew/bin/mysqlimport --local=1 --ignore-lines=1 --fields-terminated-by=',' --fields-enclosed-by='"' --user=root --password bronze "/Users/rohansaialahari/Downloads/sql-data-warehouse-project/datasets/source_crm/sales_details.csv"

/opt/homebrew/bin/mysqlimport --local=1 --ignore-lines=1 --fields-terminated-by=',' --fields-enclosed-by='"' --user=root--password bronze "/Users/rohansaialahari/Downloads/sql-data-warehouse-project/datasets/source_crm/prd_info.csv"

cp "/Users/rohansaialahari/Downloads/sql-data-warehouse-project/datasets/source_crm/prd_info.csv" \"/Users/rohansaialahari/Downloads/sql-data-warehouse-project/datasets/source_crm/prd_info.csv"

