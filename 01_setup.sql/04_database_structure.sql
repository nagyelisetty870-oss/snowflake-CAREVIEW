/*
================================================================================
CAREVIEW - PATIENT RISK MONITORING PLATFORM
================================================================================
PHASE 4: DATABASE STRUCTURE
--------------------------------------------------------------------------------
PURPOSE: Create the main database with 4 schemas (Data Lake Architecture)

SCHEMAS:
- CAREVIEW_SCH_BRONZE      : Raw data (as-is from source systems)
- CAREVIEW_SCH_SILVER     : Cleaned and validated data
- CAREVIEW_SCH_GOLD   : Business-ready reporting data
- CAREVIEW_SCH_AI_READY : AI/ML processed data and features
================================================================================
*/

-- ============================================================================
-- STEP 1: USE SYSADMIN ROLE
-- ============================================================================
USE ROLE SYSADMIN;

-- ============================================================================
-- STEP 2: CREATE MAIN DATABASE
-- ============================================================================
CREATE DATABASE IF NOT EXISTS CAREVIEW_DB
    COMMENT = 'Careview Patient Risk Monitoring Platform';

-- USE THE DATABASE
USE DATABASE CAREVIEW_DB;

-- ============================================================================
-- STEP 3: CREATE SCHEMAS (4 LAYERS)
-- ============================================================================

-- BRONZE: Data exactly as received from source systems
CREATE SCHEMA IF NOT EXISTS CAREVIEW_SCH_BRONZE
    COMMENT = 'Raw data ingested from source systems';

-- STAGING: Cleaned, validated and standardized data
CREATE  SCHEMA IF NOT EXISTS CAREVIEW_SCH_SILVER
    COMMENT = 'Cleaned and validated data ready for analysis';

-- ANALYTICS: Business-ready data for reporting and dashboards
CREATE SCHEMA IF NOT EXISTS CAREVIEW_SCH_GOLD
    COMMENT = 'Business-ready data for reporting and dashboards';

-- ML_FEATURES: AI/ML features and model outputs
CREATE SCHEMA IF NOT EXISTS CAREVIEW_SCH_AI_READY
    COMMENT = 'Machine learning features and AI processed data';

-- ============================================================================
-- STEP 4: GRANT DATABASE ACCESS TO ALL ROLES
-- ============================================================================
USE ROLE SECURITYADMIN;

GRANT USAGE ON DATABASE CAREVIEW_DB TO ROLE CAREVIEW_ADMIN;
GRANT USAGE ON DATABASE CAREVIEW_DB TO ROLE CAREVIEW_ENGINEER;
GRANT USAGE ON DATABASE CAREVIEW_DB TO ROLE CAREVIEW_DATA_SCIENTIST;
GRANT USAGE ON DATABASE CAREVIEW_DB TO ROLE CAREVIEW_ANALYST;
GRANT USAGE ON DATABASE CAREVIEW_DB TO ROLE CAREVIEW_VIEWER;

-- ============================================================================
-- STEP 5: GRANT SCHEMA ACCESS (MINIMAL PERMISSIONS)
-- Only giving USAGE (access) for now. More can be added later if needed.
-- ============================================================================

-- ADMIN: CAN ACCESS ALL SCHEMAS
GRANT USAGE ON SCHEMA CAREVIEW_SCH_BRONZE TO ROLE CAREVIEW_ADMIN;
GRANT USAGE ON SCHEMA CAREVIEW_SCH_SILVER TO ROLE CAREVIEW_ADMIN;
GRANT USAGE ON SCHEMA CAREVIEW_SCH_GOLD TO ROLE CAREVIEW_ADMIN;
GRANT USAGE ON SCHEMA CAREVIEW_SCH_AI_READY TO ROLE CAREVIEW_ADMIN;

-- ENGINEER: CAN ACCESS BRONZE, STAGING, ANALYTICS
GRANT USAGE ON SCHEMA CAREVIEW_SCH_BRONZE TO ROLE CAREVIEW_ENGINEER;
GRANT USAGE ON SCHEMA CAREVIEW_SCH_SILVER TO ROLE CAREVIEW_ENGINEER;
GRANT USAGE ON SCHEMA CAREVIEW_SCH_GOLD TO ROLE CAREVIEW_ENGINEER;

-- DATA SCIENTIST: CAN ACCESS ALL SCHEMAS
GRANT USAGE ON SCHEMA CAREVIEW_SCH_BRONZE TO ROLE CAREVIEW_DATA_SCIENTIST;
GRANT USAGE ON SCHEMA CAREVIEW_SCH_SILVER TO ROLE CAREVIEW_DATA_SCIENTIST;
GRANT USAGE ON SCHEMA CAREVIEW_SCH_GOLD TO ROLE CAREVIEW_DATA_SCIENTIST;
GRANT USAGE ON SCHEMA CAREVIEW_SCH_AI_READY TO ROLE CAREVIEW_DATA_SCIENTIST;

-- ANALYST: CAN ACCESS STAGING, ANALYTICS, ML_FEATURES
GRANT USAGE ON SCHEMA CAREVIEW_SCH_SILVER TO ROLE CAREVIEW_ANALYST;
GRANT USAGE ON SCHEMA CAREVIEW_SCH_GOLD TO ROLE CAREVIEW_ANALYST;
GRANT USAGE ON SCHEMA CAREVIEW_SCH_AI_READY TO ROLE CAREVIEW_ANALYST;

-- VIEWER: CAN ACCESS ANALYTICS ONLY
GRANT USAGE ON SCHEMA CAREVIEW_SCH_GOLD TO ROLE CAREVIEW_VIEWER;

-- ============================================================================
-- STEP 6: VERIFICATION
-- ============================================================================
SHOW SCHEMAS IN DATABASE CAREVIEW_DB;

/*
================================================================================
SUMMARY - WHAT WE CREATED:
--------------------------------------------------------------------------------
DATABASE: CAREVIEW_DB

SCHEMA                      PURPOSE                     WHO CAN ACCESS
--------------------------  --------------------------  ------------------------
CAREVIEW_SCH_BRONZE         Raw source data             Admin, Engineer, Data Scientist
CAREVIEW_SCH_SILVER        Cleaned data                Admin, Engineer, Data Scientist, Analyst
CAREVIEW_SCH_GOLD      Business reporting          Everyone
CAREVIEW_SCH_AI_READY    AI/ML features              Admin, Data Scientist, Analyst

================================================================================
HOW TO ADD MORE PERMISSIONS IN FUTURE (EXAMPLES):
================================================================================

-- GIVE ADMIN PERMISSION TO CREATE TABLES IN A SCHEMA:
-- GRANT CREATE TABLE ON SCHEMA CAREVIEW_SCH_BRONZE TO ROLE CAREVIEW_ADMIN;

-- GIVE ENGINEER PERMISSION TO CREATE AND MODIFY TABLES:
-- GRANT CREATE TABLE ON SCHEMA CAREVIEW_SCH_BRONZE TO ROLE CAREVIEW_ENGINEER;
-- GRANT CREATE VIEW ON SCHEMA CAREVIEW_SCH_SILVER TO ROLE CAREVIEW_ENGINEER;

-- GIVE DATA SCIENTIST PERMISSION TO CREATE ML TABLES:
-- GRANT CREATE TABLE ON SCHEMA CAREVIEW_SCH_AI_READY TO ROLE CAREVIEW_DATA_SCIENTIST;

-- GIVE ANALYST READ ACCESS TO ALL EXISTING TABLES IN A SCHEMA:
-- GRANT SELECT ON ALL TABLES IN SCHEMA CAREVIEW_SCH_GOLD TO ROLE CAREVIEW_ANALYST;

-- GIVE READ ACCESS TO ALL FUTURE TABLES AUTOMATICALLY:
-- GRANT SELECT ON FUTURE TABLES IN SCHEMA CAREVIEW_SCH_GOLD TO ROLE CAREVIEW_VIEWER;

-- REMOVE A PERMISSION:
-- REVOKE CREATE TABLE ON SCHEMA CAREVIEW_SCH_BRONZE FROM ROLE CAREVIEW_ENGINEER;

================================================================================
NEXT STEPS:
- Run 05_resource_monitors.sql to set up cost controls
================================================================================
*/
