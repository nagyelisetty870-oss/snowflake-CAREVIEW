/*
================================================================================
CAREVIEW - PATIENT RISK MONITORING PLATFORM
================================================================================
PHASE 8: DATA GOVERNANCE
--------------------------------------------------------------------------------
PURPOSE: Create masking policies to protect sensitive data (SSN, Email, Phone)
================================================================================
*/

USE ROLE ACCOUNTADMIN;
USE DATABASE CAREVIEW_DB;

-- ============================================================================
-- MASKING POLICY 1: HIDE SSN (SHOWS ONLY LAST 4 DIGITS)
-- ============================================================================
CREATE OR REPLACE MASKING POLICY MASK_SSN AS (VAL STRING) RETURNS STRING ->
    CASE
        WHEN CURRENT_ROLE() = 'ACCOUNTADMIN' THEN VAL
        ELSE CONCAT('XXX-XX-', RIGHT(VAL, 4))
    END;

-- ============================================================================
-- MASKING POLICY 2: HIDE EMAIL (SHOWS ONLY DOMAIN)
-- ============================================================================
CREATE OR REPLACE MASKING POLICY MASK_EMAIL AS (VAL STRING) RETURNS STRING ->
    CASE
        WHEN CURRENT_ROLE() = 'ACCOUNTADMIN' THEN VAL
        ELSE CONCAT('****@', SPLIT_PART(VAL, '@', 2))
    END;

-- ============================================================================
-- MASKING POLICY 3: HIDE PHONE (SHOWS ONLY LAST 4 DIGITS)
-- ============================================================================
CREATE OR REPLACE MASKING POLICY MASK_PHONE AS (VAL STRING) RETURNS STRING ->
    CASE
        WHEN CURRENT_ROLE() = 'ACCOUNTADMIN' THEN VAL
        ELSE CONCAT('XXX-XXX-', RIGHT(VAL, 4))
    END;

-- ============================================================================
-- VERIFY
-- ============================================================================
SHOW MASKING POLICIES;

/*
================================================================================
SUMMARY:
--------------------------------------------------------------------------------
POLICY        WHAT IT HIDES              EXAMPLE
-----------   -------------------------  ----------------------
MASK_SSN      Social Security Number     123-45-6789 → XXX-XX-6789
MASK_EMAIL    Email address              john@gmail.com → ****@gmail.com
MASK_PHONE    Phone number               555-123-4567 → XXX-XXX-4567

================================================================================
HOW TO APPLY (AFTER TABLES ARE CREATED):
================================================================================

ALTER TABLE your_table MODIFY COLUMN SSN SET MASKING POLICY MASK_SSN;
ALTER TABLE your_table MODIFY COLUMN EMAIL SET MASKING POLICY MASK_EMAIL;
ALTER TABLE your_table MODIFY COLUMN PHONE SET MASKING POLICY MASK_PHONE;

================================================================================
*/
