/*
================================================================================
CAREVIEW - PATIENT RISK MONITORING PLATFORM
================================================================================
PHASE 11: BRONZE LAYER - SIMPLE CSV DATA
================================================================================
*/


USE ROLE ACCOUNTADMIN;
USE DATABASE CAREVIEW_DB;
USE SCHEMA CAREVIEW_SCH_BRONZE;

-- ============================================================================
-- TABLE 1: BRONZE_PATIENTS
-- ============================================================================
CREATE OR REPLACE TABLE BRONZE_PATIENTS (
    PATIENT_ID      NUMBER PRIMARY KEY,
    FIRST_NAME      VARCHAR(50),
    LAST_NAME       VARCHAR(50),
    AGE             NUMBER,
    GENDER          VARCHAR(10),
    BLOOD_TYPE      VARCHAR(5),
    PHONE           VARCHAR(15),
    CITY            VARCHAR(50),
    INSURANCE_TYPE  VARCHAR(30)
);

INSERT INTO BRONZE_PATIENTS VALUES (1, 'James', 'Smith', 45, 'Male', 'A+', '555-1001', 'New York', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (2, 'Mary', 'Johnson', 67, 'Female', 'B+', '555-1002', 'Los Angeles', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (3, 'John', 'Williams', 52, 'Male', 'O+', '555-1003', 'Chicago', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (4, 'Patricia', 'Brown', 78, 'Female', 'A-', '555-1004', 'Houston', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (5, 'Robert', 'Jones', 34, 'Male', 'B-', '555-1005', 'Phoenix', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (6, 'Jennifer', 'Garcia', 61, 'Female', 'O-', '555-1006', 'Dallas', 'Medicaid');
INSERT INTO BRONZE_PATIENTS VALUES (7, 'Michael', 'Miller', 55, 'Male', 'AB+', '555-1007', 'San Diego', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (8, 'Linda', 'Davis', 72, 'Female', 'AB-', '555-1008', 'Austin', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (9, 'William', 'Rodriguez', 48, 'Male', 'A+', '555-1009', 'Seattle', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (10, 'Elizabeth', 'Martinez', 83, 'Female', 'B+', '555-1010', 'Denver', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (11, 'David', 'Anderson', 39, 'Male', 'O+', '555-1011', 'New York', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (12, 'Barbara', 'Taylor', 65, 'Female', 'A-', '555-1012', 'Los Angeles', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (13, 'Richard', 'Thomas', 57, 'Male', 'B-', '555-1013', 'Chicago', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (14, 'Susan', 'Moore', 71, 'Female', 'O-', '555-1014', 'Houston', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (15, 'Joseph', 'Jackson', 44, 'Male', 'AB+', '555-1015', 'Phoenix', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (16, 'Jessica', 'Martin', 69, 'Female', 'AB-', '555-1016', 'Dallas', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (17, 'Thomas', 'Lee', 53, 'Male', 'A+', '555-1017', 'San Diego', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (18, 'Sarah', 'Thompson', 76, 'Female', 'B+', '555-1018', 'Austin', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (19, 'Charles', 'White', 41, 'Male', 'O+', '555-1019', 'Seattle', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (20, 'Karen', 'Harris', 88, 'Female', 'A-', '555-1020', 'Denver', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (21, 'Christopher', 'Clark', 36, 'Male', 'B-', '555-1021', 'New York', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (22, 'Nancy', 'Lewis', 63, 'Female', 'O-', '555-1022', 'Los Angeles', 'Medicaid');
INSERT INTO BRONZE_PATIENTS VALUES (23, 'Daniel', 'Walker', 59, 'Male', 'AB+', '555-1023', 'Chicago', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (24, 'Betty', 'Hall', 74, 'Female', 'AB-', '555-1024', 'Houston', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (25, 'Matthew', 'Allen', 47, 'Male', 'A+', '555-1025', 'Phoenix', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (26, 'Margaret', 'Young', 66, 'Female', 'B+', '555-1026', 'Dallas', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (27, 'Anthony', 'King', 51, 'Male', 'O+', '555-1027', 'San Diego', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (28, 'Lisa', 'Wright', 79, 'Female', 'A-', '555-1028', 'Austin', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (29, 'Mark', 'Scott', 43, 'Male', 'B-', '555-1029', 'Seattle', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (30, 'Dorothy', 'Green', 85, 'Female', 'O-', '555-1030', 'Denver', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (31, 'Donald', 'Adams', 38, 'Male', 'AB+', '555-1031', 'New York', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (32, 'Sandra', 'Baker', 68, 'Female', 'AB-', '555-1032', 'Los Angeles', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (33, 'Steven', 'Nelson', 54, 'Male', 'A+', '555-1033', 'Chicago', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (34, 'Ashley', 'Hill', 73, 'Female', 'B+', '555-1034', 'Houston', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (35, 'Paul', 'Mitchell', 46, 'Male', 'O+', '555-1035', 'Phoenix', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (36, 'Kimberly', 'Roberts', 64, 'Female', 'A-', '555-1036', 'Dallas', 'Medicaid');
INSERT INTO BRONZE_PATIENTS VALUES (37, 'Andrew', 'Carter', 58, 'Male', 'B-', '555-1037', 'San Diego', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (38, 'Emily', 'Phillips', 77, 'Female', 'O-', '555-1038', 'Austin', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (39, 'Joshua', 'Evans', 42, 'Male', 'AB+', '555-1039', 'Seattle', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (40, 'Michelle', 'Turner', 81, 'Female', 'AB-', '555-1040', 'Denver', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (41, 'Kenneth', 'Parker', 35, 'Male', 'A+', '555-1041', 'New York', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (42, 'Amanda', 'Collins', 70, 'Female', 'B+', '555-1042', 'Los Angeles', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (43, 'Kevin', 'Edwards', 56, 'Male', 'O+', '555-1043', 'Chicago', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (44, 'Donna', 'Stewart', 75, 'Female', 'A-', '555-1044', 'Houston', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (45, 'Brian', 'Morris', 49, 'Male', 'B-', '555-1045', 'Phoenix', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (46, 'Carol', 'Murphy', 62, 'Female', 'O-', '555-1046', 'Dallas', 'Medicaid');
INSERT INTO BRONZE_PATIENTS VALUES (47, 'George', 'Cook', 50, 'Male', 'AB+', '555-1047', 'San Diego', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (48, 'Ruth', 'Rogers', 80, 'Female', 'AB-', '555-1048', 'Austin', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (49, 'Edward', 'Morgan', 40, 'Male', 'A+', '555-1049', 'Seattle', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (50, 'Sharon', 'Peterson', 86, 'Female', 'B+', '555-1050', 'Denver', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (51, 'Ronald', 'Cooper', 37, 'Male', 'O+', '555-1051', 'New York', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (52, 'Helen', 'Reed', 60, 'Female', 'A-', '555-1052', 'Los Angeles', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (53, 'Timothy', 'Bailey', 33, 'Male', 'B-', '555-1053', 'Chicago', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (54, 'Laura', 'Bell', 82, 'Female', 'O-', '555-1054', 'Houston', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (55, 'Jason', 'Howard', 29, 'Male', 'AB+', '555-1055', 'Phoenix', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (56, 'Deborah', 'Ward', 91, 'Female', 'AB-', '555-1056', 'Dallas', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (57, 'Jeffrey', 'Cox', 31, 'Male', 'A+', '555-1057', 'San Diego', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (58, 'Rebecca', 'Richardson', 84, 'Female', 'B+', '555-1058', 'Austin', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (59, 'Ryan', 'Wood', 28, 'Male', 'O+', '555-1059', 'Seattle', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (60, 'Cynthia', 'Watson', 87, 'Female', 'A-', '555-1060', 'Denver', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (61, 'Gary', 'Brooks', 32, 'Male', 'B-', '555-1061', 'New York', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (62, 'Kathleen', 'Kelly', 89, 'Female', 'O-', '555-1062', 'Los Angeles', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (63, 'Nicholas', 'Sanders', 30, 'Male', 'AB+', '555-1063', 'Chicago', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (64, 'Amy', 'Price', 90, 'Female', 'AB-', '555-1064', 'Houston', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (65, 'Eric', 'Bennett', 27, 'Male', 'A+', '555-1065', 'Phoenix', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (66, 'Angela', 'Gray', 92, 'Female', 'B+', '555-1066', 'Dallas', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (67, 'Stephen', 'James', 26, 'Male', 'O+', '555-1067', 'San Diego', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (68, 'Brenda', 'Ross', 93, 'Female', 'A-', '555-1068', 'Austin', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (69, 'Jonathan', 'Henderson', 25, 'Male', 'B-', '555-1069', 'Seattle', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (70, 'Anna', 'Patterson', 94, 'Female', 'O-', '555-1070', 'Denver', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (71, 'Larry', 'Hughes', 24, 'Male', 'AB+', '555-1071', 'New York', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (72, 'Diane', 'Flores', 95, 'Female', 'AB-', '555-1072', 'Los Angeles', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (73, 'Frank', 'Washington', 23, 'Male', 'A+', '555-1073', 'Chicago', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (74, 'Marie', 'Butler', 96, 'Female', 'B+', '555-1074', 'Houston', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (75, 'Scott', 'Simmons', 22, 'Male', 'O+', '555-1075', 'Phoenix', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (76, 'Janet', 'Foster', 97, 'Female', 'A-', '555-1076', 'Dallas', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (77, 'Raymond', 'Gonzalez', 21, 'Male', 'B-', '555-1077', 'San Diego', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (78, 'Catherine', 'Bryant', 98, 'Female', 'O-', '555-1078', 'Austin', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (79, 'Gregory', 'Alexander', 20, 'Male', 'AB+', '555-1079', 'Seattle', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (80, 'Frances', 'Russell', 99, 'Female', 'AB-', '555-1080', 'Denver', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (81, 'Samuel', 'Griffin', 19, 'Male', 'A+', '555-1081', 'New York', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (82, 'Virginia', 'Diaz', 58, 'Female', 'B+', '555-1082', 'Los Angeles', 'Medicaid');
INSERT INTO BRONZE_PATIENTS VALUES (83, 'Patrick', 'Hayes', 62, 'Male', 'O+', '555-1083', 'Chicago', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (84, 'Christine', 'Myers', 55, 'Female', 'A-', '555-1084', 'Houston', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (85, 'Jack', 'Ford', 48, 'Male', 'B-', '555-1085', 'Phoenix', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (86, 'Samantha', 'Hamilton', 71, 'Female', 'O-', '555-1086', 'Dallas', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (87, 'Dennis', 'Graham', 44, 'Male', 'AB+', '555-1087', 'San Diego', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (88, 'Debra', 'Sullivan', 67, 'Female', 'AB-', '555-1088', 'Austin', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (89, 'Jerry', 'Wallace', 39, 'Male', 'A+', '555-1089', 'Seattle', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (90, 'Rachel', 'Woods', 73, 'Female', 'B+', '555-1090', 'Denver', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (91, 'Tyler', 'Cole', 35, 'Male', 'O+', '555-1091', 'New York', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (92, 'Carolyn', 'West', 78, 'Female', 'A-', '555-1092', 'Los Angeles', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (93, 'Aaron', 'Jordan', 31, 'Male', 'B-', '555-1093', 'Chicago', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (94, 'Joyce', 'Owens', 82, 'Female', 'O-', '555-1094', 'Houston', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (95, 'Jose', 'Reynolds', 27, 'Male', 'AB+', '555-1095', 'Phoenix', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (96, 'Judith', 'Fisher', 86, 'Female', 'AB-', '555-1096', 'Dallas', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (97, 'Adam', 'Ellis', 23, 'Male', 'A+', '555-1097', 'San Diego', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (98, 'Janice', 'Stone', 89, 'Female', 'B+', '555-1098', 'Austin', 'Medicare');
INSERT INTO BRONZE_PATIENTS VALUES (99, 'Nathan', 'Hawkins', 56, 'Male', 'O+', '555-1099', 'Seattle', 'Private');
INSERT INTO BRONZE_PATIENTS VALUES (100, 'Grace', 'Warren', 64, 'Female', 'A-', '555-1100', 'Denver', 'Medicare');

-- ============================================================================
-- TABLE 2: BRONZE_DOCTORS
-- ============================================================================
CREATE OR REPLACE TABLE BRONZE_DOCTORS (
    DOCTOR_ID       NUMBER PRIMARY KEY,
    DOCTOR_NAME     VARCHAR(50),
    SPECIALIZATION  VARCHAR(50),
    DEPARTMENT_ID   NUMBER,
    EXPERIENCE_YRS  NUMBER,
    PHONE           VARCHAR(15)
);

INSERT INTO BRONZE_DOCTORS VALUES (1, 'Dr. Adams', 'Cardiology', 1, 15, '555-2001');
INSERT INTO BRONZE_DOCTORS VALUES (2, 'Dr. Baker', 'Neurology', 2, 12, '555-2002');
INSERT INTO BRONZE_DOCTORS VALUES (3, 'Dr. Clark', 'Orthopedics', 3, 18, '555-2003');
INSERT INTO BRONZE_DOCTORS VALUES (4, 'Dr. Davis', 'Pediatrics', 4, 10, '555-2004');
INSERT INTO BRONZE_DOCTORS VALUES (5, 'Dr. Evans', 'Oncology', 5, 20, '555-2005');
INSERT INTO BRONZE_DOCTORS VALUES (6, 'Dr. Foster', 'Pulmonology', 6, 8, '555-2006');
INSERT INTO BRONZE_DOCTORS VALUES (7, 'Dr. Green', 'Gastroenterology', 7, 14, '555-2007');
INSERT INTO BRONZE_DOCTORS VALUES (8, 'Dr. Hill', 'Nephrology', 8, 11, '555-2008');
INSERT INTO BRONZE_DOCTORS VALUES (9, 'Dr. Irving', 'Endocrinology', 9, 16, '555-2009');
INSERT INTO BRONZE_DOCTORS VALUES (10, 'Dr. Jones', 'Emergency', 10, 9, '555-2010');
INSERT INTO BRONZE_DOCTORS VALUES (11, 'Dr. King', 'Cardiology', 1, 13, '555-2011');
INSERT INTO BRONZE_DOCTORS VALUES (12, 'Dr. Lee', 'Neurology', 2, 7, '555-2012');
INSERT INTO BRONZE_DOCTORS VALUES (13, 'Dr. Moore', 'Orthopedics', 3, 19, '555-2013');
INSERT INTO BRONZE_DOCTORS VALUES (14, 'Dr. Nelson', 'Psychiatry', 11, 6, '555-2014');
INSERT INTO BRONZE_DOCTORS VALUES (15, 'Dr. Owen', 'Oncology', 5, 17, '555-2015');
INSERT INTO BRONZE_DOCTORS VALUES (16, 'Dr. Parker', 'Pulmonology', 6, 5, '555-2016');
INSERT INTO BRONZE_DOCTORS VALUES (17, 'Dr. Quinn', 'General Surgery', 12, 22, '555-2017');
INSERT INTO BRONZE_DOCTORS VALUES (18, 'Dr. Roberts', 'Emergency', 10, 4, '555-2018');
INSERT INTO BRONZE_DOCTORS VALUES (19, 'Dr. Scott', 'ICU', 13, 21, '555-2019');
INSERT INTO BRONZE_DOCTORS VALUES (20, 'Dr. Taylor', 'Radiology', 14, 3, '555-2020');
INSERT INTO BRONZE_DOCTORS VALUES (21, 'Dr. Wilson', 'Cardiology', 1, 10, '555-2021');
INSERT INTO BRONZE_DOCTORS VALUES (22, 'Dr. Young', 'Neurology', 2, 8, '555-2022');
INSERT INTO BRONZE_DOCTORS VALUES (23, 'Dr. Allen', 'Orthopedics', 3, 12, '555-2023');
INSERT INTO BRONZE_DOCTORS VALUES (24, 'Dr. Wright', 'Pediatrics', 4, 6, '555-2024');
INSERT INTO BRONZE_DOCTORS VALUES (25, 'Dr. Hall', 'Oncology', 5, 15, '555-2025');
INSERT INTO BRONZE_DOCTORS VALUES (26, 'Dr. Lopez', 'Pulmonology', 6, 9, '555-2026');
INSERT INTO BRONZE_DOCTORS VALUES (27, 'Dr. Brown', 'Gastroenterology', 7, 11, '555-2027');
INSERT INTO BRONZE_DOCTORS VALUES (28, 'Dr. Garcia', 'Nephrology', 8, 7, '555-2028');
INSERT INTO BRONZE_DOCTORS VALUES (29, 'Dr. Martinez', 'Endocrinology', 9, 13, '555-2029');
INSERT INTO BRONZE_DOCTORS VALUES (30, 'Dr. Anderson', 'Emergency', 10, 5, '555-2030');

-- ============================================================================
-- TABLE 3: BRONZE_DEPARTMENTS
-- ============================================================================
CREATE OR REPLACE TABLE BRONZE_DEPARTMENTS (
    DEPARTMENT_ID   NUMBER PRIMARY KEY,
    DEPARTMENT_NAME VARCHAR(50),
    FLOOR_NUMBER    NUMBER,
    BUILDING        VARCHAR(20),
    BED_COUNT       NUMBER,
    PHONE           VARCHAR(15)
);

INSERT INTO BRONZE_DEPARTMENTS VALUES (1, 'Cardiology', 3, 'Building A', 40, '555-3001');
INSERT INTO BRONZE_DEPARTMENTS VALUES (2, 'Neurology', 4, 'Building A', 35, '555-3002');
INSERT INTO BRONZE_DEPARTMENTS VALUES (3, 'Orthopedics', 2, 'Building B', 30, '555-3003');
INSERT INTO BRONZE_DEPARTMENTS VALUES (4, 'Pediatrics', 1, 'Building C', 50, '555-3004');
INSERT INTO BRONZE_DEPARTMENTS VALUES (5, 'Oncology', 5, 'Building A', 45, '555-3005');
INSERT INTO BRONZE_DEPARTMENTS VALUES (6, 'Pulmonology', 3, 'Building A', 30, '555-3006');
INSERT INTO BRONZE_DEPARTMENTS VALUES (7, 'Gastroenterology', 4, 'Building B', 25, '555-3007');
INSERT INTO BRONZE_DEPARTMENTS VALUES (8, 'Nephrology', 5, 'Building B', 20, '555-3008');
INSERT INTO BRONZE_DEPARTMENTS VALUES (9, 'Endocrinology', 3, 'Building C', 25, '555-3009');
INSERT INTO BRONZE_DEPARTMENTS VALUES (10, 'Emergency', 1, 'Building A', 60, '555-3010');
INSERT INTO BRONZE_DEPARTMENTS VALUES (11, 'Psychiatry', 6, 'Building C', 40, '555-3011');
INSERT INTO BRONZE_DEPARTMENTS VALUES (12, 'General Surgery', 5, 'Building B', 50, '555-3012');
INSERT INTO BRONZE_DEPARTMENTS VALUES (13, 'ICU', 6, 'Building A', 30, '555-3013');
INSERT INTO BRONZE_DEPARTMENTS VALUES (14, 'Radiology', 1, 'Building B', 5, '555-3014');
INSERT INTO BRONZE_DEPARTMENTS VALUES (15, 'General Medicine', 2, 'Building C', 40, '555-3015');

-- ============================================================================
-- TABLE 4: BRONZE_VISITS
-- ============================================================================
CREATE OR REPLACE TABLE BRONZE_VISITS (
    VISIT_ID        NUMBER PRIMARY KEY,
    PATIENT_ID      NUMBER,
    DOCTOR_ID       NUMBER,
    DEPARTMENT_ID   NUMBER,
    VISIT_DATE      DATE,
    VISIT_TYPE      VARCHAR(20),
    ADMISSION_REASON VARCHAR(100),
    STATUS          VARCHAR(20)
);

INSERT INTO BRONZE_VISITS VALUES (1, 1, 1, 1, '2025-01-05', 'Outpatient', 'Chest Pain', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (2, 2, 1, 1, '2025-01-06', 'Emergency', 'Heart Attack', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (3, 3, 3, 3, '2025-01-07', 'Outpatient', 'Back Pain', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (4, 4, 19, 13, '2025-01-08', 'Inpatient', 'Heart Failure', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (5, 5, 4, 4, '2025-01-09', 'Outpatient', 'Fever', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (6, 6, 9, 9, '2025-01-10', 'Outpatient', 'Diabetes Checkup', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (7, 7, 6, 6, '2025-01-11', 'Inpatient', 'COPD', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (8, 8, 1, 1, '2025-01-12', 'Emergency', 'Chest Pain', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (9, 9, 2, 2, '2025-01-13', 'Outpatient', 'Headache', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (10, 10, 19, 13, '2025-01-14', 'Inpatient', 'Stroke', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (11, 11, 3, 3, '2025-01-15', 'Outpatient', 'Joint Pain', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (12, 12, 9, 9, '2025-01-16', 'Outpatient', 'Thyroid Checkup', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (13, 13, 6, 6, '2025-01-17', 'Inpatient', 'Pneumonia', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (14, 14, 1, 1, '2025-01-18', 'Emergency', 'Heart Attack', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (15, 15, 7, 7, '2025-01-19', 'Outpatient', 'Stomach Pain', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (16, 16, 8, 8, '2025-01-20', 'Inpatient', 'Kidney Disease', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (17, 17, 2, 2, '2025-01-21', 'Outpatient', 'Migraine', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (18, 18, 1, 1, '2025-01-22', 'Inpatient', 'Heart Failure', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (19, 19, 14, 11, '2025-01-23', 'Outpatient', 'Anxiety', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (20, 20, 19, 13, '2025-01-24', 'Inpatient', 'Multi Organ Failure', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (21, 21, 3, 3, '2025-01-25', 'Outpatient', 'Shoulder Pain', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (22, 22, 9, 9, '2025-01-26', 'Outpatient', 'Diabetes Checkup', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (23, 23, 6, 6, '2025-01-27', 'Inpatient', 'Asthma Attack', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (24, 24, 1, 1, '2025-01-28', 'Emergency', 'Chest Pain', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (25, 25, 7, 7, '2025-01-29', 'Outpatient', 'Acid Reflux', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (26, 26, 8, 8, '2025-01-30', 'Inpatient', 'Dialysis', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (27, 27, 2, 2, '2025-01-31', 'Outpatient', 'Dizziness', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (28, 28, 1, 1, '2025-02-01', 'Inpatient', 'Cardiac Arrest', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (29, 29, 17, 12, '2025-02-02', 'Inpatient', 'Surgery', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (30, 30, 19, 13, '2025-02-03', 'Inpatient', 'Respiratory Failure', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (31, 31, 3, 3, '2025-02-04', 'Outpatient', 'Fracture Checkup', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (32, 32, 9, 9, '2025-02-05', 'Outpatient', 'Hormone Test', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (33, 33, 6, 6, '2025-02-06', 'Inpatient', 'Lung Infection', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (34, 34, 1, 1, '2025-02-07', 'Emergency', 'Heart Palpitations', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (35, 35, 7, 7, '2025-02-08', 'Outpatient', 'Colonoscopy', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (36, 36, 8, 8, '2025-02-09', 'Inpatient', 'Kidney Stones', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (37, 37, 2, 2, '2025-02-10', 'Outpatient', 'Epilepsy Checkup', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (38, 38, 1, 1, '2025-02-11', 'Inpatient', 'Heart Surgery', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (39, 39, 14, 11, '2025-02-12', 'Outpatient', 'Depression', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (40, 40, 19, 13, '2025-02-13', 'Inpatient', 'Sepsis', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (41, 41, 3, 3, '2025-02-14', 'Outpatient', 'Sports Injury', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (42, 42, 9, 9, '2025-02-15', 'Outpatient', 'Diabetes Management', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (43, 43, 6, 6, '2025-02-16', 'Inpatient', 'COPD Exacerbation', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (44, 44, 1, 1, '2025-02-17', 'Emergency', 'Heart Attack', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (45, 45, 7, 7, '2025-02-18', 'Outpatient', 'Liver Test', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (46, 46, 8, 8, '2025-02-19', 'Inpatient', 'Renal Failure', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (47, 47, 2, 2, '2025-02-20', 'Outpatient', 'Neuropathy', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (48, 48, 1, 1, '2025-02-21', 'Inpatient', 'Heart Failure', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (49, 49, 17, 12, '2025-02-22', 'Inpatient', 'Hernia Surgery', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (50, 50, 19, 13, '2025-02-23', 'Inpatient', 'Critical Condition', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (51, 51, 15, 15, '2025-02-24', 'Outpatient', 'General Checkup', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (52, 52, 15, 15, '2025-02-25', 'Outpatient', 'Routine Visit', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (53, 53, 4, 4, '2025-02-26', 'Outpatient', 'Vaccination', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (54, 54, 19, 13, '2025-02-27', 'Inpatient', 'Age Related Issues', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (55, 55, 3, 3, '2025-02-28', 'Outpatient', 'Ankle Sprain', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (56, 56, 19, 13, '2025-03-01', 'Inpatient', 'Critical Care', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (57, 57, 15, 15, '2025-03-02', 'Outpatient', 'Flu Symptoms', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (58, 58, 19, 13, '2025-03-03', 'Inpatient', 'Heart Issues', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (59, 59, 3, 3, '2025-03-04', 'Outpatient', 'Knee Pain', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (60, 60, 19, 13, '2025-03-05', 'Inpatient', 'Multi Organ Failure', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (61, 61, 15, 15, '2025-03-06', 'Outpatient', 'Annual Checkup', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (62, 62, 19, 13, '2025-03-07', 'Inpatient', 'Age Related Care', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (63, 63, 3, 3, '2025-03-08', 'Outpatient', 'Wrist Pain', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (64, 64, 19, 13, '2025-03-09', 'Inpatient', 'Critical Condition', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (65, 65, 15, 15, '2025-03-10', 'Outpatient', 'Health Screening', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (66, 66, 19, 13, '2025-03-11', 'Inpatient', 'Heart Failure', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (67, 67, 4, 4, '2025-03-12', 'Outpatient', 'Minor Illness', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (68, 68, 19, 13, '2025-03-13', 'Inpatient', 'Organ Failure', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (69, 69, 15, 15, '2025-03-14', 'Outpatient', 'Blood Test', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (70, 70, 19, 13, '2025-03-15', 'Inpatient', 'Critical Care', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (71, 71, 3, 3, '2025-03-16', 'Outpatient', 'Back Strain', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (72, 72, 19, 13, '2025-03-17', 'Inpatient', 'Age Related Issues', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (73, 73, 15, 15, '2025-03-18', 'Outpatient', 'Allergy Test', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (74, 74, 19, 13, '2025-03-19', 'Inpatient', 'Heart Problems', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (75, 75, 3, 3, '2025-03-20', 'Outpatient', 'Muscle Pain', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (76, 76, 19, 13, '2025-03-21', 'Inpatient', 'Critical Condition', 'In Progress');
INSERT INTO BRONZE_VISITS VALUES (77, 77, 15, 15, '2025-03-22', 'Outpatient', 'General Checkup', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (78, 78, 19, 13, '2025-03-23', 'Inpatient', 'Organ Failure', 'In Progress');
INSERT INTO BRONZE_VISITS VALUES (79, 79, 3, 3, '2025-03-24', 'Outpatient', 'Joint Pain', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (80, 80, 19, 13, '2025-03-25', 'Inpatient', 'Heart Failure', 'In Progress');
INSERT INTO BRONZE_VISITS VALUES (81, 1, 1, 1, '2025-03-01', 'Follow-up', 'Cardiac Monitoring', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (82, 2, 1, 1, '2025-03-02', 'Follow-up', 'Post Heart Attack', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (83, 4, 19, 13, '2025-03-03', 'Inpatient', 'Heart Failure', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (84, 10, 2, 2, '2025-03-04', 'Follow-up', 'Stroke Recovery', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (85, 14, 1, 1, '2025-03-05', 'Follow-up', 'Cardiac Rehab', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (86, 18, 1, 1, '2025-03-06', 'Follow-up', 'Heart Monitoring', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (87, 20, 19, 13, '2025-03-07', 'Inpatient', 'Critical Care', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (88, 28, 1, 1, '2025-03-08', 'Follow-up', 'Post Surgery', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (89, 30, 6, 6, '2025-03-09', 'Follow-up', 'COPD Checkup', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (90, 40, 19, 13, '2025-03-10', 'Follow-up', 'Recovery Check', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (91, 44, 1, 1, '2025-03-11', 'Follow-up', 'Cardiac Rehab', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (92, 48, 1, 1, '2025-03-12', 'Follow-up', 'Heart Checkup', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (93, 50, 19, 13, '2025-03-13', 'Follow-up', 'Critical Review', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (94, 6, 9, 9, '2025-03-14', 'Follow-up', 'Diabetes Review', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (95, 22, 9, 9, '2025-03-15', 'Follow-up', 'Diabetes Review', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (96, 42, 9, 9, '2025-03-16', 'Follow-up', 'Diabetes Review', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (97, 7, 6, 6, '2025-03-17', 'Follow-up', 'COPD Review', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (98, 43, 6, 6, '2025-03-18', 'Follow-up', 'COPD Review', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (99, 16, 8, 8, '2025-03-19', 'Follow-up', 'Kidney Review', 'Completed');
INSERT INTO BRONZE_VISITS VALUES (100, 26, 8, 8, '2025-03-20', 'Follow-up', 'Dialysis Review', 'Completed');

-- ============================================================================
-- TABLE 5: BRONZE_DIAGNOSES
-- ============================================================================
CREATE OR REPLACE TABLE BRONZE_DIAGNOSES (
    DIAGNOSIS_ID    NUMBER PRIMARY KEY,
    PATIENT_ID      NUMBER,
    VISIT_ID        NUMBER,
    DIAGNOSIS_CODE  VARCHAR(10),
    DIAGNOSIS_NAME  VARCHAR(100),
    SEVERITY        VARCHAR(20),
    IS_CHRONIC      VARCHAR(5)
);

INSERT INTO BRONZE_DIAGNOSES VALUES (1, 1, 1, 'I10', 'Hypertension', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (2, 2, 2, 'I21', 'Heart Attack', 'Critical', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (3, 2, 2, 'I25', 'Heart Disease', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (4, 3, 3, 'M54', 'Back Pain', 'Mild', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (5, 4, 4, 'I50', 'Heart Failure', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (6, 4, 4, 'E11', 'Type 2 Diabetes', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (7, 4, 4, 'N18', 'Kidney Disease', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (8, 5, 5, 'J06', 'Upper Respiratory Infection', 'Mild', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (9, 6, 6, 'E11', 'Type 2 Diabetes', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (10, 6, 6, 'I10', 'Hypertension', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (11, 7, 7, 'J44', 'COPD', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (12, 8, 8, 'I10', 'Hypertension', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (13, 9, 9, 'G43', 'Migraine', 'Mild', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (14, 10, 10, 'I63', 'Stroke', 'Critical', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (15, 10, 10, 'I10', 'Hypertension', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (16, 11, 11, 'M17', 'Knee Osteoarthritis', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (17, 12, 12, 'E03', 'Hypothyroidism', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (18, 13, 13, 'J18', 'Pneumonia', 'Severe', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (19, 14, 14, 'I21', 'Heart Attack', 'Critical', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (20, 14, 14, 'I25', 'Heart Disease', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (21, 15, 15, 'K21', 'Acid Reflux', 'Mild', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (22, 16, 16, 'N18', 'Kidney Disease', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (23, 17, 17, 'G43', 'Migraine', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (24, 18, 18, 'I50', 'Heart Failure', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (25, 18, 18, 'I10', 'Hypertension', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (26, 19, 19, 'F41', 'Anxiety Disorder', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (27, 20, 20, 'I50', 'Heart Failure', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (28, 20, 20, 'N18', 'Kidney Disease', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (29, 21, 21, 'M75', 'Shoulder Pain', 'Mild', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (30, 22, 22, 'E11', 'Type 2 Diabetes', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (31, 23, 23, 'J45', 'Asthma', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (32, 24, 24, 'I20', 'Angina', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (33, 25, 25, 'K21', 'Acid Reflux', 'Mild', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (34, 26, 26, 'N18', 'Kidney Disease', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (35, 27, 27, 'R42', 'Dizziness', 'Mild', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (36, 28, 28, 'I46', 'Cardiac Arrest', 'Critical', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (37, 28, 28, 'I25', 'Heart Disease', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (38, 29, 29, 'K35', 'Appendicitis', 'Severe', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (39, 30, 30, 'J96', 'Respiratory Failure', 'Critical', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (40, 30, 30, 'J44', 'COPD', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (41, 31, 31, 'S82', 'Leg Fracture', 'Moderate', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (42, 32, 32, 'E05', 'Hyperthyroidism', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (43, 33, 33, 'J15', 'Bacterial Pneumonia', 'Severe', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (44, 34, 34, 'I49', 'Cardiac Arrhythmia', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (45, 35, 35, 'K50', 'Crohns Disease', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (46, 36, 36, 'N20', 'Kidney Stones', 'Moderate', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (47, 37, 37, 'G40', 'Epilepsy', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (48, 38, 38, 'I25', 'Heart Disease', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (49, 39, 39, 'F32', 'Depression', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (50, 40, 40, 'A41', 'Sepsis', 'Critical', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (51, 40, 40, 'I50', 'Heart Failure', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (52, 41, 41, 'S83', 'Knee Sprain', 'Mild', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (53, 42, 42, 'E11', 'Type 2 Diabetes', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (54, 43, 43, 'J44', 'COPD', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (55, 44, 44, 'I21', 'Heart Attack', 'Critical', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (56, 45, 45, 'K76', 'Fatty Liver Disease', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (57, 46, 46, 'N17', 'Acute Kidney Failure', 'Critical', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (58, 47, 47, 'G62', 'Neuropathy', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (59, 48, 48, 'I50', 'Heart Failure', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (60, 49, 49, 'K40', 'Inguinal Hernia', 'Moderate', 'No');
INSERT INTO BRONZE_DIAGNOSES VALUES (61, 50, 50, 'I50', 'Heart Failure', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (62, 50, 50, 'N18', 'Kidney Disease', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (63, 54, 54, 'R54', 'Age Related Decline', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (64, 56, 56, 'I50', 'Heart Failure', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (65, 58, 58, 'I25', 'Heart Disease', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (66, 60, 60, 'R54', 'Multi Organ Dysfunction', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (67, 62, 62, 'R54', 'Age Related Issues', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (68, 64, 64, 'I50', 'Heart Failure', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (69, 66, 66, 'I50', 'Heart Failure', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (70, 68, 68, 'R54', 'Organ Failure', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (71, 70, 70, 'I50', 'Heart Failure', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (72, 72, 72, 'R54', 'Age Related Issues', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (73, 74, 74, 'I25', 'Heart Disease', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (74, 76, 76, 'I50', 'Heart Failure', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (75, 78, 78, 'R54', 'Organ Failure', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (76, 80, 80, 'I50', 'Heart Failure', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (77, 82, 82, 'E11', 'Type 2 Diabetes', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (78, 84, 84, 'I10', 'Hypertension', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (79, 86, 86, 'I10', 'Hypertension', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (80, 88, 88, 'E11', 'Type 2 Diabetes', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (81, 90, 90, 'I10', 'Hypertension', 'Moderate', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (82, 92, 92, 'I50', 'Heart Failure', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (83, 94, 94, 'I10', 'Hypertension', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (84, 96, 96, 'I50', 'Heart Failure', 'Critical', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (85, 98, 98, 'I25', 'Heart Disease', 'Severe', 'Yes');
INSERT INTO BRONZE_DIAGNOSES VALUES (86, 100, 100, 'I10', 'Hypertension', 'Moderate', 'Yes');

-- ============================================================================
-- TABLE 6: BRONZE_TREATMENTS
-- ============================================================================
CREATE OR REPLACE TABLE BRONZE_TREATMENTS (
    TREATMENT_ID    NUMBER PRIMARY KEY,
    VISIT_ID        NUMBER,
    PATIENT_ID      NUMBER,
    TREATMENT_NAME  VARCHAR(100),
    TREATMENT_TYPE  VARCHAR(30),
    OUTCOME         VARCHAR(20),
    COST            NUMBER(10,2)
);

INSERT INTO BRONZE_TREATMENTS VALUES (1, 1, 1, 'Blood Pressure Monitoring', 'Monitoring', 'Successful', 150.00);
INSERT INTO BRONZE_TREATMENTS VALUES (2, 2, 2, 'Emergency Cardiac Care', 'Emergency', 'Successful', 15000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (3, 2, 2, 'Stent Placement', 'Surgery', 'Successful', 25000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (4, 3, 3, 'Physical Therapy', 'Therapy', 'Successful', 200.00);
INSERT INTO BRONZE_TREATMENTS VALUES (5, 4, 4, 'ICU Monitoring', 'Monitoring', 'Ongoing', 5000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (6, 4, 4, 'Dialysis', 'Procedure', 'Successful', 2500.00);
INSERT INTO BRONZE_TREATMENTS VALUES (7, 5, 5, 'Fever Treatment', 'Treatment', 'Successful', 100.00);
INSERT INTO BRONZE_TREATMENTS VALUES (8, 6, 6, 'Diabetes Counseling', 'Counseling', 'Successful', 150.00);
INSERT INTO BRONZE_TREATMENTS VALUES (9, 7, 7, 'Oxygen Therapy', 'Treatment', 'Successful', 1200.00);
INSERT INTO BRONZE_TREATMENTS VALUES (10, 8, 8, 'Cardiac Monitoring', 'Monitoring', 'Successful', 500.00);
INSERT INTO BRONZE_TREATMENTS VALUES (11, 9, 9, 'Migraine Treatment', 'Treatment', 'Successful', 200.00);
INSERT INTO BRONZE_TREATMENTS VALUES (12, 10, 10, 'Stroke Treatment', 'Emergency', 'Successful', 20000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (13, 11, 11, 'Joint Therapy', 'Therapy', 'Successful', 300.00);
INSERT INTO BRONZE_TREATMENTS VALUES (14, 12, 12, 'Thyroid Treatment', 'Treatment', 'Successful', 180.00);
INSERT INTO BRONZE_TREATMENTS VALUES (15, 13, 13, 'Antibiotic Treatment', 'Treatment', 'Successful', 1500.00);
INSERT INTO BRONZE_TREATMENTS VALUES (16, 14, 14, 'Emergency Heart Surgery', 'Surgery', 'Successful', 45000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (17, 15, 15, 'Endoscopy', 'Procedure', 'Successful', 1200.00);
INSERT INTO BRONZE_TREATMENTS VALUES (18, 16, 16, 'Dialysis Session', 'Procedure', 'Successful', 2500.00);
INSERT INTO BRONZE_TREATMENTS VALUES (19, 17, 17, 'Migraine Treatment', 'Treatment', 'Successful', 200.00);
INSERT INTO BRONZE_TREATMENTS VALUES (20, 18, 18, 'Heart Failure Management', 'Treatment', 'Ongoing', 4000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (21, 19, 19, 'Anxiety Therapy', 'Therapy', 'Successful', 250.00);
INSERT INTO BRONZE_TREATMENTS VALUES (22, 20, 20, 'Multi-Organ Support', 'Treatment', 'Ongoing', 15000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (23, 21, 21, 'Shoulder Therapy', 'Therapy', 'Successful', 200.00);
INSERT INTO BRONZE_TREATMENTS VALUES (24, 22, 22, 'Insulin Therapy', 'Treatment', 'Successful', 150.00);
INSERT INTO BRONZE_TREATMENTS VALUES (25, 23, 23, 'Asthma Treatment', 'Treatment', 'Successful', 400.00);
INSERT INTO BRONZE_TREATMENTS VALUES (26, 24, 24, 'Cardiac Monitoring', 'Monitoring', 'Successful', 1500.00);
INSERT INTO BRONZE_TREATMENTS VALUES (27, 25, 25, 'Acid Reflux Treatment', 'Treatment', 'Successful', 150.00);
INSERT INTO BRONZE_TREATMENTS VALUES (28, 26, 26, 'Dialysis Session', 'Procedure', 'Successful', 2500.00);
INSERT INTO BRONZE_TREATMENTS VALUES (29, 27, 27, 'Balance Therapy', 'Therapy', 'Successful', 180.00);
INSERT INTO BRONZE_TREATMENTS VALUES (30, 28, 28, 'Emergency Resuscitation', 'Emergency', 'Successful', 8000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (31, 28, 28, 'ICU Care', 'Treatment', 'Successful', 12000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (32, 29, 29, 'Appendectomy', 'Surgery', 'Successful', 12000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (33, 30, 30, 'Ventilator Support', 'Treatment', 'Ongoing', 10000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (34, 31, 31, 'Cast Application', 'Procedure', 'Successful', 500.00);
INSERT INTO BRONZE_TREATMENTS VALUES (35, 32, 32, 'Thyroid Management', 'Treatment', 'Successful', 200.00);
INSERT INTO BRONZE_TREATMENTS VALUES (36, 33, 33, 'IV Antibiotics', 'Treatment', 'Successful', 1800.00);
INSERT INTO BRONZE_TREATMENTS VALUES (37, 34, 34, 'Antiarrhythmic Therapy', 'Treatment', 'Successful', 1200.00);
INSERT INTO BRONZE_TREATMENTS VALUES (38, 35, 35, 'Colonoscopy', 'Procedure', 'Successful', 2000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (39, 36, 36, 'Stone Removal', 'Surgery', 'Successful', 8000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (40, 37, 37, 'Seizure Management', 'Treatment', 'Successful', 600.00);
INSERT INTO BRONZE_TREATMENTS VALUES (41, 38, 38, 'Bypass Surgery', 'Surgery', 'Successful', 75000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (42, 39, 39, 'Depression Therapy', 'Therapy', 'Successful', 250.00);
INSERT INTO BRONZE_TREATMENTS VALUES (43, 40, 40, 'Sepsis Treatment', 'Treatment', 'Ongoing', 12000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (44, 41, 41, 'Knee Brace Fitting', 'Procedure', 'Successful', 300.00);
INSERT INTO BRONZE_TREATMENTS VALUES (45, 42, 42, 'Diabetes Education', 'Counseling', 'Successful', 150.00);
INSERT INTO BRONZE_TREATMENTS VALUES (46, 43, 43, 'Pulmonary Rehab', 'Therapy', 'Ongoing', 1500.00);
INSERT INTO BRONZE_TREATMENTS VALUES (47, 44, 44, 'Heart Attack Treatment', 'Emergency', 'Successful', 35000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (48, 45, 45, 'Liver Function Test', 'Test', 'Successful', 400.00);
INSERT INTO BRONZE_TREATMENTS VALUES (49, 46, 46, 'Emergency Dialysis', 'Procedure', 'Successful', 4000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (50, 47, 47, 'Nerve Conduction Study', 'Test', 'Successful', 600.00);
INSERT INTO BRONZE_TREATMENTS VALUES (51, 48, 48, 'Diuretic Therapy', 'Treatment', 'Ongoing', 800.00);
INSERT INTO BRONZE_TREATMENTS VALUES (52, 49, 49, 'Hernia Repair Surgery', 'Surgery', 'Successful', 15000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (53, 50, 50, 'Advanced Life Support', 'Treatment', 'Ongoing', 20000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (54, 54, 54, 'Geriatric Care', 'Treatment', 'Ongoing', 5000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (55, 56, 56, 'ICU Care', 'Treatment', 'Ongoing', 15000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (56, 58, 58, 'Cardiac Care', 'Treatment', 'Ongoing', 8000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (57, 60, 60, 'Multi-Organ Support', 'Treatment', 'Ongoing', 20000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (58, 62, 62, 'Geriatric Care', 'Treatment', 'Ongoing', 5000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (59, 64, 64, 'ICU Care', 'Treatment', 'Ongoing', 15000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (60, 66, 66, 'Heart Failure Management', 'Treatment', 'Ongoing', 8000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (61, 68, 68, 'Multi-Organ Support', 'Treatment', 'Ongoing', 20000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (62, 70, 70, 'ICU Care', 'Treatment', 'Ongoing', 15000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (63, 72, 72, 'Geriatric Care', 'Treatment', 'Ongoing', 5000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (64, 74, 74, 'Cardiac Care', 'Treatment', 'Ongoing', 8000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (65, 76, 76, 'ICU Care', 'Treatment', 'Ongoing', 15000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (66, 78, 78, 'Multi-Organ Support', 'Treatment', 'Ongoing', 20000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (67, 80, 80, 'Heart Failure Management', 'Treatment', 'Ongoing', 8000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (68, 81, 1, 'Follow-up Monitoring', 'Monitoring', 'Successful', 150.00);
INSERT INTO BRONZE_TREATMENTS VALUES (69, 82, 2, 'Cardiac Rehab', 'Therapy', 'Ongoing', 2000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (70, 83, 4, 'ICU Monitoring', 'Monitoring', 'Ongoing', 5000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (71, 84, 10, 'Physical Rehab', 'Therapy', 'Ongoing', 2000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (72, 85, 14, 'Cardiac Rehab', 'Therapy', 'Ongoing', 2000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (73, 86, 18, 'Heart Monitoring', 'Monitoring', 'Successful', 500.00);
INSERT INTO BRONZE_TREATMENTS VALUES (74, 87, 20, 'Critical Care', 'Treatment', 'Ongoing', 10000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (75, 88, 28, 'Follow-up Care', 'Monitoring', 'Successful', 200.00);
INSERT INTO BRONZE_TREATMENTS VALUES (76, 89, 30, 'COPD Management', 'Treatment', 'Ongoing', 800.00);
INSERT INTO BRONZE_TREATMENTS VALUES (77, 90, 40, 'Recovery Monitoring', 'Monitoring', 'Successful', 300.00);
INSERT INTO BRONZE_TREATMENTS VALUES (78, 91, 44, 'Cardiac Rehab', 'Therapy', 'Ongoing', 2000.00);
INSERT INTO BRONZE_TREATMENTS VALUES (79, 92, 48, 'Heart Monitoring', 'Monitoring', 'Successful', 500.00);
INSERT INTO BRONZE_TREATMENTS VALUES (80, 93, 50, 'Critical Review', 'Monitoring', 'Ongoing', 1000.00);

-- ============================================================================
-- TABLE 7: BRONZE_BILLING
-- ============================================================================
CREATE OR REPLACE TABLE BRONZE_BILLING (
    BILL_ID         NUMBER PRIMARY KEY,
    VISIT_ID        NUMBER,
    PATIENT_ID      NUMBER,
    SERVICE_TYPE    VARCHAR(50),
    AMOUNT          NUMBER(10,2),
    PAYMENT_STATUS  VARCHAR(20)
);

INSERT INTO BRONZE_BILLING VALUES (1, 1, 1, 'Consultation Fee', 150.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (2, 2, 2, 'Emergency Room', 800.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (3, 2, 2, 'Surgery Fee', 25000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (4, 2, 2, 'ICU Charges', 15000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (5, 3, 3, 'Consultation Fee', 150.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (6, 3, 3, 'Physical Therapy', 200.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (7, 4, 4, 'ICU Charges', 15000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (8, 4, 4, 'Dialysis', 2500.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (9, 5, 5, 'Consultation Fee', 150.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (10, 6, 6, 'Lab Tests', 350.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (11, 7, 7, 'Hospital Stay', 5000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (12, 8, 8, 'Emergency Room', 800.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (13, 9, 9, 'Consultation Fee', 150.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (14, 10, 10, 'ICU Charges', 25000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (15, 11, 11, 'Consultation Fee', 150.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (16, 12, 12, 'Lab Tests', 250.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (17, 13, 13, 'Hospital Stay', 7000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (18, 14, 14, 'Emergency Room', 800.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (19, 14, 14, 'Surgery Fee', 45000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (20, 15, 15, 'Procedure Fee', 1200.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (21, 16, 16, 'Dialysis', 7500.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (22, 17, 17, 'Consultation Fee', 150.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (23, 18, 18, 'Hospital Stay', 10000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (24, 19, 19, 'Consultation Fee', 150.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (25, 20, 20, 'ICU Charges', 35000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (26, 21, 21, 'Consultation Fee', 150.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (27, 22, 22, 'Lab Tests', 350.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (28, 23, 23, 'Hospital Stay', 7000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (29, 24, 24, 'Emergency Room', 800.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (30, 25, 25, 'Consultation Fee', 150.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (31, 26, 26, 'Dialysis', 7500.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (32, 27, 27, 'Consultation Fee', 150.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (33, 28, 28, 'Emergency Room', 8000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (34, 28, 28, 'ICU Charges', 24000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (35, 29, 29, 'Surgery Fee', 12000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (36, 30, 30, 'ICU Charges', 30000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (37, 31, 31, 'Consultation Fee', 150.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (38, 32, 32, 'Lab Tests', 250.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (39, 33, 33, 'Hospital Stay', 7000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (40, 34, 34, 'Emergency Room', 800.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (41, 35, 35, 'Procedure Fee', 2000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (42, 36, 36, 'Surgery Fee', 8000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (43, 37, 37, 'Consultation Fee', 150.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (44, 38, 38, 'Surgery Fee', 75000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (45, 38, 38, 'ICU Charges', 20000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (46, 39, 39, 'Consultation Fee', 150.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (47, 40, 40, 'ICU Charges', 25000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (48, 41, 41, 'Consultation Fee', 150.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (49, 42, 42, 'Lab Tests', 350.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (50, 43, 43, 'Hospital Stay', 7000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (51, 44, 44, 'Emergency Room', 800.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (52, 44, 44, 'Surgery Fee', 35000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (53, 45, 45, 'Lab Tests', 400.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (54, 46, 46, 'Dialysis', 4000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (55, 47, 47, 'Procedure Fee', 600.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (56, 48, 48, 'Hospital Stay', 10000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (57, 49, 49, 'Surgery Fee', 15000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (58, 50, 50, 'ICU Charges', 40000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (59, 54, 54, 'ICU Charges', 30000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (60, 56, 56, 'ICU Charges', 45000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (61, 58, 58, 'Hospital Stay', 15000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (62, 60, 60, 'ICU Charges', 50000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (63, 62, 62, 'Hospital Stay', 20000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (64, 64, 64, 'ICU Charges', 45000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (65, 66, 66, 'ICU Charges', 40000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (66, 68, 68, 'ICU Charges', 55000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (67, 70, 70, 'ICU Charges', 45000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (68, 72, 72, 'Hospital Stay', 25000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (69, 74, 74, 'Hospital Stay', 20000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (70, 76, 76, 'ICU Charges', 50000.00, 'Pending');
INSERT INTO BRONZE_BILLING VALUES (71, 78, 78, 'ICU Charges', 55000.00, 'Pending');
INSERT INTO BRONZE_BILLING VALUES (72, 80, 80, 'ICU Charges', 45000.00, 'Pending');
INSERT INTO BRONZE_BILLING VALUES (73, 81, 1, 'Follow-up Visit', 120.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (74, 82, 2, 'Follow-up Visit', 120.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (75, 83, 4, 'ICU Charges', 15000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (76, 84, 10, 'Follow-up Visit', 120.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (77, 85, 14, 'Follow-up Visit', 120.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (78, 86, 18, 'Follow-up Visit', 120.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (79, 87, 20, 'ICU Charges', 15000.00, 'Insurance');
INSERT INTO BRONZE_BILLING VALUES (80, 88, 28, 'Follow-up Visit', 120.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (81, 89, 30, 'Follow-up Visit', 120.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (82, 90, 40, 'Follow-up Visit', 120.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (83, 91, 44, 'Follow-up Visit', 120.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (84, 92, 48, 'Follow-up Visit', 120.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (85, 93, 50, 'Follow-up Visit', 120.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (86, 94, 6, 'Follow-up Visit', 120.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (87, 95, 22, 'Follow-up Visit', 120.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (88, 96, 42, 'Follow-up Visit', 120.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (89, 97, 7, 'Follow-up Visit', 120.00, 'Paid');
INSERT INTO BRONZE_BILLING VALUES (90, 98, 43, 'Follow-up Visit', 120.00, 'Paid');

-- ============================================================================
-- TABLE 8: BRONZE_MEDICATIONS
-- ============================================================================
CREATE OR REPLACE TABLE BRONZE_MEDICATIONS (
    MEDICATION_ID   NUMBER PRIMARY KEY,
    PATIENT_ID      NUMBER,
    MEDICATION_NAME VARCHAR(50),
    DOSAGE          VARCHAR(20),
    FREQUENCY       VARCHAR(30),
    PRESCRIBER_ID   NUMBER
);

INSERT INTO BRONZE_MEDICATIONS VALUES (1, 1, 'Lisinopril', '10mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (2, 2, 'Aspirin', '81mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (3, 2, 'Metoprolol', '50mg', 'Twice Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (4, 2, 'Clopidogrel', '75mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (5, 3, 'Ibuprofen', '400mg', 'As Needed', 3);
INSERT INTO BRONZE_MEDICATIONS VALUES (6, 4, 'Furosemide', '40mg', 'Twice Daily', 19);
INSERT INTO BRONZE_MEDICATIONS VALUES (7, 4, 'Carvedilol', '25mg', 'Twice Daily', 19);
INSERT INTO BRONZE_MEDICATIONS VALUES (8, 4, 'Insulin', '30 units', 'Twice Daily', 9);
INSERT INTO BRONZE_MEDICATIONS VALUES (9, 5, 'Paracetamol', '500mg', 'Every 6 Hours', 4);
INSERT INTO BRONZE_MEDICATIONS VALUES (10, 6, 'Metformin', '1000mg', 'Twice Daily', 9);
INSERT INTO BRONZE_MEDICATIONS VALUES (11, 6, 'Amlodipine', '5mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (12, 7, 'Tiotropium', '18mcg', 'Once Daily', 6);
INSERT INTO BRONZE_MEDICATIONS VALUES (13, 7, 'Salbutamol', '100mcg', 'As Needed', 6);
INSERT INTO BRONZE_MEDICATIONS VALUES (14, 8, 'Lisinopril', '10mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (15, 9, 'Sumatriptan', '50mg', 'As Needed', 2);
INSERT INTO BRONZE_MEDICATIONS VALUES (16, 10, 'Aspirin', '81mg', 'Once Daily', 2);
INSERT INTO BRONZE_MEDICATIONS VALUES (17, 10, 'Atorvastatin', '40mg', 'Once Daily', 2);
INSERT INTO BRONZE_MEDICATIONS VALUES (18, 11, 'Naproxen', '500mg', 'Twice Daily', 3);
INSERT INTO BRONZE_MEDICATIONS VALUES (19, 12, 'Levothyroxine', '100mcg', 'Once Daily', 9);
INSERT INTO BRONZE_MEDICATIONS VALUES (20, 13, 'Amoxicillin', '500mg', 'Three Times Daily', 6);
INSERT INTO BRONZE_MEDICATIONS VALUES (21, 14, 'Aspirin', '81mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (22, 14, 'Metoprolol', '100mg', 'Twice Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (23, 15, 'Omeprazole', '20mg', 'Once Daily', 7);
INSERT INTO BRONZE_MEDICATIONS VALUES (24, 16, 'Epoetin Alfa', '10000 units', 'Three Times Weekly', 8);
INSERT INTO BRONZE_MEDICATIONS VALUES (25, 17, 'Sumatriptan', '100mg', 'As Needed', 2);
INSERT INTO BRONZE_MEDICATIONS VALUES (26, 18, 'Furosemide', '80mg', 'Twice Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (27, 18, 'Lisinopril', '20mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (28, 19, 'Sertraline', '50mg', 'Once Daily', 14);
INSERT INTO BRONZE_MEDICATIONS VALUES (29, 20, 'Furosemide', '120mg', 'Twice Daily', 19);
INSERT INTO BRONZE_MEDICATIONS VALUES (30, 20, 'Insulin', '40 units', 'Twice Daily', 9);
INSERT INTO BRONZE_MEDICATIONS VALUES (31, 21, 'Ibuprofen', '600mg', 'Three Times Daily', 3);
INSERT INTO BRONZE_MEDICATIONS VALUES (32, 22, 'Metformin', '500mg', 'Twice Daily', 9);
INSERT INTO BRONZE_MEDICATIONS VALUES (33, 23, 'Montelukast', '10mg', 'Once Daily', 6);
INSERT INTO BRONZE_MEDICATIONS VALUES (34, 24, 'Nitroglycerin', '0.4mg', 'As Needed', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (35, 25, 'Pantoprazole', '40mg', 'Once Daily', 7);
INSERT INTO BRONZE_MEDICATIONS VALUES (36, 26, 'Calcitriol', '0.5mcg', 'Once Daily', 8);
INSERT INTO BRONZE_MEDICATIONS VALUES (37, 27, 'Meclizine', '25mg', 'Three Times Daily', 2);
INSERT INTO BRONZE_MEDICATIONS VALUES (38, 28, 'Amiodarone', '200mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (39, 28, 'Aspirin', '81mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (40, 29, 'Ciprofloxacin', '500mg', 'Twice Daily', 17);
INSERT INTO BRONZE_MEDICATIONS VALUES (41, 30, 'Prednisone', '40mg', 'Once Daily', 6);
INSERT INTO BRONZE_MEDICATIONS VALUES (42, 31, 'Calcium', '500mg', 'Twice Daily', 3);
INSERT INTO BRONZE_MEDICATIONS VALUES (43, 32, 'Methimazole', '10mg', 'Once Daily', 9);
INSERT INTO BRONZE_MEDICATIONS VALUES (44, 33, 'Azithromycin', '500mg', 'Once Daily', 6);
INSERT INTO BRONZE_MEDICATIONS VALUES (45, 34, 'Flecainide', '100mg', 'Twice Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (46, 35, 'Mesalamine', '800mg', 'Three Times Daily', 7);
INSERT INTO BRONZE_MEDICATIONS VALUES (47, 36, 'Tamsulosin', '0.4mg', 'Once Daily', 8);
INSERT INTO BRONZE_MEDICATIONS VALUES (48, 37, 'Levetiracetam', '500mg', 'Twice Daily', 2);
INSERT INTO BRONZE_MEDICATIONS VALUES (49, 38, 'Aspirin', '81mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (50, 38, 'Clopidogrel', '75mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (51, 39, 'Escitalopram', '10mg', 'Once Daily', 14);
INSERT INTO BRONZE_MEDICATIONS VALUES (52, 40, 'Vancomycin', '1g', 'Twice Daily', 19);
INSERT INTO BRONZE_MEDICATIONS VALUES (53, 41, 'Ibuprofen', '400mg', 'As Needed', 3);
INSERT INTO BRONZE_MEDICATIONS VALUES (54, 42, 'Metformin', '500mg', 'Twice Daily', 9);
INSERT INTO BRONZE_MEDICATIONS VALUES (55, 43, 'Tiotropium', '18mcg', 'Once Daily', 6);
INSERT INTO BRONZE_MEDICATIONS VALUES (56, 44, 'Aspirin', '81mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (57, 44, 'Metoprolol', '50mg', 'Twice Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (58, 45, 'Ursodiol', '300mg', 'Twice Daily', 7);
INSERT INTO BRONZE_MEDICATIONS VALUES (59, 46, 'Sevelamer', '800mg', 'Three Times Daily', 8);
INSERT INTO BRONZE_MEDICATIONS VALUES (60, 47, 'Gabapentin', '300mg', 'Three Times Daily', 2);
INSERT INTO BRONZE_MEDICATIONS VALUES (61, 48, 'Furosemide', '40mg', 'Twice Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (62, 48, 'Lisinopril', '10mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (63, 49, 'Acetaminophen', '500mg', 'As Needed', 17);
INSERT INTO BRONZE_MEDICATIONS VALUES (64, 50, 'Furosemide', '80mg', 'Twice Daily', 19);
INSERT INTO BRONZE_MEDICATIONS VALUES (65, 50, 'Carvedilol', '25mg', 'Twice Daily', 19);
INSERT INTO BRONZE_MEDICATIONS VALUES (66, 82, 'Metformin', '500mg', 'Twice Daily', 9);
INSERT INTO BRONZE_MEDICATIONS VALUES (67, 84, 'Lisinopril', '10mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (68, 86, 'Amlodipine', '5mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (69, 88, 'Metformin', '1000mg', 'Twice Daily', 9);
INSERT INTO BRONZE_MEDICATIONS VALUES (70, 90, 'Lisinopril', '20mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (71, 92, 'Furosemide', '40mg', 'Twice Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (72, 94, 'Amlodipine', '10mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (73, 96, 'Furosemide', '80mg', 'Twice Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (74, 98, 'Aspirin', '81mg', 'Once Daily', 1);
INSERT INTO BRONZE_MEDICATIONS VALUES (75, 100, 'Lisinopril', '10mg', 'Once Daily', 1);

-- ============================================================================
-- VERIFY ROW COUNTS
-- ============================================================================
SELECT 'BRONZE_PATIENTS' AS TABLE_NAME, COUNT(*) AS ROW_COUNT FROM BRONZE_PATIENTS
UNION ALL SELECT 'BRONZE_DOCTORS', COUNT(*) FROM BRONZE_DOCTORS
UNION ALL SELECT 'BRONZE_DEPARTMENTS', COUNT(*) FROM BRONZE_DEPARTMENTS
UNION ALL SELECT 'BRONZE_VISITS', COUNT(*) FROM BRONZE_VISITS
UNION ALL SELECT 'BRONZE_DIAGNOSES', COUNT(*) FROM BRONZE_DIAGNOSES
UNION ALL SELECT 'BRONZE_TREATMENTS', COUNT(*) FROM BRONZE_TREATMENTS
UNION ALL SELECT 'BRONZE_BILLING', COUNT(*) FROM BRONZE_BILLING
UNION ALL SELECT 'BRONZE_MEDICATIONS', COUNT(*) FROM BRONZE_MEDICATIONS;

/*

*/
