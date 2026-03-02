/*
================================================================================
HEALTHCARE DATA PLATFORM - 06 POLICIES (Session & Network)
================================================================================
Execution Order: 6 of 7
Dependencies: 05_grants_permissions.sql
Purpose: Security policies for session management and network access

RUN AS: ACCOUNTADMIN
================================================================================
--  DATA GOVERNANCE - MASKING POLICIES
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
--  DATA GOVERNANCE - ROW ACCESS POLICY
-- ============================================================================
CREATE OR REPLACE ROW ACCESS POLICY CAREVIEW_DB.BRONZE.ROW_ACCESS_BY_DEPT AS (DEPT STRING) 
RETURNS BOOLEAN ->
    CASE 
        WHEN CURRENT_ROLE() IN ('CAREVIEW_ADMIN', 'ACCOUNTADMIN') THEN TRUE
        WHEN CURRENT_ROLE() = 'CAREVIEW_ANALYST' THEN TRUE
        WHEN CURRENT_ROLE() = 'CAREVIEW_VIEWER' THEN DEPT IN ('GENERAL', 'PEDIATRICS')
        ELSE FALSE
    END;

SHOW SESSION POLICIES;
SHOW PARAMETERS LIKE 'SESSION%';
