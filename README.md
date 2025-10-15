# Credit-Card-Approval-Analysis
Here, I have analysed a Credit Card Application dataset using Python, MySQL and used data visualization tools like Power BI to show the Analysis
Here’s an updated, professional README for your GitHub project that includes all steps and technologies: SQL and Python-based data cleaning, EDA, and Power BI dashboarding.

***

# Credit Card Approval Analysis

## Overview

A full-cycle data analytics project analyzing credit card applications using SQL, Python (Pandas), and Power BI. The goal is to provide actionable insights into applicant characteristics, approval likelihoods, and business risk/opportunity segments.

***

## Contents

- **SQL & Python Data Cleaning**: Raw dataset preprocessing, outlier removal, transformation, exploratory analysis
- **Power BI Dashboard**: Business-oriented visual analytics with interactive filtering
- **Documentation & Example Visuals**

***

## Data Pipeline

## 1. Data Cleaning & Exploration (Python)
Began with raw dataset imported into Python (Jupyter Notebook)
Performed data cleaning: removed nulls, standardized column formats, normalized income features
Conducted basic exploration: plotted distributions and outlier checks using matplotlib
Feature engineering: converted categorical codes to readable labels (“Married”, “Employed”, etc.), regularized values where needed
Exported two CSV files: a cleaned dataset and an aggregated summary for later analysis

## 2. Data Analysis & Querying (SQL)
Imported cleaned and aggregated CSVs into SQL
Performed further data type corrections and validation
Ran SQL queries for business logic, custom mappings, segmentation (e.g., CASE statements for category interpretation)
Outlier analysis and integrity review on the SQL side

## 3. Business Analytics Dashboard (Power BI)

- KPIs: Total Applicants, Approval Rate, Mean Income, Credit Score
- Visuals:
  - Approval by Gender/Employment/Marriage
  - Average stats by approval status
  - Approval By Industry
  - Distribution analyses (Income, Age, Debt, Credit Score)
  - Outlier checks (Max, Min, Avg per Approval)
- Usability: Clear color palette, modern UI, filter panel for segment exploration

***

## Directory Structure

| Folder / File          | Purpose                                              |
|------------------------|------------------------------------------------------|
| /data/                 | Cleaned and raw datasets (CSV/Excel)                 |
| /sql/                  | SQL cleaning and transformation scripts              |
| /python/               | Python notebooks/scripts for EDA/cleaning            |
| /PowerBI-dashboard/    | Final .pbix file for Power BI                        |
| /images/               | Dashboard screenshots and sample charts              |

***

## Analytical Highlights

- Data-driven approval rate benchmarks by demographic and employment
- Outlier and risk pattern detection using SQL/Python analytics
- Power BI dashboard for stakeholder decision support

***

## Author

Project by Khaidem Varun Singh

***

