/*
================================================================================
CAREVIEW - PATIENT RISK MONITORING PLATFORM
================================================================================
PHASE 7: ALERTS
--------------------------------------------------------------------------------
PURPOSE: Simple alerts to monitor costs and security
================================================================================
*/

-- ============================================================================
-- STEP 1: SET CONTEXT
-- ============================================================================
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;

USE DATABASE CAREVIEW_DB;

-- ============================================================================
-- ALERT 1: HIGH CREDIT USAGE (Checks every hour)
-- ============================================================================
CREATE OR REPLACE ALERT CAREVIEW_HIGH_CREDIT_ALERT
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '60 MINUTE'
    IF (EXISTS (
        SELECT 1 FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
        WHERE DATE(START_TIME) = CURRENT_DATE()
        HAVING SUM(CREDITS_USED) > 10
    ))
    THEN SELECT 'High credit usage detected';

-- ============================================================================
-- ALERT 2: FAILED LOGINS (Checks every 30 minutes)
-- ============================================================================
CREATE OR REPLACE ALERT CAREVIEW_FAILED_LOGIN_ALERT
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '30 MINUTE'
    IF (EXISTS (
        SELECT 1 FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
        WHERE IS_SUCCESS = 'NO'
            AND EVENT_TIMESTAMP >= DATEADD(HOUR, -1, CURRENT_TIMESTAMP())
        HAVING COUNT(*) > 3
    ))
    THEN SELECT 'Multiple failed logins detected';

-- ============================================================================
-- ALERT 3: LONG RUNNING QUERY (Checks every 15 minutes)
-- ============================================================================
CREATE OR REPLACE ALERT CAREVIEW_LONG_QUERY_ALERT
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '15 MINUTE'
    IF (EXISTS (
        SELECT 1 FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
        WHERE TOTAL_ELAPSED_TIME > 300000
            AND START_TIME >= DATEADD(MINUTE, -15, CURRENT_TIMESTAMP())
    ))
    THEN SELECT 'Long running query detected';

-- ============================================================================
-- STEP 2: ACTIVATE ALERTS
-- ============================================================================
ALTER ALERT CAREVIEW_HIGH_CREDIT_ALERT RESUME;
ALTER ALERT CAREVIEW_FAILED_LOGIN_ALERT RESUME;
ALTER ALERT CAREVIEW_LONG_QUERY_ALERT RESUME;

-- ============================================================================
-- STEP 3: VIEW ALL ALERTS
-- ============================================================================
SHOW ALERTS;

/*
================================================================================
HOW TO MONITOR ALERTS:
================================================================================

-- 1. SEE ALL YOUR ALERTS:
SHOW ALERTS;

-- 2. CHECK ALERT HISTORY (WHEN DID ALERTS TRIGGER?):
SELECT *
FROM SNOWFLAKE.ACCOUNT_USAGE.ALERT_HISTORY
ORDER BY SCHEDULED_TIME DESC
LIMIT 20;

-- 3. PAUSE AN ALERT:
ALTER ALERT CAREVIEW_HIGH_CREDIT_ALERT SUSPEND;

-- 4. RESUME AN ALERT:
ALTER ALERT CAREVIEW_HIGH_CREDIT_ALERT RESUME;

-- 5. DELETE AN ALERT:
DROP ALERT CAREVIEW_HIGH_CREDIT_ALERT;

================================================================================
SUMMARY:
================================================================================
ALERT NAME                    TRIGGERS WHEN
----------------------------  ---------------------------
CAREVIEW_HIGH_CREDIT_ALERT    Daily credits > 10
CAREVIEW_FAILED_LOGIN_ALERT   > 3 failed logins in 1 hour
CAREVIEW_LONG_QUERY_ALERT     Query runs > 5 minutes

================================================================================
*/
