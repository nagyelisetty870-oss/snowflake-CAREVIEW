/*
================================================================================
CAREVIEW - PATIENT RISK MONITORING PLATFORM
================================================================================
PHASE 10: VERIFICATION - VALIDATION QUERIES AND TEST SCRIPTS
--------------------------------------------------------------------------------
PURPOSE: Validate all setup from phases 1-9 is correctly configured
         Run test cases to ensure policies and access work as expected
================================================================================
*/

-- ============================================================================
-- TEST CASE 1: VERIFY DATABASE AND SCHEMAS EXIST
-- ============================================================================

-- VERIFY DATABASE
SELECT 
    DATABASE_NAME,
    DATABASE_OWNER,
    COMMENT,
    CREATED
FROM SNOWFLAKE.INFORMATION_SCHEMA.DATABASES
WHERE DATABASE_NAME = 'CAREVIEW_DB';

-- VERIFY SCHEMAS
SELECT 
    CATALOG_NAME AS DATABASE_NAME,
    SCHEMA_NAME,
    SCHEMA_OWNER,
    COMMENT
FROM CAREVIEW_DB.INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME IN ('BRONZE', 'SILVER', 'GOLD', 'AI_READY', 'MONITORING', 'ALERTS', 'AUDIT', 'GOVERNANCE')
ORDER BY SCHEMA_NAME;

-- ============================================================================
-- TEST CASE 2: VERIFY ROLES EXIST AND HIERARCHY
-- ============================================================================

-- LIST ALL CAREVIEW ROLES
SHOW ROLES LIKE 'CAREVIEW%';

-- VERIFY ROLE COUNT (EXPECTED: 14 ROLES - 6 FUNCTIONAL + 8 ACCESS)
SELECT COUNT(*) AS ROLE_COUNT 
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
WHERE "name" LIKE 'CAREVIEW%';

-- VERIFY ROLE HIERARCHY
SELECT 
    GRANTEE_NAME AS CHILD_ROLE,
    NAME AS PARENT_ROLE
FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
WHERE PRIVILEGE = 'USAGE'
    AND GRANTED_ON = 'ROLE'
    AND NAME LIKE 'CAREVIEW%'
    AND DELETED_ON IS NULL
ORDER BY CHILD_ROLE;

-- ============================================================================
-- TEST CASE 3: VERIFY WAREHOUSES EXIST
-- ============================================================================

SHOW WAREHOUSES LIKE 'CAREVIEW%';

-- VERIFY 4 WAREHOUSES CREATED
SELECT 
    "name" AS WAREHOUSE_NAME,
    "size" AS SIZE,
    "auto_suspend" AS AUTO_SUSPEND,
    "auto_resume" AS AUTO_RESUME,
    "resource_monitor" AS RESOURCE_MONITOR
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
WHERE "name" LIKE 'CAREVIEW%';

-- ============================================================================
-- TEST CASE 4: VERIFY RESOURCE MONITORS
-- ============================================================================

SHOW RESOURCE MONITORS LIKE 'CAREVIEW%';

-- EXPECTED: 5 RESOURCE MONITORS
SELECT COUNT(*) AS MONITOR_COUNT
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
WHERE "name" LIKE 'CAREVIEW%';

-- ============================================================================
-- TEST CASE 5: VERIFY MONITORING VIEWS (12 EXPECTED)
-- ============================================================================

SHOW VIEWS IN SCHEMA CAREVIEW_DB.MONITORING;

SELECT COUNT(*) AS VIEW_COUNT
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

-- ============================================================================
-- TEST CASE 6: VERIFY ALERTS (8 EXPECTED)
-- ============================================================================

SHOW ALERTS IN SCHEMA CAREVIEW_DB.ALERTS;

SELECT COUNT(*) AS ALERT_COUNT
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

-- ============================================================================
-- TEST CASE 7: VERIFY DATA GOVERNANCE OBJECTS
-- ============================================================================

-- VERIFY TAGS (4 EXPECTED)
SHOW TAGS IN SCHEMA CAREVIEW_DB.GOVERNANCE;

SELECT COUNT(*) AS TAG_COUNT
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

-- VERIFY MASKING POLICIES (3 EXPECTED)
SHOW MASKING POLICIES IN SCHEMA CAREVIEW_DB.GOVERNANCE;

SELECT COUNT(*) AS MASKING_POLICY_COUNT
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

-- VERIFY ROW ACCESS POLICIES (1 EXPECTED)
SHOW ROW ACCESS POLICIES IN SCHEMA CAREVIEW_DB.GOVERNANCE;

-- ============================================================================
-- TEST CASE 8: VERIFY AUDIT VIEWS (6 EXPECTED)
-- ============================================================================

SHOW VIEWS IN SCHEMA CAREVIEW_DB.AUDIT;

SELECT COUNT(*) AS AUDIT_VIEW_COUNT
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

-- ============================================================================
-- TEST CASE 9: VERIFY NETWORK POLICY EXISTS
-- ============================================================================

SHOW NETWORK POLICIES LIKE 'CAREVIEW%';

-- ============================================================================
-- TEST CASE 10: VERIFY PASSWORD AND SESSION POLICIES
-- ============================================================================

SHOW PASSWORD POLICIES IN SCHEMA CAREVIEW_SECURITY.NETWORK_CONFIG;
SHOW SESSION POLICIES IN SCHEMA CAREVIEW_SECURITY.NETWORK_CONFIG;

-- ============================================================================
-- COMPREHENSIVE VERIFICATION SUMMARY
-- ============================================================================

-- CREATE A VERIFICATION REPORT TABLE
CREATE OR REPLACE TEMPORARY TABLE VERIFICATION_RESULTS (
    TEST_CATEGORY VARCHAR(50),
    TEST_NAME VARCHAR(100),
    EXPECTED_VALUE VARCHAR(50),
    ACTUAL_VALUE VARCHAR(50),
    STATUS VARCHAR(10)
);

-- THE RESULTS WOULD BE POPULATED BY RUNNING EACH TEST ABOVE

/*
================================================================================
VERIFICATION CHECKLIST:
--------------------------------------------------------------------------------
[  ] Database CAREVIEW_DB exists
[  ] 8 Schemas created (BRONZE, SILVER, GOLD, AI_READY, MONITORING, ALERTS, AUDIT, GOVERNANCE)
[  ] 14 Roles created (6 functional + 8 access roles)
[  ] Role hierarchy correctly established
[  ] 4 Warehouses created with resource monitors
[  ] 5 Resource monitors configured
[  ] 12 Monitoring views created
[  ] 8 Alerts configured and active
[  ] 4 Tags created for data classification
[  ] 3 Masking policies created
[  ] 1 Row access policy created
[  ] 6 Audit views created
[  ] Network policy configured
[  ] Password and session policies created

RUN EACH TEST CASE ABOVE AND VERIFY COUNTS MATCH EXPECTED VALUES
================================================================================
*/

-- ============================================================================
-- QUICK VALIDATION SCRIPT
-- ============================================================================

SELECT 'DATABASE' AS OBJECT_TYPE, COUNT(*) AS COUNT, '1' AS EXPECTED
FROM SNOWFLAKE.INFORMATION_SCHEMA.DATABASES WHERE DATABASE_NAME = 'CAREVIEW_DB'
UNION ALL
SELECT 'SCHEMAS', COUNT(*), '8'
FROM CAREVIEW_DB.INFORMATION_SCHEMA.SCHEMATA 
WHERE SCHEMA_NAME IN ('BRONZE', 'SILVER', 'GOLD', 'AI_READY', 'MONITORING', 'ALERTS', 'AUDIT', 'GOVERNANCE');
