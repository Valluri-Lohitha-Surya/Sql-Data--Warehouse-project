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


CREATE OR ALTER PROCEDURE load_Bronze AS
BEGIN
 DECLARE @Start_time DATETIME, @end_time DATETIME , @batch_start_time DATETIME , @batch_end_time DATETIME;
 BEGIN TRY
 SET @batch_start_time = GETDATE();
    PRINT '==========================================================================================';
    PRINT 'LOADING BRONZE LAYER';
    PRINT '==========================================================================================';

    PRINT '------------------------------------------------------------------------------------------';
    PRINT 'LOADING CRM TABLES';
    PRINT '------------------------------------------------------------------------------------------';

    SET @Start_time =GETDATE();
    PRINT '>>Truncating Table: Bronze.crm_cust_info';
    TRUNCATE TABLE Bronze.crm_cust_info;

    PRINT '>>Inseting Data Into: Bronze.crm_cust_info';
        BULK INSERT Bronze.crm_cust_info
        FROM 'C:\Users\lohit\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
        WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR= ',',
        TABLOCK
        );
     SET @end_time = GETDATE();
     PRINT '>>Loading Time: ' + CAST(DATEDIFF(second, @Start_time, @end_time) AS NVARCHAR) + ' seconds';
     PRINT '-------------------';

     SET @Start_time =GETDATE();
      PRINT '>>Truncating Table: Bronze.crm_prd_info';
     TRUNCATE TABLE Bronze.crm_prd_info

     PRINT '>>Inseting Data Into: Bronze.crm_prd_info';
        BULK INSERT Bronze.crm_prd_info
        FROM 'C:\Users\lohit\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
        WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR= ',',
        TABLOCK
        );
        SET @end_time =GETDATE();
        PRINT 'Loading Time ' + CAST(DATEDIFF(second,@Start_time,@end_time) AS NVARCHAR) + ' seconds';
        PRINT '-------------------------'

        SET @Start_time =GETDATE();
      PRINT '>>Truncating Table: Bronze.crm_sales_details';
         TRUNCATE TABLE Bronze.crm_sales_details

          PRINT '>>Inseting Data Into: Bronze.crm_sales_details';
        BULK INSERT Bronze.crm_sales_details
        FROM 'C:\Users\lohit\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
        WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR= ',',
        TABLOCK
        );
        SET @end_time =GETDATE();
          PRINT '>>Loading Time: ' + CAST(DATEDIFF(second, @Start_time, @end_time) AS NVARCHAR) + ' seconds';
     PRINT '-------------------';

        PRINT '------------------------------------------------------------------------------------------';
        PRINT 'LOADING CRM TABLES';
        PRINT '------------------------------------------------------------------------------------------';

        SET @Start_time =GETDATE();
        PRINT '>>Truncating Table: Bronze.erp_cust_az12';
         TRUNCATE TABLE Bronze.erp_cust_az12

          PRINT '>>Inseting Data Into: Bronze.erp_cust_az12';
        BULK INSERT Bronze.erp_cust_az12
        FROM 'C:\Users\lohit\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
        WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR= ',',
        TABLOCK
        );
        SET @end_time =GETDATE();
        PRINT '>>Loading Time: ' + CAST(DATEDIFF(second, @Start_time, @end_time) AS NVARCHAR) + ' seconds';
     PRINT '-------------------';

        SET @Start_time =GETDATE();
        PRINT '>>Truncating Table: Bronze.erp_loc_a101';
         TRUNCATE TABLE Bronze.erp_loc_a101

          PRINT '>>Inseting Data Into: Bronze.erp_loc_a101';
        BULK INSERT Bronze.erp_loc_a101
        FROM 'C:\Users\lohit\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
        WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR= ',',
        TABLOCK
        );
        SET @end_time =GETDATE();
        PRINT '>>Loading Time: ' + CAST(DATEDIFF(second, @Start_time, @end_time) AS NVARCHAR) + ' seconds';
     PRINT '-------------------';

        SET @Start_time =GETDATE();
         PRINT '>>Truncating Table: Bronze.erp_px_cat_g1v2';
         TRUNCATE TABLE Bronze.erp_px_cat_g1v2

          PRINT '>>Inseting Data Into: Bronze.erp_px_cat_g1v2';
        BULK INSERT Bronze.erp_px_cat_g1v2
        FROM 'C:\Users\lohit\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR= ',',
        TABLOCK
        );
        SET @end_time =GETDATE();
        PRINT '>>Loading Time: ' + CAST(DATEDIFF(second, @Start_time, @end_time) AS NVARCHAR) + ' seconds';
     PRINT '-------------------';

     SET @batch_end_time = GETDATE();
     PRINT  '============================================================================='
     PRINT  '>> Loading Bronze Layer Completed.'
     PRINT  '>>Total Load Duration : ' + CAST(DATEDIFF(second , @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
     PRINT '=============================================================================='
        END TRY
        BEGIN CATCH
        PRINT '============================================================================='
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
        PRINT 'Error Message' + ERROR_MESSAGE();
        PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR(50));
        PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR(50));
        PRINT '============================================================================='
        END CATCH
  END

 
