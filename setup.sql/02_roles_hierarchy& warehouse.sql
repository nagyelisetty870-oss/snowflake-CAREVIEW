/*
================================================================================
HEALTHCARE DATA PLATFORM - 02 ROLES & HIERARCHY
================================================================================
Execution Order: 2 of 7
Dependencies: 01_account_setup.sql
Purpose: Create RBAC role hierarchy for data access control

RUN AS: ACCOUNTADMIN
================================================================================
*/
--============================================================================
-- 2. CREATE ROLES (Role Hierarchy: ADMIN > ANALYST > VIEWER)
-- ============================================================================
CREATE ROLE IF NOT EXISTS CAREVIEW_ADMIN
    COMMENT = 'CareView Admin - Full access to all project resources';

CREATE ROLE IF NOT EXISTS CAREVIEW_ANALYST
    COMMENT = 'CareView Analyst - Read/Write access to transformed data';

CREATE ROLE IF NOT EXISTS CAREVIEW_VIEWER
    COMMENT = 'CareView Viewer - Read-only access to analytics data';

-- Establish role hierarchy
GRANT ROLE CAREVIEW_VIEWER TO ROLE CAREVIEW_ANALYST;
GRANT ROLE CAREVIEW_ANALYST TO ROLE CAREVIEW_ADMIN;
GRANT ROLE CAREVIEW_ADMIN TO ROLE SYSADMIN;

-- Grant warehouse access
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE CAREVIEW_ADMIN;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE CAREVIEW_ANALYST;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE CAREVIEW_VIEWER;


-- ============================================================================
-- VERIFICATION
-- ============================================================================
SHOW ROLES LIKE 'HEALTHCARE%';
SHOW GRANTS ON ROLE HEALTHCARE_ADMIN;




-