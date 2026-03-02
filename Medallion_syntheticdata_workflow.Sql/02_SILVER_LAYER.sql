/*
================================================================================
CAREVIEW - SILVER LAYER (Cleansed Data)
================================================================================
Purpose: Validated, standardized, and transformed data
Transformations: Text normalization, null filtering, calculated fields
Run As: CAREVIEW_ADMIN or CAREVIEW_ANALYST
================================================================================
*/

-- ============================================================================
-- 1. SILVER PATIENTS - Cleansed patient data with calculated age 
-- ============================================================================
CREATE OR REPLACE TABLE CAREVIEW_DB.SILVER.PATIENTS AS
SELECT 
    PATIENT_ID,
    INITCAP(TRIM(FIRST_NAME)) AS FIRST_NAME,
    INITCAP(TRIM(LAST_NAME)) AS LAST_NAME,
    DATE_OF_BIRTH,
    DATEDIFF('YEAR', DATE_OF_BIRTH, CURRENT_DATE()) AS AGE,
    UPPER(TRIM(GENDER)) AS GENDER,
    UPPER(TRIM(BLOOD_TYPE)) AS BLOOD_TYPE,
    PHONE_NUMBER,
    REGISTRATION_DATE
FROM CAREVIEW_DB.BRONZE.PATIENTS
WHERE PATIENT_ID IS NOT NULL;

-- ============================================================================
-- 2. SILVER VISITS - Cleansed visits with length of stay calculation
-- ============================================================================
CREATE OR REPLACE TABLE CAREVIEW_DB.SILVER.VISITS AS
SELECT 
    V.VISIT_ID,
    V.PATIENT_ID,
    V.VISIT_DATE,
    UPPER(TRIM(V.DEPARTMENT)) AS DEPARTMENT,
    UPPER(TRIM(V.VISIT_TYPE)) AS VISIT_TYPE,
    INITCAP(V.DOCTOR_NAME) AS DOCTOR_NAME,
    V.DISCHARGE_DATE,
    CASE 
        WHEN V.DISCHARGE_DATE IS NOT NULL 
        THEN DATEDIFF('DAY', V.VISIT_DATE, V.DISCHARGE_DATE)
        ELSE 0 
    END AS LENGTH_OF_STAY_DAYS,
    TRIM(V.VISIT_NOTES) AS VISIT_NOTES
FROM CAREVIEW_DB.BRONZE.VISITS V
INNER JOIN CAREVIEW_DB.BRONZE.PATIENTS P ON V.PATIENT_ID = P.PATIENT_ID
WHERE V.VISIT_ID IS NOT NULL;

-- ============================================================================
-- 3. SILVER DIAGNOSES - Cleansed diagnosis with severity scoring
-- ============================================================================
CREATE OR REPLACE TABLE CAREVIEW_DB.SILVER.DIAGNOSES AS
SELECT 
    D.DIAGNOSIS_ID,
    D.VISIT_ID,
    D.PATIENT_ID,
    UPPER(TRIM(D.DIAGNOSIS_CODE)) AS DIAGNOSIS_CODE,
    INITCAP(TRIM(D.DIAGNOSIS_NAME)) AS DIAGNOSIS_NAME,
    CASE UPPER(TRIM(D.SEVERITY))
        WHEN 'MILD' THEN 1
        WHEN 'MODERATE' THEN 2
        WHEN 'SEVERE' THEN 3
        WHEN 'CRITICAL' THEN 4
        ELSE 0
    END AS SEVERITY_LEVEL,
    UPPER(TRIM(D.SEVERITY)) AS SEVERITY_TEXT,
    D.DIAGNOSIS_DATE
FROM CAREVIEW_DB.BRONZE.DIAGNOSES D
INNER JOIN CAREVIEW_DB.BRONZE.VISITS V ON D.VISIT_ID = V.VISIT_ID
WHERE D.DIAGNOSIS_ID IS NOT NULL;

-- ============================================================================
-- 4. SILVER TREATMENTS - Cleansed treatment with outcome status
-- ============================================================================
CREATE OR REPLACE TABLE CAREVIEW_DB.SILVER.TREATMENTS AS
SELECT 
    T.TREATMENT_ID,
    T.VISIT_ID,
    T.PATIENT_ID,
    INITCAP(TRIM(T.TREATMENT_NAME)) AS TREATMENT_NAME,
    UPPER(TRIM(T.TREATMENT_TYPE)) AS TREATMENT_TYPE,
    T.TREATMENT_DATE,
    INITCAP(T.DOCTOR_NAME) AS DOCTOR_NAME,
    CASE UPPER(TRIM(T.OUTCOME))
        WHEN 'SUCCESSFUL' THEN 'COMPLETED'
        WHEN 'ONGOING' THEN 'IN_PROGRESS'
        WHEN 'COMPLICATIONS' THEN 'NEEDS_REVIEW'
        ELSE 'UNKNOWN'
    END AS OUTCOME_STATUS
FROM CAREVIEW_DB.BRONZE.TREATMENTS T
INNER JOIN CAREVIEW_DB.BRONZE.VISITS V ON T.VISIT_ID = V.VISIT_ID
WHERE T.TREATMENT_ID IS NOT NULL;

-- ============================================================================
-- 5. SILVER BILLING - Cleansed billing with payment categorization
-- ============================================================================
CREATE OR REPLACE TABLE CAREVIEW_DB.SILVER.BILLING AS
SELECT 
    B.BILL_ID,
    B.VISIT_ID,
    B.PATIENT_ID,
    INITCAP(TRIM(B.SERVICE_NAME)) AS SERVICE_NAME,
    B.AMOUNT,
    UPPER(TRIM(B.PAYMENT_STATUS)) AS PAYMENT_STATUS,
    CASE UPPER(TRIM(B.PAYMENT_STATUS))
        WHEN 'PAID' THEN 'RESOLVED'
        WHEN 'INSURANCE' THEN 'PROCESSING'
        WHEN 'PENDING' THEN 'OUTSTANDING'
        WHEN 'DENIED' THEN 'DISPUTED'
        ELSE 'UNKNOWN'
    END AS PAYMENT_CATEGORY,
    B.BILL_DATE,
    UPPER(TRIM(B.DEPARTMENT)) AS DEPARTMENT
FROM CAREVIEW_DB.BRONZE.BILLING B
INNER JOIN CAREVIEW_DB.BRONZE.VISITS V ON B.VISIT_ID = V.VISIT_ID
WHERE B.BILL_ID IS NOT NULL;
