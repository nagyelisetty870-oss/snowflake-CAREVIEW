import streamlit as st
from snowflake.snowpark.context import get_active_session
import pandas as pd

st.set_page_config(page_title="CareView AI Dashboard", page_icon="🏥", layout="wide")

session = get_active_session()

st.markdown("""
<style>
    .block-container { padding-top: 1rem !important; }
    .main-header {
        background: linear-gradient(135deg, #1a4b6e 0%, #2563a0 100%);
        padding: 35px 30px;
        border-radius: 12px;
        margin: -20px 0 25px 0;
        text-align: center;
        box-shadow: 0 3px 12px rgba(26,75,110,0.25);
    }
    .main-header h1 { color: #ffffff; margin: 0; font-size: 2.5em; font-weight: 600; }
    .main-header p { color: #b8d4ed; margin: 8px 0 0 0; font-size: 1.1em; }
    .metric-card {
        background: #ffffff;
        padding: 18px;
        border-radius: 10px;
        border-left: 4px solid;
        box-shadow: 0 1px 4px rgba(0,0,0,0.06);
        margin-bottom: 12px;
    }
    .risk-high { border-left-color: #d4a5a5; background: linear-gradient(135deg, #ffffff 0%, #faf5f5 100%); }
    .risk-medium { border-left-color: #d4c4a5; background: linear-gradient(135deg, #ffffff 0%, #faf8f5 100%); }
    .risk-low { border-left-color: #a5d4b0; background: linear-gradient(135deg, #ffffff 0%, #f5faf7 100%); }
    .section-header {
        background: linear-gradient(135deg, #f5f8fb 0%, #eaf0f6 100%);
        padding: 12px 20px;
        border-radius: 8px;
        margin: 20px 0 15px 0;
        border-left: 4px solid #3b7cb8;
        font-weight: 600;
        color: #1a4b6e;
        cursor: help;
        position: relative;
    }
    .section-header:hover::after {
        content: attr(data-tooltip);
        position: absolute;
        left: 0;
        top: 100%;
        background: #1a4b6e;
        color: white;
        padding: 10px 14px;
        border-radius: 6px;
        font-size: 0.85em;
        font-weight: normal;
        white-space: nowrap;
        z-index: 100;
        box-shadow: 0 3px 10px rgba(0,0,0,0.2);
        margin-top: 5px;
    }
    .insight-box {
        background: linear-gradient(135deg, #f0f6fb 0%, #e5eef7 100%);
        padding: 18px;
        border-radius: 10px;
        margin: 10px 0;
        border: 1px solid #c5d8e8;
    }
    .precaution-box {
        background: linear-gradient(135deg, #faf8f5 0%, #f5f0e8 100%);
        padding: 15px;
        border-radius: 10px;
        margin: 10px 0;
        border: 1px solid #e0d5c5;
    }
    .medicine-card {
        background: linear-gradient(135deg, #f5faf7 0%, #eaf5ee 100%);
        padding: 12px 15px;
        border-radius: 8px;
        margin: 8px 0;
        border-left: 4px solid #7ab89a;
    }
    .condition-card {
        background: linear-gradient(135deg, #f5f8fb 0%, #e8f0f8 100%);
        padding: 15px;
        border-radius: 10px;
        margin: 10px 0;
        border: 1px solid #c5d5e5;
    }
    .stTabs [data-baseweb="tab-list"] {
        gap: 20px;
        background: linear-gradient(135deg, #1a4b6e 0%, #2563a0 100%);
        padding: 12px 20px;
        border-radius: 10px;
        justify-content: space-around;
    }
    .stTabs [data-baseweb="tab"] {
        background-color: rgba(255,255,255,0.12);
        border-radius: 8px;
        padding: 12px 28px;
        font-weight: 600;
        color: #ffffff;
        border: 1px solid rgba(255,255,255,0.2);
        flex: 1;
        justify-content: center;
    }
    .stTabs [data-baseweb="tab"]:hover {
        background-color: rgba(255,255,255,0.2);
    }
    .stTabs [aria-selected="true"] {
        background-color: #ffffff !important;
        color: #1a4b6e !important;
        border: 1px solid #ffffff !important;
    }
    .stat-box {
        background: linear-gradient(135deg, #f0f6fb 0%, #e5eef7 100%);
        padding: 22px;
        border-radius: 12px;
        text-align: center;
        border: 1px solid #c5d8e8;
        box-shadow: 0 2px 6px rgba(26,75,110,0.08);
    }
    .stat-box h2 { margin: 0; font-size: 2.2em; color: #1a4b6e; font-weight: 700; }
    .stat-box p { margin: 8px 0 0 0; color: #4a7a9e; font-size: 0.95em; font-weight: 500; }
    .stat-box-high { 
        border-color: #e5c5c5; 
        background: linear-gradient(135deg, #fdf8f8 0%, #f8f0f0 100%); 
    }
    .stat-box-high h2 { color: #8a5a5a; }
    .stat-box-high p { color: #a07070; }
    .stat-box-medium { 
        border-color: #e5dcc5; 
        background: linear-gradient(135deg, #fdfcf8 0%, #f8f5f0 100%); 
    }
    .stat-box-medium h2 { color: #7a6a4a; }
    .stat-box-medium p { color: #9a8a6a; }
    .stat-box-low { 
        border-color: #c5e5d0; 
        background: linear-gradient(135deg, #f8fdf9 0%, #f0f8f2 100%); 
    }
    .stat-box-low h2 { color: #4a7a5a; }
    .stat-box-low p { color: #6a9a7a; }
</style>
""", unsafe_allow_html=True)

st.markdown("""
<div class="main-header">
    <h1>🏥 CareView AI Clinical Dashboard</h1>
    <p>Real-time Patient Risk Monitoring & Clinical Intelligence</p>
</div>
""", unsafe_allow_html=True)

@st.cache_data(ttl=300)
def load_risk_data():
    return session.sql("SELECT * FROM CAREVIEW_DB.AI_READY.PATIENT_RISK_SCORES ORDER BY RISK_SCORE DESC").to_pandas()

@st.cache_data(ttl=300)
def load_visit_insights():
    return session.sql("SELECT * FROM CAREVIEW_DB.AI_READY.VISIT_INSIGHTS ORDER BY VISIT_DATE DESC").to_pandas()

@st.cache_data(ttl=300)
def load_clinical_intel():
    return session.sql("SELECT * FROM CAREVIEW_DB.AI_READY.CLINICAL_INTELLIGENCE ORDER BY DIAGNOSIS_COUNT DESC").to_pandas()

@st.cache_data(ttl=300)
def load_treatments(patient_id):
    return session.sql(f"SELECT * FROM CAREVIEW_DB.SILVER.TREATMENTS WHERE PATIENT_ID = '{patient_id}' ORDER BY TREATMENT_DATE DESC").to_pandas()

@st.cache_data(ttl=300)
def load_patient_visits(patient_id):
    return session.sql(f"SELECT * FROM CAREVIEW_DB.AI_READY.VISIT_INSIGHTS WHERE PATIENT_ID = '{patient_id}' ORDER BY VISIT_DATE DESC").to_pandas()

risk_df = load_risk_data()
visits_df = load_visit_insights()
clinical_df = load_clinical_intel()

high_risk = len(risk_df[risk_df['RISK_CATEGORY'] == 'HIGH'])
medium_risk = len(risk_df[risk_df['RISK_CATEGORY'] == 'MEDIUM'])
low_risk = len(risk_df[risk_df['RISK_CATEGORY'] == 'LOW'])

tab1, tab2, tab3, tab4, tab5 = st.tabs([
    "📊  Overview  ", "⚠️  Risk Monitor  ", "👤  Patient Details  ", "🧠  Clinical Insights  ", "📋  Visit Analytics  "
])

# ==================== TAB 1: OVERVIEW ====================
with tab1:
    st.markdown('<div class="section-header" data-tooltip="Summary of total patients and their risk categorization across the system">📈 Key Metrics at a Glance</div>', unsafe_allow_html=True)
    
    col1, col2, col3, col4 = st.columns(4)
    with col1:
        st.markdown(f'<div class="stat-box"><h2>{len(risk_df)}</h2><p>👥 Total Patients</p></div>', unsafe_allow_html=True)
    with col2:
        st.markdown(f'<div class="stat-box stat-box-high"><h2>{high_risk}</h2><p>🔴 High Risk</p></div>', unsafe_allow_html=True)
    with col3:
        st.markdown(f'<div class="stat-box stat-box-medium"><h2>{medium_risk}</h2><p>🟡 Medium Risk</p></div>', unsafe_allow_html=True)
    with col4:
        st.markdown(f'<div class="stat-box stat-box-low"><h2>{low_risk}</h2><p>🟢 Low Risk</p></div>', unsafe_allow_html=True)
    
    st.markdown('<div class="section-header" data-tooltip="Visual breakdown of patients by risk level and average age per category">🎯 Risk Distribution by Category</div>', unsafe_allow_html=True)
    col1, col2 = st.columns(2)
    with col1:
        risk_counts = risk_df['RISK_CATEGORY'].value_counts().reset_index()
        risk_counts.columns = ['Risk Category', 'Count']
        st.bar_chart(risk_counts.set_index('Risk Category'), color='#5a8ab8')
    with col2:
        age_risk = risk_df.groupby('RISK_CATEGORY')['AGE'].mean().reset_index()
        age_risk.columns = ['Risk Category', 'Avg Age']
        st.bar_chart(age_risk.set_index('Risk Category'), color='#7aa0c8')

    st.markdown('<div class="section-header" data-tooltip="Number of patient visits recorded across each hospital department">🏥 Department Visit Activity</div>', unsafe_allow_html=True)
    dept_counts = visits_df['DEPARTMENT'].value_counts().reset_index()
    dept_counts.columns = ['Department', 'Visits']
    st.bar_chart(dept_counts.set_index('Department'), color='#3b7cb8')

# ==================== TAB 2: RISK MONITOR ====================
with tab2:
    st.markdown('<div class="section-header" data-tooltip="Patients with critical risk scores requiring immediate medical intervention">🚨 High Risk Patients - Immediate Attention Required</div>', unsafe_allow_html=True)
    
    high_risk_patients = risk_df[risk_df['RISK_CATEGORY'] == 'HIGH'].sort_values('RISK_SCORE', ascending=False)
    
    if len(high_risk_patients) > 0:
        for _, patient in high_risk_patients.iterrows():
            st.markdown(f"""
            <div class="metric-card risk-high">
                <h4 style="margin:0; color:#7a4a4a;">🔴 {patient['FIRST_NAME']} {patient['LAST_NAME']} &nbsp;|&nbsp; ID: {patient['PATIENT_ID']}</h4>
                <p style="margin:8px 0 0 0; color:#5a5a5a;"><b>Risk Score:</b> {patient['RISK_SCORE']} &nbsp;|&nbsp; <b>Age:</b> {patient['AGE']} &nbsp;|&nbsp; <b>Visits:</b> {patient['TOTAL_VISITS']} &nbsp;|&nbsp; <b>Max Severity:</b> {patient['MAX_SEVERITY_LEVEL']}</p>
            </div>
            """, unsafe_allow_html=True)
            
            with st.expander(f"📋 View Details & Precautions for {patient['FIRST_NAME']}"):
                col1, col2 = st.columns(2)
                with col1:
                    st.markdown("""
                    <div class="precaution-box">
                        <h5 style="margin:0 0 10px 0; color:#6a5a4a;">⚠️ Immediate Precautions</h5>
                        <ul style="margin:0; padding-left:20px; color:#5a5a5a;">
                            <li>Schedule urgent follow-up within 48 hours</li>
                            <li>Monitor vital signs every 4-6 hours</li>
                            <li>Review and adjust current medications</li>
                            <li>Consider specialist referral</li>
                            <li>Alert emergency contact on file</li>
                        </ul>
                    </div>
                    """, unsafe_allow_html=True)
                with col2:
                    st.markdown("""
                    <div class="insight-box">
                        <h5 style="margin:0 0 10px 0; color:#1a4b6e;">✅ Risk Avoidance Steps</h5>
                        <ul style="margin:0; padding-left:20px; color:#5a5a5a;">
                            <li>Strict medication adherence</li>
                            <li>Daily symptom monitoring</li>
                            <li>Dietary modifications as advised</li>
                            <li>Regular physical activity</li>
                            <li>Stress management program</li>
                        </ul>
                    </div>
                    """, unsafe_allow_html=True)
                
                st.markdown("**🤖 AI Care Recommendation:**")
                st.info(patient['AI_RECOMMENDATION'])
    else:
        st.success("✅ No high-risk patients currently!")
    
    st.markdown('<div class="section-header" data-tooltip="Patients with moderate risk levels requiring regular monitoring and follow-up care">🟡 Medium Risk Patients - Monitoring Required</div>', unsafe_allow_html=True)
    medium_risk_patients = risk_df[risk_df['RISK_CATEGORY'] == 'MEDIUM'].sort_values('RISK_SCORE', ascending=False)
    
    for _, patient in medium_risk_patients.head(8).iterrows():
        st.markdown(f"""
        <div class="metric-card risk-medium">
            <h4 style="margin:0; color:#6a5a3a;">🟡 {patient['FIRST_NAME']} {patient['LAST_NAME']} &nbsp;|&nbsp; ID: {patient['PATIENT_ID']}</h4>
            <p style="margin:8px 0 0 0; color:#5a5a5a;"><b>Risk Score:</b> {patient['RISK_SCORE']} &nbsp;|&nbsp; <b>Age:</b> {patient['AGE']} &nbsp;|&nbsp; <b>Diagnoses:</b> {patient['TOTAL_DIAGNOSES']}</p>
        </div>
        """, unsafe_allow_html=True)

    st.markdown('<div class="section-header" data-tooltip="Patients with low risk scores who are currently stable with no immediate concerns">🟢 Low Risk Patients - Stable</div>', unsafe_allow_html=True)
    low_risk_patients = risk_df[risk_df['RISK_CATEGORY'] == 'LOW'].sort_values('RISK_SCORE', ascending=False)
    st.dataframe(low_risk_patients[['PATIENT_ID', 'FIRST_NAME', 'LAST_NAME', 'AGE', 'RISK_SCORE']].head(10), use_container_width=True, hide_index=True)

# ==================== TAB 3: PATIENT DETAILS ====================
with tab3:
    st.markdown('<div class="section-header" data-tooltip="Search and view complete patient profile including demographics, risk score, and medical history">👤 Patient Search & Comprehensive Details</div>', unsafe_allow_html=True)
    
    patient_options = risk_df.apply(lambda x: f"{x['PATIENT_ID']} - {x['FIRST_NAME']} {x['LAST_NAME']} ({x['RISK_CATEGORY']})", axis=1).tolist()
    selected_patient = st.selectbox("🔍 Select Patient", patient_options)
    patient_id = selected_patient.split(" - ")[0]
    patient_data = risk_df[risk_df['PATIENT_ID'] == patient_id].iloc[0]
    
    risk_color = "risk-high" if patient_data['RISK_CATEGORY'] == 'HIGH' else "risk-medium" if patient_data['RISK_CATEGORY'] == 'MEDIUM' else "risk-low"
    risk_emoji = "🔴" if patient_data['RISK_CATEGORY'] == 'HIGH' else "🟡" if patient_data['RISK_CATEGORY'] == 'MEDIUM' else "🟢"
    text_color = "#7a4a4a" if patient_data['RISK_CATEGORY'] == 'HIGH' else "#6a5a3a" if patient_data['RISK_CATEGORY'] == 'MEDIUM' else "#4a6a5a"
    
    st.markdown(f"""
    <div class="metric-card {risk_color}">
        <h2 style="margin:0; color:{text_color};">{risk_emoji} {patient_data['FIRST_NAME']} {patient_data['LAST_NAME']}</h2>
        <p style="margin:8px 0 0 0; color:#5a5a5a;"><b>Patient ID:</b> {patient_data['PATIENT_ID']} &nbsp;|&nbsp; <b>Age:</b> {patient_data['AGE']} years &nbsp;|&nbsp; <b>Risk Category:</b> {patient_data['RISK_CATEGORY']}</p>
    </div>
    """, unsafe_allow_html=True)
    
    col1, col2, col3, col4 = st.columns(4)
    col1.metric("🎯 Risk Score", patient_data['RISK_SCORE'])
    col2.metric("🏥 Total Visits", patient_data['TOTAL_VISITS'])
    col3.metric("🔬 Diagnoses", patient_data['TOTAL_DIAGNOSES'])
    col4.metric("⚠️ Max Severity", patient_data['MAX_SEVERITY_LEVEL'])
    
    st.markdown('<div class="section-header" data-tooltip="List of medications and treatments prescribed to the patient with status and prescribing physician">💊 Recent Medicines & Treatments</div>', unsafe_allow_html=True)
    treatments = load_treatments(patient_id)
    if len(treatments) > 0:
        for _, treatment in treatments.iterrows():
            status_color = "#6a9a7a" if treatment['OUTCOME_STATUS'] == 'COMPLETED' else "#b8a060"
            st.markdown(f"""
            <div class="medicine-card">
                <b style="color:#3a5a4a;">💊 {treatment['TREATMENT_NAME']}</b> &nbsp;|&nbsp; <span style="background:{status_color};color:white;padding:2px 8px;border-radius:4px;font-size:0.8em;">{treatment['OUTCOME_STATUS']}</span><br>
                <small style="color:#5a5a5a;"><b>Type:</b> {treatment['TREATMENT_TYPE']} &nbsp;|&nbsp; <b>Date:</b> {treatment['TREATMENT_DATE']} &nbsp;|&nbsp; <b>Doctor:</b> {treatment['DOCTOR_NAME']}</small>
            </div>
            """, unsafe_allow_html=True)
    else:
        st.info("No treatment records found for this patient.")
    
    st.markdown('<div class="section-header" data-tooltip="Current health status including latest diagnosis, severity level, and clinical sentiment analysis">📊 Present Condition</div>', unsafe_allow_html=True)
    patient_visits = load_patient_visits(patient_id)
    if len(patient_visits) > 0:
        latest = patient_visits.iloc[0]
        sentiment_color = "#6a9a7a" if latest['NOTES_SENTIMENT'] == 'POSITIVE' else "#b87a7a" if latest['NOTES_SENTIMENT'] == 'NEGATIVE' else "#7a7a7a"
        severity_color = "#b87a7a" if latest['SEVERITY_TEXT'] == 'CRITICAL' else "#b8a060" if latest['SEVERITY_TEXT'] == 'SEVERE' else "#5a8ab8" if latest['SEVERITY_TEXT'] == 'MODERATE' else "#6a9a7a"
        
        st.markdown(f"""
        <div class="condition-card">
            <h4 style="margin:0 0 12px 0; color:#1a4b6e;">📋 Latest Visit Summary</h4>
            <p style="color:#5a5a5a;"><b>Visit Date:</b> {latest['VISIT_DATE']} &nbsp;|&nbsp; <b>Department:</b> {latest['DEPARTMENT']} &nbsp;|&nbsp; <b>Type:</b> {latest['VISIT_TYPE']}</p>
            <p style="color:#5a5a5a;"><b>Diagnosis:</b> {latest['DIAGNOSIS_NAME']} &nbsp;|&nbsp; <b>Severity:</b> <span style="background:{severity_color};color:white;padding:2px 10px;border-radius:4px;">{latest['SEVERITY_TEXT']}</span></p>
            <p style="color:#5a5a5a;"><b>Clinical Sentiment:</b> <span style="color:{sentiment_color};font-weight:bold;">{latest['NOTES_SENTIMENT']}</span> (Score: {latest['NOTES_SENTIMENT_SCORE']:.2f})</p>
            <p style="color:#5a5a5a;"><b>Length of Stay:</b> {latest['LENGTH_OF_STAY_DAYS']} days</p>
        </div>
        """, unsafe_allow_html=True)
        
        st.markdown("**📜 Visit History:**")
        st.dataframe(patient_visits[['VISIT_DATE', 'DEPARTMENT', 'DIAGNOSIS_NAME', 'SEVERITY_TEXT', 'LENGTH_OF_STAY_DAYS', 'NOTES_SENTIMENT']], use_container_width=True, hide_index=True)
    
    st.markdown('<div class="section-header" data-tooltip="AI-powered personalized care recommendations based on patient history and risk factors">🤖 AI-Generated Clinical Insights</div>', unsafe_allow_html=True)
    st.markdown(f"""
    <div class="insight-box">
        <h4 style="margin:0 0 12px 0; color:#1a4b6e;">🧠 Personalized Care Recommendation</h4>
        <p style="color:#4a4a4a;">{patient_data['AI_RECOMMENDATION']}</p>
    </div>
    """, unsafe_allow_html=True)
    
    if patient_data['RISK_CATEGORY'] in ['HIGH', 'MEDIUM']:
        st.markdown('<div class="section-header" data-tooltip="Recommended preventive measures and lifestyle changes to reduce patient risk level">⚠️ Precautions to Avoid High Risk</div>', unsafe_allow_html=True)
        st.markdown(f"""
        <div class="precaution-box">
            <table style="width:100%; color:#5a5a5a;">
                <tr><td>✅ Schedule follow-up within {'48 hours' if patient_data['RISK_CATEGORY'] == 'HIGH' else '1 week'}</td><td>✅ Review medication interactions</td></tr>
                <tr><td>✅ Monitor vitals {'daily' if patient_data['RISK_CATEGORY'] == 'HIGH' else 'weekly'}</td><td>✅ Maintain healthy diet plan</td></tr>
                <tr><td>✅ {'Emergency contact alert' if patient_data['RISK_CATEGORY'] == 'HIGH' else 'Regular exercise routine'}</td><td>✅ Stress reduction activities</td></tr>
            </table>
        </div>
        """, unsafe_allow_html=True)

# ==================== TAB 4: CLINICAL INSIGHTS ====================
with tab4:
    st.markdown('<div class="section-header" data-tooltip="AI-driven analysis of diagnoses with treatment recommendations and clinical priority levels">🧠 AI-Powered Clinical Intelligence</div>', unsafe_allow_html=True)
    
    selected_diagnosis = st.selectbox("🔍 Select Diagnosis for AI Insights", clinical_df['DIAGNOSIS_NAME'].tolist())
    diagnosis_data = clinical_df[clinical_df['DIAGNOSIS_NAME'] == selected_diagnosis].iloc[0]
    
    col_a, col_b, col_c, col_d = st.columns(4)
    col_a.metric("Total Cases", diagnosis_data['DIAGNOSIS_COUNT'])
    col_b.metric("Patients", diagnosis_data['AFFECTED_PATIENTS'])
    col_c.metric("Avg Severity", f"{diagnosis_data['AVG_SEVERITY']:.2f}")
    col_d.metric("Critical", diagnosis_data['CRITICAL_CASES'])
    
    priority_color = "#b87a7a" if 'HIGH' in str(diagnosis_data['CLINICAL_PRIORITY']) else "#b8a060" if 'STANDARD' in str(diagnosis_data['CLINICAL_PRIORITY']) else "#6a9a7a"
    
    st.markdown(f"""
    <div class="insight-box">
        <h4 style="margin:0; color:#1a4b6e;">🎯 Clinical Priority: <span style="background:{priority_color};color:white;padding:4px 12px;border-radius:6px;">{diagnosis_data['CLINICAL_PRIORITY']}</span></h4>
    </div>
    """, unsafe_allow_html=True)
    
    st.markdown('<div class="section-header" data-tooltip="AI-generated treatment protocols and prevention strategies for the selected diagnosis">💡 AI Treatment & Prevention Tips</div>', unsafe_allow_html=True)
    st.markdown(f"""
    <div class="precaution-box">
        <p style="color:#4a4a4a;">{diagnosis_data['AI_INSIGHT']}</p>
    </div>
    """, unsafe_allow_html=True)

# ==================== TAB 5: VISIT ANALYTICS ====================
with tab5:
    st.markdown('<div class="section-header" data-tooltip="Comprehensive analytics on patient visits including duration, sentiment, and severity trends">📋 Visit Analytics Dashboard</div>', unsafe_allow_html=True)
    
    col1, col2, col3, col4 = st.columns(4)
    col1.metric("📊 Total Visits", len(visits_df))
    col2.metric("🛏️ Avg Stay", f"{visits_df['LENGTH_OF_STAY_DAYS'].mean():.1f} days")
    col3.metric("😊 Positive Sentiment", (visits_df['NOTES_SENTIMENT'] == 'POSITIVE').sum())
    col4.metric("🚨 Critical Cases", (visits_df['SEVERITY_TEXT'] == 'CRITICAL').sum())
    
    col1, col2 = st.columns(2)
    with col1:
        st.markdown('<div class="section-header" data-tooltip="Distribution of visits across severity levels from mild to critical">📈 Severity Distribution</div>', unsafe_allow_html=True)
        severity_counts = visits_df['SEVERITY_TEXT'].value_counts().reset_index()
        severity_counts.columns = ['Severity', 'Count']
        st.bar_chart(severity_counts.set_index('Severity'), color='#5a8ab8')
    
    with col2:
        st.markdown('<div class="section-header" data-tooltip="Breakdown of visits by type - Emergency, Inpatient, and Outpatient">🏥 Visit Type Breakdown</div>', unsafe_allow_html=True)
        visit_type_counts = visits_df['VISIT_TYPE'].value_counts().reset_index()
        visit_type_counts.columns = ['Visit Type', 'Count']
        st.bar_chart(visit_type_counts.set_index('Visit Type'), color='#3b7cb8')
    
    st.markdown('<div class="section-header" data-tooltip="Detailed list of most recent patient visits with diagnosis and sentiment information">📊 Recent Visits</div>', unsafe_allow_html=True)
    st.dataframe(
        visits_df[['VISIT_ID', 'PATIENT_ID', 'DEPARTMENT', 'VISIT_TYPE', 'VISIT_DATE', 'DIAGNOSIS_NAME', 'SEVERITY_TEXT', 'NOTES_SENTIMENT']].head(20),
        use_container_width=True, hide_index=True
    )

st.markdown("---")
st.markdown("<center><small style='color:#7a8a9a;'>🏥 CareView AI Clinical Dashboard | Powered by Snowflake Cortex AI</small></center>", unsafe_allow_html=True)
