"""
================================================================================
CAREVIEW HEALTHCARE ANALYTICS - GOLD LAYER DASHBOARD
================================================================================
Business metrics and KPIs from aggregated Gold layer data
================================================================================
"""

import streamlit as st
from snowflake.snowpark.context import get_active_session

# PAGE CONFIG
st.set_page_config(page_title="CareView Gold Analytics", page_icon="📊", layout="wide")

# SESSION
session = get_active_session()

# HEADER
st.title("Careview Business Analytics")
st.markdown("*Executive Metrics*")
st.divider()

# SIDEBAR NAVIGATION
page = st.sidebar.radio("Select Dashboard:", 
    ["Executive Summary", "Department Analytics", "Revenue Analysis", "Diagnosis Trends"])

# =============================================================================
# PAGE 1: EXECUTIVE SUMMARY
# =============================================================================
if page == "Executive Summary":
    st.header("Executive Summary")
    
    # KPI METRICS
    kpi_query = """
        SELECT 
            COUNT(*) AS TOTAL_PATIENTS,
            SUM(TOTAL_VISITS) AS TOTAL_VISITS,
            SUM(TOTAL_BILLED) AS TOTAL_REVENUE,
            SUM(OUTSTANDING_BALANCE) AS OUTSTANDING_AR
        FROM CAREVIEW_DB.GOLD.PATIENT_SUMMARY
    """
    kpi = session.sql(kpi_query).to_pandas()
    
    c1, c2, c3, c4 = st.columns(4)
    c1.metric("Total Patients", f"{int(kpi['TOTAL_PATIENTS'].iloc[0]):,}")
    c2.metric("Total Visits", f"{int(kpi['TOTAL_VISITS'].iloc[0]):,}")
    c3.metric("Total Revenue", f"${kpi['TOTAL_REVENUE'].iloc[0]:,.0f}")
    c4.metric("Outstanding AR", f"${kpi['OUTSTANDING_AR'].iloc[0]:,.0f}")
    
    st.divider()
    
    # DEPARTMENT REVENUE CHART
    st.subheader("Revenue by Department")
    dept_rev = session.sql("""
        SELECT DEPARTMENT, TOTAL_REVENUE 
        FROM CAREVIEW_DB.GOLD.DEPARTMENT_METRICS 
        ORDER BY TOTAL_REVENUE DESC
    """).to_pandas()
    st.bar_chart(dept_rev.set_index("DEPARTMENT"))

# =============================================================================
# PAGE 2: DEPARTMENT ANALYTICS
# =============================================================================
elif page == "Department Analytics":
    st.header("Department Performance")
    
    dept_df = session.sql("""
        SELECT 
            DEPARTMENT,
            TOTAL_VISITS,
            UNIQUE_PATIENTS,
            AVG_LENGTH_OF_STAY,
            EMERGENCY_VISITS,
            INPATIENT_VISITS,
            OUTPATIENT_VISITS,
            TOTAL_REVENUE,
            AVG_BILL_AMOUNT
        FROM CAREVIEW_DB.GOLD.DEPARTMENT_METRICS
        ORDER BY TOTAL_REVENUE DESC
    """).to_pandas()
    
    # DEPARTMENT SELECTOR
    selected = st.selectbox("Select Department:", dept_df['DEPARTMENT'].tolist())
    row = dept_df[dept_df['DEPARTMENT'] == selected].iloc[0]
    
    c1, c2, c3, c4 = st.columns(4)
    c1.metric("Total Visits", int(row['TOTAL_VISITS']))
    c2.metric("Unique Patients", int(row['UNIQUE_PATIENTS']))
    c3.metric("Avg Stay (Days)", f"{row['AVG_LENGTH_OF_STAY']:.1f}")
    c4.metric("Revenue", f"${row['TOTAL_REVENUE']:,.0f}")
    
    st.divider()
    
    # VISIT TYPE BREAKDOWN
    st.subheader("Visit Type Distribution")
    visit_types = {
        "Emergency": row['EMERGENCY_VISITS'],
        "Inpatient": row['INPATIENT_VISITS'],
        "Outpatient": row['OUTPATIENT_VISITS']
    }
    st.bar_chart(visit_types)
    
    # COMPARISON TABLE
    st.subheader("All Departments Comparison")
    st.dataframe(dept_df, use_container_width=True)

# =============================================================================
# PAGE 3: REVENUE ANALYSIS
# =============================================================================
elif page == "Revenue Analysis":
    st.header("Revenue & Collection Analysis")
    
    rev_df = session.sql("""
        SELECT 
            TO_CHAR(REVENUE_MONTH, 'YYYY-MM') AS MONTH,
            DEPARTMENT,
            TOTAL_AMOUNT,
            PAID_AMOUNT,
            PENDING_AMOUNT,
            COLLECTION_RATE_PCT
        FROM CAREVIEW_DB.GOLD.MONTHLY_REVENUE
        ORDER BY REVENUE_MONTH DESC
    """).to_pandas()
    
    # OVERALL METRICS
    totals = rev_df.agg({
        'TOTAL_AMOUNT': 'sum',
        'PAID_AMOUNT': 'sum',
        'PENDING_AMOUNT': 'sum'
    })
    
    c1, c2, c3 = st.columns(3)
    c1.metric("Total Billed", f"${totals['TOTAL_AMOUNT']:,.0f}")
    c2.metric("Collected", f"${totals['PAID_AMOUNT']:,.0f}")
    c3.metric("Pending", f"${totals['PENDING_AMOUNT']:,.0f}")
    
    st.divider()
    
    # MONTHLY TREND
    st.subheader("Monthly Revenue Trend")
    monthly = rev_df.groupby('MONTH')['TOTAL_AMOUNT'].sum()
    st.line_chart(monthly)
    
    # COLLECTION RATE BY DEPARTMENT
    st.subheader("Collection Rate by Department")
    st.dataframe(rev_df[['MONTH', 'DEPARTMENT', 'TOTAL_AMOUNT', 'COLLECTION_RATE_PCT']], 
                 use_container_width=True)

# =============================================================================
# PAGE 4: DIAGNOSIS TRENDS
# =============================================================================
elif page == "Diagnosis Trends":
    st.header("Diagnosis Analytics")
    
    diag_df = session.sql("""
        SELECT 
            DIAGNOSIS_CODE,
            DIAGNOSIS_NAME,
            DIAGNOSIS_COUNT,
            AFFECTED_PATIENTS,
            AVG_SEVERITY,
            CRITICAL_CASES,
            SEVERE_CASES
        FROM CAREVIEW_DB.GOLD.DIAGNOSIS_ANALYTICS
        ORDER BY DIAGNOSIS_COUNT DESC
    """).to_pandas()
    
    # TOP DIAGNOSES
    st.subheader("Top 10 Diagnoses by Frequency")
    st.bar_chart(diag_df.head(10).set_index('DIAGNOSIS_NAME')['DIAGNOSIS_COUNT'])
    
    # SEVERITY DISTRIBUTION
    st.subheader("High Severity Cases")
    high_sev = diag_df[diag_df['AVG_SEVERITY'] >= 2.5]
    st.dataframe(high_sev[['DIAGNOSIS_NAME', 'AVG_SEVERITY', 'CRITICAL_CASES', 'SEVERE_CASES']], 
                 use_container_width=True)
    
    # FULL TABLE
    st.subheader("All Diagnoses")
    st.dataframe(diag_df, use_container_width=True)

# FOOTER
st.divider()
st.caption("CareView Gold Layer Analytics | Business Intelligence Dashboard")