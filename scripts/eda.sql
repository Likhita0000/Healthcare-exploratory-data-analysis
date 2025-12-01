/* =============================================================================
   EXPLORATORY DATA ANALYSIS (EDA)
   Healthcare Analytics – Gold Layer
   ---------------------------------------------------------------------------
   Purpose:
   This script performs a complete exploratory data analysis across all 
   dimension and fact tables in the Gold Layer. It covers:
   • Database structure exploration
   • Dimension-level profiling
   • Fact-level understanding
   • Date and time-based patterns
   • Financial measure analysis
   • Volume and magnitude analysis

   This structured EDA helps validate data quality, uncover trends, and 
   prepare insights for reporting and modeling.
   ============================================================================= */


/* ============================================================================
   1. DATABASE EXPLORATION
   ---------------------------------------------------------------------------
   Objective:
   Identify all available tables in the database to understand the schema.
   ============================================================================ */

SELECT * FROM INFORMATION_SCHEMA.TABLES;



/* ============================================================================
   2. DIMENSION EXPLORATION
   ---------------------------------------------------------------------------
   Purpose:
   Explore and validate all dimension tables—checking distinct values, ranges,
   duplicates, and key business attributes.
   ============================================================================ */

-- ---------------------------------------------------------------------------
-- 2.1 Explore gold.fact_appointments (as part of dimension profiling)
-- ---------------------------------------------------------------------------

SELECT * FROM gold.fact_appointments;

SELECT DISTINCT appointment_status FROM gold.fact_appointments;
SELECT DISTINCT visit_type FROM gold.fact_appointments;
SELECT DISTINCT payment_method FROM gold.fact_appointments;

SELECT COUNT(*) AS total_appointments 
FROM gold.fact_appointments;

-- Check for duplicate appointment IDs
SELECT appointment_id, COUNT(*) AS duplicate_count
FROM gold.fact_appointments
GROUP BY appointment_id
HAVING COUNT(*) > 1;



-- ---------------------------------------------------------------------------
-- 2.2 Explore gold.dim_departments
-- ---------------------------------------------------------------------------

SELECT DISTINCT department_type FROM gold.dim_departments;
SELECT DISTINCT department_name FROM gold.dim_departments;

-- Check for exact duplicate department entries
SELECT
    department_name,
    department_type,
    COUNT(*) AS duplicate_count
FROM gold.dim_departments
GROUP BY department_name, department_type
HAVING COUNT(*) > 1;  -- Expected due to multiple hospitals

-- Validate a specific department
SELECT *
FROM gold.dim_departments
WHERE department_type = 'Inpatient' 
  AND department_name = 'Cardiology';



-- ---------------------------------------------------------------------------
-- 2.3 Explore gold.dim_doctors
-- ---------------------------------------------------------------------------

SELECT * FROM gold.dim_doctors;

SELECT DISTINCT specialization FROM gold.dim_doctors;
SELECT DISTINCT employment_type FROM gold.dim_doctors;

-- Explore ranges for doctor experience and consultation times
SELECT
    MIN(avg_consultation_time_min) AS low_min_consultation_time,
    MAX(avg_consultation_time_min) AS high_min_consultation_time,
    MIN(experience_years) AS least_experienced,
    MAX(experience_years) AS most_experienced
FROM gold.dim_doctors;

-- Check for missing department or hospital links
SELECT
    doctor_name,
    CASE WHEN dept_id IS NULL THEN 1 ELSE 0 END AS dept_missing,
    CASE WHEN hospital_id IS NULL THEN 1 ELSE 0 END AS hospital_missing
FROM gold.dim_doctors
WHERE dept_id IS NULL OR hospital_id IS NULL;



-- ---------------------------------------------------------------------------
-- 2.4 Explore gold.dim_hospitals
-- ---------------------------------------------------------------------------

SELECT * FROM gold.dim_hospitals;

SELECT DISTINCT ownership_type FROM gold.dim_hospitals;
SELECT DISTINCT region FROM gold.dim_hospitals;

-- Explore bed count range
SELECT 
    MIN(bed_count) AS low_bed_count,
    MAX(bed_count) AS high_bed_count
FROM gold.dim_hospitals;



-- ---------------------------------------------------------------------------
-- 2.5 Explore gold.dim_patients
-- ---------------------------------------------------------------------------

SELECT * FROM gold.dim_patients;

SELECT DISTINCT insurance_provider FROM gold.dim_patients;
SELECT DISTINCT insurance_type FROM gold.dim_patients;
SELECT DISTINCT marital_status FROM gold.dim_patients;



/* ============================================================================
   3. DATE EXPLORATION
   ---------------------------------------------------------------------------
   Objective:
   Understand the timeline of appointments and patient demographics.
   ============================================================================ */

-- ---------------------------------------------------------------------------
-- Appointments date range
-- ---------------------------------------------------------------------------

SELECT
    MIN(appointment_date) AS earliest_date,
    MAX(appointment_date) AS latest_date
FROM gold.fact_appointments;

-- Distinct appointment years
SELECT DISTINCT YEAR(appointment_date) AS years
FROM gold.fact_appointments;

-- Appointments per month
SELECT 
    DATETRUNC(MONTH, appointment_date) AS appointment_month,
    COUNT(*) AS number_of_appointments
FROM gold.fact_appointments
GROUP BY DATETRUNC(MONTH, appointment_date)
ORDER BY appointment_month;



-- ---------------------------------------------------------------------------
-- Patient date of birth and age analysis
-- ---------------------------------------------------------------------------

SELECT 
    MIN(age) AS youngest_age,
    MAX(age) AS oldest_age,
    MIN(date_of_birth) AS earliest_birthdate,
    MAX(date_of_birth) AS latest_birthdate
FROM gold.dim_patients;

-- Identify patients with incorrect age values
SELECT
    patient_id,
    CONCAT(first_name, last_name) AS patient_name,
    date_of_birth,
    age
FROM gold.dim_patients
WHERE age = 0;



/* ============================================================================
   4. MEASURES EXPLORATION – FINANCIAL METRICS
   ---------------------------------------------------------------------------
   Purpose:
   Analyze financial measures such as total billing amounts, payments, range,
   averages, and identify unpaid or partially paid appointments.
   ============================================================================ */

-- View complete fact table
SELECT * FROM gold.fact_appointments;

-- Summary statistics for billing and payments
SELECT 
    SUM(total_bill_usd) AS total_bill_usd,
    SUM(amount_paid_usd) AS total_amount_usd,
    AVG(total_bill_usd) AS avg_bill_usd,
    AVG(amount_paid_usd) AS avg_amount_usd,
    MIN(total_bill_usd) AS min_bill_usd,
    MAX(total_bill_usd) AS max_bill_usd,
    MIN(amount_paid_usd) AS min_amount_usd,
    MAX(amount_paid_usd) AS max_amount_usd
FROM gold.fact_appointments;

-- Identify underpaid or unpaid appointments
SELECT 
    appointment_id,
    total_bill_usd,
    amount_paid_usd
FROM gold.fact_appointments
WHERE total_bill_usd != amount_paid_usd;

-- Hospital bed capacity summary
SELECT 
    SUM(bed_count) AS total_bed_count,
    AVG(bed_count) AS avg_bed_count
FROM gold.dim_hospitals;



/* =============================================================================
   5. MAGNITUDE ANALYSIS – FACT APPOINTMENTS
   ---------------------------------------------------------------------------
   Purpose:
   Analyze the scale, volume, and distribution of core appointment activity 
   across hospitals.

   Key Questions:
   • What is the total revenue generated per hospital?
   • How do appointment statuses differ across hospitals?
   • Which visit types are most utilized?
   • What is the overall workload distribution?

   This section provides a foundation for performance analysis and operational
   decision-making.
   ============================================================================= */

-- Full fact table reference
SELECT * FROM gold.fact_appointments;

-- Appointment status distribution (overall)
SELECT 
    appointment_status,
    COUNT(*) AS count_appointment_status
FROM gold.fact_appointments
GROUP BY appointment_status;

-- Appointment status distribution per hospital
SELECT 
    hospital_id,
    appointment_status,
    COUNT(*) AS count_appointment_status
FROM gold.fact_appointments
GROUP BY hospital_id, appointment_status
ORDER BY hospital_id, COUNT(*) DESC;

-- Visit type counts by hospital
SELECT 
    hospital_id,
    visit_type,
    COUNT(*) AS count_visit_type
FROM gold.fact_appointments
GROUP BY hospital_id, visit_type
ORDER BY hospital_id;


SELECT 
    dept_id,
    appointment_status,
    COUNT(*) AS count_appointment_status
FROM gold.fact_appointments
GROUP BY dept_id, appointment_status
ORDER BY dept_id, COUNT(*) DESC;

SELECT 
    dept_id,
    visit_type,
    COUNT(*) AS count_visit_type
FROM gold.fact_appointments
GROUP BY dept_id, visit_type
ORDER BY dept_id;

SELECT 
    dept_id,
    SUM(amount_paid_usd) AS total_amount_paid,
    ROUND(AVG(amount_paid_usd), 2) AS avg_amount_paid
FROM gold.fact_appointments
GROUP BY dept_id
ORDER BY dept_id;   

SELECT 
    visit_type,
    SUM(amount_paid_usd) AS total_amount_paid,
    ROUND(AVG(amount_paid_usd), 2) AS avg_amount_paid
FROM gold.fact_appointments
GROUP BY visit_type
ORDER BY visit_type;

SELECT 
    appointment_status,
    SUM(amount_paid_usd) AS total_amount_paid,
    ROUND(AVG(amount_paid_usd), 2) AS avg_amount_paid
FROM gold.fact_appointments
GROUP BY appointment_status
ORDER BY appointment_status;

-- Revenue per hospital
SELECT 
    hospital_id,
    SUM(amount_paid_usd) AS total_amount_paid,
    ROUND(AVG(amount_paid_usd), 2) AS avg_amount_paid
FROM gold.fact_appointments
GROUP BY hospital_id
ORDER BY hospital_id;

/* =============================================================================

-- Ranking analysis

============================================================================= */ 

SELECT * FROM gold.fact_appointments;

-- Rank Hospitals by Total Revenue
SELECT
    hospital_id,
    SUM(amount_paid_usd) AS total_revenue,
    RANK() OVER (ORDER BY SUM(amount_paid_usd) DESC) AS revenue_rank
FROM gold.fact_appointments
GROUP BY hospital_id
ORDER BY revenue_rank;

-- Rank Departments by Appointment Volume
SELECT
    dept_id,
    COUNT(*) AS total_appointments,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS appointment_rank
FROM gold.fact_appointments
GROUP BY dept_id
ORDER BY appointment_rank;

-- Rank Doctors by Experience
SELECT
    doctor_id,
    doctor_name,
    experience_years,
    RANK() OVER (ORDER BY experience_years DESC) AS experience_rank
FROM gold.dim_doctors
ORDER BY experience_rank;
