/*
================================================================================
CAREVIEW - PATIENT RISK MONITORING PLATFORM
================================================================================
PHASE 6: MONITORING QUERIES
--------------------------------------------------------------------------------
PURPOSE: Simple queries to monitor Snowflake usage and costs

NO NEED TO CREATE VIEWS - JUST RUN THESE QUERIES WHEN NEEDED!
Snowflake already has built-in views in SNOWFLAKE.ACCOUNT_USAGE
================================================================================
*/

-- ============================================================================
-- QUERY 1: DAILY CREDIT USAGE
-- Question: How many credits did we use each day?
-- ============================================================================
SELECT 
    DATE(START_TIME) AS DAY,
    ROUND(SUM(CREDITS_USED), 2) AS CREDITS
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE START_TIME >= DATEADD(DAY, -30, CURRENT_DATE())
GROUP BY DATE(START_TIME)
ORDER BY DAY DESC;

-- ============================================================================
-- QUERY 2: WAREHOUSE USAGE
-- Question: Which warehouse is using the most credits?
-- ============================================================================
SELECT 
    WAREHOUSE_NAME,
    ROUND(SUM(CREDITS_USED), 2) AS TOTAL_CREDITS
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE START_TIME >= DATEADD(DAY, -30, CURRENT_DATE())
GROUP BY WAREHOUSE_NAME
ORDER BY TOTAL_CREDITS DESC;

-- ============================================================================
-- QUERY 3: STORAGE USAGE
-- Question: How much storage is each database using?
-- ============================================================================
SELECT 
    DATABASE_NAME,
    ROUND(AVG(AVERAGE_DATABASE_BYTES) / 1024 / 1024 / 1024, 2) AS SIZE_GB
FROM SNOWFLAKE.ACCOUNT_USAGE.DATABASE_STORAGE_USAGE_HISTORY
WHERE USAGE_DATE >= DATEADD(DAY, -7, CURRENT_DATE())
GROUP BY DATABASE_NAME
ORDER BY SIZE_GB DESC;

-- ============================================================================
-- QUERY 4: USER LOGINS (LAST 7 DAYS)
-- Question: Who logged in recently?
-- ============================================================================
SELECT 
    USER_NAME,
    EVENT_TIMESTAMP AS LOGIN_TIME,
    IS_SUCCESS
FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
WHERE EVENT_TIMESTAMP >= DATEADD(DAY, -7, CURRENT_DATE())
ORDER BY EVENT_TIMESTAMP DESC;

-- ============================================================================
-- QUERY 5: FAILED LOGINS
-- Question: Who failed to login? (Security check)
-- ============================================================================
SELECT 
    USER_NAME,
    EVENT_TIMESTAMP AS ATTEMPT_TIME,
    CLIENT_IP,
    ERROR_MESSAGE
FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
WHERE IS_SUCCESS = 'NO'
    AND EVENT_TIMESTAMP >= DATEADD(DAY, -30, CURRENT_DATE())
ORDER BY EVENT_TIMESTAMP DESC;

-- ============================================================================
-- QUERY 6: SLOW QUERIES (OVER 1 MINUTE)
-- Question: Which queries are taking too long?
-- ============================================================================
SELECT 
    USER_NAME,
    WAREHOUSE_NAME,
    ROUND(TOTAL_ELAPSED_TIME / 1000, 0) AS SECONDS,
    START_TIME
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE TOTAL_ELAPSED_TIME > 60000
    AND START_TIME >= DATEADD(DAY, -7, CURRENT_DATE())
ORDER BY TOTAL_ELAPSED_TIME DESC
LIMIT 50;

-- ============================================================================
-- QUERY 7: FAILED QUERIES
-- Question: Which queries failed?
-- ============================================================================
SELECT 
    USER_NAME,
    ERROR_CODE,
    ERROR_MESSAGE,
    START_TIME
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE EXECUTION_STATUS = 'FAIL'
    AND START_TIME >= DATEADD(DAY, -7, CURRENT_DATE())
ORDER BY START_TIME DESC;

-- ============================================================================
-- QUERY 8: TOP USERS BY QUERY COUNT
-- Question: Who is running the most queries?
-- ============================================================================
SELECT 
    USER_NAME,
    COUNT(*) AS QUERY_COUNT
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE START_TIME >= DATEADD(DAY, -30, CURRENT_DATE())
GROUP BY USER_NAME
ORDER BY QUERY_COUNT DESC;

-- ============================================================================
-- QUERY 9: TABLE ROW COUNTS
-- Question: How many rows are in each table?
-- ============================================================================
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME,
    ROW_COUNT
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLES
WHERE TABLE_CATALOG = 'CAREVIEW_DB'
    AND DELETED IS NULL
ORDER BY ROW_COUNT DESC;

-- ============================================================================
-- QUERY 10: MONTHLY COST SUMMARY
-- Question: How much did we spend each month?
-- ============================================================================
SELECT 
    DATE_TRUNC('MONTH', START_TIME) AS MONTH,
    ROUND(SUM(CREDITS_USED), 2) AS TOTAL_CREDITS
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE START_TIME >= DATEADD(MONTH, -6, CURRENT_DATE())
GROUP BY DATE_TRUNC('MONTH', START_TIME)
ORDER BY MONTH DESC;

/*
================================================================================
SUMMARY - 10 MONITORING QUERIES:
--------------------------------------------------------------------------------
#   QUERY                      RUN WHEN
--  -------------------------  ----------------------------------
1   Daily Credit Usage         Weekly - check costs
2   Warehouse Usage            Weekly - find expensive warehouses
3   Storage Usage              Monthly - check storage costs
4   User Logins                As needed - audit
5   Failed Logins              Weekly - security check
6   Slow Queries               When performance issues occur
7   Failed Queries             When errors are reported
8   Top Users                  Monthly - track usage
9   Table Row Counts           As needed - data check
10  Monthly Cost Summary       Monthly - budget review

NO VIEWS NEEDED - JUST COPY AND RUN THE QUERY YOU NEED!
================================================================================
*/
