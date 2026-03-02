/*
================================================================================
HEALTHCARE DATA PLATFORM - 03 WAREHOUSES & RESOURCE MONITORS
================================================================================
Execution Order: 3 of 7
Dependencies: 02_roles_hierarchy.sql
Purpose: Create compute warehouses and cost control monitors

RUN AS: ACCOUNTADMIN

WAREHOUSE STRATEGY:
============================================================================
2.5 CREATE WAREHOUSE
============================================================================
*/
  CREATE WAREHOUSE IF NOT EXISTS CAREVIEW_WH
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'CareView dedicated warehouse';

-- ============================================================================
-- 2.6 RESOURCE MONITOR (Simple monthly budget control)
-- ============================================================================
CREATE OR REPLACE RESOURCE MONITOR CAREVIEW_MONITOR
    WITH CREDIT_QUOTA = 100
    FREQUENCY = MONTHLY
    START_TIMESTAMP = IMMEDIATELY
    TRIGGERS
        ON 75 PERCENT DO NOTIFY
        ON 90 PERCENT DO NOTIFY
        ON 100 PERCENT DO SUSPEND;

ALTER WAREHOUSE CAREVIEW_WH SET RESOURCE_MONITOR = CAREVIEW_MONITOR;

GRANT USAGE ON WAREHOUSE CAREVIEW_WH TO ROLE CAREVIEW_ADMIN;
GRANT USAGE ON WAREHOUSE CAREVIEW_WH TO ROLE CAREVIEW_ANALYST;
GRANT USAGE ON WAREHOUSE CAREVIEW_WH TO ROLE CAREVIEW_VIEWER;
GRANT OPERATE ON WAREHOUSE CAREVIEW_WH TO ROLE CAREVIEW_ADMIN;
