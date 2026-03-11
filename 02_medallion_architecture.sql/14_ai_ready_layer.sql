/*
==================================================
CAREVIEW - AI READY LAYER
==================================================

PURPOSE: AI-enhanced views using CORTEX functions

VIEWS CREATED:
1. AI_PATIENT_SUMMARY     - AI summary for each patient
2. AI_PATIENT_RISK        - AI risk assessment
3. AI_DIAGNOSIS_INSIGHTS  - AI insights on diagnoses
4. AI_BILLING_SUMMARY     - AI billing recommendations
5. AI_DEPARTMENT_SUMMARY  - AI department performance

==================================================
*/

USE ROLE ACCOUNTADMIN;
USE DATABASE CAREVIEW_DB;
USE SCHEMA CAREVIEW_SCH_AI_READY;


/*
==================================================
VIEW 1: AI_PATIENT_SUMMARY
==================================================

WHAT IT DOES:
- Generates AI summary for each patient
- Uses patient visits, treatments, billing data

CORTEX FUNCTION: COMPLETE

==================================================
*/

CREATE OR REPLACE VIEW AI_PATIENT_SUMMARY AS
SELECT
    P.PATIENT_ID,
    P.FULL_NAME,
    P.AGE,
    P.AGE_GROUP,
    P.GENDER,
    P.CITY,
    P.INSURANCE_TYPE,
    P.TOTAL_VISITS,
    P.TOTAL_DIAGNOSES,
    P.TOTAL_TREATMENTS,
    P.TOTAL_MEDICATIONS,
    P.TOTAL_TREATMENT_COST,
    P.TOTAL_BILLED,
    
    -- AI Generated Summary
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large2',
        'In 2 sentences, summarize this patient: ' 
        || P.FULL_NAME || ', age ' || P.AGE 
        || ', ' || P.GENDER || ', from ' || P.CITY
        || '. Has ' || P.TOTAL_VISITS || ' visits, '
        || P.TOTAL_DIAGNOSES || ' diagnoses, '
        || P.TOTAL_MEDICATIONS || ' medications. '
        || 'Total billed: $' || P.TOTAL_BILLED || '.'
    ) AS AI_SUMMARY

FROM CAREVIEW_DB.CAREVIEW_SCH_GOLD.GOLD_PATIENT_SUMMARY P;


/*
==================================================
VIEW 2: AI_PATIENT_RISK
==================================================

WHAT IT DOES:
- Generates AI risk assessment
- Based on diagnoses and chronic conditions

CORTEX FUNCTION: COMPLETE

==================================================
*/

CREATE OR REPLACE VIEW AI_PATIENT_RISK AS
SELECT
    R.PATIENT_ID,
    R.FULL_NAME,
    R.AGE,
    R.AGE_GROUP,
    R.GENDER,
    R.DIAGNOSIS_COUNT,
    R.HIGH_RISK_COUNT,
    R.CHRONIC_COUNT,
    R.MEDICATION_COUNT,
    R.VISIT_COUNT,
    R.RISK_LEVEL,
    
    -- AI Generated Risk Assessment
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large2',
        'In 2 sentences, assess health risk for: '
        || R.FULL_NAME || ', age ' || R.AGE
        || '. Has ' || R.HIGH_RISK_COUNT || ' high-risk diagnoses, '
        || R.CHRONIC_COUNT || ' chronic conditions, '
        || R.MEDICATION_COUNT || ' medications. '
        || 'Current risk level: ' || R.RISK_LEVEL || '.'
    ) AS AI_RISK_ASSESSMENT

FROM CAREVIEW_DB.CAREVIEW_SCH_GOLD.GOLD_PATIENT_RISK R;


/*
==================================================
VIEW 3: AI_DIAGNOSIS_INSIGHTS
==================================================

WHAT IT DOES:
- Generates AI insights on diagnosis patterns
- Shows patient demographics affected

CORTEX FUNCTION: COMPLETE

==================================================
*/

CREATE OR REPLACE VIEW AI_DIAGNOSIS_INSIGHTS AS
SELECT
    D.DIAGNOSIS_CODE,
    D.DIAGNOSIS_NAME,
    D.SEVERITY,
    D.HIGH_RISK,
    D.IS_CHRONIC,
    D.PATIENT_COUNT,
    D.CHILD_COUNT,
    D.ADULT_COUNT,
    D.SENIOR_COUNT,
    
    -- AI Generated Insight
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large2',
        'In 2 sentences, provide insight about '
        || D.DIAGNOSIS_NAME || ' (severity: ' || D.SEVERITY || '). '
        || 'Affects ' || D.PATIENT_COUNT || ' patients: '
        || D.CHILD_COUNT || ' children, '
        || D.ADULT_COUNT || ' adults, '
        || D.SENIOR_COUNT || ' seniors.'
    ) AS AI_INSIGHT

FROM CAREVIEW_DB.CAREVIEW_SCH_GOLD.GOLD_DIAGNOSIS_INSIGHTS D
WHERE D.PATIENT_COUNT > 0;


/*
==================================================
VIEW 4: AI_BILLING_SUMMARY
==================================================

WHAT IT DOES:
- Generates AI recommendations for billing
- Focus on pending payments

CORTEX FUNCTION: COMPLETE

==================================================
*/

CREATE OR REPLACE VIEW AI_BILLING_SUMMARY AS
SELECT
    B.SERVICE_TYPE,
    B.PAYMENT_STATUS,
    B.AMOUNT_CATEGORY,
    B.INSURANCE_TYPE,
    B.BILL_COUNT,
    B.PATIENT_COUNT,
    B.TOTAL_AMOUNT,
    B.AVG_AMOUNT,
    
    -- AI Generated Recommendation
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large2',
        'In 2 sentences, recommend action for: '
        || B.BILL_COUNT || ' bills totaling $' || B.TOTAL_AMOUNT
        || '. Service: ' || B.SERVICE_TYPE
        || ', Status: ' || B.PAYMENT_STATUS
        || ', Insurance: ' || B.INSURANCE_TYPE || '.'
    ) AS AI_RECOMMENDATION

FROM CAREVIEW_DB.CAREVIEW_SCH_GOLD.GOLD_BILLING_ANALYSIS B;


/*
==================================================
VIEW 5: AI_DEPARTMENT_SUMMARY
==================================================

WHAT IT DOES:
- Generates AI performance summary
- For each department

CORTEX FUNCTION: COMPLETE

==================================================
*/

CREATE OR REPLACE VIEW AI_DEPARTMENT_SUMMARY AS
SELECT
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME,
    D.BUILDING,
    D.BED_COUNT,
    D.TOTAL_DOCTORS,
    D.TOTAL_VISITS,
    D.TOTAL_PATIENTS,
    D.TOTAL_REVENUE,
    
    -- AI Generated Summary
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large2',
        'In 2 sentences, summarize performance of '
        || D.DEPARTMENT_NAME || ' department. '
        || 'Has ' || D.TOTAL_DOCTORS || ' doctors, '
        || D.BED_COUNT || ' beds, '
        || D.TOTAL_PATIENTS || ' patients, '
        || D.TOTAL_VISITS || ' visits. '
        || 'Revenue: $' || D.TOTAL_REVENUE || '.'
    ) AS AI_SUMMARY

FROM CAREVIEW_DB.CAREVIEW_SCH_GOLD.GOLD_DEPARTMENT_SUMMARY D;


/*
==================================================
VIEW 6: AI_DOCTOR_PERFORMANCE
==================================================

WHAT IT DOES:
- Generates AI performance summary
- For each doctor

CORTEX FUNCTION: COMPLETE

==================================================
*/

CREATE OR REPLACE VIEW AI_DOCTOR_PERFORMANCE AS
SELECT
    D.DOCTOR_ID,
    D.DOCTOR_NAME,
    D.SPECIALIZATION,
    D.EXPERIENCE_LEVEL,
    D.DEPARTMENT_NAME,
    D.TOTAL_PATIENTS,
    D.TOTAL_VISITS,
    D.TOTAL_PRESCRIPTIONS,
    
    -- AI Generated Summary
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large2',
        'In 2 sentences, summarize performance of Dr. '
        || D.DOCTOR_NAME || ' (' || D.SPECIALIZATION || '). '
        || 'Experience: ' || D.EXPERIENCE_LEVEL
        || ', Patients: ' || D.TOTAL_PATIENTS
        || ', Visits: ' || D.TOTAL_VISITS
        || ', Prescriptions: ' || D.TOTAL_PRESCRIPTIONS || '.'
    ) AS AI_SUMMARY

FROM CAREVIEW_DB.CAREVIEW_SCH_GOLD.GOLD_DOCTOR_SUMMARY D;


/*
==================================================
VERIFY - LIST ALL VIEWS
==================================================
*/

SHOW VIEWS IN SCHEMA CAREVIEW_DB.CAREVIEW_SCH_AI_READY;


/*
==================================================
SAMPLE QUERIES
==================================================

-- Get AI summary for a patient:
SELECT * FROM AI_PATIENT_SUMMARY WHERE PATIENT_ID = 1;

-- Get high risk patients:
SELECT * FROM AI_PATIENT_RISK WHERE RISK_LEVEL = 'HIGH';

-- Get diagnosis insights:
SELECT * FROM AI_DIAGNOSIS_INSIGHTS WHERE SEVERITY = 'SEVERE';

-- Get pending billing recommendations:
SELECT * FROM AI_BILLING_SUMMARY WHERE PAYMENT_STATUS = 'PENDING';

-- Get department performance:
SELECT * FROM AI_DEPARTMENT_SUMMARY;

-- Get doctor performance:
SELECT * FROM AI_DOCTOR_PERFORMANCE;

==================================================
*/

SELECT * FROM AI_PATIENT_RISK;

SELECT *
FROM CAREVIEW_DB.GOLD.PATIENT_SUMMARY
LIMIT 10;


SHOW QUERIES;