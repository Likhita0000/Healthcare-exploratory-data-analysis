-- =================================================================================
/*
	This script creates the database and schema
*/

CREATE DATABASE healthcare_gold;
GO
USE healthcare_gold;
GO
CREATE SCHEMA gold;
GO
-- =================================================================================
/*
    This DDL script checks whether each table already exists in the database. 
    If a table exists, it is dropped before creating a new one with the defined structure and constraints.
    This ensures the latest schema is always applied without duplicate or outdated tables.
*/

-- ---------------------------------------------------------------------------------
IF OBJECT_ID('gold.dim_departments', 'u') IS NOT NULL
	DROP TABLE gold.dim_departments;


CREATE TABLE gold.dim_departments (
    dept_id INT NOT NULL,
	department_name VARCHAR(50) NOT NULL,
	hospital_id	INT NOT NULL,
	floor_number INT,
	department_type VARCHAR(50)
);

-- ---------------------------------------------------------------------------------
IF OBJECT_ID('gold.dim_doctors', 'u') IS NOT NULL
	DROP TABLE gold.dim_doctors;


CREATE TABLE gold.dim_doctors (
	doctor_id INT NOT NULL,
	doctor_name	VARCHAR(50),
	gender VARCHAR(10),
	specialization VARCHAR(50),
	experience_years INT,
	dept_id	INT NOT NULL,
	hospital_id INT,
	employment_type VARCHAR(50),
	avg_consultation_time_min INT
);

-- ---------------------------------------------------------------------------------
IF OBJECT_ID('gold.dim_hospitals', 'u') IS NOT NULL
	DROP TABLE gold.dim_hospitals;


CREATE TABLE gold.dim_hospitals (
	hospital_id INT NOT NULL,
	hospital_name VARCHAR(50) NOT NULL,
	city VARCHAR(25),
	state VARCHAR(10),
	region VARCHAR(25),
	bed_count INT,
	ownership_type VARCHAR(25)
);

-- ---------------------------------------------------------------------------------
IF OBJECT_ID('gold.dim_patients', 'u') IS NOT NULL
	DROP TABLE gold.dim_patients;


CREATE TABLE gold.dim_patients(
	patient_id INT NOT NULL,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	gender VARCHAR(15),
	date_of_birth DATE,
	age	INT,
	city VARCHAR(50),
	state VARCHAR(15),
	insurance_provider VARCHAR(50),
	insurance_type VARCHAR(50),
	marital_status  VARCHAR(50)

);

-- ---------------------------------------------------------------------------------
IF OBJECT_ID('gold.fact_appointments', 'u') IS NOT NULL
	DROP TABLE gold.fact_appointments;


CREATE TABLE gold.fact_appointments(
	appointment_id INT NOT NULL,
	patient_id INT NOT NULL,
	doctor_id INT NOT NULL,
	dept_id INT,
	hospital_id INT,
	appointment_datetime DATETIME,
	appointment_date DATE,
	appointment_status VARCHAR(50),
	visit_type VARCHAR(50),
	wait_time_min INT,
	consultation_duration_min INT,
	total_bill_usd DECIMAL(10,2),
	amount_paid_usd	DECIMAL(10,2),
	payment_method VARCHAR(30),
	satisfaction_score INT,
	followup_required_flag VARCHAR(10),
	readmission_30d_flag VARCHAR(10)
);


-- =================================================================================
/*
    This script truncates existing tables and reloads them with fresh data 
    using BULK INSERT from CSV files for efficient data refresh.
*/

-- ---------------------------------------------------------------------------------
TRUNCATE TABLE gold.dim_departments;

BULK INSERT gold.dim_departments
        FROM 'healthcare_dim_departments.csv'
        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            FIRSTROW = 2,
            TABLOCK,
            CODEPAGE = '65001'
        );

-- ---------------------------------------------------------------------------------
TRUNCATE TABLE gold.dim_doctors;

BULK INSERT gold.dim_doctors
        FROM 'healthcare_dim_doctors.csv'
        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            FIRSTROW = 2,
            TABLOCK,
            CODEPAGE = '65001'
        );

-- ---------------------------------------------------------------------------------
TRUNCATE TABLE gold.dim_hospitals;

BULK INSERT gold.dim_hospitals
        FROM 'healthcare_dim_hospitals.csv'
        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            FIRSTROW = 2,
            TABLOCK,
            CODEPAGE = '65001'
        );

-- ---------------------------------------------------------------------------------
TRUNCATE TABLE gold.dim_patients;

BULK INSERT gold.dim_patients
        FROM 'healthcare_dim_patients.csv'
        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            FIRSTROW = 2,
            TABLOCK,
            CODEPAGE = '65001'
        );

-- ---------------------------------------------------------------------------------
TRUNCATE TABLE gold.fact_appointments;

BULK INSERT gold.fact_appointments
        FROM 'healthcare_fact_appointments.csv'
        WITH (
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            FIRSTROW = 2,
            TABLOCK,
            CODEPAGE = '65001'
        );
