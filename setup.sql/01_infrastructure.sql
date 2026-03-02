/*
================================================================================
CAREVIEW - INFRASTRUCTURE SETUP
================================================================================
Purpose: Core infrastructure including roles, database, schemas, and governance
Run As: ACCOUNTADMIN
================================================================================
*/

-- ============================================================================
-- 1. ENABLE CORTEX CROSS-REGION
-- ============================================================================
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';

-- ============================================================================
-- 5. DATA GOVERNANCE - MASKING POLICIES
-- ============================================================================
CREATE OR REPLACE MASKING POLICY CAREVIEW_DB.BRONZE.MASK_PHI_STRING AS (VAL STRING) 
RETURNS STRING ->
    CASE 
        WHEN CURRENT_ROLE() IN ('CAREVIEW_ADMIN', 'ACCOUNTADMIN') THEN VAL
        ELSE '***MASKED***'
    END;

CREATE OR REPLACE MASKING POLICY CAREVIEW_DB.BRONZE.MASK_PHONE AS (VAL STRING) 
RETURNS STRING ->
    CASE 
        WHEN CURRENT_ROLE() IN ('CAREVIEW_ADMIN', 'ACCOUNTADMIN') THEN VAL
        ELSE 'XXX-XXXX'
    END;

CREATE OR REPLACE MASKING POLICY CAREVIEW_DB.BRONZE.MASK_AMOUNT AS (VAL NUMBER) 
RETURNS NUMBER ->
    CASE 
        WHEN CURRENT_ROLE() IN ('CAREVIEW_ADMIN', 'CAREVIEW_ANALYST', 'ACCOUNTADMIN') THEN VAL
        ELSE NULL
    END;

-- ============================================================================
-- 6. DATA GOVERNANCE - ROW ACCESS POLICY
-- ============================================================================
CREATE OR REPLACE ROW ACCESS POLICY CAREVIEW_DB.BRONZE.ROW_ACCESS_BY_DEPT AS (DEPT STRING) 
RETURNS BOOLEAN ->
    CASE 
        WHEN CURRENT_ROLE() IN ('CAREVIEW_ADMIN', 'ACCOUNTADMIN') THEN TRUE
        WHEN CURRENT_ROLE() = 'CAREVIEW_ANALYST' THEN TRUE
        WHEN CURRENT_ROLE() = 'CAREVIEW_VIEWER' THEN DEPT IN ('GENERAL', 'PEDIATRICS')
        ELSE FALSE
    END;

-- ============================================================================
-- 7. AUDIT VIEW (Run AFTER Bronze schema and tables are created)
-- ============================================================================
-- Note: This view uses ACCOUNT_USAGE which requires ACCOUNTADMIN and has 45-min latency
-- CREATE OR REPLACE VIEW CAREVIEW_DB.BRONZE.VW_ACCESS_AUDIT AS
-- SELECT 
--     QUERY_START_TIME,
--     USER_NAME,
--     ROLE_NAME,
--     DATABASE_NAME,
--     SCHEMA_NAME,
--     QUERY_TYPE,
--     ROWS_PRODUCED,
--     EXECUTION_STATUS
-- FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
-- WHERE DATABASE_NAME = 'CAREVIEW_DB'
--     AND QUERY_START_TIME >= DATEADD('DAY', -30, CURRENT_TIMESTAMP())
-- ORDER BY QUERY_START_TIME DESC;
