/*
================================================================================
CAREVIEW - PATIENT RISK MONITORING PLATFORM
================================================================================
PHASE 2: RBAC SETUP - ROLE-BASED ACCESS CONTROL
--------------------------------------------------------------------------------
PURPOSE: Create roles to control who can do what in the Careview platform

ROLE HIERARCHY (WHO REPORTS TO WHO):
                    ACCOUNTADMIN
                         |
                      SYSADMIN
                         |
                   CAREVIEW_ADMIN
                         |
          +--------------+--------------+
          |              |              |
    CAREVIEW_       CAREVIEW_      CAREVIEW_
    ENGINEER     DATA_SCIENTIST    ANALYST
                                      |
                               CAREVIEW_VIEWER
================================================================================
*/

-- ============================================================================
-- STEP 1: USE SECURITY ADMIN ROLE
-- ============================================================================
USE ROLE SECURITYADMIN;

-- ============================================================================
-- STEP 2: CREATE 5 MAIN ROLES
-- Purpose: Each role has different access levels
-- ============================================================================

-- ADMIN: Full control over everything in Careview
CREATE ROLE IF NOT EXISTS CAREVIEW_ADMIN
    COMMENT = 'Admin role - full access to all Careview data';

-- ENGINEER: Builds and manages data pipelines
CREATE ROLE IF NOT EXISTS CAREVIEW_ENGINEER
    COMMENT = 'Engineer role - manages data pipelines and ETL';

-- DATA SCIENTIST: Works on ML and AI models
CREATE ROLE IF NOT EXISTS CAREVIEW_DATA_SCIENTIST
    COMMENT = 'Data Scientist role - ML models and AI features';

-- ANALYST: Runs queries and creates reports
CREATE ROLE IF NOT EXISTS CAREVIEW_ANALYST
    COMMENT = 'Analyst role - queries data and creates reports';

-- VIEWER: Can only view dashboards (read-only)
CREATE ROLE IF NOT EXISTS CAREVIEW_VIEWER
    COMMENT = 'Viewer role - read-only access to dashboards';

-- ============================================================================
-- STEP 3: SET UP ROLE HIERARCHY
-- Purpose: Higher roles inherit permissions from lower roles
-- ============================================================================

-- VIEWER IS THE BASE (LOWEST LEVEL)
-- ANALYST CAN DO EVERYTHING VIEWER CAN + MORE
GRANT ROLE CAREVIEW_VIEWER TO ROLE CAREVIEW_ANALYST;

-- DATA SCIENTIST AND ENGINEER CAN DO EVERYTHING ANALYST CAN + MORE
GRANT ROLE CAREVIEW_ANALYST TO ROLE CAREVIEW_DATA_SCIENTIST;
GRANT ROLE CAREVIEW_ANALYST TO ROLE CAREVIEW_ENGINEER;

-- ADMIN CAN DO EVERYTHING
GRANT ROLE CAREVIEW_DATA_SCIENTIST TO ROLE CAREVIEW_ADMIN;
GRANT ROLE CAREVIEW_ENGINEER TO ROLE CAREVIEW_ADMIN;

-- ADMIN REPORTS TO SYSADMIN
GRANT ROLE CAREVIEW_ADMIN TO ROLE SYSADMIN;

-- ============================================================================
-- STEP 4: VERIFICATION - CHECK WHAT WE CREATED
-- ============================================================================

-- VIEW ALL CAREVIEW ROLES
SHOW ROLES LIKE 'CAREVIEW%';

-- CHECK ROLE HIERARCHY
SHOW GRANTS TO ROLE CAREVIEW_ADMIN;
SHOW GRANTS TO ROLE CAREVIEW_ANALYST;

/*
================================================================================
SUMMARY - WHAT WE CREATED:
--------------------------------------------------------------------------------
5 ROLES WITH HIERARCHY:

ROLE                    ACCESS LEVEL
----------------------  -----------------------------------------
CAREVIEW_ADMIN          Full access - manages everything
CAREVIEW_ENGINEER       Builds data pipelines (Bronze/Silver/Gold)
CAREVIEW_DATA_SCIENTIST Works on AI/ML in AI_READY layer
CAREVIEW_ANALYST        Queries and reports from Gold layer
CAREVIEW_VIEWER         View dashboards only (read-only)

NEXT STEPS:
- Run 03_warehouse_management.sql to create warehouses
================================================================================
*/
