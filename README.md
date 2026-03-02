CareView AI Healthcare Analytics Platform

The CareView AI Healthcare Analytics Platform is a Snowflake-based healthcare analytics project designed to demonstrate enterprise-level data architecture, governance, monitoring, and AI-powered analytics using Snowflake Cortex.

The platform processes hospital operational data through a structured data pipeline and transforms it into meaningful insights. These insights support healthcare operations, financial monitoring, and clinical intelligence. The analytics results are visualized through interactive dashboards built using Streamlit.

This project demonstrates how modern data platforms can combine structured data pipelines, governance frameworks, and artificial intelligence capabilities to support healthcare decision-making.

System Architecture

The CareView platform follows a structured four-layer architecture designed for scalable analytics and AI-powered insights.

                         CAREVIEW DATA PLATFORM
--------------------------------------------------------------------------------
CAREVIEW DATA FLOW ARCHITECTURE
================================================================================

   DATA SOURCES
   ─────────────────────────────────────────────────────────
   Patients | Visits | Diagnoses | Treatments | Billing

             │
             ▼

   RAW LAYER
   ─────────────────────────────────────────────────────────
   Stores original healthcare data
   No transformations applied
             │
             ▼

   BRONZE LAYER
   ─────────────────────────────────────────────────────────
   Data Cleaning & Standardization
   • Remove null values
   • Normalize text fields
   • Validate relationships
            │
            ▼│
                        

   GOLD LAYER
   ─────────────────────────────────────────────────────────
   Business Analytics Tables
   • Patient Summary
   • Department Metrics
   • Monthly Revenue
   • Diagnosis Analytics
            │
            ▼

   AI_ANALYTICS LAYER
   ─────────────────────────────────────────────────────────
   Snowflake Cortex AI
   • Risk scoring
   • Clinical insights
   • Patient intelligence
            │
            ▼

   VISUALIZATION
   ─────────────────────────────────────────────────────────
   Streamlit Dashboards
   • Executive Overview
   • Financial Analytics
   • Disease Analytics
   • Patient Insights


Enterprise Snowflake Implementation Phases

The CareView project follows a structured enterprise Snowflake implementation model consisting of fifteen phases. Each phase represents a key component of building a production-grade data platform.

Phase 1 — Account Administration

The first phase focuses on configuring the Snowflake account environment. This includes defining security policies, managing administrative configurations, and establishing network restrictions to ensure secure access.

Security controls are implemented at the account level to prevent unauthorized access and ensure that only approved users and systems can interact with the data platform. These settings provide the foundation for all subsequent phases.

Phase 2 — RBAC Setup

Role-Based Access Control is implemented to manage user permissions across the platform.

The hierarchy of roles is structured to support secure data access. The SYSADMIN role sits at the top of the hierarchy, followed by the CAREVIEW_ADMIN role, the CAREVIEW_ANALYST role, and the CAREVIEW_VIEWER role.

The CAREVIEW_ADMIN role has full administrative access to the database environment and infrastructure components. The CAREVIEW_ANALYST role is responsible for performing data analysis and managing analytics tables. The CAREVIEW_VIEWER role has read-only access to analytics outputs.

This role hierarchy ensures that sensitive healthcare data is protected while still allowing appropriate users to perform their tasks.

Phase 3 — Warehouse Management

Dedicated Snowflake warehouses are created to separate workloads and optimize system performance.

One warehouse is configured to execute data pipeline operations such as data ingestion and transformations. Another warehouse is used for analytics queries executed by analysts. A separate warehouse is used for AI workloads that process Cortex AI functions. A dashboard warehouse supports the execution of Streamlit dashboards.

Separating workloads across warehouses prevents resource contention and improves both system performance and cost management.

Phase 4 — Database Structure

The CareView platform uses a structured Snowflake database called CAREVIEW_DB.

Within this database, multiple schemas are created to organize the data pipeline. The RAW schema stores the original ingested data. The BRONZE schema stores cleaned operational data. The GOLD schema contains business analytics datasets. The AI_ANALYTICS schema contains AI-generated insights and enriched datasets.

This structure aligns with modern data architecture practices and ensures that each stage of the pipeline is clearly separated.

Data Architecture

The CareView platform processes healthcare data across four major layers.

RAW Layer

The RAW layer stores the initial healthcare datasets exactly as they are received from source systems. No transformations are applied at this stage. The purpose of this layer is to preserve the original state of the data.

The raw tables include patients, visits, diagnoses, treatments, and billing records. These datasets form the foundation of the data pipeline.

Maintaining raw data allows the platform to support auditing, troubleshooting, and data lineage tracking.

BRONZE Layer

The Bronze layer contains cleaned and standardized operational data. Data transformations are applied in this layer to improve data quality and consistency.

Common transformations include trimming whitespace, formatting text values, validating null fields, and enforcing referential integrity between related tables.

Additional derived fields are calculated during this stage. These include the patient age, the length of hospital stay, severity levels associated with diagnoses, and payment category classifications.

The Bronze layer represents operationally reliable data that can be used for downstream analytics.

GOLD Layer

The Gold layer contains analytics-ready datasets that support reporting, dashboards, and business intelligence queries.

One of the primary tables in this layer is the patient summary table, which aggregates information about each patient including demographics, visit counts, billing totals, and treatment history.

Another important table is the department metrics table. This dataset provides operational performance indicators for each hospital department including visit volumes, number of unique patients, average length of stay, and total revenue generated.

The monthly revenue table supports financial analytics by summarizing revenue data over time. It includes billing totals, insurance reimbursements, patient payments, and collection rates.

The diagnosis analytics table provides insights into disease patterns by analyzing diagnosis frequencies, severity levels, and patient impact.

AI Analytics Layer

The AI Analytics layer enriches the analytics data using Snowflake Cortex AI capabilities.

Artificial intelligence models generate insights such as patient risk scores, clinical recommendations, and diagnosis summaries.

The system uses several Cortex AI functions including SNOWFLAKE.CORTEX.COMPLETE for generating text-based recommendations, SNOWFLAKE.CORTEX.SUMMARIZE for summarizing clinical notes, and SNOWFLAKE.CORTEX.SENTIMENT for evaluating text sentiment.

The AI models are powered by the Llama 3.1 8B language model.

The AI-generated datasets include tables that evaluate patient risk levels, analyze visit patterns, and generate diagnosis-level clinical intelligence. These insights support proactive healthcare decision-making.

Data Governance

Healthcare data contains sensitive information that requires strong governance controls.

Masking policies are implemented to protect personally identifiable information. Patient names, phone numbers, and billing amounts are masked for users who do not have administrative privileges.

These policies automatically apply based on user roles and ensure that sensitive data is protected during analysis and reporting.

Row-level access policies are also implemented to restrict data visibility. These policies limit users to viewing data from authorized departments such as General Medicine or Pediatrics.

Monitoring and Alerts

Resource monitoring ensures that Snowflake compute resources are used efficiently.

Monitoring tools track warehouse utilization, credit consumption, query execution time, and queue wait times.

Alerts are configured to notify administrators when usage thresholds are exceeded. These alerts help identify issues such as excessive credit consumption or query bottlenecks before they affect system performance.

Audit and Access Tracking

Audit mechanisms track user activity across the platform.

Audit views record login activity, query execution, role usage, and data access events. These logs allow administrators to monitor how the platform is being used and identify any suspicious activity.

Audit records are retained for a period of thirty days to support security reviews and compliance monitoring.

Execution Order

The project scripts must be executed in a specific order to ensure correct dependencies between infrastructure components and data layers.

First, the infrastructure setup script creates the database, schemas, roles, and governance policies. The RAW layer script then creates the raw data tables. The Bronze layer script performs the cleaning and transformation processes. The Gold layer script builds the analytics tables. The AI analytics script generates the AI-enriched datasets. Finally, the data quality tests script validates the results of the pipeline.

Executing scripts in this order ensures that each stage of the pipeline is built on top of the previous layer.

Dataset Summary

The RAW layer contains five source tables including patients, visits, diagnoses, treatments, and billing records. These tables contain approximately five hundred eighty records combined.

The Gold layer contains aggregated analytics tables including patient summary records, department metrics, monthly revenue data, and diagnosis analytics results.

Across the entire platform there are approximately seventeen tables used to support the analytics pipeline.

Example Analytical Queries

The platform supports various analytical queries that demonstrate its capabilities.

One query identifies the highest risk patients by selecting the top patient records with the highest AI-generated risk scores.

Another query analyzes department revenue by comparing visit counts, revenue totals, and average patient stay durations across departments.

A financial analytics query calculates the monthly collection rate trend by summarizing billing and payment data.

Another query identifies diagnoses that are classified as critical and retrieves AI-generated clinical insights associated with those conditions.

Dashboard Layer

The final output of the platform is presented through interactive dashboards built using Streamlit within Snowflake.

The dashboards include several modules that support different analytical perspectives.

The Executive Overview dashboard provides high-level hospital performance metrics. The AI Clinical Intelligence dashboard presents AI-generated recommendations and diagnosis insights. The Department Performance dashboard analyzes operational metrics across departments. The Financial Analytics dashboard tracks revenue performance and collection rates. The Disease Analytics dashboard analyzes diagnosis patterns and severity levels. The Patient Insights dashboard provides demographic analysis and patient-level analytics.

These dashboards allow healthcare stakeholders to easily interpret the data and make informed decisions.

Technology Stack

The CareView platform is built using several modern data technologies.

Snowflake is used as the cloud data warehouse for storing and processing all healthcare datasets. Snowflake Cortex provides artificial intelligence capabilities for generating insights and recommendations. Streamlit is used to build interactive analytics dashboards. Plotly is used to generate charts and visualizations. SQL and Pandas are used for data transformation and processing. GitHub is used for version control, while Azure DevOps supports project management and workflow tracking.

Project Outcome

The CareView AI Healthcare Analytics Platform demonstrates a complete enterprise data platform built on Snowflake.

The project showcases the implementation of role-based security architecture, governance and masking policies, resource monitoring and alerting, multi-layer data architecture, AI-powered analytics, and interactive visualization dashboards.

By integrating these capabilities, the platform enables healthcare organizations to transform operational data into actionable intelligence that supports both clinical and business decision-making.