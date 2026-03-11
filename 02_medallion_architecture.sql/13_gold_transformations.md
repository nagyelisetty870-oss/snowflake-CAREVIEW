# Gold Layer Transformations

## Overview

Gold layer contains **business-ready aggregated data** with **CORTEX AI insights**.

---

## Tables Created

| Table | What It Shows | One Row Per |
|-------|---------------|-------------|
| GOLD_PATIENT_SUMMARY | Patient totals | Patient |
| GOLD_DOCTOR_SUMMARY | Doctor workload | Doctor |
| GOLD_DEPARTMENT_SUMMARY | Department stats | Department |
| GOLD_MONTHLY_VISITS | Monthly trends | Month |
| GOLD_PATIENT_MEDICATIONS | Medications | Patient-Medication |
| GOLD_PATIENT_RISK | Risk analysis | Patient |
| GOLD_DIAGNOSIS_INSIGHTS | Diagnosis patterns | Diagnosis |
| GOLD_BILLING_ANALYSIS | Revenue analysis | Service-Status |

---

## CORTEX AI Views

| View | What It Does | Cortex Function |
|------|--------------|-----------------|
| GOLD_AI_PATIENT_RISK_SUMMARY | AI risk summary for patients | COMPLETE |
| GOLD_AI_DIAGNOSIS_ANALYSIS | AI insights on diagnoses | COMPLETE |
| GOLD_AI_BILLING_RECOMMENDATIONS | AI billing actions | COMPLETE |
| GOLD_AI_DEPARTMENT_SUMMARY | AI department performance | COMPLETE |

---

## Table 1: GOLD_PATIENT_SUMMARY

### What It Does
One row per patient with all totals.

### Who Uses It
Care managers, patient services

### Columns

| Column | Source | How |
|--------|--------|-----|
| PATIENT_ID | SILVER_PATIENTS | Direct |
| FULL_NAME | SILVER_PATIENTS | Direct |
| AGE, AGE_GROUP, GENDER | SILVER_PATIENTS | Direct |
| CITY, INSURANCE_TYPE | SILVER_PATIENTS | Direct |
| TOTAL_VISITS | SILVER_VISITS | COUNT |
| TOTAL_DIAGNOSES | SILVER_DIAGNOSES | COUNT |
| TOTAL_TREATMENTS | SILVER_TREATMENTS | COUNT |
| TOTAL_TREATMENT_COST | SILVER_TREATMENTS | SUM |
| TOTAL_MEDICATIONS | SILVER_MEDICATIONS | COUNT |
| TOTAL_BILLED | SILVER_BILLING | SUM |

---

## Table 2: GOLD_DOCTOR_SUMMARY

### What It Does
One row per doctor with workload.

### Who Uses It
Hospital management, HR

### Columns

| Column | Source | How |
|--------|--------|-----|
| DOCTOR_ID, DOCTOR_NAME | SILVER_DOCTORS | Direct |
| SPECIALIZATION | SILVER_DOCTORS | Direct |
| EXPERIENCE_YRS, EXPERIENCE_LEVEL | SILVER_DOCTORS | Direct |
| DEPARTMENT_NAME | SILVER_DEPARTMENTS | JOIN |
| TOTAL_PATIENTS | SILVER_VISITS | COUNT DISTINCT |
| TOTAL_VISITS | SILVER_VISITS | COUNT |
| TOTAL_PRESCRIPTIONS | SILVER_MEDICATIONS | COUNT |

---

## Table 3: GOLD_DEPARTMENT_SUMMARY

### What It Does
One row per department with performance.

### Who Uses It
Operations, finance

### Columns

| Column | Source | How |
|--------|--------|-----|
| DEPARTMENT_ID, DEPARTMENT_NAME | SILVER_DEPARTMENTS | Direct |
| BUILDING, BED_COUNT | SILVER_DEPARTMENTS | Direct |
| TOTAL_DOCTORS | SILVER_DOCTORS | COUNT |
| TOTAL_VISITS | SILVER_VISITS | COUNT |
| TOTAL_PATIENTS | SILVER_VISITS | COUNT DISTINCT |
| TOTAL_REVENUE | SILVER_BILLING | SUM |

---

## Table 4: GOLD_MONTHLY_VISITS

### What It Does
One row per month with trends.

### Who Uses It
Finance, executives

### Columns

| Column | Source | How |
|--------|--------|-----|
| VISIT_YEAR | SILVER_VISITS | GROUP BY |
| VISIT_MONTH | SILVER_VISITS | GROUP BY |
| TOTAL_VISITS | SILVER_VISITS | COUNT |
| TOTAL_PATIENTS | SILVER_VISITS | COUNT DISTINCT |
| TREATMENT_REVENUE | SILVER_TREATMENTS | SUM |
| BILLING_REVENUE | SILVER_BILLING | SUM |

---

## Table 5: GOLD_PATIENT_MEDICATIONS

### What It Does
Medications for each patient with prescriber info.

### Who Uses It
Pharmacy, care managers

### Columns

| Column | Source | How |
|--------|--------|-----|
| PATIENT_ID, PATIENT_NAME | SILVER_PATIENTS | Direct |
| AGE, AGE_GROUP | SILVER_PATIENTS | Direct |
| MEDICATION_ID, MEDICATION_NAME | SILVER_MEDICATIONS | Direct |
| DOSAGE, FREQUENCY | SILVER_MEDICATIONS | Direct |
| PRESCRIBER_ID, PRESCRIBER_NAME | SILVER_MEDICATIONS | Direct |

---

## Table 6: GOLD_PATIENT_RISK

### What It Does
Risk analysis for each patient.

### Who Uses It
Care managers, doctors, risk team

### Columns

| Column | Source | How |
|--------|--------|-----|
| PATIENT_ID, FULL_NAME | SILVER_PATIENTS | Direct |
| AGE, AGE_GROUP, GENDER | SILVER_PATIENTS | Direct |
| DIAGNOSIS_COUNT | SILVER_DIAGNOSES | COUNT |
| HIGH_RISK_COUNT | SILVER_DIAGNOSES | SUM(HIGH_RISK='Yes') |
| CHRONIC_COUNT | SILVER_DIAGNOSES | SUM(IS_CHRONIC=TRUE) |
| MEDICATION_COUNT | SILVER_MEDICATIONS | COUNT |
| VISIT_COUNT | SILVER_VISITS | COUNT |
| RISK_LEVEL | Calculated | CASE statement |

### Risk Level Logic

| Condition | Risk Level |
|-----------|------------|
| HIGH_RISK_COUNT >= 2 | HIGH |
| CHRONIC_COUNT >= 2 | MEDIUM |
| AGE >= 65 | MEDIUM |
| Otherwise | LOW |

---

## Table 7: GOLD_DIAGNOSIS_INSIGHTS

### What It Does
Diagnosis patterns with patient breakdown.

### Who Uses It
Medical staff, quality team

### Columns

| Column | Source | How |
|--------|--------|-----|
| DIAGNOSIS_CODE, DIAGNOSIS_NAME | SILVER_DIAGNOSES | Direct |
| SEVERITY, HIGH_RISK, IS_CHRONIC | SILVER_DIAGNOSES | Direct |
| PATIENT_COUNT | SILVER_DIAGNOSES | COUNT DISTINCT |
| DIAGNOSIS_COUNT | SILVER_DIAGNOSES | COUNT |
| CHILD_COUNT | SILVER_PATIENTS | SUM(AGE_GROUP='Child') |
| ADULT_COUNT | SILVER_PATIENTS | SUM(AGE_GROUP='Adult') |
| SENIOR_COUNT | SILVER_PATIENTS | SUM(AGE_GROUP='Senior') |
| MALE_COUNT | SILVER_PATIENTS | SUM(GENDER='MALE') |
| FEMALE_COUNT | SILVER_PATIENTS | SUM(GENDER='FEMALE') |

---

## Table 8: GOLD_BILLING_ANALYSIS

### What It Does
Revenue analysis by service and payment status.

### Who Uses It
Finance, revenue cycle team

### Columns

| Column | Source | How |
|--------|--------|-----|
| SERVICE_TYPE | SILVER_BILLING | GROUP BY |
| PAYMENT_STATUS | SILVER_BILLING | GROUP BY |
| AMOUNT_CATEGORY | SILVER_BILLING | GROUP BY |
| INSURANCE_TYPE | SILVER_PATIENTS | GROUP BY |
| BILL_COUNT | SILVER_BILLING | COUNT |
| PATIENT_COUNT | SILVER_BILLING | COUNT DISTINCT |
| TOTAL_AMOUNT | SILVER_BILLING | SUM |
| AVG_AMOUNT | SILVER_BILLING | AVG |
| MIN_AMOUNT | SILVER_BILLING | MIN |
| MAX_AMOUNT | SILVER_BILLING | MAX |

---

## CORTEX AI Views

### View 1: GOLD_AI_PATIENT_RISK_SUMMARY

**What It Does:** Generates AI text summary of patient risk

**Cortex Function:** `SNOWFLAKE.CORTEX.COMPLETE('mistral-large2', prompt)`

**Prompt:** Summarizes age, high-risk diagnoses, chronic conditions, medications

**Filter:** Only HIGH and MEDIUM risk patients

---

### View 2: GOLD_AI_DIAGNOSIS_ANALYSIS

**What It Does:** Generates AI insights on diagnosis patterns

**Cortex Function:** `SNOWFLAKE.CORTEX.COMPLETE('mistral-large2', prompt)`

**Prompt:** Provides medical insight about diagnosis, patient count, seniors affected

---

### View 3: GOLD_AI_BILLING_RECOMMENDATIONS

**What It Does:** Generates AI recommendations for pending bills

**Cortex Function:** `SNOWFLAKE.CORTEX.COMPLETE('mistral-large2', prompt)`

**Prompt:** Recommends action for pending bills by service type

**Filter:** Only PENDING payment status

---

### View 4: GOLD_AI_DEPARTMENT_SUMMARY

**What It Does:** Generates AI summary of department performance

**Cortex Function:** `SNOWFLAKE.CORTEX.COMPLETE('mistral-large2', prompt)`

**Prompt:** Summarizes doctors, patients, visits, revenue

---

## Business Questions Answered

| Question | Table/View |
|----------|------------|
| How much has a patient spent? | GOLD_PATIENT_SUMMARY |
| How many patients does a doctor see? | GOLD_DOCTOR_SUMMARY |
| Which department has most revenue? | GOLD_DEPARTMENT_SUMMARY |
| How are visits trending monthly? | GOLD_MONTHLY_VISITS |
| What medications is a patient taking? | GOLD_PATIENT_MEDICATIONS |
| Which patients are high risk? | GOLD_PATIENT_RISK |
| What AI summary for a patient's risk? | GOLD_AI_PATIENT_RISK_SUMMARY |
| Which diagnoses affect seniors most? | GOLD_DIAGNOSIS_INSIGHTS |
| What AI insight about a diagnosis? | GOLD_AI_DIAGNOSIS_ANALYSIS |
| How much revenue is pending? | GOLD_BILLING_ANALYSIS |
| What AI action for pending bills? | GOLD_AI_BILLING_RECOMMENDATIONS |
| How is a department performing? | GOLD_AI_DEPARTMENT_SUMMARY |
