/*
================================================================================
CAREVIEW - AI-READY LAYER (Cortex AI Enriched)
================================================================================
Purpose: AI-powered insights using Snowflake Cortex functions
Features: Risk scoring, sentiment analysis, clinical intelligence

CORTEX AI FUNCTIONS USED:
-------------------------
1. SNOWFLAKE.CORTEX.AI_COMPLETE() - LLM text generation for recommendations
2. SNOWFLAKE.CORTEX.SENTIMENT() - Analyze text sentiment (-1 to +1 scale)
3. SNOWFLAKE.CORTEX.SUMMARIZE() - Auto-summarize long text

PRE-REQUISITES:
---------------
- Cortex enabled: ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION'
- Gold layer tables must exist (PATIENT_SUMMARY, DIAGNOSIS_ANALYTICS)
- Silver layer tables must exist (VISITS, DIAGNOSES)

TABLES CREATED:
---------------
1. PATIENT_RISK_SCORES   - Risk assessment with AI care recommendations
2. VISIT_INSIGHTS        - Sentiment analysis of visit notes
3. CLINICAL_INTELLIGENCE - AI-generated clinical insights per diagnosis
================================================================================
*/

-- ============================================================================
-- 1. PATIENT RISK SCORES
-- ============================================================================
-- Purpose: Calculate patient risk scores and generate AI care recommendations
-- Source: GOLD.PATIENT_SUMMARY
-- AI Function: CORTEX.AI_COMPLETE (llama3.1-8b) for personalized recommendations
--
-- RISK SCORING FORMULA (0-100 scale):
--   - Severity contribution: MAX_SEVERITY_LEVEL * 25 (max 100)
--   - Age contribution: 30 pts if >65, 15 pts if >50, 0 otherwise
--   - Visit frequency: TOTAL_VISITS * 5 (capped at 25)
--   - Financial risk: 20 pts if outstanding balance > $5000
--
-- RISK CATEGORIES:
--   - HIGH: Age >65 AND Severity >=3 (Severe/Critical)
--   - MEDIUM: Age >50 OR Severity >=2 OR Visits >3
--   - LOW: All others
-- ============================================================================
CREATE OR REPLACE TABLE CAREVIEW_DB.AI_READY.PATIENT_RISK_SCORES AS
SELECT 
    -- Patient identifiers from Gold summary
    PS.PATIENT_ID,
    PS.FIRST_NAME,
    PS.LAST_NAME,
    PS.AGE,
    PS.TOTAL_VISITS,
    PS.TOTAL_DIAGNOSES,
    PS.MAX_SEVERITY_LEVEL,
    PS.OUTSTANDING_BALANCE,
    
    -- Risk category based on age and severity combination
    CASE 
        WHEN PS.AGE > 65 AND PS.MAX_SEVERITY_LEVEL >= 3 THEN 'HIGH'
        WHEN PS.AGE > 50 OR PS.MAX_SEVERITY_LEVEL >= 2 OR PS.TOTAL_VISITS > 3 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS RISK_CATEGORY,
    
    -- Numeric risk score (0-100) for sorting and thresholds
    ROUND(
        (COALESCE(PS.MAX_SEVERITY_LEVEL, 0) * 25) +
        (CASE WHEN PS.AGE > 65 THEN 30 WHEN PS.AGE > 50 THEN 15 ELSE 0 END) +
        (LEAST(PS.TOTAL_VISITS, 5) * 5) +
        (CASE WHEN PS.OUTSTANDING_BALANCE > 5000 THEN 20 ELSE 0 END)
    , 0) AS RISK_SCORE,
    
    -- AI-generated personalized care recommendation using Cortex LLM
    SNOWFLAKE.CORTEX.AI_COMPLETE(
        'llama3.1-8b',
        'Generate a brief (2-3 sentence) care recommendation for a ' || PS.AGE || ' year old patient with ' || PS.TOTAL_DIAGNOSES || ' diagnoses and severity level ' || 
        COALESCE(PS.MAX_SEVERITY_LEVEL, 0) || '. Be concise and clinical.'
    ) AS AI_RECOMMENDATION,
    
    -- Timestamp for tracking when scores were calculated
    CURRENT_TIMESTAMP() AS SCORED_AT
FROM CAREVIEW_DB.GOLD.PATIENT_SUMMARY PS;

-- ============================================================================
-- 2. VISIT INSIGHTS
-- ============================================================================
-- Purpose: Analyze visit notes sentiment and generate AI summaries
-- Source: SILVER.VISITS joined with SILVER.DIAGNOSES
-- AI Functions:
--   - CORTEX.SENTIMENT: Returns score from -1 (negative) to +1 (positive)
--   - CORTEX.SUMMARIZE: Condenses visit details into brief summary
--
-- SENTIMENT THRESHOLDS:
--   - POSITIVE: Score > 0.3 (indicates good outcomes/progress)
--   - NEGATIVE: Score < -0.3 (indicates concerns/complications)
--   - NEUTRAL: Score between -0.3 and 0.3
-- ============================================================================
CREATE OR REPLACE TABLE CAREVIEW_DB.AI_READY.VISIT_INSIGHTS AS
SELECT 
    -- Visit details
    V.VISIT_ID,
    V.PATIENT_ID,
    V.DEPARTMENT,
    V.VISIT_TYPE,
    V.VISIT_DATE,
    V.LENGTH_OF_STAY_DAYS,
    
    -- Diagnosis context
    D.DIAGNOSIS_NAME,
    D.SEVERITY_TEXT,
    
    -- Raw sentiment score from Cortex (-1 to +1)
    SNOWFLAKE.CORTEX.SENTIMENT(V.VISIT_NOTES) AS NOTES_SENTIMENT_SCORE,
    
    -- Categorized sentiment for easier filtering/reporting
    CASE 
        WHEN SNOWFLAKE.CORTEX.SENTIMENT(V.VISIT_NOTES) > 0.3 THEN 'POSITIVE'
        WHEN SNOWFLAKE.CORTEX.SENTIMENT(V.VISIT_NOTES) < -0.3 THEN 'NEGATIVE'
        ELSE 'NEUTRAL'
    END AS NOTES_SENTIMENT,
    
    -- AI-generated visit summary combining all visit context
    SNOWFLAKE.CORTEX.SUMMARIZE(
        'Visit: ' || V.VISIT_TYPE || ' to ' || V.DEPARTMENT || 
        '. Diagnosis: ' || COALESCE(D.DIAGNOSIS_NAME, 'None') || 
        '. Severity: ' || COALESCE(D.SEVERITY_TEXT, 'N/A') || 
        '. Notes: ' || COALESCE(V.VISIT_NOTES, 'No notes')
    ) AS AI_VISIT_SUMMARY,
    
    -- Timestamp for tracking analysis freshness
    CURRENT_TIMESTAMP() AS ANALYZED_AT
FROM CAREVIEW_DB.SILVER.VISITS V
LEFT JOIN CAREVIEW_DB.SILVER.DIAGNOSES D ON V.VISIT_ID = D.VISIT_ID;

-- ============================================================================
-- 3. CLINICAL INTELLIGENCE
-- ============================================================================
-- Purpose: Generate AI-powered clinical insights for each diagnosis type
-- Source: GOLD.DIAGNOSIS_ANALYTICS (aggregated diagnosis patterns)
-- AI Function: CORTEX.AI_COMPLETE for clinical insights and prevention tips
--
-- CLINICAL PRIORITY LEVELS:
--   - CRITICAL_PRIORITY: Has any critical cases (immediate attention)
--   - HIGH_PRIORITY: Average severity >= 2.5 (close monitoring)
--   - STANDARD_PRIORITY: Average severity >= 1.5 (routine care)
--   - LOW_PRIORITY: All others (preventive focus)
--
-- NOTE: Limited to TOP 10 diagnoses to reduce Cortex LLM processing time
-- ============================================================================
CREATE OR REPLACE TABLE CAREVIEW_DB.AI_READY.CLINICAL_INTELLIGENCE AS
SELECT 
    -- Diagnosis identifiers
    DA.DIAGNOSIS_CODE,
    DA.DIAGNOSIS_NAME,
    
    -- Aggregated metrics from Gold layer
    DA.DIAGNOSIS_COUNT,
    DA.AFFECTED_PATIENTS,
    DA.AVG_SEVERITY,
    DA.CRITICAL_CASES,
    
    -- Priority classification for clinical workflow integration
    CASE 
        WHEN DA.CRITICAL_CASES > 0 THEN 'CRITICAL_PRIORITY'
        WHEN DA.AVG_SEVERITY >= 2.5 THEN 'HIGH_PRIORITY'
        WHEN DA.AVG_SEVERITY >= 1.5 THEN 'STANDARD_PRIOleRITY'
        ELSE 'LOW_PRIORITY'
    END AS CLINICAL_PRIORITY,
    
    -- Single AI call with combined insight (faster than 2 separate calls)
    SNOWFLAKE.CORTEX.AI_COMPLETE(
        'llama3.1-8b',
        'For ' || DA.DIAGNOSIS_NAME || ' (' || DA.DIAGNOSIS_CODE || '): Give 1 treatment tip and 1 prevention tip in 2 short sentences.'
    ) AS AI_INSIGHT,
    
    -- Timestamp for tracking when insights were generated
    CURRENT_TIMESTAMP() AS GENERATED_AT
FROM CAREVIEW_DB.GOLD.DIAGNOSIS_ANALYTICS DA
WHERE DA.DIAGNOSIS_COUNT >= 2
ORDER BY DA.DIAGNOSIS_COUNT DESC
LIMIT 10;

select * from CAREVIEW_DB.AI_READY.CLINICAL_INTELLIGENCE;

/*
================================================================================
SAMPLE QUERIES FOR AI-READY LAYER
================================================================================

-- High-risk patients requiring immediate attention
SELECT PATIENT_ID, FIRST_NAME, LAST_NAME, RISK_SCORE, RISK_CATEGORY, AI_RECOMMENDATION
FROM CAREVIEW_DB.AI_READY.PATIENT_RISK_SCORES
WHERE RISK_CATEGORY = 'HIGH'
ORDER BY RISK_SCORE DESC;

-- Visits with negative sentiment (potential issues)
SELECT VISIT_ID, PATIENT_ID, DEPARTMENT, NOTES_SENTIMENT, AI_VISIT_SUMMARY
FROM CAREVIEW_DB.AI_READY.VISIT_INSIGHTS
WHERE NOTES_SENTIMENT = 'NEGATIVE';

-- Critical diagnoses with AI insights
SELECT DIAGNOSIS_NAME, CLINICAL_PRIORITY, AI_CLINICAL_INSIGHT, AI_PREVENTION_TIPS
FROM CAREVIEW_DB.AI_READY.CLINICAL_INTELLIGENCE
WHERE CLINICAL_PRIORITY = 'CRITICAL_PRIORITY';

================================================================================
*/

-- -- Cancel first query
-- SELECT SYSTEM$CANCEL_QUERY('01c2b04c-3202-62f6-0014-2e1a0001804a');

-- -- Cancel second query  
-- SELECT SYSTEM$CANCEL_QUERY('01c2b03a-3202-62f6-0014-2e1a0001776e');

-- SELECT SYSTEM$CANCEL_QUERY('01c2b053-3202-62f6-0014-2e1a000182ce');







