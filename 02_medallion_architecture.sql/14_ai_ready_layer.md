# AI-Ready Layer

## What is This?

The AI-Ready Layer takes your hospital data and adds **smart, human-readable summaries** using Snowflake's built-in AI (Cortex).

Instead of just seeing numbers, you get **plain English explanations** that anyone can understand.

---

## How It Works

```
Gold Layer (Numbers) → AI-Ready Layer (Numbers + AI Summaries)
```

Each view uses `SNOWFLAKE.CORTEX.COMPLETE()` to send data to an AI model (`mistral-large2`) which returns a 2-sentence summary.

---

## Views Available

### 1. AI_PATIENT_SUMMARY

**Purpose:** Get a quick overview of any patient

**What You See:**
| Column | Description |
|--------|-------------|
| Patient details | Name, age, gender, city |
| Visit stats | Total visits, diagnoses, medications |
| Costs | Treatment cost, total billed |
| **AI_SUMMARY** | Plain English patient overview |

**Example AI Output:**
> "John Smith is a 45-year-old male from Seattle with moderate healthcare utilization. He has had 5 visits, 2 diagnoses, and 3 medications with $1,200 in total billing."

**Try It:**
```sql
SELECT * FROM AI_PATIENT_SUMMARY WHERE PATIENT_ID = 1;
```

---

### 2. AI_PATIENT_RISK

**Purpose:** Understand patient health risks at a glance

**What You See:**
| Column | Description |
|--------|-------------|
| Risk factors | High-risk diagnoses, chronic conditions |
| Medication count | Number of current medications |
| Risk level | LOW, MEDIUM, or HIGH |
| **AI_RISK_ASSESSMENT** | Plain English risk explanation |

**Example AI Output:**
> "This patient presents elevated health risks due to 2 chronic conditions and 4 medications. Close monitoring is recommended given the HIGH risk classification."

**Try It:**
```sql
SELECT * FROM AI_PATIENT_RISK WHERE RISK_LEVEL = 'HIGH';
```

---

### 3. AI_DIAGNOSIS_INSIGHTS

**Purpose:** Understand diagnosis patterns across patients

**What You See:**
| Column | Description |
|--------|-------------|
| Diagnosis info | Code, name, severity |
| Risk flags | Is it high-risk? Is it chronic? |
| Demographics | How many children, adults, seniors affected |
| **AI_INSIGHT** | Plain English clinical insight |

**Example AI Output:**
> "Type 2 Diabetes is a moderate-severity chronic condition affecting primarily the adult and senior population. With 15 patients diagnosed, this represents a significant care management opportunity."

**Try It:**
```sql
SELECT * FROM AI_DIAGNOSIS_INSIGHTS WHERE SEVERITY = 'SEVERE';
```

---

### 4. AI_BILLING_SUMMARY

**Purpose:** Get actionable billing recommendations

**What You See:**
| Column | Description |
|--------|-------------|
| Billing details | Service type, payment status |
| Amounts | Total amount, average amount |
| Insurance | Insurance type breakdown |
| **AI_RECOMMENDATION** | Plain English action items |

**Example AI Output:**
> "There are 25 pending bills totaling $45,000 for laboratory services under Medicare. Consider initiating follow-up calls and sending reminder notices to reduce outstanding receivables."

**Try It:**
```sql
SELECT * FROM AI_BILLING_SUMMARY WHERE PAYMENT_STATUS = 'PENDING';
```

---

### 5. AI_DEPARTMENT_SUMMARY

**Purpose:** Quick department performance overview

**What You See:**
| Column | Description |
|--------|-------------|
| Department info | Name, building, bed count |
| Staffing | Total doctors |
| Activity | Visits, patients, revenue |
| **AI_SUMMARY** | Plain English performance summary |

**Example AI Output:**
> "The Cardiology department shows strong performance with 12 doctors managing 1,500 patients across 3,200 visits. Revenue of $2.5M indicates healthy operational efficiency for the 50-bed unit."

**Try It:**
```sql
SELECT * FROM AI_DEPARTMENT_SUMMARY;
```

---

### 6. AI_DOCTOR_PERFORMANCE

**Purpose:** Individual doctor performance insights

**What You See:**
| Column | Description |
|--------|-------------|
| Doctor info | Name, specialization, experience level |
| Department | Which department they work in |
| Activity | Patients, visits, prescriptions |
| **AI_SUMMARY** | Plain English performance summary |

**Example AI Output:**
> "Dr. Sarah Johnson is a senior cardiologist demonstrating high productivity with 120 patients and 280 visits this period. Her 95 prescriptions indicate active treatment engagement."

**Try It:**
```sql
SELECT * FROM AI_DOCTOR_PERFORMANCE;
```

---

## Data Flow

```
┌─────────────────────┐
│   GOLD LAYER        │
│   (Clean Numbers)   │
├─────────────────────┤
│ GOLD_PATIENT_SUMMARY│───→ AI_PATIENT_SUMMARY
│ GOLD_PATIENT_RISK   │───→ AI_PATIENT_RISK
│ GOLD_DIAGNOSIS_...  │───→ AI_DIAGNOSIS_INSIGHTS
│ GOLD_BILLING_...    │───→ AI_BILLING_SUMMARY
│ GOLD_DEPARTMENT_... │───→ AI_DEPARTMENT_SUMMARY
│ GOLD_DOCTOR_SUMMARY │───→ AI_DOCTOR_PERFORMANCE
└─────────────────────┘
```

---

## Important Notes

| Topic | Details |
|-------|---------|
| **AI Model** | Uses `mistral-large2` via Snowflake Cortex |
| **Processing** | AI runs each time you query the view |
| **Cost** | Each query uses AI credits - be mindful of large queries |
| **Speed** | AI processing adds a few seconds per row |

**Tip:** For frequently accessed data, consider saving results to a table instead of querying the view repeatedly.

---

## Quick Reference

| I want to... | Use this view |
|--------------|---------------|
| Summarize a patient | `AI_PATIENT_SUMMARY` |
| Check patient risk | `AI_PATIENT_RISK` |
| Understand a diagnosis | `AI_DIAGNOSIS_INSIGHTS` |
| Get billing advice | `AI_BILLING_SUMMARY` |
| Review department stats | `AI_DEPARTMENT_SUMMARY` |
| Evaluate doctor performance | `AI_DOCTOR_PERFORMANCE` |
