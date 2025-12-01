# Healthcare Analytics – Gold Layer: Exploratory Data Analysis (EDA)

## 📘 Overview

This project presents a complete Exploratory Data Analysis (EDA) performed on a **Healthcare Analytics Gold Layer Data Warehouse**. The goal of this analysis is to understand the structure, quality, and behavioral patterns within the data, while generating insights useful for downstream reporting, operational decision‑making, and advanced analytics.

The EDA covers schema discovery, dimension profiling, fact‑table exploration, date patterns, financial measures, and workload distribution across hospitals, departments, and visit types.

---

## 🏗️ Project Structure

The analysis is organized into the following major sections:

### **1. Database Exploration**

* Retrieved all available tables from the database schema.
* Understood high‑level structure of the Gold Layer.

### **2. Dimension Exploration**

Comprehensive profiling of all dimension tables:

* **Patients**: insurance, demographics, age ranges, anomalies.
* **Doctors**: specialization, experience, consultation time, missing links.
* **Departments**: unique values, duplicates, validation checks.
* **Hospitals**: ownership, region, bed capacity.

### **3. Fact Table Exploration (fact_appointments)**

* Appointment status distribution.
* Visit types and payment methods.
* Duplicate checks.
* Revenue and payment discrepancies.

### **4. Date‑Based Analysis**

* Appointment date range.
* Monthly and yearly appointment trends.
* Patient birthdate and age irregularities.

### **5. Financial Metrics Exploration**

* Revenue summaries.
* Billing and payment averages.
* Identification of underpaid or unpaid appointments.
* Hospital capacity insights.

### **6. Magnitude & Operational Analysis**

* Workload distribution by hospital and department.
* Revenue ranking.
* Most common visit types.
* Status patterns across different organizational units.

### **7. Ranking Analysis (Key Additions)**

Sample ranking queries included:

* Hospital revenue ranking.
* Department workload ranking.
* Doctor experience or workload ranking.

---

## 📊 Key Insights Generated

* Highlighted discrepancies between billed and paid amounts.
* Identified invalid patient ages and missing relational links.
* Showed workload imbalances across hospitals and departments.
* Revealed top revenue‑generating hospitals and highest‑volume departments.
* Tracked seasonality and monthly appointment behavior.

---

## 🛠️ Technologies Used

* **SQL** (Core analytics & data validation)
* **Data Warehousing Concepts** (Gold Layer, fact/dim structure)
* **Analytical Functions** (Ranking, aggregation, window functions)

