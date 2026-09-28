# Nashville Housing Data Cleaning – SQL

## Project Overview

This project focuses on cleaning and preparing the Nashville Housing dataset using SQL Server.

The main goal was to improve data quality and organize the dataset for further analysis and visualization.

## Tools Used

* SQL Server
* SQL Server Management Studio (SSMS)

## Data Cleaning Tasks

The following data cleaning techniques were performed:

* Standardized date formats
* Filled missing Property Address values using Parcel ID
* Split Property Address into separate Address and City columns
* Split Owner Address into separate Address, City, and State columns
* Standardized `SoldAsVacant` values from `0/1` to `No/Yes`
* Identified and removed duplicate records
* Removed unnecessary columns
* Checked for remaining NULL values

## SQL Concepts Used

* SELECT
* UPDATE
* CASE
* JOIN
* SELF JOIN
* CHARINDEX
* SUBSTRING
* CTE
* ROW_NUMBER()
* PARTITION BY
* DELETE

## Project Outcome

The dataset was cleaned and transformed into a more structured format suitable for further analysis and visualization.

## Files

* `NashvilleHousingDataCleaning.sql` – SQL script containing the data cleaning queries.
* `README.md` – Project documentation.

## Project Source

This project was completed as part of my Data Analyst learning and portfolio development.

