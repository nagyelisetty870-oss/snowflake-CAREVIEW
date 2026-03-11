SOURCE SYSTEMS
(EMR | Hospital Management | Billing | Clinical Systems)
        │
        ▼
┌───────────────────────────────────────────────────────────────────────┐
│                         BRONZE LAYER                                  │
│                     Raw Healthcare Data                               │
│                                                                       │
│ Tables:                                                               │
│ BRONZE_PATIENTS | BRONZE_DOCTORS | BRONZE_DEPARTMENTS                 │
│ BRONZE_VISITS | BRONZE_DIAGNOSES | BRONZE_TREATMENTS                  │
│ BRONZE_MEDICATIONS | BRONZE_BILLING                                   │
│                                                                       │
│ Purpose: Raw ingestion of hospital operational data                   │
└───────────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌───────────────────────────────────────────────────────────────────────┐
│                         SILVER LAYER                                  │
│                Cleaned & Standardized Healthcare Data                 │
│                                                                       │
│ Tables:                                                               │
│ SILVER_PATIENTS | SILVER_DOCTORS | SILVER_DEPARTMENTS                 │
│ SILVER_VISITS | SILVER_DIAGNOSES | SILVER_TREATMENTS                  │
│ SILVER_MEDICATIONS | SILVER_BILLING                                   │
│                                                                       │
│ Purpose: Data cleansing, validation, standardization                  │
└───────────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌───────────────────────────────────────────────────────────────────────┐
│                         GOLD LAYER                                    │
│                 Business Analytics & Aggregations                     │
│                                                                       │
│ Tables:                                                               │
│ GOLD_PATIENT_SUMMARY | GOLD_PATIENT_RISK                              │
│ GOLD_MONTHLY_VISITS | GOLD_DOCTOR_SUMMARY                             │
│ GOLD_DEPARTMENT_SUMMARY | GOLD_BILLING_ANALYSIS                       │
│ GOLD_DIAGNOSIS_INSIGHTS | GOLD_PATIENT_MEDICATION                     │
│                                                                       │
│ Purpose: KPI metrics, dashboards, reporting datasets                  │
└───────────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌───────────────────────────────────────────────────────────────────────┐
│                         AI LAYER                                      │
│                Predictive Insights & Advanced Analytics               │
│                                                                       │
│ Views:                                                                │
│ AI_PATIENT_RISK | AI_PATIENT_SUMMARY                                  │
│ AI_DOCTOR_PERFORMANCE | AI_DEPARTMENT_SUMMARY                         │
│ AI_BILLING_SUMMARY | AI_DIAGNOSIS_INSIGHTS                            │
│                                                                       │
│ Purpose: Predictive analytics and intelligent insights                │
└───────────────────────────────────────────────────────────────────────┘
                                │
                                ▼
                        CAREVIEW APPLICATION
                (Streamlit Clinical Intelligence Dashboard)