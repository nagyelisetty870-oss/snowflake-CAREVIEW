/*
================================================================================
CAREVIEW - PATIENT RISK MONITORING PLATFORM
================================================================================
PHASE 5: RESOURCE MONITORS
--------------------------------------------------------------------------------
PURPOSE: Control and monitor credit usage at account and warehouse level
         
MONITORS:
1. CAREVIEW_ACCOUNT_MONITOR - Account-level credit control
2. CAREVIEW_LOAD_MONITOR    - Loading warehouse credits
3. CAREVIEW_TRANSFORM_MONITOR - Transform warehouse credits
4. CAREVIEW_ANALYTICS_MONITOR - Analytics warehouse credits
5. CAREVIEW_AI_MONITOR      - AI warehouse credits
================================================================================
*/

-- ============================================================================
-- STEP 1: SET ADMIN CONTEXT
-- ============================================================================
USE ROLE ACCOUNTADMIN;

-- ============================================================================
-- STEP 2: CREATE ACCOUNT-LEVEL RESOURCE MONITOR
-- ----------------------------------------------------------------------------
-- Controls total credit usage across the account
-- Notify at 50%, 75%, 90%, suspend at 100%
-- ============================================================================

CREATE OR REPLACE RESOURCE MONITOR CAREVIEW_ACCOUNT_MONITOR
    WITH
        CREDIT_QUOTA = 300           -- MONTHLY CREDIT LIMIT
        FREQUENCY = MONTHLY           -- RESET MONTHLY
        START_TIMESTAMP = IMMEDIATELY
        TRIGGERS
            ON 50 PERCENT DO NOTIFY   -- ALERT AT 50%
            ON 75 PERCENT DO NOTIFY   -- ALERT AT 75%
            ON 90 PERCENT DO NOTIFY   -- ALERT AT 90%
            ON 100 PERCENT DO SUSPEND -- SUSPEND AT 100%
            ON 110 PERCENT DO SUSPEND_IMMEDIATE; -- FORCE SUSPEND AT 110%

-- ============================================================================
-- STEP 3: CREATE LOAD WAREHOUSE MONITOR
-- ----------------------------------------------------------------------------
-- Controls credits for data loading operations
-- ============================================================================

CREATE OR REPLACE RESOURCE MONITOR CAREVIEW_LOAD_MONITOR
    WITH
        CREDIT_QUOTA = 350           -- MONTHLY LIMIT FOR LOADING
        FREQUENCY = MONTHLY
        START_TIMESTAMP = IMMEDIATELY
        TRIGGERS
            ON 50 PERCENT DO NOTIFY
            ON 80 PERCENT DO NOTIFY
            ON 100 PERCENT DO SUSPEND;

-- ============================================================================
-- STEP 4: CREATE TRANSFORM WAREHOUSE MONITOR
-- ============================================================================

CREATE OR REPLACE RESOURCE MONITOR CAREVIEW_TRANSFORM_MONITOR
    WITH
        CREDIT_QUOTA = 200            -- HIGHER LIMIT FOR TRANSFORMATIONS
        FREQUENCY = MONTHLY
        START_TIMESTAMP = IMMEDIATELY
        TRIGGERS
            ON 50 PERCENT DO NOTIFY
            ON 80 PERCENT DO NOTIFY
            ON 100 PERCENT DO SUSPEND;

-- ============================================================================
-- STEP 5: CREATE ANALYTICS WAREHOUSE MONITOR
-- ============================================================================

CREATE OR REPLACE RESOURCE MONITOR CAREVIEW_ANALYTICS_MONITOR
    WITH
        CREDIT_QUOTA = 300            -- HIGHER LIMIT FOR USER QUERIES
        FREQUENCY = MONTHLY
        START_TIMESTAMP = IMMEDIATELY
        TRIGGERS
            ON 50 PERCENT DO NOTIFY
            ON 75 PERCENT DO NOTIFY
            ON 90 PERCENT DO NOTIFY
            ON 100 PERCENT DO SUSPEND;

-- ============================================================================
-- STEP 6: CREATE AI WAREHOUSE MONITOR
-- ============================================================================

CREATE OR REPLACE RESOURCE MONITOR CAREVIEW_AI_MONITOR
    WITH
        CREDIT_QUOTA = 350            -- AI WORKLOADS CREDIT LIMIT
        FREQUENCY = MONTHLY
        START_TIMESTAMP = IMMEDIATELY
        TRIGGERS
            ON 50 PERCENT DO NOTIFY
            ON 80 PERCENT DO NOTIFY
            ON 100 PERCENT DO SUSPEND;

-- ============================================================================
-- STEP 7: ASSIGN MONITORS TO WAREHOUSES
-- ============================================================================

ALTER WAREHOUSE CAREVIEW_LOAD_WH SET RESOURCE_MONITOR = CAREVIEW_LOAD_MONITOR;
ALTER WAREHOUSE CAREVIEW_TRANSFORM_WH SET RESOURCE_MONITOR = CAREVIEW_TRANSFORM_MONITOR;
ALTER WAREHOUSE CAREVIEW_ANALYTICS_WH SET RESOURCE_MONITOR = CAREVIEW_ANALYTICS_MONITOR;
ALTER WAREHOUSE CAREVIEW_AI_WH SET RESOURCE_MONITOR = CAREVIEW_AI_MONITOR;

-- ============================================================================
-- STEP 8: VERIFICATION QUERIES
-- ============================================================================

-- VIEW ALL RESOURCE MONITORS
SHOW RESOURCE MONITORS LIKE 'CAREVIEW%';

-- CHECK WAREHOUSE MONITOR ASSIGNMENTS
SHOW WAREHOUSES LIKE 'CAREVIEW%';

/*
================================================================================
RESOURCE MONITOR SUMMARY:
--------------------------------------------------------------------------------
MONITOR                    QUOTA    NOTIFY AT      SUSPEND AT
-------------------------- -------- -------------- -----------
CAREVIEW_ACCOUNT_MONITOR   300      50%, 75%, 90%  100%
CAREVIEW_LOAD_MONITOR      350      50%, 80%       100%
CAREVIEW_TRANSFORM_MONITOR 200      50%, 80%       100%
CAREVIEW_ANALYTICS_MONITOR 300      50%, 75%, 90%  100%
CAREVIEW_AI_MONITOR        350      50%, 80%       100%
================================================================================
*/
