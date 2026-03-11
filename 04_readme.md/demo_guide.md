# 🏥 CAREVIEW DEMO GUIDE - Leadership Presentation

## Executive Summary

**Business Problem:**
Healthcare organizations struggle to identify high-risk patients early, leading to:
- Delayed clinical interventions
- Increased hospital readmissions (costing ~$26B annually in US)
- Inconsistent manual risk assessments
- Higher operational costs

**Solution - Careview Platform:**
An AI-powered patient risk monitoring platform built entirely on Snowflake that:
- Continuously monitors patient health metrics
- Uses Cortex AI for intelligent risk scoring
- Provides real-time alerts and dashboards
- Enables proactive care management

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                           CAREVIEW DATA PLATFORM                                     │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                      │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐    │
│  │   BRONZE     │────▶│   SILVER     │────▶│    GOLD      │────▶│  AI-READY    │    │
│  │  (Raw Data)  │     │ (Cleansed)   │     │ (Analytics)  │     │  (Cortex AI) │    │
│  │  8 Tables    │     │  8 Tables    │     │  6 Tables    │     │  6 Tables    │    │
│  │  ~3700 rows  │     │ Transformed  │     │ Aggregated   │     │ LLM-Enhanced │    │
│  └──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘    │
│                                                                        │             │
│  ┌──────────────────────────────────────────────────────────────────────┘            │
│  │                                                                                   │
│  ▼                                                                                   │
│  ┌─────────────────────────────────────────────────────────────────────────────────┐ │
│  │                        STREAMLIT AI DASHBOARD                                   │ │
│  │   • Patient Risk Analysis  • Clinical Intelligence  • Billing Analytics        │ │
│  └─────────────────────────────────────────────────────────────────────────────────┘ │
│                                                                                      │
│  ┌─────────────────────────────────────────────────────────────────────────────────┐ │
│  │                     GOVERNANCE & SECURITY LAYER                                 │ │
│  │   • RBAC (5 Roles)  • Masking Policies  • Resource Monitors  • Audit Trails    │ │
│  └─────────────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

# DEMO FLOW (14 SQL Files + Streamlit App)

## PHASE 1: ACCOUNT ADMINISTRATION
**File:** `01_account_administration.sql`

**Business Value:** HIPAA-compliant security foundation

**What It Creates:**
| Object | Purpose |
|--------|---------|
| `CAREVIEW_SECURITY` Database | Centralized security objects |
| `CAREVIEW_NETWORK_POLICY` | IP allowlist control (restrict in production) |
| `CAREVIEW_PASSWORD_POLICY` | 12+ chars, special chars, 90-day rotation |
| `CAREVIEW_SESSION_POLICY` | Auto-logout: 60 mins idle, 40 mins UI idle |

**Demo Script:**
```
"Before building any data platform, we establish security controls.
This creates enterprise-grade password policies requiring 12+ characters,
special characters, and automatic password rotation every 90 days -
meeting HIPAA compliance requirements."
```

---

## PHASE 2: RBAC SETUP
**File:** `02_rbac_setup.sql`

**Business Value:** Least-privilege access control

**Role Hierarchy:**
```
                    ACCOUNTADMIN
                         │
                      SYSADMIN
                         │
                   CAREVIEW_ADMIN ─────────────────┐
                         │                         │
           ┌─────────────┼─────────────┐           │
           │             │             │           │
    CAREVIEW_       CAREVIEW_     CAREVIEW_        │
    ENGINEER     DATA_SCIENTIST   ANALYST         │
                                      │            │
                               CAREVIEW_VIEWER ───┘
```

**Role Responsibilities:**
| Role | Access Level | Use Case |
|------|--------------|----------|
| `CAREVIEW_ADMIN` | Full access | Platform management |
| `CAREVIEW_ENGINEER` | Bronze/Silver/Gold | Data pipeline development |
| `CAREVIEW_DATA_SCIENTIST` | All + AI_READY | ML model development |
| `CAREVIEW_ANALYST` | Silver/Gold/AI_READY | Reporting & analysis |
| `CAREVIEW_VIEWER` | Gold only (read) | Dashboard access |

**Demo Script:**
```
"We implement role-based access control with 5 distinct roles.
The VIEWER can only see dashboards in the Gold layer.
The DATA_SCIENTIST gets full access including the AI_READY schema
for building machine learning models. This ensures doctors see
patient data while data scientists can't see PHI unnecessarily."
```

---

## PHASE 3: WAREHOUSE MANAGEMENT
**File:** `03_warehouse_management.sql`

**Business Value:** Cost optimization through workload isolation

**Warehouses Created:**
| Warehouse | Size | Auto-Suspend | Purpose | Who Uses It |
|-----------|------|--------------|---------|-------------|
| `CAREVIEW_LOAD_WH` | X-Small | 60 sec | Data ingestion | Engineer, Admin |
| `CAREVIEW_TRANSFORM_WH` | Small | 120 sec | ETL processing | Engineer, Admin |
| `CAREVIEW_ANALYTICS_WH` | X-Small | 120 sec | Queries & reports | Everyone |
| `CAREVIEW_AI_WH` | Small | 60 sec | Cortex AI workloads | Data Scientist |

**Demo Script:**
```
"We create 4 purpose-built warehouses that auto-suspend when idle.
This prevents expensive compute costs from idle resources.
The AI warehouse is specifically sized for Cortex LLM processing,
while the analytics warehouse handles dashboard queries."
```

---

## PHASE 4: DATABASE STRUCTURE
**File:** `04_database_structure.sql`

**Business Value:** Medallion architecture for data quality progression

**Schemas (Data Lake Layers):**
| Schema | Purpose | Who Can Access |
|--------|---------|----------------|
| `CAREVIEW_SCH_BRONZE` | Raw data as-is from sources | Admin, Engineer, Data Scientist |
| `CAREVIEW_SCH_SILVER` | Cleaned & validated data | Admin, Engineer, DS, Analyst |
| `CAREVIEW_SCH_GOLD` | Business-ready analytics | Everyone |
| `CAREVIEW_SCH_AI_READY` | AI/ML processed features | Admin, Data Scientist, Analyst |

**Demo Script:**
```
"Our database follows the medallion architecture - Bronze for raw data,
Silver for cleansed data, Gold for business reporting, and AI_READY
for machine learning features. Each layer progressively improves
data quality while maintaining the original source data in Bronze."
```

---

## PHASE 5: RESOURCE MONITORS
**File:** `05_resource_monitors.sql`

**Business Value:** Cost governance and runaway query prevention

**Monitors Created:**
| Monitor | Credit Quota | Alerts At | Action |
|---------|--------------|-----------|--------|
| `CAREVIEW_ACCOUNT_MONITOR` | 300/month | 50%, 75%, 90% | Suspend at 100% |
| `CAREVIEW_LOAD_MONITOR` | 350/month | 50%, 80% | Suspend at 100% |
| `CAREVIEW_TRANSFORM_MONITOR` | 200/month | 50%, 80% | Suspend at 100% |
| `CAREVIEW_ANALYTICS_MONITOR` | 300/month | 50%, 75%, 90% | Suspend at 100% |
| `CAREVIEW_AI_MONITOR` | 350/month | 50%, 80% | Suspend at 100% |

**Demo Script:**
```
"Resource monitors prevent cost overruns. When the analytics warehouse
reaches 75% of its monthly budget, stakeholders get notified.
At 100%, queries are suspended - no surprise bills at month-end."
```

---

## PHASE 6: MONITORING VIEWS
**File:** `06_monitoring_views.sql`

**Business Value:** Operational visibility and cost transparency

**Views Created (12 total):**
| View | Purpose |
|------|---------|
| `CREDIT_USAGE_SUMMARY` | Daily credit consumption |
| `WAREHOUSE_PERFORMANCE` | Query execution metrics |
| `STORAGE_USAGE` | Database storage trends |
| `USER_ACTIVITY` | Login and query patterns |
| `QUERY_PERFORMANCE` | Slow query identification |
| `COST_BY_WAREHOUSE` | Cost allocation by warehouse |
| + 6 more... | Various operational metrics |

**Demo Script:**
```
"These 12 monitoring views give our ops team real-time visibility.
We can see which warehouse is consuming the most credits,
identify slow queries, and track user activity - all without
writing complex queries against ACCOUNT_USAGE views."
```

---

## PHASE 7: ALERTS
**File:** `07_alerts.sql`

**Business Value:** Proactive issue detection

**Alerts Created:**
| Alert | Trigger Condition | Check Frequency |
|-------|-------------------|-----------------|
| `CAREVIEW_HIGH_CREDIT_ALERT` | Daily credits > 10 | Every 60 mins |
| `CAREVIEW_FAILED_LOGIN_ALERT` | > 3 failed logins in 1 hour | Every 30 mins |
| `CAREVIEW_LONG_QUERY_ALERT` | Query runs > 5 minutes | Every 15 mins |

**Demo Script:**
```
"Automated alerts notify us of security issues and cost anomalies.
Multiple failed logins could indicate a brute-force attack.
Long-running queries might be scanning too much data.
We catch these issues before they become problems."
```

---

## PHASE 8: DATA GOVERNANCE
**File:** `08_data_governance.sql`

**Business Value:** PHI protection and regulatory compliance

**Masking Policies:**
| Policy | What It Protects | Example Output |
|--------|------------------|----------------|
| `MASK_SSN` | Social Security Numbers | `123-45-6789` → `XXX-XX-6789` |
| `MASK_EMAIL` | Email addresses | `john@gmail.com` → `****@gmail.com` |
| `MASK_PHONE` | Phone numbers | `555-123-4567` → `XXX-XXX-4567` |

**Demo Script:**
```
"Dynamic masking automatically protects sensitive data.
When an analyst queries patient data, they see masked SSNs -
only the last 4 digits. This meets HIPAA requirements while
still allowing legitimate analytics work."
```

---

## PHASE 9: AUDIT VIEWS
**File:** `09_audit_views.sql`

**Business Value:** Compliance reporting and security forensics

**Audit Queries Provided:**
| Audit | Purpose | When to Run |
|-------|---------|-------------|
| Who logged in? | User access tracking | Daily |
| Failed logins | Security monitoring | Daily |
| Who ran queries? | User activity audit | Weekly |
| What queries failed? | Error investigation | As needed |
| All users | User inventory | Monthly |
| All roles | Role inventory | Monthly |

**Demo Script:**
```
"For HIPAA compliance, we need to track who accessed what data.
These audit queries show all login attempts, failed queries,
and user activity. During an audit, we can prove exactly
who accessed patient records and when."
```

---

## PHASE 10: VERIFICATION
**File:** `10_verification.sql`

**Business Value:** Quality assurance and deployment validation

**What It Validates:**
- All roles created correctly
- All warehouses exist with proper settings
- Database and schemas accessible
- Resource monitors assigned
- Network and password policies active

**Demo Script:**
```
"Before loading any data, we verify all infrastructure is correct.
This script checks every object we've created - think of it as
our infrastructure test suite."
```

---

## PHASE 11: BRONZE LAYER (Raw Data)
**File:** `11_bronze_layer.sql`

**Business Value:** Source system integration point

**Tables Created (8 tables, ~3,700 rows):**
| Table | Records | Description |
|-------|---------|-------------|
| `BRONZE_PATIENTS` | 100 | Patient demographics (name, DOB, insurance) |
| `BRONZE_DOCTORS` | 10 | Provider information |
| `BRONZE_DEPARTMENTS` | 6 | Hospital departments |
| `BRONZE_VISITS` | 200 | Patient encounters |
| `BRONZE_DIAGNOSES` | 150 | ICD-10 diagnosis codes |
| `BRONZE_TREATMENTS` | 100 | Treatment records |
| `BRONZE_MEDICATIONS` | 120 | Prescription data |
| `BRONZE_BILLING` | 180 | Financial transactions |

**Demo Script:**
```
"The Bronze layer contains raw data exactly as received from
source systems - our EHR, billing system, and provider databases.
We load 8 core healthcare tables: patients, doctors, visits,
diagnoses, treatments, medications, and billing records."
```

---

## PHASE 12: SILVER LAYER (Cleansed Data)
**File:** `12_silver_layer.sql`

**Business Value:** Data quality and standardization

**Transformations Applied:**
| Transformation | Example | Business Impact |
|----------------|---------|-----------------|
| **TRIM whitespace** | `" John "` → `"John"` | Clean names for matching |
| **UPPER standardization** | `"male"` → `"MALE"` | Consistent categorization |
| **Calculated fields** | `FULL_NAME`, `AGE_GROUP` | Ready-to-use analytics |
| **Experience levels** | `< 5 yrs` = "Junior" | Provider categorization |
| **Risk flags** | `HIGH_RISK` = "Yes/No" | Clinical alerts |
| **Cost categories** | `< $1000` = "Low" | Financial segmentation |

**Tables Created (8 tables):**
| Table | Key Transformations |
|-------|---------------------|
| `SILVER_PATIENTS` | FULL_NAME, AGE_GROUP (Child/Adult/Senior) |
| `SILVER_DOCTORS` | EXPERIENCE_LEVEL (Junior/Mid-Level/Senior) |
| `SILVER_DEPARTMENTS` | Standardized names |
| `SILVER_VISITS` | VISIT_YEAR, VISIT_MONTH, VISIT_DAY |
| `SILVER_DIAGNOSES` | HIGH_RISK flag, IS_CHRONIC boolean |
| `SILVER_TREATMENTS` | COST_CATEGORY (Low/Medium/High) |
| `SILVER_MEDICATIONS` | PRESCRIBER_NAME joined |
| `SILVER_BILLING` | AMOUNT_CATEGORY |

**Demo Script:**
```
"The Silver layer cleanses and enriches our data. Names are
standardized, age groups are calculated, and we flag high-risk
diagnoses. A doctor with 3 years experience is marked 'Junior'
while one with 15 years is 'Senior' - enabling experience-based analytics."
```

---

## PHASE 13: GOLD LAYER (Analytics-Ready)
**File:** `13_gold_layer.sql`

**Business Value:** Business intelligence and operational dashboards

**Tables Created (6 aggregated tables):**
| Table | Purpose | Key Metrics |
|-------|---------|-------------|
| `GOLD_PATIENT_RISK` | Risk stratification | HIGH_RISK_COUNT, CHRONIC_COUNT, RISK_LEVEL |
| `GOLD_PATIENT_SUMMARY` | 360° patient view | Total visits, diagnoses, medications, billing |
| `GOLD_DIAGNOSIS_INSIGHTS` | Clinical patterns | PATIENT_COUNT, HIGH_RISK_RATE |
| `GOLD_BILLING_ANALYSIS` | Revenue analytics | BILL_COUNT, TOTAL_AMOUNT by category |
| `GOLD_DEPARTMENT_SUMMARY` | Operational metrics | TOTAL_REVENUE, TOTAL_PATIENTS, BED_COUNT |
| `GOLD_DOCTOR_SUMMARY` | Provider performance | TOTAL_PATIENTS, TOTAL_PRESCRIPTIONS |

**Risk Scoring Logic:**
```sql
RISK_LEVEL = CASE
    WHEN HIGH_RISK_COUNT >= 2 OR CHRONIC_COUNT >= 3 THEN 'HIGH'
    WHEN HIGH_RISK_COUNT >= 1 OR CHRONIC_COUNT >= 2 THEN 'MEDIUM'
    ELSE 'LOW'
END
```

**Demo Script:**
```
"The Gold layer aggregates Silver data into business metrics.
GOLD_PATIENT_RISK calculates risk levels: patients with 2+ high-risk
diagnoses or 3+ chronic conditions are flagged HIGH priority.
This powers our clinical dashboard and care management workflows."
```

---

## PHASE 14: AI-READY LAYER (Cortex AI)
**File:** `14_ai_ready_layer.sql`

**Business Value:** AI-powered clinical intelligence

**Tables Created (6 AI-enhanced tables):**
| Table | Cortex Function | Purpose |
|-------|-----------------|---------|
| `AI_PATIENT_SUMMARIES` | `CORTEX.COMPLETE` | Natural language patient summaries |
| `AI_RISK_INSIGHTS` | `CORTEX.COMPLETE` | Risk factor analysis & recommendations |
| `AI_DIAGNOSIS_INSIGHTS` | `CORTEX.COMPLETE` | Treatment recommendations per diagnosis |
| `AI_BILLING_RECOMMENDATIONS` | `CORTEX.COMPLETE` | Revenue optimization insights |
| `AI_DEPARTMENT_SUMMARIES` | `CORTEX.COMPLETE` | Department performance narratives |
| `AI_DOCTOR_SUMMARIES` | `CORTEX.COMPLETE` | Provider performance insights |

**Cortex AI Prompts Used:**
```sql
-- Patient Summary Generation
SNOWFLAKE.CORTEX.COMPLETE(
    'mistral-large2',
    'Generate a brief patient summary: ' || 
    'Age ' || AGE || ', ' || GENDER || ', ' ||
    TOTAL_VISITS || ' visits, ' ||
    TOTAL_DIAGNOSES || ' diagnoses. Max 50 words.'
)

-- Risk Analysis
SNOWFLAKE.CORTEX.COMPLETE(
    'mistral-large2',
    'Analyze risk for patient with ' ||
    HIGH_RISK_COUNT || ' high-risk diagnoses and ' ||
    CHRONIC_COUNT || ' chronic conditions. 
    Risk level: ' || RISK_LEVEL || '. Max 100 words.'
)
```

**Demo Script:**
```
"The AI-Ready layer uses Snowflake Cortex to generate clinical intelligence.
Instead of structured data, clinicians see natural language summaries:
'John is a 67-year-old male with diabetes and hypertension, HIGH risk
due to 2 chronic conditions. Recommend monthly A1C monitoring.'
This transforms data into actionable clinical narratives."
```

---

## PHASE 15: STREAMLIT DASHBOARD
**Files:** `careview_ai_dashboard.py` (Primary) & `streamlit_app.py` (Alternative)

**Business Value:** Self-service clinical analytics

**Dashboard Tabs:**
| Tab | Features |
|-----|----------|
| **📊 Overview** | KPI cards, risk distribution charts, billing summary |
| **⚠️ Risk Analysis** | Risk-filtered patient list with AI assessments |
| **👤 Patient Details** | Complete patient profile with history |
| **💰 Billing** | Patient bills, payment status, AI recommendations |
| **🏥 Departments & Doctors** | Department metrics, doctor availability |

**Key Features:**
- Real-time data from Gold layer tables
- AI-generated insights displayed inline
- Color-coded risk indicators (🔴 High, 🟡 Medium, 🟢 Low)
- Drill-down from summary to patient detail
- Cached queries (5-minute TTL) for performance

**Demo Script:**
```
"The Streamlit dashboard brings everything together. Leadership sees
KPIs at a glance - 100 patients, 25 high-risk. Click any patient
to see their complete history with AI-generated summaries.
The billing tab shows outstanding amounts and AI recommendations
for revenue cycle improvement. All powered by Snowflake, no external tools."
```

---

# DEPLOYMENT INSTRUCTIONS

## Step 1: Run SQL Files (In Order)
```sql
-- Execute in Snowflake Worksheets
-- Files 01-10: Infrastructure setup
-- Files 11-14: Data layers
```

## Step 2: Deploy Streamlit App
```sql
-- Create stage for Streamlit files
CREATE OR REPLACE STAGE CAREVIEW_DB.CAREVIEW_SCH_GOLD.STREAMLIT_STAGE;

-- Upload careview_ai_dashboard.py to stage
-- Then create Streamlit app:
CREATE OR REPLACE STREAMLIT CAREVIEW_DB.CAREVIEW_SCH_GOLD.CAREVIEW_DASHBOARD
    FROM '@CAREVIEW_DB.CAREVIEW_SCH_GOLD.STREAMLIT_STAGE'
    MAIN_FILE = 'careview_ai_dashboard.py'
    QUERY_WAREHOUSE = 'CAREVIEW_ANALYTICS_WH';
```

---

# KEY TALKING POINTS FOR LEADERSHIP

## 1. Security & Compliance
- HIPAA-compliant password policies
- Dynamic data masking for PHI
- Role-based access control
- Complete audit trail

## 2. Cost Governance
- 5 resource monitors prevent overruns
- 4 purpose-built warehouses with auto-suspend
- Real-time cost visibility via monitoring views

## 3. Data Quality
- Medallion architecture (Bronze → Silver → Gold)
- Progressive data cleansing
- Automated quality flags

## 4. AI Intelligence
- Cortex LLM for patient summaries
- Risk analysis recommendations
- Treatment suggestions per diagnosis
- No external AI tools needed - all in Snowflake

## 5. Business Value
- **Faster intervention**: High-risk patients identified automatically
- **Reduced readmissions**: Proactive care management
- **Cost optimization**: Revenue cycle insights
- **Clinical efficiency**: AI summaries save clinician time

---

# DEMO CHECKLIST

- [ ] Run `10_verification.sql` to confirm all objects exist
- [ ] Query `GOLD_PATIENT_RISK` to show risk stratification
- [ ] Query `AI_RISK_INSIGHTS` to show AI-generated content
- [ ] Open Streamlit dashboard
- [ ] Show Overview tab KPIs
- [ ] Filter Risk Analysis to HIGH risk patients
- [ ] Drill into one patient's complete profile
- [ ] Show AI-generated patient summary
- [ ] Demonstrate masking by switching to VIEWER role
- [ ] Show resource monitor usage

---

*Careview - Transforming Patient Care Through AI-Powered Insights*
*Built 100% on Snowflake with Cortex AI*
