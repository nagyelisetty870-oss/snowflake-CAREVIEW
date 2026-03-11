/*
================================================================================
CAREVIEW - SILVER LAYER
================================================================================
PURPOSE: Clean and enrich Bronze data with simple transformations

TRANSFORMATIONS APPLIED:
================================================================================
TABLE              TRANSFORMATION
-----------------  --------------------------------------------------
PATIENTS           TRIM whitespace, UPPER names, FULL_NAME, AGE_GROUP
DOCTORS            TRIM/UPPER names, EXPERIENCE_LEVEL category
DEPARTMENTS        TRIM/UPPER names, no calculation changes
VISITS             TRIM/UPPER text, extract YEAR/MONTH/DAY from date
DIAGNOSES          TRIM/UPPER codes, HIGH_RISK flag, IS_CHRONIC to BOOLEAN
TREATMENTS         TRIM/UPPER names, COST_CATEGORY
MEDICATIONS        TRIM/UPPER names, join to get PRESCRIBER_NAME
BILLING            TRIM/UPPER text, AMOUNT_CATEGORY
================================================================================
*/

USE ROLE ACCOUNTADMIN;
USE DATABASE CAREVIEW_DB;
USE SCHEMA CAREVIEW_SCH_SILVER;

-- ============================================================================
-- TABLE 1: SILVER_PATIENTS
-- Transformations: TRIM, UPPER names, FULL_NAME, AGE_GROUP
-- ============================================================================
CREATE OR REPLACE TABLE SILVER_PATIENTS AS
SELECT
    PATIENT_ID,
    TRIM(FIRST_NAME) AS FIRST_NAME,
    TRIM(LAST_NAME) AS LAST_NAME,
    TRIM(FIRST_NAME) || ' ' || TRIM(LAST_NAME) AS FULL_NAME,
    AGE,
    CASE 
        WHEN AGE < 18 THEN 'Child'
        WHEN AGE < 60 THEN 'Adult'
        ELSE 'Senior'
    END AS AGE_GROUP,
    UPPER(TRIM(GENDER)) AS GENDER,
    UPPER(TRIM(BLOOD_TYPE)) AS BLOOD_TYPE,
    TRIM(PHONE) AS PHONE,
    TRIM(CITY) AS CITY,
    UPPER(TRIM(INSURANCE_TYPE)) AS INSURANCE_TYPE
FROM CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_PATIENTS;

-- ============================================================================
-- TABLE 2: SILVER_DOCTORS
-- Transformations: TRIM, UPPER, EXPERIENCE_LEVEL
-- ============================================================================
CREATE OR REPLACE TABLE SILVER_DOCTORS AS
SELECT
    DOCTOR_ID,
    TRIM(DOCTOR_NAME) AS DOCTOR_NAME,
    UPPER(TRIM(SPECIALIZATION)) AS SPECIALIZATION,
    DEPARTMENT_ID,
    EXPERIENCE_YRS,
    CASE 
        WHEN EXPERIENCE_YRS < 5 THEN 'Junior'
        WHEN EXPERIENCE_YRS < 10 THEN 'Mid-Level'
        ELSE 'Senior'
    END AS EXPERIENCE_LEVEL,
    TRIM(PHONE) AS PHONE
FROM CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_DOCTORS;

-- ============================================================================
-- TABLE 3: SILVER_DEPARTMENTS
-- Transformations: TRIM, UPPER
-- ============================================================================
CREATE OR REPLACE TABLE SILVER_DEPARTMENTS AS
SELECT
    DEPARTMENT_ID,
    UPPER(TRIM(DEPARTMENT_NAME)) AS DEPARTMENT_NAME,
    FLOOR_NUMBER,
    UPPER(TRIM(BUILDING)) AS BUILDING,
    BED_COUNT,
    TRIM(PHONE) AS PHONE
FROM CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_DEPARTMENTS;

-- ============================================================================
-- TABLE 4: SILVER_VISITS
-- Transformations: Join names, extract date parts, TRIM/UPPER text
-- ============================================================================
CREATE OR REPLACE TABLE SILVER_VISITS AS
SELECT
    V.VISIT_ID,
    V.PATIENT_ID,
    P.FULL_NAME AS PATIENT_NAME,
    V.DOCTOR_ID,
    D.DOCTOR_NAME,
    V.DEPARTMENT_ID,
    DEP.DEPARTMENT_NAME,
    V.VISIT_DATE,
    YEAR(V.VISIT_DATE) AS VISIT_YEAR,
    MONTH(V.VISIT_DATE) AS VISIT_MONTH,
    DAY(V.VISIT_DATE) AS VISIT_DAY,
    UPPER(TRIM(V.VISIT_TYPE)) AS VISIT_TYPE,
    TRIM(V.ADMISSION_REASON) AS ADMISSION_REASON,
    UPPER(TRIM(V.STATUS)) AS STATUS
FROM CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_VISITS V
LEFT JOIN SILVER_PATIENTS P ON V.PATIENT_ID = P.PATIENT_ID
LEFT JOIN SILVER_DOCTORS D ON V.DOCTOR_ID = D.DOCTOR_ID
LEFT JOIN SILVER_DEPARTMENTS DEP ON V.DEPARTMENT_ID = DEP.DEPARTMENT_ID;

-- ============================================================================
-- TABLE 5: SILVER_DIAGNOSES
-- Transformations: TRIM/UPPER, HIGH_RISK flag, IS_CHRONIC to BOOLEAN
-- ============================================================================
CREATE OR REPLACE TABLE SILVER_DIAGNOSES AS
SELECT
    DG.DIAGNOSIS_ID,
    DG.PATIENT_ID,
    P.FULL_NAME AS PATIENT_NAME,
    DG.VISIT_ID,
    UPPER(TRIM(DG.DIAGNOSIS_CODE)) AS DIAGNOSIS_CODE,
    TRIM(DG.DIAGNOSIS_NAME) AS DIAGNOSIS_NAME,
    UPPER(TRIM(DG.SEVERITY)) AS SEVERITY,
    CASE 
        WHEN UPPER(TRIM(DG.SEVERITY)) IN ('SEVERE', 'CRITICAL') THEN 'Yes'
        ELSE 'No'
    END AS HIGH_RISK,
    CASE 
        WHEN UPPER(TRIM(DG.IS_CHRONIC)) = 'YES' THEN TRUE
        ELSE FALSE
    END AS IS_CHRONIC
FROM CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_DIAGNOSES DG
LEFT JOIN SILVER_PATIENTS P ON DG.PATIENT_ID = P.PATIENT_ID;

-- ============================================================================
-- TABLE 6: SILVER_TREATMENTS
-- Transformations: TRIM/UPPER, COST_CATEGORY
-- ============================================================================
CREATE OR REPLACE TABLE SILVER_TREATMENTS AS
SELECT
    T.TREATMENT_ID,
    T.VISIT_ID,
    T.PATIENT_ID,
    P.FULL_NAME AS PATIENT_NAME,
    TRIM(T.TREATMENT_NAME) AS TREATMENT_NAME,
    UPPER(TRIM(T.TREATMENT_TYPE)) AS TREATMENT_TYPE,
    UPPER(TRIM(T.OUTCOME)) AS OUTCOME,
    T.COST,
    CASE 
        WHEN T.COST < 1000 THEN 'Low'
        WHEN T.COST < 5000 THEN 'Medium'
        ELSE 'High'
    END AS COST_CATEGORY
FROM CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_TREATMENTS T
LEFT JOIN SILVER_PATIENTS P ON T.PATIENT_ID = P.PATIENT_ID;

-- ============================================================================
-- TABLE 7: SILVER_MEDICATIONS
-- Transformations: TRIM/UPPER, join PRESCRIBER_NAME
-- ============================================================================
CREATE OR REPLACE TABLE SILVER_MEDICATIONS AS
SELECT
    M.MEDICATION_ID,
    M.PATIENT_ID,
    P.FULL_NAME AS PATIENT_NAME,
    TRIM(M.MEDICATION_NAME) AS MEDICATION_NAME,
    UPPER(TRIM(M.DOSAGE)) AS DOSAGE,
    UPPER(TRIM(M.FREQUENCY)) AS FREQUENCY,
    M.PRESCRIBER_ID,
    D.DOCTOR_NAME AS PRESCRIBER_NAME
FROM CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_MEDICATIONS M
LEFT JOIN SILVER_PATIENTS P ON M.PATIENT_ID = P.PATIENT_ID
LEFT JOIN SILVER_DOCTORS D ON M.PRESCRIBER_ID = D.DOCTOR_ID;

-- ============================================================================
-- TABLE 8: SILVER_BILLING
-- Transformations: TRIM/UPPER, AMOUNT_CATEGORY
-- ============================================================================
CREATE OR REPLACE TABLE SILVER_BILLING AS
SELECT
    B.BILL_ID,
    B.VISIT_ID,
    B.PATIENT_ID,
    P.FULL_NAME AS PATIENT_NAME,
    UPPER(TRIM(B.SERVICE_TYPE)) AS SERVICE_TYPE,
    B.AMOUNT,
    CASE 
        WHEN B.AMOUNT < 1000 THEN 'Low'
        WHEN B.AMOUNT < 5000 THEN 'Medium'
        ELSE 'High'
    END AS AMOUNT_CATEGORY,
    UPPER(TRIM(B.PAYMENT_STATUS)) AS PAYMENT_STATUS
FROM CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_BILLING B
LEFT JOIN SILVER_PATIENTS P ON B.PATIENT_ID = P.PATIENT_ID;

-- ============================================================================
-- VERIFY ROW COUNTS
-- ============================================================================
SELECT 'SILVER_PATIENTS' AS TBL, COUNT(*) AS CNT FROM SILVER_PATIENTS
UNION ALL SELECT 'SILVER_DOCTORS', COUNT(*) FROM SILVER_DOCTORS
UNION ALL SELECT 'SILVER_DEPARTMENTS', COUNT(*) FROM SILVER_DEPARTMENTS
UNION ALL SELECT 'SILVER_VISITS', COUNT(*) FROM SILVER_VISITS
UNION ALL SELECT 'SILVER_DIAGNOSES', COUNT(*) FROM SILVER_DIAGNOSES
UNION ALL SELECT 'SILVER_TREATMENTS', COUNT(*) FROM SILVER_TREATMENTS
UNION ALL SELECT 'SILVER_MEDICATIONS', COUNT(*) FROM SILVER_MEDICATIONS
UNION ALL SELECT 'SILVER_BILLING', COUNT(*) FROM SILVER_BILLING;
