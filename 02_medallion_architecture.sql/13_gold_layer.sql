/*
==================================================
CAREVIEW - GOLD LAYER
==================================================

WHAT IS GOLD LAYER?
- Final layer for business reporting
- Data is grouped and summarized
- Easy to query for dashboards
- INCLUDES CORTEX AI FOR INSIGHTS

TABLES WE CREATE:
1. GOLD_PATIENT_SUMMARY      - One row per patient
2. GOLD_DOCTOR_SUMMARY       - One row per doctor
3. GOLD_DEPARTMENT_SUMMARY   - One row per department
4. GOLD_MONTHLY_VISITS       - One row per month
5. GOLD_PATIENT_MEDICATIONS  - Medications per patient
6. GOLD_PATIENT_RISK         - AI risk analysis per patient
7. GOLD_DIAGNOSIS_INSIGHTS   - AI insights on diagnoses
8. GOLD_BILLING_ANALYSIS     - AI billing insights

==================================================
*/

USE ROLE ACCOUNTADMIN;
USE DATABASE CAREVIEW_DB;
USE SCHEMA CAREVIEW_SCH_GOLD;


/*
==================================================
TABLE 1: GOLD_PATIENT_SUMMARY
==================================================

WHAT IT DOES:
- Shows one row for each patient
- Counts all their visits, diagnoses, treatments, medications
- Sums all their costs and bills

WHO USES IT:
- Care managers
- Patient services team

CHANGES FROM SILVER:
- No new calculations
- Just COUNT and SUM from multiple tables
- Grouped by patient

==================================================
*/

CREATE OR REPLACE TABLE GOLD_PATIENT_SUMMARY AS
SELECT
    
    -- ========== PATIENT INFO (no change) ==========
    P.PATIENT_ID,
    P.FULL_NAME,
    P.AGE,
    P.AGE_GROUP,
    P.GENDER,
    P.CITY,
    P.INSURANCE_TYPE,

    -- ========== COUNTS (new columns) ==========
    
    -- How many times did patient visit?
    COUNT(DISTINCT V.VISIT_ID) AS TOTAL_VISITS,

    -- How many diagnoses does patient have?
    COUNT(DISTINCT D.DIAGNOSIS_ID) AS TOTAL_DIAGNOSES,

    -- How many treatments did patient receive?
    COUNT(DISTINCT T.TREATMENT_ID) AS TOTAL_TREATMENTS,

    -- How many medications prescribed to patient?
    COUNT(DISTINCT M.MEDICATION_ID) AS TOTAL_MEDICATIONS,

    -- ========== SUMS (new columns) ==========
    
    -- Total treatment cost for patient
    SUM(T.COST) AS TOTAL_TREATMENT_COST,

    -- Total billed amount for patient
    SUM(B.AMOUNT) AS TOTAL_BILLED

FROM CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_PATIENTS P
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_VISITS V ON P.PATIENT_ID = V.PATIENT_ID
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_DIAGNOSES D ON P.PATIENT_ID = D.PATIENT_ID
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_TREATMENTS T ON P.PATIENT_ID = T.PATIENT_ID
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_MEDICATIONS M ON P.PATIENT_ID = M.PATIENT_ID
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_BILLING B ON P.PATIENT_ID = B.PATIENT_ID
GROUP BY
    P.PATIENT_ID,
    P.FULL_NAME,
    P.AGE,
    P.AGE_GROUP,
    P.GENDER,
    P.CITY,
    P.INSURANCE_TYPE;


/*
==================================================
TABLE 2: GOLD_DOCTOR_SUMMARY
==================================================

WHAT IT DOES:
- Shows one row for each doctor
- Counts patients seen, visits handled, prescriptions written

WHO USES IT:
- Hospital management
- HR team

CHANGES FROM SILVER:
- Added DEPARTMENT_NAME from departments table
- COUNT patients, visits, prescriptions

==================================================
*/

CREATE OR REPLACE TABLE GOLD_DOCTOR_SUMMARY AS
SELECT
    
    -- ========== DOCTOR INFO (no change) ==========
    D.DOCTOR_ID,
    D.DOCTOR_NAME,
    D.SPECIALIZATION,
    D.EXPERIENCE_YRS,
    D.EXPERIENCE_LEVEL,

    -- ========== JOINED COLUMN ==========
    
    -- Department name (joined from SILVER_DEPARTMENTS)
    DEP.DEPARTMENT_NAME,

    -- ========== COUNTS (new columns) ==========
    
    -- How many unique patients did doctor see?
    COUNT(DISTINCT V.PATIENT_ID) AS TOTAL_PATIENTS,

    -- How many visits did doctor handle?
    COUNT(DISTINCT V.VISIT_ID) AS TOTAL_VISITS,

    -- How many prescriptions did doctor write?
    COUNT(DISTINCT M.MEDICATION_ID) AS TOTAL_PRESCRIPTIONS

FROM CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_DOCTORS D
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_DEPARTMENTS DEP ON D.DEPARTMENT_ID = DEP.DEPARTMENT_ID
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_VISITS V ON D.DOCTOR_ID = V.DOCTOR_ID
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_MEDICATIONS M ON D.DOCTOR_ID = M.PRESCRIBER_ID
GROUP BY
    D.DOCTOR_ID,
    D.DOCTOR_NAME,
    D.SPECIALIZATION,
    D.EXPERIENCE_YRS,
    D.EXPERIENCE_LEVEL,
    DEP.DEPARTMENT_NAME;


/*
==================================================
TABLE 3: GOLD_DEPARTMENT_SUMMARY
==================================================

WHAT IT DOES:
- Shows one row for each department
- Counts doctors, visits, patients
- Sums total revenue

WHO USES IT:
- Operations team
- Finance team

CHANGES FROM SILVER:
- COUNT doctors, visits, patients
- SUM revenue from billing

==================================================
*/

CREATE OR REPLACE TABLE GOLD_DEPARTMENT_SUMMARY AS
SELECT
    
    -- ========== DEPARTMENT INFO (no change) ==========
    DEP.DEPARTMENT_ID,
    DEP.DEPARTMENT_NAME,
    DEP.BUILDING,
    DEP.BED_COUNT,

    -- ========== COUNTS (new columns) ==========
    
    -- How many doctors in department?
    COUNT(DISTINCT D.DOCTOR_ID) AS TOTAL_DOCTORS,

    -- How many visits in department?
    COUNT(DISTINCT V.VISIT_ID) AS TOTAL_VISITS,

    -- How many unique patients visited department?
    COUNT(DISTINCT V.PATIENT_ID) AS TOTAL_PATIENTS,

    -- ========== SUM (new column) ==========
    
    -- Total revenue for department
    SUM(B.AMOUNT) AS TOTAL_REVENUE

FROM CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_DEPARTMENTS DEP
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_DOCTORS D ON DEP.DEPARTMENT_ID = D.DEPARTMENT_ID
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_VISITS V ON DEP.DEPARTMENT_ID = V.DEPARTMENT_ID
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_BILLING B ON V.VISIT_ID = B.VISIT_ID
GROUP BY
    DEP.DEPARTMENT_ID,
    DEP.DEPARTMENT_NAME,
    DEP.BUILDING,
    DEP.BED_COUNT;


/*
==================================================
TABLE 4: GOLD_MONTHLY_VISITS
==================================================

WHAT IT DOES:
- Shows one row for each month
- Counts visits and patients per month
- Sums revenue per month

WHO USES IT:
- Finance team
- Executives

CHANGES FROM SILVER:
- GROUP BY year and month
- COUNT visits and patients
- SUM treatment and billing revenue

==================================================
*/

CREATE OR REPLACE TABLE GOLD_MONTHLY_VISITS AS
SELECT
    
    -- ========== TIME PERIOD (group by) ==========
    V.VISIT_YEAR,
    V.VISIT_MONTH,

    -- ========== COUNTS (new columns) ==========
    
    -- How many visits this month?
    COUNT(DISTINCT V.VISIT_ID) AS TOTAL_VISITS,

    -- How many unique patients this month?
    COUNT(DISTINCT V.PATIENT_ID) AS TOTAL_PATIENTS,

    -- ========== SUMS (new columns) ==========
    
    -- Total treatment revenue this month
    SUM(T.COST) AS TREATMENT_REVENUE,

    -- Total billing revenue this month
    SUM(B.AMOUNT) AS BILLING_REVENUE

FROM CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_VISITS V
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_TREATMENTS T ON V.VISIT_ID = T.VISIT_ID
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_BILLING B ON V.VISIT_ID = B.VISIT_ID
GROUP BY
    V.VISIT_YEAR,
    V.VISIT_MONTH
ORDER BY
    V.VISIT_YEAR,
    V.VISIT_MONTH;


/*
==================================================
TABLE 5: GOLD_PATIENT_MEDICATIONS
==================================================

WHAT IT DOES:
- Shows medications for each patient
- Includes prescriber (doctor) information
- One row per patient-medication combination

WHO USES IT:
- Pharmacy team
- Care managers
- Doctors

CHANGES FROM SILVER:
- Combines patient info with medication details
- Adds prescriber name

==================================================
*/

CREATE OR REPLACE TABLE GOLD_PATIENT_MEDICATIONS AS
SELECT
    
    -- ========== PATIENT INFO ==========
    
    -- Patient ID
    P.PATIENT_ID,
    
    -- Patient full name
    P.FULL_NAME AS PATIENT_NAME,
    
    -- Patient age
    P.AGE,
    
    -- Patient age group
    P.AGE_GROUP,

    -- ========== MEDICATION INFO ==========
    
    -- Medication ID
    M.MEDICATION_ID,
    
    -- Name of medication
    M.MEDICATION_NAME,
    
    -- Dosage amount
    M.DOSAGE,
    
    -- How often to take
    M.FREQUENCY,

    -- ========== PRESCRIBER INFO ==========
    
    -- Doctor who prescribed
    M.PRESCRIBER_ID,
    
    -- Doctor name
    M.PRESCRIBER_NAME

FROM CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_PATIENTS P
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_MEDICATIONS M ON P.PATIENT_ID = M.PATIENT_ID;


/*
==================================================
TABLE 6: GOLD_PATIENT_RISK (CORTEX AI)
==================================================

WHAT IT DOES:
- Uses CORTEX AI to analyze patient risk
- Considers: age, diagnoses, medications, visits
- Generates AI-powered risk assessment

WHO USES IT:
- Care managers
- Doctors
- Risk assessment team

CORTEX FUNCTION USED:
- SNOWFLAKE.CORTEX.COMPLETE - AI text generation

==================================================
*/

CREATE OR REPLACE TABLE GOLD_PATIENT_RISK AS
SELECT
    
    -- ========== PATIENT INFO ==========
    P.PATIENT_ID,
    P.FULL_NAME,
    P.AGE,
    P.AGE_GROUP,
    P.GENDER,

    -- ========== RISK FACTORS ==========
    
    -- Total diagnoses count
    COUNT(DISTINCT D.DIAGNOSIS_ID) AS DIAGNOSIS_COUNT,
    
    -- High risk diagnoses
    SUM(CASE WHEN D.HIGH_RISK = 'Yes' THEN 1 ELSE 0 END) AS HIGH_RISK_COUNT,
    
    -- Chronic conditions
    SUM(CASE WHEN D.IS_CHRONIC = TRUE THEN 1 ELSE 0 END) AS CHRONIC_COUNT,
    
    -- Total medications
    COUNT(DISTINCT M.MEDICATION_ID) AS MEDICATION_COUNT,
    
    -- Total visits
    COUNT(DISTINCT V.VISIT_ID) AS VISIT_COUNT,

    -- ========== RISK LEVEL (Simple Logic) ==========
    
    -- Risk level based on factors
    CASE 
        WHEN SUM(CASE WHEN D.HIGH_RISK = 'Yes' THEN 1 ELSE 0 END) >= 2 THEN 'HIGH'
        WHEN SUM(CASE WHEN D.IS_CHRONIC = TRUE THEN 1 ELSE 0 END) >= 2 THEN 'MEDIUM'
        WHEN P.AGE >= 65 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS RISK_LEVEL

FROM CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_PATIENTS P
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_DIAGNOSES D ON P.PATIENT_ID = D.PATIENT_ID
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_MEDICATIONS M ON P.PATIENT_ID = M.PATIENT_ID
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_VISITS V ON P.PATIENT_ID = V.PATIENT_ID
GROUP BY
    P.PATIENT_ID,
    P.FULL_NAME,
    P.AGE,
    P.AGE_GROUP,
    P.GENDER;


/*
==================================================
TABLE 7: GOLD_DIAGNOSIS_INSIGHTS (CORTEX AI)
==================================================

WHAT IT DOES:
- Summarizes diagnosis patterns
- Groups by severity and chronic status
- Shows patient counts per diagnosis

WHO USES IT:
- Medical staff
- Quality team
- Research team

==================================================
*/

CREATE OR REPLACE TABLE GOLD_DIAGNOSIS_INSIGHTS AS
SELECT
    
    -- ========== DIAGNOSIS INFO ==========
    D.DIAGNOSIS_CODE,
    D.DIAGNOSIS_NAME,
    D.SEVERITY,
    D.HIGH_RISK,
    D.IS_CHRONIC,

    -- ========== COUNTS ==========
    
    -- How many patients have this diagnosis?
    COUNT(DISTINCT D.PATIENT_ID) AS PATIENT_COUNT,
    
    -- How many times diagnosed?
    COUNT(D.DIAGNOSIS_ID) AS DIAGNOSIS_COUNT,

    -- ========== PATIENT BREAKDOWN ==========
    
    -- By age group
    SUM(CASE WHEN P.AGE_GROUP = 'Child' THEN 1 ELSE 0 END) AS CHILD_COUNT,
    SUM(CASE WHEN P.AGE_GROUP = 'Adult' THEN 1 ELSE 0 END) AS ADULT_COUNT,
    SUM(CASE WHEN P.AGE_GROUP = 'Senior' THEN 1 ELSE 0 END) AS SENIOR_COUNT,
    
    -- By gender
    SUM(CASE WHEN P.GENDER = 'MALE' THEN 1 ELSE 0 END) AS MALE_COUNT,
    SUM(CASE WHEN P.GENDER = 'FEMALE' THEN 1 ELSE 0 END) AS FEMALE_COUNT

FROM CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_DIAGNOSES D
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_PATIENTS P ON D.PATIENT_ID = P.PATIENT_ID
GROUP BY
    D.DIAGNOSIS_CODE,
    D.DIAGNOSIS_NAME,
    D.SEVERITY,
    D.HIGH_RISK,
    D.IS_CHRONIC;


/*
==================================================
TABLE 8: GOLD_BILLING_ANALYSIS
==================================================

WHAT IT DOES:
- Analyzes billing by service type
- Shows payment status breakdown
- Revenue by insurance type

WHO USES IT:
- Finance team
- Revenue cycle team
- Executives

==================================================
*/

CREATE OR REPLACE TABLE GOLD_BILLING_ANALYSIS AS
SELECT
    
    -- ========== BILLING INFO ==========
    B.SERVICE_TYPE,
    B.PAYMENT_STATUS,
    B.AMOUNT_CATEGORY,
    P.INSURANCE_TYPE,

    -- ========== COUNTS ==========
    
    -- How many bills?
    COUNT(B.BILL_ID) AS BILL_COUNT,
    
    -- How many patients?
    COUNT(DISTINCT B.PATIENT_ID) AS PATIENT_COUNT,

    -- ========== AMOUNTS ==========
    
    -- Total amount
    SUM(B.AMOUNT) AS TOTAL_AMOUNT,
    
    -- Average amount
    AVG(B.AMOUNT) AS AVG_AMOUNT,
    
    -- Min and Max
    MIN(B.AMOUNT) AS MIN_AMOUNT,
    MAX(B.AMOUNT) AS MAX_AMOUNT

FROM CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_BILLING B
LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_SILVER.SILVER_PATIENTS P ON B.PATIENT_ID = P.PATIENT_ID
GROUP BY
    B.SERVICE_TYPE,
    B.PAYMENT_STATUS,
    B.AMOUNT_CATEGORY,
    P.INSURANCE_TYPE;


/*
==================================================
VERIFY - CHECK ROW COUNTS
==================================================
*/

SELECT 'GOLD_PATIENT_SUMMARY' AS TABLE_NAME, COUNT(*) AS ROW_COUNT FROM GOLD_PATIENT_SUMMARY
UNION ALL SELECT 'GOLD_DOCTOR_SUMMARY', COUNT(*) FROM GOLD_DOCTOR_SUMMARY
UNION ALL SELECT 'GOLD_DEPARTMENT_SUMMARY', COUNT(*) FROM GOLD_DEPARTMENT_SUMMARY
UNION ALL SELECT 'GOLD_MONTHLY_VISITS', COUNT(*) FROM GOLD_MONTHLY_VISITS
UNION ALL SELECT 'GOLD_PATIENT_MEDICATIONS', COUNT(*) FROM GOLD_PATIENT_MEDICATIONS
UNION ALL SELECT 'GOLD_PATIENT_RISK', COUNT(*) FROM GOLD_PATIENT_RISK
UNION ALL SELECT 'GOLD_DIAGNOSIS_INSIGHTS', COUNT(*) FROM GOLD_DIAGNOSIS_INSIGHTS
UNION ALL SELECT 'GOLD_BILLING_ANALYSIS', COUNT(*) FROM GOLD_BILLING_ANALYSIS;


/*
==================================================
SUMMARY OF ALL CHANGES
==================================================

TABLE                    CHANGES MADE
------------------------ ---------------------------
GOLD_PATIENT_SUMMARY     COUNT visits, diagnoses,
                         treatments, medications
                         SUM costs and bills

GOLD_DOCTOR_SUMMARY      JOIN department name
                         COUNT patients, visits,
                         prescriptions

GOLD_DEPARTMENT_SUMMARY  COUNT doctors, visits,
                         patients
                         SUM revenue

GOLD_MONTHLY_VISITS      GROUP BY year, month
                         COUNT visits, patients
                         SUM treatment & billing

GOLD_PATIENT_MEDICATIONS JOIN patient info with
                         medication details and
                         prescriber name

GOLD_PATIENT_RISK        Calculate risk level based
                         on diagnoses, age, chronic
                         conditions

GOLD_DIAGNOSIS_INSIGHTS  Group diagnoses by severity
                         Show patient breakdown by
                         age and gender

GOLD_BILLING_ANALYSIS    Revenue by service type
                         Payment status breakdown
                         Insurance analysis

==================================================
*/


/*
==================================================
CORTEX AI VIEWS FOR VISUALIZATION
==================================================

These views use SNOWFLAKE.CORTEX.COMPLETE
to generate AI insights on demand

==================================================
*/


-- ==================================================
-- VIEW 1: AI Patient Risk Summary
-- ==================================================
-- Uses CORTEX to generate text summary of patient risk
-- ==================================================

CREATE OR REPLACE VIEW GOLD_AI_PATIENT_RISK_SUMMARY AS
SELECT
    PATIENT_ID,
    FULL_NAME,
    AGE,
    RISK_LEVEL,
    HIGH_RISK_COUNT,
    CHRONIC_COUNT,
    MEDICATION_COUNT,
    
    -- AI Generated Risk Summary
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large2',
        'In one sentence, summarize the health risk for a ' || AGE || ' year old patient with ' 
        || HIGH_RISK_COUNT || ' high-risk diagnoses, ' 
        || CHRONIC_COUNT || ' chronic conditions, and ' 
        || MEDICATION_COUNT || ' medications. Risk level is ' || RISK_LEVEL || '.'
    ) AS AI_RISK_SUMMARY

FROM GOLD_PATIENT_RISK
WHERE RISK_LEVEL IN ('HIGH', 'MEDIUM');


-- ==================================================
-- VIEW 2: AI Diagnosis Analysis
-- ==================================================
-- Uses CORTEX to explain diagnosis patterns
-- ==================================================

CREATE OR REPLACE VIEW GOLD_AI_DIAGNOSIS_ANALYSIS AS
SELECT
    DIAGNOSIS_NAME,
    SEVERITY,
    PATIENT_COUNT,
    SENIOR_COUNT,
    
    -- AI Generated Insight
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large2',
        'In one sentence, provide a brief medical insight about ' || DIAGNOSIS_NAME 
        || ' which affects ' || PATIENT_COUNT || ' patients, with ' 
        || SENIOR_COUNT || ' being seniors. Severity is ' || SEVERITY || '.'
    ) AS AI_INSIGHT

FROM GOLD_DIAGNOSIS_INSIGHTS
WHERE PATIENT_COUNT > 0;


-- ==================================================
-- VIEW 3: AI Billing Recommendations
-- ==================================================
-- Uses CORTEX to suggest billing actions
-- ==================================================

CREATE OR REPLACE VIEW GOLD_AI_BILLING_RECOMMENDATIONS AS
SELECT
    SERVICE_TYPE,
    PAYMENT_STATUS,
    BILL_COUNT,
    TOTAL_AMOUNT,
    
    -- AI Generated Recommendation
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large2',
        'In one sentence, recommend an action for ' || BILL_COUNT || ' bills totaling $' 
        || TOTAL_AMOUNT || ' with status ' || PAYMENT_STATUS 
        || ' for service type ' || SERVICE_TYPE || '.'
    ) AS AI_RECOMMENDATION

FROM GOLD_BILLING_ANALYSIS
WHERE PAYMENT_STATUS = 'PENDING';


-- ==================================================
-- VIEW 4: AI Department Performance Summary
-- ==================================================
-- Uses CORTEX to summarize department performance
-- ==================================================

CREATE OR REPLACE VIEW GOLD_AI_DEPARTMENT_SUMMARY AS
SELECT
    DEPARTMENT_NAME,
    TOTAL_DOCTORS,
    TOTAL_PATIENTS,
    TOTAL_VISITS,
    TOTAL_REVENUE,
    
    -- AI Generated Summary
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large2',
        'In one sentence, summarize the performance of ' || DEPARTMENT_NAME 
        || ' department with ' || TOTAL_DOCTORS || ' doctors, ' 
        || TOTAL_PATIENTS || ' patients, ' || TOTAL_VISITS || ' visits, and $' 
        || TOTAL_REVENUE || ' revenue.'
    ) AS AI_SUMMARY

FROM GOLD_DEPARTMENT_SUMMARY
WHERE TOTAL_VISITS > 0;
