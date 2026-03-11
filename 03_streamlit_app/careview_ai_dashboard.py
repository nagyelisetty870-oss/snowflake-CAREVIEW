import streamlit as st
from snowflake.snowpark.context import get_active_session
import pandas as pd

st.set_page_config(page_title="CareView Clinical Suite", page_icon="💊", layout="wide", initial_sidebar_state="expanded")

session = get_active_session()

st.markdown("""
<style>
    @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap');
    
    * { font-family: 'Poppins', sans-serif; }
    .block-container { padding: 0 2rem 1rem 2rem !important; max-width: 1600px; background: #f8f9fa; }
    .stApp { background: linear-gradient(135deg, #f8f9fa 0%, #f0f2f5 100%); }
    .stMainBlockContainer { padding-top: 0 !important; }
    
    [data-testid="stSidebar"] {
        background: linear-gradient(180deg, #4a6278 0%, #5d7b93 50%, #6b8ba3 100%);
        padding: 1rem;
    }
    [data-testid="stSidebar"] * { color: #f5f7f9 !important; }
    [data-testid="stSidebar"] .stRadio > label { font-weight: 500; letter-spacing: 0.3px; }
    [data-testid="stSidebar"] [data-testid="stMarkdownContainer"] p { color: #d1dbe5 !important; }
    [data-testid="stSidebar"] .stRadio > div { gap: 8px; }
    [data-testid="stSidebar"] .stRadio > div > label { 
        padding: 12px 16px !important; 
        border-radius: 8px !important; 
        transition: all 0.2s ease !important;
        font-size: 0.95em !important;
    }
    [data-testid="stSidebar"] .stRadio > div > label:hover { 
        background: rgba(255,255,255,0.1) !important; 
    }
    
    .sidebar-logo {
        text-align: center;
        padding: 25px 10px 30px 10px;
        border-bottom: 1px solid rgba(255,255,255,0.15);
        margin-bottom: 25px;
    }
    .sidebar-logo h1 {
        color: #ffffff !important;
        font-size: 1.6em;
        font-weight: 600;
        margin: 0;
        letter-spacing: 0.5px;
    }
    .sidebar-logo p {
        color: #d1dbe5 !important;
        font-size: 0.8em;
        margin: 8px 0 0 0;
        font-weight: 400;
        letter-spacing: 0.3px;
    }
    
    .top-bar {
        background: linear-gradient(135deg, #5d7b93 0%, #6b8ba3 100%);
        padding: 45px 35px;
        border-radius: 0 0 16px 16px;
        margin: 0 -2rem 25px -2rem;
        box-shadow: 0 4px 20px rgba(93,123,147,0.15);
        display: flex;
        justify-content: space-between;
        align-items: center;
        min-height: 120px;
        width: calc(100% + 4rem);
    }
    .top-bar h1 {
        color: white;
        font-size: 1.8em;
        font-weight: 600;
        margin: 0;
    }
    .top-bar-stats {
        display: flex;
        gap: 30px;
    }
    .top-stat {
        text-align: center;
        color: white;
    }
    .top-stat h3 {
        font-size: 1.8em;
        font-weight: 700;
        margin: 0;
    }
    .top-stat p {
        font-size: 0.85em;
        opacity: 0.9;
        margin: 2px 0 0 0;
    }
    
    .kpi-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 20px;
        margin-bottom: 25px;
    }
    .kpi-card {
        background: white;
        border-radius: 16px;
        padding: 24px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.06);
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
    }
    .kpi-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 4px;
        height: 100%;
    }
    .kpi-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 40px rgba(0,0,0,0.1);
    }
    .kpi-card h2 {
        font-size: 2.5em;
        font-weight: 700;
        margin: 0;
        line-height: 1;
    }
    .kpi-card p {
        color: #6c757d;
        font-size: 0.95em;
        margin: 8px 0 0 0;
        font-weight: 500;
    }
    .kpi-card .icon {
        position: absolute;
        top: 20px;
        right: 20px;
        font-size: 2.5em;
        opacity: 0.15;
    }
    
    .kpi-total::before { background: #5d7b93; }
    .kpi-total h2 { color: #5d7b93; }
    .kpi-high::before { background: #5d7b93; }
    .kpi-high h2 { color: #5d7b93; }
    .kpi-medium::before { background: #5d7b93; }
    .kpi-medium h2 { color: #5d7b93; }
    .kpi-low::before { background: #5d7b93; }
    .kpi-low h2 { color: #5d7b93; }
    
    .content-card {
        background: white;
        border-radius: 20px;
        padding: 25px 30px;
        box-shadow: 0 4px 25px rgba(0,0,0,0.05);
        margin-bottom: 20px;
        border: 1px solid rgba(0,0,0,0.05);
    }
    .content-card h3 {
        color: #2c3e50;
        font-size: 1.2em;
        font-weight: 600;
        margin: 0 0 20px 0;
        padding-bottom: 15px;
        border-bottom: 2px solid #ecf0f1;
    }
    
    .patient-card {
        background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
        border-radius: 16px;
        padding: 20px 24px;
        margin: 12px 0;
        border-left: 5px solid;
        transition: all 0.3s ease;
        box-shadow: 0 2px 15px rgba(0,0,0,0.04);
    }
    .patient-card:hover {
        transform: translateX(8px);
        box-shadow: 0 8px 30px rgba(0,0,0,0.08);
    }
    .patient-high { border-left-color: #5d7b93; background: linear-gradient(135deg, #ffffff 0%, #f5f8fa 100%); }
    .patient-medium { border-left-color: #6b8ba3; background: linear-gradient(135deg, #ffffff 0%, #f5f8fa 100%); }
    .patient-low { border-left-color: #7a9ab3; background: linear-gradient(135deg, #ffffff 0%, #f5f8fa 100%); }
    
    .patient-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;
    }
    .patient-name {
        font-size: 1.15em;
        font-weight: 600;
        color: #2c3e50;
    }
    .patient-info {
        color: #6c757d;
        font-size: 0.9em;
        line-height: 1.6;
    }
    
    .badge {
        padding: 6px 14px;
        border-radius: 20px;
        font-size: 0.8em;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .badge-urgent { background: #5d7b93; color: white; }
    .badge-moderate { background: #6b8ba3; color: white; }
    .badge-routine { background: #7a9ab3; color: white; }
    .badge-paid { background: #5d7b93; color: white; }
    .badge-pending { background: #8faabb; color: white; }
    .badge-insurance { background: #5d7b93; color: white; }
    
    .info-card {
        background: linear-gradient(135deg, #f8f9fa 0%, #ecf0f1 100%);
        border-radius: 14px;
        padding: 18px 22px;
        margin: 10px 0;
        border: 1px solid rgba(0,0,0,0.06);
    }
    
    .doctor-card {
        background: white;
        border-radius: 16px;
        padding: 20px;
        margin: 12px 0;
        box-shadow: 0 4px 15px rgba(0,0,0,0.04);
        border: 1px solid #ecf0f1;
        transition: all 0.3s ease;
    }
    .doctor-card:hover {
        box-shadow: 0 8px 30px rgba(0,0,0,0.08);
        border-color: #5d7b93;
    }
    
    .dept-card {
        background: linear-gradient(135deg, #5d7b93 0%, #6b8ba3 100%);
        border-radius: 16px;
        padding: 22px;
        margin: 12px 0;
        color: white;
        transition: all 0.3s ease;
        border: 1px solid rgba(255,255,255,0.1);
    }
    .dept-card:hover {
        transform: scale(1.02);
        box-shadow: 0 12px 40px rgba(93,123,147,0.25);
    }
    .dept-card h4 {
        color: #ffffff;
        font-size: 1.2em;
        margin: 0 0 12px 0;
    }
    .dept-card p {
        color: #e8eef3;
        font-size: 0.9em;
        line-height: 1.6;
        margin: 0;
    }
    
    .bill-item {
        background: white;
        border-radius: 12px;
        padding: 16px 20px;
        margin: 10px 0;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 2px 10px rgba(0,0,0,0.04);
        border: 1px solid #ecf0f1;
        transition: all 0.2s ease;
    }
    .bill-item:hover {
        border-color: #5d7b93;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    }
    
    .visit-timeline {
        position: relative;
        padding-left: 30px;
    }
    .visit-timeline::before {
        content: '';
        position: absolute;
        left: 8px;
        top: 0;
        bottom: 0;
        width: 2px;
        background: #5d7b93;
    }
    .visit-item {
        position: relative;
        background: white;
        border-radius: 12px;
        padding: 16px 20px;
        margin: 15px 0;
        box-shadow: 0 2px 15px rgba(0,0,0,0.04);
        border: 1px solid #ecf0f1;
    }
    .visit-item::before {
        content: '';
        position: absolute;
        left: -26px;
        top: 20px;
        width: 12px;
        height: 12px;
        background: #5d7b93;
        border-radius: 50%;
        border: 3px solid white;
        box-shadow: 0 2px 8px rgba(93,123,147,0.3);
    }
    
    .diagnosis-chip {
        display: inline-block;
        background: linear-gradient(135deg, #f8f9fa 0%, #ecf0f1 100%);
        border-radius: 10px;
        padding: 12px 18px;
        margin: 6px 4px;
        border: 1px solid #dee2e6;
    }
    
    .severity-critical { background: #5d7b93; color: white; padding: 4px 12px; border-radius: 6px; font-size: 0.75em; font-weight: 600; }
    .severity-severe { background: #6b8ba3; color: white; padding: 4px 12px; border-radius: 6px; font-size: 0.75em; font-weight: 600; }
    .severity-moderate { background: #7a9ab3; color: white; padding: 4px 12px; border-radius: 6px; font-size: 0.75em; font-weight: 600; }
    .severity-mild { background: #8faabb; color: white; padding: 4px 12px; border-radius: 6px; font-size: 0.75em; font-weight: 600; }
    
    .avail-badge {
        padding: 5px 12px;
        border-radius: 15px;
        font-size: 0.8em;
        font-weight: 600;
    }
    .avail-free { background: #e8eef3; color: #5d7b93; }
    .avail-busy { background: #d1dbe5; color: #4a6278; }
    .avail-full { background: #c4d1dc; color: #3d5468; }
    
    .footer-bar {
        background: linear-gradient(135deg, #5d7b93 0%, #6b8ba3 100%);
        padding: 20px 30px;
        border-radius: 16px;
        margin-top: 30px;
        text-align: center;
        color: #e8eef3;
    }
    .footer-bar span { color: #ffffff; font-weight: 600; }
    
    div[data-testid="stMetric"] {
        background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
        padding: 18px 22px;
        border-radius: 14px;
        border: 1px solid #dee2e6;
        box-shadow: 0 2px 10px rgba(0,0,0,0.04);
    }
    
    .stSelectbox > div > div { border-radius: 10px; border-color: #dee2e6; }
    .stExpander { border-radius: 12px; border: 1px solid #dee2e6; background: white; }
    
    .section-title {
        color: #5d7b93;
        font-size: 1.3em;
        font-weight: 600;
        margin: 25px 0 15px 0;
        padding-bottom: 10px;
        border-bottom: 3px solid #5d7b93;
        display: inline-block;
    }
</style>
""", unsafe_allow_html=True)

with st.sidebar:
    st.markdown("""
    <div class="sidebar-logo">
        <h1>CareView</h1>
        <p>Clinical Intelligence Suite</p>
    </div>
    """, unsafe_allow_html=True)
    
    page = st.radio(
        "Navigation",
        ["Dashboard", "Risk Monitor", "Patient Profiles", "Billing Center", "Operations"],
        label_visibility="collapsed"
    )
    
    st.markdown("---")
    st.markdown("**Quick Stats**")
    st.markdown("Last Updated: Now")
    st.markdown("Data Status: Live")

@st.cache_data(ttl=300)
def load_patient_risk():
    return session.sql("""
        SELECT PATIENT_ID, FULL_NAME, AGE, AGE_GROUP, GENDER, DIAGNOSIS_COUNT,
               HIGH_RISK_COUNT, CHRONIC_COUNT, MEDICATION_COUNT, VISIT_COUNT, RISK_LEVEL
        FROM CAREVIEW_DB.CAREVIEW_SCH_GOLD.GOLD_PATIENT_RISK 
        ORDER BY RISK_LEVEL DESC, HIGH_RISK_COUNT DESC
    """).to_pandas()

@st.cache_data(ttl=300)
def load_patient_summary():
    return session.sql("""
        SELECT PATIENT_ID, FULL_NAME, AGE, AGE_GROUP, GENDER, CITY, INSURANCE_TYPE,
               TOTAL_VISITS, TOTAL_DIAGNOSES, TOTAL_TREATMENTS, TOTAL_MEDICATIONS,
               TOTAL_TREATMENT_COST, TOTAL_BILLED
        FROM CAREVIEW_DB.CAREVIEW_SCH_GOLD.GOLD_PATIENT_SUMMARY 
        ORDER BY TOTAL_BILLED DESC NULLS LAST
    """).to_pandas()

@st.cache_data(ttl=300)
def load_billing_summary():
    return session.sql("""
        SELECT SERVICE_TYPE, PAYMENT_STATUS, INSURANCE_TYPE, BILL_COUNT, PATIENT_COUNT, TOTAL_AMOUNT, AVG_AMOUNT
        FROM CAREVIEW_DB.CAREVIEW_SCH_GOLD.GOLD_BILLING_ANALYSIS 
        ORDER BY TOTAL_AMOUNT DESC
    """).to_pandas()

@st.cache_data(ttl=300)
def load_department_summary():
    return session.sql("""
        SELECT DEPARTMENT_ID, DEPARTMENT_NAME, BUILDING, BED_COUNT, TOTAL_DOCTORS,
               TOTAL_VISITS, TOTAL_PATIENTS, TOTAL_REVENUE
        FROM CAREVIEW_DB.CAREVIEW_SCH_GOLD.GOLD_DEPARTMENT_SUMMARY 
        ORDER BY TOTAL_REVENUE DESC NULLS LAST
    """).to_pandas()

@st.cache_data(ttl=300)
def load_doctor_performance():
    return session.sql("""
        SELECT DOCTOR_ID, DOCTOR_NAME, SPECIALIZATION, EXPERIENCE_YRS, EXPERIENCE_LEVEL,
               DEPARTMENT_NAME, TOTAL_PATIENTS, TOTAL_VISITS, TOTAL_PRESCRIPTIONS
        FROM CAREVIEW_DB.CAREVIEW_SCH_GOLD.GOLD_DOCTOR_SUMMARY 
        ORDER BY TOTAL_PATIENTS DESC
    """).to_pandas()

@st.cache_data(ttl=300)
def load_patient_bills(patient_id):
    return session.sql(f"""
        SELECT b.BILL_ID, b.SERVICE_TYPE, b.AMOUNT, b.PAYMENT_STATUS, v.VISIT_DATE, d.DOCTOR_NAME
        FROM CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_BILLING b
        JOIN CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_VISITS v ON b.VISIT_ID = v.VISIT_ID
        LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_DOCTORS d ON v.DOCTOR_ID = d.DOCTOR_ID
        WHERE b.PATIENT_ID = {patient_id}
        ORDER BY v.VISIT_DATE DESC
    """).to_pandas()

@st.cache_data(ttl=300)
def load_patient_visits(patient_id):
    return session.sql(f"""
        SELECT v.VISIT_DATE, v.VISIT_TYPE, v.ADMISSION_REASON, v.STATUS,
               d.DOCTOR_NAME, d.SPECIALIZATION, dept.DEPARTMENT_NAME
        FROM CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_VISITS v
        LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_DOCTORS d ON v.DOCTOR_ID = d.DOCTOR_ID
        LEFT JOIN CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_DEPARTMENTS dept ON v.DEPARTMENT_ID = dept.DEPARTMENT_ID
        WHERE v.PATIENT_ID = {patient_id}
        ORDER BY v.VISIT_DATE DESC
    """).to_pandas()

@st.cache_data(ttl=300)
def load_patient_treatments(patient_id):
    return session.sql(f"""
        SELECT t.TREATMENT_NAME, t.TREATMENT_TYPE, t.OUTCOME, t.COST, v.VISIT_DATE
        FROM CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_TREATMENTS t
        JOIN CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_VISITS v ON t.VISIT_ID = v.VISIT_ID
        WHERE t.PATIENT_ID = {patient_id}
        ORDER BY v.VISIT_DATE DESC
    """).to_pandas()

@st.cache_data(ttl=300)
def load_patient_diagnoses(patient_id):
    return session.sql(f"""
        SELECT diag.DIAGNOSIS_NAME, diag.SEVERITY, diag.IS_CHRONIC, v.VISIT_DATE
        FROM CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_DIAGNOSES diag
        JOIN CAREVIEW_DB.CAREVIEW_SCH_BRONZE.BRONZE_VISITS v ON diag.VISIT_ID = v.VISIT_ID
        WHERE diag.PATIENT_ID = {patient_id}
        ORDER BY v.VISIT_DATE DESC
    """).to_pandas()

risk_df = load_patient_risk()
summary_df = load_patient_summary()
billing_df = load_billing_summary()
dept_df = load_department_summary()
doctor_df = load_doctor_performance()

high_risk = len(risk_df[risk_df['RISK_LEVEL'] == 'HIGH'])
medium_risk = len(risk_df[risk_df['RISK_LEVEL'] == 'MEDIUM'])
low_risk = len(risk_df[risk_df['RISK_LEVEL'] == 'LOW'])
total_revenue = billing_df['TOTAL_AMOUNT'].sum()

if page == "Dashboard":
    st.markdown(f"""
    <div class="top-bar">
        <div>
            <h1>Welcome to CareView</h1>
            <p style="color:rgba(255,255,255,0.9);margin:5px 0 0 0;">Real-time clinical intelligence at your fingertips</p>
        </div>
        <div class="top-bar-stats">
            <div class="top-stat">
                <h3>{len(risk_df)}</h3>
                <p>Active Patients</p>
            </div>
            <div class="top-stat">
                <h3>${total_revenue/1000:.0f}K</h3>
                <p>Total Revenue</p>
            </div>
            <div class="top-stat">
                <h3>{len(dept_df)}</h3>
                <p>Departments</p>
            </div>
        </div>
    </div>
    """, unsafe_allow_html=True)
    
    st.markdown(f"""
    <div class="kpi-grid">
        <div class="kpi-card kpi-total">
            <h2>{len(risk_df)}</h2>
            <p>Total Patients</p>
        </div>
        <div class="kpi-card kpi-high">
            <h2>{high_risk}</h2>
            <p>High Risk</p>
        </div>
        <div class="kpi-card kpi-medium">
            <h2>{medium_risk}</h2>
            <p>Medium Risk</p>
        </div>
        <div class="kpi-card kpi-low">
            <h2>{low_risk}</h2>
            <p>Low Risk</p>
        </div>
    </div>
    """, unsafe_allow_html=True)
    
    col1, col2 = st.columns(2)
    with col1:
        st.markdown('<div class="content-card"><h3>Risk Distribution</h3>', unsafe_allow_html=True)
        risk_counts = risk_df['RISK_LEVEL'].value_counts().reset_index()
        risk_counts.columns = ['Risk Level', 'Count']
        st.bar_chart(risk_counts.set_index('Risk Level'), color='#5d7b93', height=280)
        st.markdown('</div>', unsafe_allow_html=True)
    
    with col2:
        st.markdown('<div class="content-card"><h3>Revenue by Status</h3>', unsafe_allow_html=True)
        status_summary = billing_df.groupby('PAYMENT_STATUS')['TOTAL_AMOUNT'].sum().reset_index()
        status_summary.columns = ['Status', 'Amount']
        st.bar_chart(status_summary.set_index('Status'), color='#5d7b93', height=280)
        st.markdown('</div>', unsafe_allow_html=True)
    
    st.markdown('<div class="content-card"><h3>Department Performance</h3>', unsafe_allow_html=True)
    cols = st.columns(3)
    for i, (_, d) in enumerate(dept_df.head(6).iterrows()):
        with cols[i % 3]:
            rev = f"${d['TOTAL_REVENUE']:,.0f}" if pd.notna(d['TOTAL_REVENUE']) else "N/A"
            st.markdown(f"""
            <div class="dept-card">
                <h4>{d['DEPARTMENT_NAME']}</h4>
                <p><b>Beds:</b> {d['BED_COUNT']} | <b>Doctors:</b> {d['TOTAL_DOCTORS']} | <b>Revenue:</b> {rev}</p>
            </div>
            """, unsafe_allow_html=True)
    st.markdown('</div>', unsafe_allow_html=True)

elif page == "Risk Monitor":
    st.markdown("""
    <div class="top-bar">
        <div>
            <h1>Risk Monitor</h1>
            <p style="color:rgba(255,255,255,0.9);margin:5px 0 0 0;">Real-time patient risk assessment & alerts</p>
        </div>
    </div>
    """, unsafe_allow_html=True)
    
    risk_filter = st.selectbox("Filter by Risk Level", ["All Patients", "HIGH", "MEDIUM", "LOW"])
    
    filtered_risk = risk_df if risk_filter == "All Patients" else risk_df[risk_df['RISK_LEVEL'] == risk_filter]
    
    for _, patient in filtered_risk.iterrows():
        risk_level = patient['RISK_LEVEL']
        card_class = "patient-high" if risk_level == 'HIGH' else "patient-medium" if risk_level == 'MEDIUM' else "patient-low"
        badge_class = "badge-urgent" if risk_level == 'HIGH' else "badge-moderate" if risk_level == 'MEDIUM' else "badge-routine"
        badge_text = "URGENT" if risk_level == 'HIGH' else "MODERATE" if risk_level == 'MEDIUM' else "ROUTINE"
        
        st.markdown(f"""
        <div class="patient-card {card_class}">
            <div class="patient-header">
                <span class="patient-name">{patient['FULL_NAME']}</span>
                <span class="badge {badge_class}">{badge_text}</span>
            </div>
            <p class="patient-info">
                <b>ID:</b> {patient['PATIENT_ID']} | <b>Age:</b> {patient['AGE']} ({patient['AGE_GROUP']}) | 
                <b>High Risk Dx:</b> {patient['HIGH_RISK_COUNT']} | <b>Chronic:</b> {patient['CHRONIC_COUNT']} | 
                <b>Medications:</b> {patient['MEDICATION_COUNT']}
            </p>
        </div>
        """, unsafe_allow_html=True)
        
        with st.expander(f"View Care Plan for {patient['FULL_NAME']}"):
            if risk_level == 'HIGH':
                st.error("**IMMEDIATE ACTION REQUIRED**")
                st.markdown("""
                - Schedule urgent follow-up within **48 hours**
                - Monitor vitals **every 4-6 hours**
                - Complete medication review
                - Consider specialist referral
                """)
            elif risk_level == 'MEDIUM':
                st.warning("**Monitoring Required**")
                st.markdown("""
                - Schedule follow-up within **1 week**
                - Weekly vital sign monitoring
                - Review current medications
                """)
            else:
                st.success("**Routine Care**")
                st.markdown("- Continue standard care plan")

elif page == "Patient Profiles":
    st.markdown("""
    <div class="top-bar">
        <div>
            <h1>Patient Profiles</h1>
            <p style="color:rgba(255,255,255,0.9);margin:5px 0 0 0;">Comprehensive patient information & history</p>
        </div>
    </div>
    """, unsafe_allow_html=True)
    
    patient_options = summary_df.apply(lambda x: f"{x['PATIENT_ID']} - {x['FULL_NAME']}", axis=1).tolist()
    selected = st.selectbox("Search Patient", patient_options)
    patient_id = int(selected.split(" - ")[0])
    
    patient = summary_df[summary_df['PATIENT_ID'] == patient_id].iloc[0]
    risk_data = risk_df[risk_df['PATIENT_ID'] == patient_id]
    risk_level = risk_data['RISK_LEVEL'].values[0] if len(risk_data) > 0 else "LOW"
    
    card_class = "patient-high" if risk_level == 'HIGH' else "patient-medium" if risk_level == 'MEDIUM' else "patient-low"
    
    st.markdown(f"""
    <div class="patient-card {card_class}" style="margin-bottom:25px;">
        <h2 style="margin:0 0 10px 0;color:#2c3e50;">{patient['FULL_NAME']}</h2>
        <p class="patient-info" style="font-size:1em;">
            <b>Patient ID:</b> {patient['PATIENT_ID']} | <b>Age:</b> {patient['AGE']} ({patient['AGE_GROUP']}) | 
            <b>Gender:</b> {patient['GENDER']} | <b>Location:</b> {patient['CITY']} | <b>Insurance:</b> {patient['INSURANCE_TYPE']}
        </p>
    </div>
    """, unsafe_allow_html=True)
    
    col1, col2, col3, col4 = st.columns(4)
    col1.metric("Visits", patient['TOTAL_VISITS'])
    col2.metric("Diagnoses", patient['TOTAL_DIAGNOSES'])
    col3.metric("Medications", patient['TOTAL_MEDICATIONS'])
    col4.metric("Total Billed", f"${patient['TOTAL_BILLED']:,.2f}" if pd.notna(patient['TOTAL_BILLED']) else "$0")
    
    st.markdown('<div class="content-card"><h3>Visit Timeline</h3>', unsafe_allow_html=True)
    visits = load_patient_visits(patient_id)
    if len(visits) > 0:
        st.markdown('<div class="visit-timeline">', unsafe_allow_html=True)
        for _, v in visits.iterrows():
            st.markdown(f"""
            <div class="visit-item">
                <div style="display:flex;justify-content:space-between;align-items:center;">
                    <b style="color:#5d7b93;">{v['VISIT_DATE']}</b>
                    <span style="background:#ecf0f1;color:#5d7b93;padding:4px 12px;border-radius:20px;font-size:0.8em;font-weight:600;">{v['VISIT_TYPE']}</span>
                </div>
                <p style="margin:8px 0 0 0;color:#6c757d;">
                    <b>Dept:</b> {v['DEPARTMENT_NAME']} | <b>Dr.</b> {v['DOCTOR_NAME']} ({v['SPECIALIZATION']}) | <b>Reason:</b> {v['ADMISSION_REASON']}
                </p>
            </div>
            """, unsafe_allow_html=True)
        st.markdown('</div>', unsafe_allow_html=True)
    else:
        st.info("No visits recorded")
    st.markdown('</div>', unsafe_allow_html=True)
    
    col1, col2 = st.columns(2)
    with col1:
        st.markdown('<div class="content-card"><h3>Diagnoses</h3>', unsafe_allow_html=True)
        diagnoses = load_patient_diagnoses(patient_id)
        if len(diagnoses) > 0:
            for _, d in diagnoses.iterrows():
                sev = d['SEVERITY']
                sev_class = "severity-critical" if sev == 'Critical' else "severity-severe" if sev == 'Severe' else "severity-moderate" if sev == 'Moderate' else "severity-mild"
                chronic = ' | <span style="background:#5d7b93;color:white;padding:2px 8px;border-radius:4px;font-size:0.7em;">CHRONIC</span>' if d['IS_CHRONIC'] == 'Yes' else ''
                st.markdown(f"""
                <div class="diagnosis-chip">
                    <b>{d['DIAGNOSIS_NAME']}</b> <span class="{sev_class}">{sev}</span>{chronic}
                    <br><small style="color:#6c757d;">{d['VISIT_DATE']}</small>
                </div>
                """, unsafe_allow_html=True)
        else:
            st.info("No diagnoses")
        st.markdown('</div>', unsafe_allow_html=True)
    
    with col2:
        st.markdown('<div class="content-card"><h3>Treatments</h3>', unsafe_allow_html=True)
        treatments = load_patient_treatments(patient_id)
        if len(treatments) > 0:
            for _, t in treatments.iterrows():
                outcome_class = "badge-paid" if t['OUTCOME'] == 'Successful' else "badge-pending"
                st.markdown(f"""
                <div class="diagnosis-chip">
                    <b>{t['TREATMENT_NAME']}</b> <span class="badge {outcome_class}" style="font-size:0.7em;">{t['OUTCOME']}</span>
                    <br><small style="color:#6c757d;">{t['TREATMENT_TYPE']} | ${t['COST']:,.2f} | {t['VISIT_DATE']}</small>
                </div>
                """, unsafe_allow_html=True)
        else:
            st.info("No treatments")
        st.markdown('</div>', unsafe_allow_html=True)

elif page == "Billing Center":
    st.markdown("""
    <div class="top-bar">
        <div>
            <h1>Billing Center</h1>
            <p style="color:rgba(255,255,255,0.9);margin:5px 0 0 0;">Financial management & billing analytics</p>
        </div>
    </div>
    """, unsafe_allow_html=True)
    
    bill_options = summary_df.apply(lambda x: f"{x['PATIENT_ID']} - {x['FULL_NAME']}", axis=1).tolist()
    selected_bill = st.selectbox("Select Patient", bill_options, key="bill_select")
    bill_patient_id = int(selected_bill.split(" - ")[0])
    
    bills = load_patient_bills(bill_patient_id)
    if len(bills) > 0:
        total = bills['AMOUNT'].sum()
        paid = bills[bills['PAYMENT_STATUS'] == 'Paid']['AMOUNT'].sum()
        insurance = bills[bills['PAYMENT_STATUS'] == 'Insurance']['AMOUNT'].sum()
        pending = total - paid - insurance
        
        col1, col2, col3, col4 = st.columns(4)
        col1.metric("Total", f"${total:,.2f}")
        col2.metric("Paid", f"${paid:,.2f}")
        col3.metric("Insurance", f"${insurance:,.2f}")
        col4.metric("Outstanding", f"${pending:,.2f}")
        
        st.markdown('<div class="content-card"><h3>Itemized Bills</h3>', unsafe_allow_html=True)
        for _, b in bills.iterrows():
            badge_class = "badge-paid" if b['PAYMENT_STATUS'] == 'Paid' else "badge-insurance" if b['PAYMENT_STATUS'] == 'Insurance' else "badge-pending"
            st.markdown(f"""
            <div class="bill-item">
                <div>
                    <b style="color:#2c3e50;">#{b['BILL_ID']} - {b['SERVICE_TYPE']}</b>
                    <p style="margin:4px 0 0 0;color:#6c757d;font-size:0.9em;">{b['VISIT_DATE']}</p>
                </div>
                <div style="text-align:right;">
                    <b style="font-size:1.2em;color:#2c3e50;">${b['AMOUNT']:,.2f}</b>
                    <br><span class="badge {badge_class}">{b['PAYMENT_STATUS']}</span>
                </div>
            </div>
            """, unsafe_allow_html=True)
        st.markdown('</div>', unsafe_allow_html=True)
    else:
        st.info("No billing records found")
    
    col1, col2 = st.columns(2)
    with col1:
        st.markdown('<div class="content-card"><h3>Revenue by Service</h3>', unsafe_allow_html=True)
        svc = billing_df.groupby('SERVICE_TYPE')['TOTAL_AMOUNT'].sum().reset_index()
        svc.columns = ['Service', 'Amount']
        st.bar_chart(svc.set_index('Service'), color='#5d7b93', height=280)
        st.markdown('</div>', unsafe_allow_html=True)
    with col2:
        st.markdown('<div class="content-card"><h3>Revenue by Insurance</h3>', unsafe_allow_html=True)
        ins = billing_df.groupby('INSURANCE_TYPE')['TOTAL_AMOUNT'].sum().reset_index()
        ins.columns = ['Insurance', 'Amount']
        st.bar_chart(ins.set_index('Insurance'), color='#5d7b93', height=280)
        st.markdown('</div>', unsafe_allow_html=True)

elif page == "Operations":
    st.markdown("""
    <div class="top-bar">
        <div>
            <h1>Operations Center</h1>
            <p style="color:rgba(255,255,255,0.9);margin:5px 0 0 0;">Department & staff management</p>
        </div>
    </div>
    """, unsafe_allow_html=True)
    
    col1, col2, col3, col4 = st.columns(4)
    col1.metric("Departments", len(dept_df))
    col2.metric("Physicians", int(dept_df['TOTAL_DOCTORS'].sum()))
    col3.metric("Bed Capacity", int(dept_df['BED_COUNT'].sum()))
    total_rev = dept_df['TOTAL_REVENUE'].sum()
    col4.metric("Revenue", f"${total_rev:,.0f}" if pd.notna(total_rev) else "$0")
    
    st.markdown('<div class="content-card"><h3>Departments</h3>', unsafe_allow_html=True)
    cols = st.columns(2)
    for i, (_, d) in enumerate(dept_df.iterrows()):
        with cols[i % 2]:
            rev = f"${d['TOTAL_REVENUE']:,.0f}" if pd.notna(d['TOTAL_REVENUE']) else "N/A"
            st.markdown(f"""
            <div class="dept-card">
                <h4>{d['DEPARTMENT_NAME']}</h4>
                <p>
                    {d['BUILDING']} | {d['BED_COUNT']} beds | {d['TOTAL_DOCTORS']} doctors<br>
                    {d['TOTAL_PATIENTS']} patients | {rev}
                </p>
            </div>
            """, unsafe_allow_html=True)
    st.markdown('</div>', unsafe_allow_html=True)
    
    st.markdown('<div class="content-card"><h3>Physician Directory</h3>', unsafe_allow_html=True)
    dept_filter = st.selectbox("Filter by Department", ["All"] + doctor_df['DEPARTMENT_NAME'].unique().tolist())
    filtered_docs = doctor_df if dept_filter == "All" else doctor_df[doctor_df['DEPARTMENT_NAME'] == dept_filter]
    
    schedule = {'Senior': '8:00 AM - 4:00 PM', 'Mid-Level': '9:00 AM - 5:00 PM', 'Junior': '10:00 AM - 6:00 PM'}
    
    for _, doc in filtered_docs.iterrows():
        timing = schedule.get(doc['EXPERIENCE_LEVEL'], '9:00 AM - 5:00 PM')
        avail_class = "avail-free" if doc['TOTAL_PATIENTS'] < 10 else "avail-busy" if doc['TOTAL_PATIENTS'] < 20 else "avail-full"
        avail_text = "Available" if doc['TOTAL_PATIENTS'] < 10 else "Busy" if doc['TOTAL_PATIENTS'] < 20 else "Full"
        
        st.markdown(f"""
        <div class="doctor-card">
            <div style="display:flex;justify-content:space-between;align-items:center;">
                <b style="font-size:1.1em;color:#2c3e50;">{doc['DOCTOR_NAME']}</b>
                <span class="avail-badge {avail_class}">{avail_text}</span>
            </div>
            <p style="margin:10px 0 0 0;color:#6c757d;">
                {doc['SPECIALIZATION']} | {doc['DEPARTMENT_NAME']} | {doc['EXPERIENCE_YRS']} yrs ({doc['EXPERIENCE_LEVEL']})<br>
                {doc['TOTAL_PATIENTS']} patients | {doc['TOTAL_VISITS']} visits | {timing}
            </p>
        </div>
        """, unsafe_allow_html=True)
    st.markdown('</div>', unsafe_allow_html=True)

st.markdown("""
<div class="footer-bar">
    <p><span>CareView</span> Clinical Intelligence Suite</p>
</div>
""", unsafe_allow_html=True)
