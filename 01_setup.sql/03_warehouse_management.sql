/*
================================================================================
CAREVIEW - PATIENT RISK MONITORING PLATFORM
================================================================================
PHASE 3: WAREHOUSE MANAGEMENT
--------------------------------------------------------------------------------
PURPOSE: Create 4 warehouses for different workloads

WAREHOUSES:
1. CAREVIEW_LOAD_WH      - Loading data into Bronze layer
2. CAREVIEW_TRANSFORM_WH - Transforming data (Silver/Gold)
3. CAREVIEW_ANALYTICS_WH - Running queries and reports
4. CAREVIEW_AI_WH        - AI and ML workloads
================================================================================
*/

-- ============================================================================
-- STEP 1: USE SYSADMIN ROLE
-- ============================================================================
USE ROLE SYSADMIN;

-- ============================================================================
-- STEP 2: CREATE LOADING WAREHOUSE
-- Purpose: For loading raw data into Bronze layer
-- ============================================================================
CREATE WAREHOUSE IF NOT EXISTS CAREVIEW_LOAD_WH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 60              -- STOP AFTER 1 MINUTE IDLE (SAVES MONEY)
    AUTO_RESUME = TRUE             -- START AUTOMATICALLY WHEN NEEDED
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for loading data into Bronze layer';

-- ============================================================================
-- STEP 3: CREATE TRANSFORMATION WAREHOUSE
-- Purpose: For transforming data (Bronze -> Silver -> Gold)
-- ============================================================================
CREATE WAREHOUSE IF NOT EXISTS CAREVIEW_TRANSFORM_WH
    WAREHOUSE_SIZE = 'SMALL'
    AUTO_SUSPEND = 120             -- STOP AFTER 2 MINUTES IDLE
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for data transformations';

-- ============================================================================
-- STEP 4: CREATE ANALYTICS WAREHOUSE
-- Purpose: For running queries, reports, and dashboards
-- ============================================================================
CREATE WAREHOUSE IF NOT EXISTS CAREVIEW_ANALYTICS_WH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 120             -- STOP AFTER 2 MINUTES IDLE
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for analytics and reporting';

-- ============================================================================
-- STEP 5: CREATE AI WAREHOUSE
-- Purpose: For AI/ML workloads and Cortex functions
-- ============================================================================
CREATE WAREHOUSE IF NOT EXISTS CAREVIEW_AI_WH
    WAREHOUSE_SIZE = 'SMALL'
    AUTO_SUSPEND = 60              -- STOP AFTER 1 MINUTE IDLE
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for AI and ML workloads';

-- ============================================================================
-- STEP 6: GRANT WAREHOUSE ACCESS TO ROLES
-- ============================================================================
USE ROLE SECURITYADMIN;

-- ENGINEER: CAN USE LOAD AND TRANSFORM WAREHOUSES
GRANT USAGE ON WAREHOUSE CAREVIEW_LOAD_WH TO ROLE CAREVIEW_ENGINEER;
GRANT USAGE ON WAREHOUSE CAREVIEW_TRANSFORM_WH TO ROLE CAREVIEW_ENGINEER;

-- ANALYST AND VIEWER: CAN USE ANALYTICS WAREHOUSE
GRANT USAGE ON WAREHOUSE CAREVIEW_ANALYTICS_WH TO ROLE CAREVIEW_VIEWER;
GRANT USAGE ON WAREHOUSE CAREVIEW_ANALYTICS_WH TO ROLE CAREVIEW_ANALYST;

-- DATA SCIENTIST: CAN USE AI AND ANALYTICS WAREHOUSES
GRANT USAGE ON WAREHOUSE CAREVIEW_AI_WH TO ROLE CAREVIEW_DATA_SCIENTIST;
GRANT USAGE ON WAREHOUSE CAREVIEW_ANALYTICS_WH TO ROLE CAREVIEW_DATA_SCIENTIST;

-- ADMIN: CAN USE ALL WAREHOUSES
GRANT ALL PRIVILEGES ON WAREHOUSE CAREVIEW_LOAD_WH TO ROLE CAREVIEW_ADMIN;
GRANT ALL PRIVILEGES ON WAREHOUSE CAREVIEW_TRANSFORM_WH TO ROLE CAREVIEW_ADMIN;
GRANT ALL PRIVILEGES ON WAREHOUSE CAREVIEW_ANALYTICS_WH TO ROLE CAREVIEW_ADMIN;
GRANT ALL PRIVILEGES ON WAREHOUSE CAREVIEW_AI_WH TO ROLE CAREVIEW_ADMIN;

-- ============================================================================
-- STEP 7: VERIFICATION
-- ============================================================================
SHOW WAREHOUSES LIKE 'CAREVIEW%';

/*
================================================================================
SUMMARY - WHAT WE CREATED:
--------------------------------------------------------------------------------
WAREHOUSE               SIZE      AUTO_SUSPEND   WHO USES IT
----------------------  --------  ------------   ----------------------
CAREVIEW_LOAD_WH        X-SMALL   1 minute       Engineer, Admin
CAREVIEW_TRANSFORM_WH   SMALL     2 minutes      Engineer, Admin
CAREVIEW_ANALYTICS_WH   X-SMALL   2 minutes      Everyone
CAREVIEW_AI_WH          SMALL     1 minute       Data Scientist, Admin

NEXT STEPS:
- Run 04_database_structure.sql to create database and schemas
================================================================================
*/
