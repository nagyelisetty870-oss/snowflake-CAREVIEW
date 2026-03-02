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
--  AUDIT VIEW (Run AFTER Bronze schema and tables are created)
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
