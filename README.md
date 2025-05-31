# Credit Portfolio Monitoring Covenant Compliance Analysis




## 1. Project Overview 

This project simulates a comprehensive credit risk monitoring system for a portfolio of SME loans . It includes synthetic datasets for borrowers, loans, covenants, and quarterly financials, enabling in-depth analysis of covenant breaches, early warning indicators, and credit rating effectiveness. Key metrics such as DSCR, LTV, Debt/EBITDA, and Current Ratio are calculated and tracked over time. Analytical SQL views and queries help answer executive-level questions like "What % of the loan book is at risk?" and "Which sectors show rising leverage?". 

**Data Overview**
This project uses a set of simulated but realistic tables representing key entities in an SME loan portfolio, designed to mirror a real-world credit monitoring system. The data includes:

* **`borrower_data`**: Contains core SME customer information including `sector`, `region`, and `risk_rating`. This is essential for segmentation, trend analysis, and understanding borrower demographics
  
![borrower](https://github.com/user-attachments/assets/5f9eae71-2fa3-45ca-8dc1-efe747482bbe)

  
* **`loans_data`**: Includes loan-level details such as `loan_amount`, `interest_rate`, `start_date`, `maturity_date`, `status`, and `payment_frequency`. It provides the foundation for assessing exposure, tracking loan performance, and linking covenants to borrowers.

![Screenshot 2025-05-30 014617](https://github.com/user-attachments/assets/cfaaf13f-4881-4697-99c8-c89414e51a0f)

  
* **`financials_data`**: Provides quarterly income statement and balance sheet values per borrower. Key fields like `revenue`, `operating_profit`, `total_debt`, and `current_assets` are used to derive financial health indicators and trends over time.

![fin](https://github.com/user-attachments/assets/a2291a4d-160c-4f85-8498-98603fbdec21)

  
* **`covenants_data`**: Defines threshold rules for financial ratios such as `DSCR`, `LTV`, and `Current Ratio` for each loan. Breach analysis from this table is crucial for flagging loans at risk.

![cov](https://github.com/user-attachments/assets/bac2f90b-6e98-45b8-b0e2-f005cd407457)

  
* **Derived Views**: Financial ratios and covenant checks are computed in analytical views to support dashboarding and executive reporting.

Together, these tables enable a multi-layered risk analysis combining borrower behavior, financial performance, and loan structure to surface insights critical for credit risk management.


## 2. Business Problem

This project addresses credit risk management challenges faced by financial institutions lending to SMEs. It focuses on identifying at-risk loans, analyzing financial deterioration signals, evaluating the effectiveness of covenants, and understanding risk patterns across sectors and regions to support proactive credit decision-making.

**Key Business Questions:**

* What percentage of SME loans are currently at risk due to covenant breaches or weak financials?
* Which sectors and regions exhibit the highest credit risk?
* How effective are current covenant types (LTV, DSCR, Debt/EBITDA) in predicting loan distress?
* What financial trends typically precede defaults or covenant breaches (e.g., revenue decline, worsening ratios)?
* How has the rate of covenant breaches changed over time?
* Which sectors or regions show the sharpest rise in leverage (Debt/EBITDA) in the past year?
* If covenant thresholds are tightened (e.g., LTV ≤ 0.65, Debt/EBITDA ≤ 3), how many loans would be in breach?


## 3. Analysis and Insights

Analysis is done in SQL and visualizations in Power BI.
First the overview:No of Loans and No of customers.

![dv1](https://github.com/user-attachments/assets/30265cc8-759a-446e-a995-6d6e58e1ca40)

Let's look at the 'Default' and 'Watchlist' loans: which companies have multiple of these categories of loans

![sql1](https://github.com/user-attachments/assets/6004ab02-ac91-4299-8de4-ac0527d9e5fd)

Since 'Bullet' payment mode of loand are riskier, let's have a look at what % oF bullet loans are defaulted/watchlisted

![sql2](https://github.com/user-attachments/assets/f97c9156-eb1a-4096-bfd5-4e4ef74e9e24)

Now, on to the business questions

**Q1.What percentage of SME loans are currently at risk due to covenant breaches or weak financials?**

![Q1](https://github.com/user-attachments/assets/c7091b5e-5209-4c03-9adc-cbfcf1629ccf)

**Insights**
 
With 959 total loans, 841 loans have breached covenants in different areas, making the at risk loan percentage around 88%. 
This clearly suggests stricter monitoring of these loans to further avoid loan default.


**Q2.Which sectors and regions exhibit the highest credit risk?**

![Q2](https://github.com/user-attachments/assets/6a1a643c-c300-49b2-910d-6d8e05cc1c28)


**Insights**

The Isle of Man exhibits the highest credit risk among all regions, with 57% of its loans classified as "at risk." This is followed by England (50.77%), Scotland (49.75%), Northern Ireland (48.66%), and Wales (46.99%). Despite Northern Ireland having the highest number of total loans, its proportion of at-risk loans is comparatively lower than the Isle of Man.

From a sector perspective, the Retail sector stands out with both the highest number of sanctioned loans and the highest proportion of at-risk loans at 69%, indicating a significant concentration of credit risk. It is followed by Manufacturing (57.89%), Hospitality (55.26%), and Logistics (52.48%). In contrast, sectors such as Technology (40.74%) and Professional Services (35.79%) show comparatively lower risk exposure.

These insights help identify geographic and industry clusters with elevated credit risk, enabling targeted credit monitoring and risk mitigation strategies.



**Q3.How effective are current covenant types (LTV, DSCR, Debt/EBITDA) in predicting loan distress?**

