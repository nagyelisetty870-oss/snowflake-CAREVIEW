/*
================================================================================
CAREVIEW - PATIENT RISK MONITORING PLATFORM
================================================================================
PHASE 9: AUDIT QUERIES
--------------------------------------------------------------------------------
PURPOSE: Track WHO did WHAT and WHEN for security and compliance

JUST RUN THESE QUERIES - NO SETUP NEEDED!
================================================================================
*/

USE ROLE ACCOUNTADMIN;

-- ============================================================================
-- AUDIT 1: WHO LOGGED IN?
-- Shows all users who logged into Snowflake in last 7 days
-- ============================================================================
SELECT 
    USER_NAME,                              -- Who logged in
    EVENT_TIMESTAMP AS LOGIN_TIME,          -- When they logged in
    IS_SUCCESS                              -- Did login succeed (YES/NO)
FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
WHERE EVENT_TIMESTAMP >= DATEADD(DAY, -7, CURRENT_DATE())
ORDER BY LOGIN_TIME DESC;

-- ============================================================================
-- AUDIT 2: FAILED LOGINS (SECURITY CHECK)
-- Shows failed login attempts - important for security!
-- ============================================================================
SELECT 
    USER_NAME,                              -- Who tried to login
    EVENT_TIMESTAMP AS ATTEMPT_TIME,        -- When they tried
    ERROR_MESSAGE                           -- Why it failed
FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
WHERE IS_SUCCESS = 'NO'
    AND EVENT_TIMESTAMP >= DATEADD(DAY, -7, CURRENT_DATE())
ORDER BY ATTEMPT_TIME DESC;

-- ============================================================================
-- AUDIT 3: WHO RAN QUERIES?
-- Shows how many queries each user ran
-- ============================================================================
SELECT 
    USER_NAME,                              -- Who ran queries
    COUNT(*) AS TOTAL_QUERIES               -- How many queries
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE START_TIME >= DATEADD(DAY, -7, CURRENT_DATE())
GROUP BY USER_NAME
ORDER BY TOTAL_QUERIES DESC;

-- ============================================================================
-- AUDIT 4: WHAT QUERIES FAILED?
-- Shows queries that had errors
-- ============================================================================
SELECT 
    USER_NAME,                              -- Who ran the query
    START_TIME,                             -- When it ran
    ERROR_MESSAGE                           -- What went wrong
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE EXECUTION_STATUS = 'FAIL'
    AND START_TIME >= DATEADD(DAY, -7, CURRENT_DATE())
ORDER BY START_TIME DESC;

-- ============================================================================
-- AUDIT 5: ALL USERS IN THE SYSTEM
-- Shows list of all users
-- ============================================================================
SELECT 
    NAME AS USER_NAME,                      -- User name
    CREATED_ON,                             -- When user was created
    LAST_SUCCESS_LOGIN,                     -- Last time they logged in
    DISABLED                                -- Is user disabled (TRUE/FALSE)
FROM SNOWFLAKE.ACCOUNT_USAGE.USERS
ORDER BY CREATED_ON DESC;

-- ============================================================================
-- AUDIT 6: ALL ROLES IN THE SYSTEM
-- Shows list of all roles
-- ============================================================================
SELECT 
    NAME AS ROLE_NAME,                      -- Role name
    CREATED_ON                              -- When role was created
FROM SNOWFLAKE.ACCOUNT_USAGE.ROLES
ORDER BY CREATED_ON DESC;

/*
================================================================================
SUMMARY - 6 SIMPLE AUDIT QUERIES:
--------------------------------------------------------------------------------

QUERY                   WHAT IT SHOWS                  WHEN TO RUN
----------------------  -----------------------------  ---------------
1. Who logged in?       User logins                    Daily
2. Failed logins        Security issues                Daily
3. Who ran queries?     User activity                  Weekly
4. Failed queries       Errors to fix                  When needed
5. All users            User list                      Monthly
6. All roles            Role list                      Monthly

================================================================================
HOW TO EXPLAIN THESE QUERIES:
================================================================================

AUDIT 1 - "This shows everyone who logged in. We check this daily."

AUDIT 2 - "This shows failed logins. If someone fails many times, 
           it could be a hacker trying to break in."

AUDIT 3 - "This shows how active each user is. Helps us understand 
           who uses the system most."

AUDIT 4 - "This shows broken queries. We fix these errors."

AUDIT 5 - "This is our user list. We check who has access."

AUDIT 6 - "This is our role list. Roles control what users can do."

================================================================================
*/
