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
* How has the rate of covenant breaches changed over time?
* Which sectors or regions show the sharpest rise in leverage (Debt/EBITDA) in the past year?
* If covenant thresholds are tightened (e.g., LTV ≤ 0.65, Debt/EBITDA ≤ 3), how many loans would be in breach?
* What is the Y-O-Y Revenue change of the companies ?


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

* The Isle of Man exhibits the highest credit risk among all regions, with 57% of its loans classified as "at risk." This is followed by England (50.77%), Scotland (49.75%), Northern Ireland (48.66%), and Wales (46.99%). Despite Northern Ireland having the highest number of total loans, its proportion of at-risk loans is comparatively lower than the Isle of Man.

* From a sector perspective, the Retail sector stands out with both the highest number of sanctioned loans and the highest proportion of at-risk loans at 69%, indicating a significant concentration of credit risk. It is followed by Manufacturing (57.89%), Hospitality (55.26%), and Logistics (52.48%). In contrast, sectors such as Technology (40.74%) and Professional Services (35.79%) show comparatively lower risk exposure.

* These insights help identify geographic and industry clusters with elevated credit risk, enabling targeted credit monitoring and risk mitigation strategies.



**Q3.How effective are current covenant types (LTV, DSCR, Debt/EBITDA) in predicting loan distress?**

![Q3](https://github.com/user-attachments/assets/1f293bc5-346d-4d75-93b1-4de50ad08a1c)


**Insights**


* The table evaluates the predictive power of different covenant types by measuring how often a breach in each covenant is followed by an actual loan default. While Debt/EBITDA breaches are the most frequent (297 breaches across 518 loans), only 9.09% of those breaches resulted in a default, indicating limited predictive strength.

* On the other hand, Current Ratio breaches, though fewer in number (32 out of 559 loans), had the highest predictive power, with 12.5% of breached loans eventually defaulting. Similarly, LTV breaches show moderate effectiveness with an 11.84% conversion to default, followed by DSCR at 8.82%.

* These results suggest that while Debt/EBITDA is the most commonly breached, Current Ratio and LTV covenants are more reliable early warning indicators of actual loan defaults.


**Q4.How has the rate of covenant breaches changed over time?**

![Q4](https://github.com/user-attachments/assets/e0afd151-f0a8-401d-b9f0-5f0cc596821c)


**Insights**

* An analysis of quarterly covenant breach trends across the SME loan portfolio reveals a consistently high breach rate, averaging above 61% throughout the observed periods. The highest breach rate occurred in Q3 2021 (July 2021) at 67.78%, followed closely by Q3 2022 (66.53%), indicating possible seasonal or economic stress patterns during mid-year periods.

* Despite minor fluctuations, the overall breach rate remained remarkably stable, ranging between 61% and 68%, suggesting that a significant portion of loans consistently fail to meet covenant thresholds. This persistent pattern may indicate systemic financial stress across the portfolio or the need to reevaluate the stringency and structure of covenant requirements.

* These insights support the need for proactive risk management, potentially including earlier interventions or revised covenant frameworks to mitigate future defaults.

**Q5.Which sectors or regions show the sharpest rise in leverage (Debt/EBITDA) in the past year?**



**Q6.If covenant thresholds are tightened (e.g., LTV ≤ 0.65, Debt/EBITDA ≤ 3), how many loans would be in breach?**

![Q6](https://github.com/user-attachments/assets/26d06b88-a5cd-4736-86b5-5c09bc18eddf)



**Insights**


* Tightening covenant thresholds would drastically increase the number of detected breaches across the portfolio:

* LTV breaches would rise from 108 to 2,786,

* Debt/EBITDA breaches would spike from 0 to 5,530,

* Current Ratio breaches would increase from 21 to 841.

* Despite the total number of loans (959) remaining the same, these elevated breach counts reflect how stricter financial covenants would classify a significantly larger proportion of loans as at-risk. While this could improve early detection of financial stress, it may also lead to operational and compliance implications such as covenant renegotiations or loan repricing. The analysis suggests a trade-off between early warning effectiveness and portfolio manageability.



**Q7.What is the Y-O-Y Revenue change of the companies ?**

![Q7](https://github.com/user-attachments/assets/759cfca9-460d-4602-824c-a87f23f811fb)

**Assumptions**

If the revenue decline is more than 10% from last year, then those companies are marked, otherwise they are marked Stable.

