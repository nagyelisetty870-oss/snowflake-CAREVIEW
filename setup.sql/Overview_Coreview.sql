/*
================================================================================
CAREVIEW - COMPREHENSIVE DOCUMENTATION
================================================================================

PROJECT OVERVIEW
================================================================================
CareView is a healthcare analytics platform built on Snowflake using the 
Medallion Architecture (Bronze → Silver → Gold → AI-Ready layers).

ARCHITECTURE
================================================================================

┌─────────────────────────────────────────────────────────────────────────────┐
│                           CAREVIEW_DB DATABASE                               │
├───────────────┬───────────────┬───────────────┬─────────────────────────────┤
│    BRONZE     │    SILVER     │     GOLD      │         AI_READY            │
│   (Raw Data)  │  (Cleansed)   │  (Analytics)  │      (AI-Enriched)          │
├───────────────┼───────────────┼───────────────┼─────────────────────────────┤
│ PATIENTS      │ PATIENTS      │ PATIENT_      │ PATIENT_RISK_SCORES         │
│ VISITS        │ VISITS        │   SUMMARY     │ VISIT_INSIGHTS              │
│ DIAGNOSES     │ DIAGNOSES     │ DEPARTMENT_   │ CLINICAL_INTELLIGENCE       │
│ TREATMENTS    │ TREATMENTS    │   METRICS     │                             │
│ BILLING       │ BILLING       │ MONTHLY_      │                             │
│               │               │   REVENUE     │                             │
│               │               │ DIAGNOSIS_    │                             │
│               │               │   ANALYTICS   │                             │
└───────────────┴───────────────┴───────────────┴─────────────────────────────┘

LAYER DESCRIPTIONS
================================================================================

BRONZE LAYER (Raw Data)
-----------------------
- Source: Direct data ingestion
- Format: Original structure preserved
- Records: 5 tables, ~580 total records
- Purpose: Single source of truth

SILVER LAYER (Cleansed)
-----------------------
- Source: Bronze tables
- Transformations:
  * Text normalization (UPPER, INITCAP, TRIM)
  * Null filtering (INNER JOINs for referential integrity)
  * Calculated fields (AGE, LENGTH_OF_STAY_DAYS, SEVERITY_LEVEL)
  * Status mapping (PAYMENT_CATEGORY, OUTCOME_STATUS)

GOLD LAYER (Analytics)
----------------------
- Source: Silver tables
- Purpose: Business intelligence and KPIs
- Tables:
  * PATIENT_SUMMARY: Patient-level aggregations
  * DEPARTMENT_METRICS: Department performance KPIs
  * MONTHLY_REVENUE: Time-series financial analysis
  * DIAGNOSIS_ANALYTICS: Disease pattern insights

AI_READY LAYER (Cortex AI)
--------------------------
- Source: Gold tables
- AI Functions Used:
  * SNOWFLAKE.CORTEX.COMPLETE(): LLM-generated recommendations
  * SNOWFLAKE.CORTEX.SENTIMENT(): Text sentiment analysis
  * SNOWFLAKE.CORTEX.SUMMARIZE(): Automatic text summarization
- Model: llama3.1-8b

ROLE HIERARCHY
================================================================================

                    ┌──────────────┐
                    │  SYSADMIN   │
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐
                    │CAREVIEW_ADMIN│ ← Full access to all schemas
                    └──────┬───────┘
                           │
                   ┌───────▼────────┐
                   │CAREVIEW_ANALYST│ ← Read Bronze, Read/Write Silver & Gold
                   └───────┬────────┘
                           │
                    ┌──────▼───────┐
                    │CAREVIEW_VIEWER│ ← Read-only Gold & AI_Ready
                    └──────────────┘

DATA GOVERNANCE
================================================================================

Masking Policies:
- MASK_PHI_STRING: Masks patient names for non-admin roles
- MASK_PHONE: Masks phone numbers for non-admin roles
- MASK_AMOUNT: Masks billing amounts for viewer role

Row Access Policy:
- ROW_ACCESS_BY_DEPT: Limits viewer to GENERAL and PEDIATRICS departments

Audit:
- VW_ACCESS_AUDIT: Tracks all queries against CAREVIEW_DB (last 30 days)

TABLE SCHEMAS
================================================================================

BRONZE.PATIENTS
---------------
| Column           | Type        | Description                    |
|------------------|-------------|--------------------------------|
| PATIENT_ID       | VARCHAR(20) | Unique patient identifier      |
| FIRST_NAME       | VARCHAR(50) | Patient first name             |
| LAST_NAME        | VARCHAR(50) | Patient last name              |
| DATE_OF_BIRTH    | DATE        | Patient birth date             |
| GENDER           | VARCHAR(10) | Male/Female/Other              |
| BLOOD_TYPE       | VARCHAR(5)  | Blood type (A+, B-, etc.)      |
| PHONE_NUMBER     | VARCHAR(15) | Contact phone number           |
| REGISTRATION_DATE| DATE        | Date patient registered        |

BRONZE.VISITS
-------------
| Column          | Type         | Description                     |
|-----------------|--------------|-------------------------------- |
| VISIT_ID        | VARCHAR(20)  | Unique visit identifier         |
| PATIENT_ID      | VARCHAR(20)  | Reference to patient            |
| VISIT_DATE      | DATE         | Date of hospital visit          |
| DEPARTMENT      | VARCHAR(30)  | Department visited              |
| VISIT_TYPE      | VARCHAR(20)  | Inpatient/Outpatient/Emergency  |
| DOCTOR_NAME     | VARCHAR(50)  | Attending physician name        |
| DISCHARGE_DATE  | DATE         | Date of discharge               |
| VISIT_NOTES     | VARCHAR(500) | Brief notes about the visit     |

BRONZE.DIAGNOSES
----------------
| Column          | Type         | Description                     |
|-----------------|--------------|-------------------------------- |
| DIAGNOSIS_ID    | VARCHAR(20)  | Unique diagnosis identifier     |
| VISIT_ID        | VARCHAR(20)  | Reference to visit              |
| PATIENT_ID      | VARCHAR(20)  | Reference to patient            |
| DIAGNOSIS_CODE  | VARCHAR(10)  | ICD-10 diagnosis code           |
| DIAGNOSIS_NAME  | VARCHAR(100) | Diagnosis description           |
| SEVERITY        | VARCHAR(20)  | Mild/Moderate/Severe/Critical   |
| DIAGNOSIS_DATE  | DATE         | Date diagnosis was made         |

BRONZE.TREATMENTS
-----------------
| Column          | Type         | Description                     |
|-----------------|--------------|-------------------------------- |
| TREATMENT_ID    | VARCHAR(20)  | Unique treatment identifier     |
| VISIT_ID        | VARCHAR(20)  | Reference to visit              |
| PATIENT_ID      | VARCHAR(20)  | Reference to patient            |
| TREATMENT_NAME  | VARCHAR(100) | Name of treatment/procedure     |
| TREATMENT_TYPE  | VARCHAR(30)  | Medication/Surgery/Therapy/Test |
| TREATMENT_DATE  | DATE         | Date treatment was given        |
| DOCTOR_NAME     | VARCHAR(50)  | Doctor who performed treatment  |
| OUTCOME         | VARCHAR(30)  | Successful/Ongoing/Complications|

BRONZE.BILLING
--------------
| Column          | Type          | Description                    |
|-----------------|---------------|--------------------------------|
| BILL_ID         | VARCHAR(20)   | Unique billing identifier      |
| VISIT_ID        | VARCHAR(20)   | Reference to visit             |
| PATIENT_ID      | VARCHAR(20)   | Reference to patient           |
| SERVICE_NAME    | VARCHAR(100)  | Description of billed service  |
| AMOUNT          | DECIMAL(10,2) | Billed amount in USD           |
| PAYMENT_STATUS  | VARCHAR(20)   | Paid/Pending/Insurance/Denied  |
| BILL_DATE       | DATE          | Date bill was generated        |
| DEPARTMENT      | VARCHAR(30)   | Department that provided service|

EXECUTION ORDER
================================================================================

Run worksheets in this order:
1. 01_INFRASTRUCTURE_SETUP.sql  - Roles, database, schemas, policies
2. 02_BRONZE_LAYER.sql          - Raw data tables and inserts
3. 03_SILVER_LAYER.sql          - Cleansed/transformed tables
4. 04_GOLD_LAYER.sql            - Analytics and KPI tables
5. 05_AI_READY_LAYER.sql        - Cortex AI enriched tables
6. 06_DATA_QUALITY_TESTS.sql    - Validation queries

RECORD COUNTS
================================================================================

| Layer    | Table              | Records |
|----------|--------------------| --------|
| BRONZE   | PATIENTS           | 100     |
| BRONZE   | VISITS             | 120     |
| BRONZE   | DIAGNOSES          | 120     |
| BRONZE   | TREATMENTS         | 120     |
| BRONZE   | BILLING            | 120     |
| SILVER   | All tables         | ~same   |
| GOLD     | PATIENT_SUMMARY    | 100     |
| GOLD     | DEPARTMENT_METRICS | 8       |
| GOLD     | MONTHLY_REVENUE    | ~64     |
| GOLD     | DIAGNOSIS_ANALYTICS| ~30     |
| AI_READY | All tables         | Varies  |

Total Tables: 17

SAMPLE QUERIES
================================================================================

-- Top 5 high-risk patients
SELECT PATIENT_ID, FIRST_NAME, LAST_NAME, RISK_SCORE, AI_RECOMMENDATION
FROM CAREVIEW_DB.AI_READY.PATIENT_RISK_SCORES
ORDER BY RISK_SCORE DESC
LIMIT 5;

-- Department revenue summary
SELECT DEPARTMENT, TOTAL_VISITS, TOTAL_REVENUE, AVG_LENGTH_OF_STAY
FROM CAREVIEW_DB.GOLD.DEPARTMENT_METRICS
ORDER BY TOTAL_REVENUE DESC;

-- Monthly collection rate trend
SELECT REVENUE_MONTH, SUM(TOTAL_AMOUNT) AS REVENUE, 
       ROUND(AVG(COLLECTION_RATE_PCT), 2) AS AVG_COLLECTION_RATE
FROM CAREVIEW_DB.GOLD.MONTHLY_REVENUE
GROUP BY REVENUE_MONTH
ORDER BY REVENUE_MONTH;

-- Critical diagnoses requiring attention
SELECT DIAGNOSIS_NAME, CRITICAL_CASES, AI_CLINICAL_INSIGHT
FROM CAREVIEW_DB.AI_READY.CLINICAL_INTELLIGENCE
WHERE CLINICAL_PRIORITY = 'CRITICAL_PRIORITY';

================================================================================
*/
