/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Description:
    This script creates tables in the 'bronze' schema to store raw data
    imported from source systems (CRM and ERP).
    
Purpose:
    - Store source data in its original format.
    - Maintain a historical record of ingested files.
    - Provide a reliable source for Silver layer transformations.

 Bronze Layer Responsibilities:
    - Raw data ingestion
    - No business transformations
    - Source data preservation
    - Audit and traceability support

 Data Sources:
    CRM Customer Information
    CRM Product Information
    CRM Sales Details
    ERP Customer Data
    ERP Location Data
    ERP Category Data

--------------------------------------------------------------------------------------
Warning:
    - This script may DROP and RECREATE existing Bronze tables.
    - All existing data in the affected tables will be permanently removed.
    - Ensure backups are available before executing in non-development
      environments.

=======================================================================================
*/

IF OBJECT_ID('bronze.crm_cust_info' , 'U') IS NOT NULL
DROP TABLE bronze.crm_cust_info
CREATE TABLE bronze.crm_cust_info (
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(100),
    cst_lastname NVARCHAR(100),
    cst_material_status NVARCHAR(50),
    cst_gndr NVARCHAR(20),
    cst_create_date DATE
);

 IF OBJECT_ID('bronze.crm_prd_info' , 'U') IS NOT NULL
DROP TABLE bronze.crm_prd_info
CREATE TABLE bronze.crm_prd_info (
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(255),
    prd_cost DECIMAL(18,2),
    prd_line NVARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
);

IF OBJECT_ID('bronze.crm_sales_details' , 'U') IS NOT NULL
DROP TABLE bronze.crm_sales_details
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price DECIMAL(18,2)
);

IF OBJECT_ID('bronze.erp_cust_az12' , 'U') IS NOT NULL
DROP TABLE bronze.erp_cust_az12
CREATE TABLE bronze.erp_cust_az12 (
    cid NVARCHAR(50),
    bdate DATE,
    gen NVARCHAR(20)
);

IF OBJECT_ID('bronze.erp_loc_a101' , 'U') IS NOT NULL
DROP TABLE bronze.erp_loc_a101
CREATE TABLE bronze.erp_loc_a101 (
    cid NVARCHAR(50),
    cntry NVARCHAR(50)
);

IF OBJECT_ID('bronze.erp_px_cat_g1v2' , 'U') IS NOT NULL
DROP TABLE bronze.erp_px_cat_g1v2
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50)
);

