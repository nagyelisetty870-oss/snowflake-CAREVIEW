"""
================================================================================
CAREVIEW - PATIENT RISK MONITORING PLATFORM
================================================================================
PHASE 15: STREAMLIT VISUALIZATION DASHBOARD
--------------------------------------------------------------------------------
Careview Dashboard: Patient Risk Monitoring and Analytics

Features:
1. Executive Summary with KPIs
2. High-Risk Patient Watchlist
3. Department Performance Metrics
4. Risk Distribution Analysis
5. AI-Generated Insights Display
================================================================================
"""

import streamlit as st
import pandas as pd
import altair as alt

# ============================================================================
# CONNECTION SETUP
# ============================================================================
try:
    from snowflake.snowpark.context import get_active_session
    session = get_active_session()
except:
    from snowflake.snowpark import Session
    session = Session.builder.config('connection_name', 'default').create()

# ============================================================================
# PAGE CONFIGURATION
# ============================================================================
st.title(":material/monitor_heart: Careview Dashboard")
st.caption("Patient Risk Monitoring Platform")

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================
@st.cache_data(ttl=300)
def load_patient_360(_session):
    """Load patient 360 data from Gold layer"""
    query = """
    SELECT 
        PATIENT_ID, FULL_NAME, AGE, GENDER, AGE_GROUP,
        TOTAL_VISITS, TOTAL_DIAGNOSES, CHRONIC_CONDITIONS,
        ACTIVE_MEDICATIONS, ABNORMAL_LAB_RESULTS,
        CURRENT_RISK_SCORE, CURRENT_RISK_CATEGORY,
        URGENCY_LEVEL, OVERALL_PATIENT_STATUS,
        LATEST_BP_CATEGORY, LATEST_O2_SAT, LATEST_BMI_CATEGORY,
        DAYS_SINCE_LAST_VISIT
    FROM CAREVIEW_DB.GOLD.GOLD_PATIENT_360
    WHERE IS_ACTIVE = TRUE
    """
    return _session.sql(query).to_pandas()

@st.cache_data(ttl=300)
def load_high_risk_patients(_session):
    """Load high-risk patients from Gold layer"""
    query = """
    SELECT 
        PATIENT_ID, FULL_NAME, AGE, GENDER,
        CURRENT_RISK_SCORE, CURRENT_RISK_CATEGORY,
        PRIMARY_RISK_FACTOR, URGENCY_LEVEL,
        CHRONIC_CONDITIONS, CRITICAL_LAB_RESULTS,
        RECOMMENDED_ACTION, PRIORITY_RANK
    FROM CAREVIEW_DB.GOLD.GOLD_HIGH_RISK_PATIENTS
    ORDER BY PRIORITY_RANK
    LIMIT 20
    """
    return _session.sql(query).to_pandas()

@st.cache_data(ttl=300)
def load_department_metrics(_session):
    """Load department metrics from Gold layer"""
    query = """
    SELECT 
        DEPARTMENT, TOTAL_VISITS, UNIQUE_PATIENTS,
        EMERGENCY_VISITS, ROUTINE_VISITS,
        AVG_VISIT_DURATION_HRS, TOTAL_REVENUE,
        AVG_CHARGE_PER_VISIT, FOLLOW_UP_RATE_PCT
    FROM CAREVIEW_DB.GOLD.GOLD_DEPARTMENT_METRICS
    """
    return _session.sql(query).to_pandas()

@st.cache_data(ttl=300)
def load_risk_summary(_session):
    """Load risk summary counts"""
    query = """
    SELECT 
        RISK_CATEGORY,
        COUNT(*) AS PATIENT_COUNT
    FROM CAREVIEW_DB.GOLD.GOLD_PATIENT_RISK_SUMMARY
    GROUP BY RISK_CATEGORY
    ORDER BY 
        CASE RISK_CATEGORY 
            WHEN 'CRITICAL' THEN 1 
            WHEN 'HIGH' THEN 2 
            WHEN 'MEDIUM' THEN 3 
            ELSE 4 
        END
    """
    return _session.sql(query).to_pandas()

@st.cache_data(ttl=300)
def load_ai_insights(_session):
    """Load AI-generated insights"""
    query = """
    SELECT 
        PATIENT_ID, FULL_NAME, RISK_CATEGORY,
        AI_RISK_ANALYSIS, AI_RECOMMENDED_ACTIONS
    FROM CAREVIEW_DB.AI_READY.AI_RISK_INSIGHTS
    LIMIT 5
    """
    return _session.sql(query).to_pandas()

# ============================================================================
# LOAD DATA
# ============================================================================
try:
    df_patients = load_patient_360(session)
    df_high_risk = load_high_risk_patients(session)
    df_departments = load_department_metrics(session)
    df_risk_summary = load_risk_summary(session)
    df_ai_insights = load_ai_insights(session)
    data_loaded = True
except Exception as e:
    st.error(f"Error loading data: {str(e)}")
    data_loaded = False

if data_loaded:
    # ========================================================================
    # EXECUTIVE SUMMARY - KEY METRICS
    # ========================================================================
    st.header("Executive Summary")
    
    col1, col2, col3, col4 = st.columns(4)
    
    with col1:
        total_patients = len(df_patients)
        st.metric(
            label="Total Active Patients",
            value=f"{total_patients:,}"
        )
    
    with col2:
        high_risk_count = len(df_patients[df_patients['CURRENT_RISK_CATEGORY'].isin(['HIGH', 'CRITICAL'])])
        st.metric(
            label="High/Critical Risk",
            value=f"{high_risk_count:,}",
            delta=f"{(high_risk_count/total_patients*100):.1f}%" if total_patients > 0 else "0%"
        )
    
    with col3:
        avg_risk = df_patients['CURRENT_RISK_SCORE'].mean()
        st.metric(
            label="Avg Risk Score",
            value=f"{avg_risk:.1f}"
        )
    
    with col4:
        urgent_count = len(df_patients[df_patients['URGENCY_LEVEL'].isin(['IMMEDIATE', 'URGENT'])])
        st.metric(
            label="Urgent Attention",
            value=f"{urgent_count:,}"
        )
    
    st.divider()
    
    # ========================================================================
    # RISK DISTRIBUTION CHARTS
    # ========================================================================
    st.header("Risk Analysis")
    
    col_left, col_right = st.columns(2)
    
    with col_left:
        st.subheader("Patients by Risk Category")
        if not df_risk_summary.empty:
            color_scale = alt.Scale(
                domain=['CRITICAL', 'HIGH', 'MEDIUM', 'LOW'],
                range=['#dc3545', '#fd7e14', '#ffc107', '#28a745']
            )
            
            chart_risk = alt.Chart(df_risk_summary).mark_arc(innerRadius=50).encode(
                theta=alt.Theta('PATIENT_COUNT:Q'),
                color=alt.Color('RISK_CATEGORY:N', scale=color_scale, legend=alt.Legend(title="Risk Level")),
                tooltip=['RISK_CATEGORY', 'PATIENT_COUNT']
            ).properties(height=300)
            
            st.altair_chart(chart_risk, use_container_width=True)
    
    with col_right:
        st.subheader("Risk Score Distribution")
        if not df_patients.empty:
            chart_hist = alt.Chart(df_patients).mark_bar().encode(
                x=alt.X('CURRENT_RISK_SCORE:Q', bin=alt.Bin(maxbins=20), title='Risk Score'),
                y=alt.Y('count()', title='Patient Count'),
                color=alt.value('#1f77b4')
            ).properties(height=300)
            
            st.altair_chart(chart_hist, use_container_width=True)
    
    st.divider()
    
    # ========================================================================
    # HIGH-RISK PATIENT WATCHLIST
    # ========================================================================
    st.header("High-Risk Patient Watchlist")
    
    if not df_high_risk.empty:
        st.dataframe(
            df_high_risk[[
                'PRIORITY_RANK', 'FULL_NAME', 'AGE', 'GENDER',
                'CURRENT_RISK_SCORE', 'CURRENT_RISK_CATEGORY',
                'PRIMARY_RISK_FACTOR', 'URGENCY_LEVEL', 'RECOMMENDED_ACTION'
            ]],
            column_config={
                "PRIORITY_RANK": st.column_config.NumberColumn("Rank", width="small"),
                "FULL_NAME": st.column_config.TextColumn("Patient Name", width="medium"),
                "AGE": st.column_config.NumberColumn("Age", width="small"),
                "GENDER": st.column_config.TextColumn("Gender", width="small"),
                "CURRENT_RISK_SCORE": st.column_config.ProgressColumn(
                    "Risk Score",
                    min_value=0,
                    max_value=100,
                    format="%d"
                ),
                "CURRENT_RISK_CATEGORY": st.column_config.TextColumn("Category", width="small"),
                "PRIMARY_RISK_FACTOR": st.column_config.TextColumn("Primary Risk", width="medium"),
                "URGENCY_LEVEL": st.column_config.TextColumn("Urgency", width="small"),
                "RECOMMENDED_ACTION": st.column_config.TextColumn("Recommended Action", width="large")
            },
            hide_index=True,
            use_container_width=True
        )
    else:
        st.info("No high-risk patients found.")
    
    st.divider()
    
    # ========================================================================
    # DEPARTMENT PERFORMANCE
    # ========================================================================
    st.header("Department Performance")
    
    if not df_departments.empty:
        col_d1, col_d2 = st.columns(2)
        
        with col_d1:
            st.subheader("Visits by Department")
            chart_dept = alt.Chart(df_departments).mark_bar().encode(
                x=alt.X('TOTAL_VISITS:Q', title='Total Visits'),
                y=alt.Y('DEPARTMENT:N', sort='-x', title='Department'),
                color=alt.value('#17a2b8')
            ).properties(height=250)
            
            st.altair_chart(chart_dept, use_container_width=True)
        
        with col_d2:
            st.subheader("Revenue by Department")
            chart_revenue = alt.Chart(df_departments).mark_bar().encode(
                x=alt.X('TOTAL_REVENUE:Q', title='Revenue ($)'),
                y=alt.Y('DEPARTMENT:N', sort='-x', title='Department'),
                color=alt.value('#28a745')
            ).properties(height=250)
            
            st.altair_chart(chart_revenue, use_container_width=True)
        
        st.subheader("Department Metrics Summary")
        st.dataframe(
            df_departments,
            column_config={
                "DEPARTMENT": st.column_config.TextColumn("Department"),
                "TOTAL_VISITS": st.column_config.NumberColumn("Visits", format="%d"),
                "UNIQUE_PATIENTS": st.column_config.NumberColumn("Patients", format="%d"),
                "EMERGENCY_VISITS": st.column_config.NumberColumn("Emergency", format="%d"),
                "AVG_VISIT_DURATION_HRS": st.column_config.NumberColumn("Avg Duration (hrs)", format="%.1f"),
                "TOTAL_REVENUE": st.column_config.NumberColumn("Revenue", format="$%,.0f"),
                "AVG_CHARGE_PER_VISIT": st.column_config.NumberColumn("Avg Charge", format="$%,.0f"),
                "FOLLOW_UP_RATE_PCT": st.column_config.ProgressColumn(
                    "Follow-up Rate",
                    min_value=0,
                    max_value=100,
                    format="%.1f%%"
                )
            },
            hide_index=True,
            use_container_width=True
        )
    
    st.divider()
    
    # ========================================================================
    # AI INSIGHTS SECTION
    # ========================================================================
    st.header(":material/smart_toy: AI-Generated Insights")
    
    if not df_ai_insights.empty:
        for idx, row in df_ai_insights.iterrows():
            with st.expander(f"Patient: {row['FULL_NAME']} - Risk: {row['RISK_CATEGORY']}"):
                st.markdown("**AI Risk Analysis:**")
                st.write(row['AI_RISK_ANALYSIS'] if row['AI_RISK_ANALYSIS'] else "Analysis pending...")
                
                st.markdown("**AI Recommended Actions:**")
                st.write(row['AI_RECOMMENDED_ACTIONS'] if row['AI_RECOMMENDED_ACTIONS'] else "Recommendations pending...")
    else:
        st.info("AI insights are being generated. Please run the AI-Ready layer SQL to populate insights.")
    
    # ========================================================================
    # FOOTER
    # ========================================================================
    st.divider()
    st.caption("Careview - Patient Risk Monitoring Platform | Powered by Snowflake Cortex AI")

else:
    st.warning("Please ensure the Careview database and tables are created by running the SQL files in order.")
    st.info("""
    **Setup Instructions:**
    1. Run SQL files 01-14 in order to set up the database
    2. The data pipeline follows: Bronze → Silver → Gold → AI-Ready
    3. Refresh this page after setup is complete
    """)
