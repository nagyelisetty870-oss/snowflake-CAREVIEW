# Silver Layer Transformations

## Overview
Silver layer contains **cleaned and enriched** data from Bronze layer.

**Row counts match Bronze layer** (using LEFT JOINs to preserve all records).

---

## Transformations by Table

### 1. SILVER_PATIENTS
| Column | Transformation |
|--------|----------------|
| FIRST_NAME | TRIM whitespace |
| LAST_NAME | TRIM whitespace |
| FULL_NAME | FIRST_NAME + ' ' + LAST_NAME |
| AGE_GROUP | Categorize by age |
| GENDER | UPPER + TRIM |
| BLOOD_TYPE | UPPER + TRIM |
| INSURANCE_TYPE | UPPER + TRIM |

**Age Groups:**
- Child (< 18)
- Adult (18-59)
- Senior (60+)

---

### 2. SILVER_DOCTORS
| Column | Transformation |
|--------|----------------|
| DOCTOR_NAME | TRIM whitespace |
| SPECIALIZATION | UPPER + TRIM |
| EXPERIENCE_LEVEL | Categorize by years |
| PHONE | TRIM whitespace |

**Experience Levels:**
- Junior (< 5 years)
- Mid-Level (5-9 years)
- Senior (10+ years)

---

### 3. SILVER_DEPARTMENTS
| Column | Transformation |
|--------|----------------|
| DEPARTMENT_NAME | UPPER + TRIM |
| BUILDING | UPPER + TRIM |
| PHONE | TRIM whitespace |

---

### 4. SILVER_VISITS
| Column | Transformation |
|--------|----------------|
| PATIENT_NAME | Join from SILVER_PATIENTS |
| DOCTOR_NAME | Join from SILVER_DOCTORS |
| DEPARTMENT_NAME | Join from SILVER_DEPARTMENTS |
| VISIT_YEAR | YEAR(VISIT_DATE) |
| VISIT_MONTH | MONTH(VISIT_DATE) |
| VISIT_DAY | DAY(VISIT_DATE) |
| VISIT_TYPE | UPPER + TRIM |
| ADMISSION_REASON | TRIM whitespace |
| STATUS | UPPER + TRIM |

---

### 5. SILVER_DIAGNOSES
| Column | Transformation |
|--------|----------------|
| PATIENT_NAME | Join from SILVER_PATIENTS |
| DIAGNOSIS_CODE | UPPER + TRIM |
| DIAGNOSIS_NAME | TRIM whitespace |
| SEVERITY | UPPER + TRIM |
| HIGH_RISK | 'Yes' if SEVERE/CRITICAL, else 'No' |
| IS_CHRONIC | Convert 'Yes'/'No' to TRUE/FALSE |

---

### 6. SILVER_TREATMENTS
| Column | Transformation |
|--------|----------------|
| PATIENT_NAME | Join from SILVER_PATIENTS |
| TREATMENT_NAME | TRIM whitespace |
| TREATMENT_TYPE | UPPER + TRIM |
| OUTCOME | UPPER + TRIM |
| COST_CATEGORY | Categorize by cost |

**Cost Categories:**
- Low (< $1,000)
- Medium ($1,000 - $4,999)
- High ($5,000+)

---

### 7. SILVER_MEDICATIONS
| Column | Transformation |
|--------|----------------|
| PATIENT_NAME | Join from SILVER_PATIENTS |
| MEDICATION_NAME | TRIM whitespace |
| DOSAGE | UPPER + TRIM |
| FREQUENCY | UPPER + TRIM |
| PRESCRIBER_NAME | Join from SILVER_DOCTORS |

---

### 8. SILVER_BILLING
| Column | Transformation |
|--------|----------------|
| PATIENT_NAME | Join from SILVER_PATIENTS |
| SERVICE_TYPE | UPPER + TRIM |
| AMOUNT_CATEGORY | Categorize by amount |
| PAYMENT_STATUS | UPPER + TRIM |

**Amount Categories:**
- Low (< $1,000)
- Medium ($1,000 - $4,999)
- High ($5,000+)

---

## Summary

| Table | Transformations |
|-------|-----------------|
| PATIENTS | TRIM, FULL_NAME, AGE_GROUP |
| DOCTORS | TRIM, EXPERIENCE_LEVEL |
| DEPARTMENTS | TRIM, UPPER |
| VISITS | Join names, extract date parts |
| DIAGNOSES | HIGH_RISK flag, IS_CHRONIC to boolean |
| TREATMENTS | COST_CATEGORY |
| MEDICATIONS | Join PRESCRIBER_NAME |
| BILLING | AMOUNT_CATEGORY |
