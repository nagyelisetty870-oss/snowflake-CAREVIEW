/*
================================================================================
HEALTHCARE DATA PLATFORM - 04 DATABASES & SCHEMAS (Medallion Architecture)
================================================================================
Execution Order: 4 of 7
Dependencies: 03_warehouses_monitors.sql
Purpose: Create 4-layer data architecture (Bronze → Silver → Gold → Platinum)

RUN AS: ACCOUNTADMIN

-- ============================================================================
-- CareView Healthcare Analytics Platform
-- Database and Schema Setup (Medallion Architecture)
-- ============================================================================
-- Purpose: Creates the foundational data architecture for CareView analytics
-- Architecture: Bronze -> Silver -> Gold -> AI_Ready (Medallion pattern)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- DATABASE
-- ----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS CAREVIEW_DB
    COMMENT = 'CareView Healthcare Analytics Platform';

-- ----------------------------------------------------------------------------
-- SCHEMAS
-- ----------------------------------------------------------------------------

-- Bronze Layer: Raw ingestion zone
CREATE SCHEMA IF NOT EXISTS CAREVIEW_DB.BRONZE
    COMMENT = 'Raw data layer - Source data as-is';

-- Silver Layer: Cleansed and conformed data
CREATE SCHEMA IF NOT EXISTS CAREVIEW_DB.SILVER
    COMMENT = 'Cleansed layer - Validated and standardized data';

-- Gold Layer: Business-ready aggregations
CREATE SCHEMA IF NOT EXISTS CAREVIEW_DB.GOLD
    COMMENT = 'Analytics layer - Aggregated metrics and KPIs';

-- AI-Ready Layer: ML/AI feature store
CREATE SCHEMA IF NOT EXISTS CAREVIEW_DB.AI_READY
    COMMENT = 'AI layer - Cortex AI enriched insights';
