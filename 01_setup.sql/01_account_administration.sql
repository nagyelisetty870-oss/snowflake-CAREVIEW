/*
================================================================================
CAREVIEW - PATIENT RISK MONITORING PLATFORM
================================================================================
PHASE 1: ACCOUNT ADMINISTRATION
--------------------------------------------------------------------------------
PURPOSE: Set up basic security settings for the Careview platform

WHAT THIS FILE DOES:
- Creates a network policy to control who can access Snowflake
- Creates a password policy for strong passwords
- Creates a session policy for auto-logout
================================================================================
*/



-- ============================================================================
-- STEP 1: USE ADMIN ROLE
-- ============================================================================
USE ROLE ACCOUNTADMIN;

-- ============================================================================
-- STEP 2: CREATE SECURITY DATABASE
-- Purpose: Store all security-related objects in one place
-- ============================================================================
CREATE DATABASE IF NOT EXISTS CAREVIEW_SECURITY;
CREATE SCHEMA IF NOT EXISTS CAREVIEW_SECURITY.NETWORK_CONFIG;

-- ============================================================================
-- STEP 3: CREATE NETWORK POLICY
-- Purpose: Control which IP addresses can access Snowflake
-- Note: 0.0.0.0/0 means ALL IPs allowed (change this in production!)
-- ============================================================================
CREATE OR REPLACE NETWORK POLICY CAREVIEW_NETWORK_POLICY
    ALLOWED_IP_LIST = ('0.0.0.0/0')
    COMMENT = 'Careview network policy - restrict IPs in production';

-- ============================================================================
-- STEP 4: CREATE PASSWORD POLICY
-- Purpose: Enforce strong passwords for security
-- ============================================================================
CREATE OR REPLACE PASSWORD POLICY CAREVIEW_SECURITY.NETWORK_CONFIG.CAREVIEW_PASSWORD_POLICY
    PASSWORD_MIN_LENGTH = 12              -- MINIMUM 12 CHARACTERS
    PASSWORD_MAX_LENGTH = 256             -- MAXIMUM 256 CHARACTERS
    PASSWORD_MIN_UPPER_CASE_CHARS = 1     -- AT LEAST 1 UPPERCASE LETTER
    PASSWORD_MIN_LOWER_CASE_CHARS = 1     -- AT LEAST 1 LOWERCASE LETTER
    PASSWORD_MIN_NUMERIC_CHARS = 1        -- AT LEAST 1 NUMBER
    PASSWORD_MIN_SPECIAL_CHARS = 1        -- AT LEAST 1 SPECIAL CHARACTER
    PASSWORD_MAX_AGE_DAYS = 90            -- CHANGE PASSWORD EVERY 90 DAYS
    PASSWORD_MAX_RETRIES = 5              -- LOCK AFTER 5 FAILED ATTEMPTS
    PASSWORD_LOCKOUT_TIME_MINS = 15       -- UNLOCK AFTER 15 MINUTES
    COMMENT = 'Strong password policy for Careview users';

-- ============================================================================
-- STEP 5: CREATE SESSION POLICY
-- Purpose: Auto-logout inactive users for security
-- ============================================================================
CREATE OR REPLACE SESSION POLICY CAREVIEW_SECURITY.NETWORK_CONFIG.CAREVIEW_SESSION_POLICY
    SESSION_IDLE_TIMEOUT_MINS = 60        -- LOGOUT AFTER 60 MINS IDLE
    SESSION_UI_IDLE_TIMEOUT_MINS = 40     -- UI LOGOUT AFTER 30 MINS IDLE
    COMMENT = 'Auto-logout policy for Careview users';

-- ============================================================================
-- STEP 6: VERIFICATION - CHECK WHAT WE CREATED
-- ============================================================================

-- CHECK NETWORK POLICY
SHOW NETWORK POLICIES LIKE 'CAREVIEW%';

-- CHECK PASSWORD POLICY
SHOW PASSWORD POLICIES IN SCHEMA CAREVIEW_SECURITY.NETWORK_CONFIG;

-- CHECK SESSION POLICY
SHOW SESSION POLICIES IN SCHEMA CAREVIEW_SECURITY.NETWORK_CONFIG;

/*
================================================================================
SUMMARY - WHAT WE CREATED:
--------------------------------------------------------------------------------
1. CAREVIEW_SECURITY database    - Stores security objects
2. CAREVIEW_NETWORK_POLICY       - Controls IP access (allow all for now)
3. CAREVIEW_PASSWORD_POLICY      - Strong password rules
4. CAREVIEW_SESSION_POLICY       - Auto-logout after inactivity

NEXT STEPS:
- Run 02_rbac_setup.sql to create roles
- In production: Change network policy to specific IPs
================================================================================
*/
