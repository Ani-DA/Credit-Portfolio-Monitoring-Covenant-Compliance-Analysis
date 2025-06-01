# Credit Portfolio Monitoring Covenant Compliance Analysis


![credit risk github](https://github.com/user-attachments/assets/2bb2b998-a606-4834-9ba5-122a3c6ea7e0)



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


**Sector:**


![Q5 S](https://github.com/user-attachments/assets/5a6dcab4-1cb5-4c4e-87fa-584045047180)

**Region:**

![Q5R](https://github.com/user-attachments/assets/6e39466f-c6dc-4d9a-9efa-3be5e8af0af6)


**Insights**

* Finance sector experiences sharpest spike in mid 2021 peaking at 3.7k average_debt_ebitda, possibly suggesting heavy borrowing or reduced earnings (EBITDA) during recovery periods post-lockdowns, But it is 
worth having a thorough drill down. Technology sector experices decline in late 2022.

* Isle of Man experinces steep surge in average DEBT_EBITDA in mid 2021, the same period in which the Financial sector experiences huge spike, making a thorough analysis a priority. Wales, Scotland and England also exhibited increases just before the same period, but to a lesser extent. 

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




## 4. Code Analysis

I have done the analysis in SQL Server Management Studio. The entire sql file is attached in the repository. 
Here I'm attaching some code snippets for the analysis I've done for the business questions:

**What percentage of SME loans are currently at risk due to covenant breaches or weak financials?**

![sql3](https://github.com/user-attachments/assets/7a9ebd21-2ade-4001-899c-9cc019d58714)


**Which sectors and regions exhibit the highest credit risk?**
  
![sql4](https://github.com/user-attachments/assets/127e1375-eb0e-451a-b836-72239860b436)



![sql5](https://github.com/user-attachments/assets/28b0a869-03e9-428e-8d7d-3db65554beb0)


**How effective are current covenant types (LTV, DSCR, Debt/EBITDA) in predicting loan distress?**


![sql6](https://github.com/user-attachments/assets/85557eb6-8d2e-4b37-86fb-c7227dd4ea8b)


**How has the rate of covenant breaches changed over time?**


![sql7](https://github.com/user-attachments/assets/9642bdff-fe3b-44dd-a275-abf0dd3975a3)


**Which sectors or regions show the sharpest rise in leverage (Debt/EBITDA) in the past year?**
![sql8](https://github.com/user-attachments/assets/8c5f7d60-3988-4dc1-aff1-4c31be6f0191)


**If covenant thresholds are tightened (e.g., LTV ≤ 0.65, Debt/EBITDA ≤ 3), how many loans would be in breach?**

![sql9](https://github.com/user-attachments/assets/0ea72296-0b7d-4707-8c60-98af4bff6591)

**What is the Y-O-Y Revenue change of the companies ?**
![sql10](https://github.com/user-attachments/assets/0a4262e0-0f72-498c-9d99-7c87d786accd)


## 4. Recommendations

### 1. **Strengthen Monitoring in High-Risk Regions**

* The **Isle of Man** exhibits the highest proportion of at-risk loans (57%), **England** with 50% ,signaling a significant concentration of regional credit risk.
* **Recommendation**: Implement enhanced borrower monitoring and possibly higher risk-based pricing or collateral requirements specially in these regions. Consider conducting region-specific credit reviews to understand underlying causes of elevated risk.

---

### 2. **Reassess Sectoral Exposure and Lending Strategies**

* The **Retail sector** has both the highest loan volume and the highest risk (69% at-risk), followed by Manufacturing, Hospitality, and Logistics.
* **Recommendation**: Reduce exposure or apply more stringent credit approval and monitoring for these high-risk sectors. Simultaneously, increase strategic lending towards **Technology** and **Professional Services**, which exhibit more stable performance.

---

### 3. **Prioritize Current Ratio and LTV Covenants in Risk Models**

* **Current Ratio** breaches, though less frequent, have the highest predictive power (12.5% lead to default), followed by **LTV** (11.84%).
* **Recommendation**: Assign higher weight to **Current Ratio** and **LTV** breaches in early warning systems and default prediction models. Reconsider the emphasis on **Debt/EBITDA**, which shows limited predictive strength despite frequent breaches.

---

### 4. **Address Persistently High Covenant Breach Rates**

* Breach rates have remained **consistently high (61–68%)**, with seasonal peaks in Q3 (e.g., 67.78% in Q3 2021), suggesting systemic issues or cyclic stress.
* **Recommendation**: Investigate root causes of systemic covenant failures — e.g., unrealistic thresholds, economic seasonality, or borrower profile mismatches. Consider covenant adjustments or additional support interventions during known stress periods.

---

### 5. **Investigate Post-Lockdown Financial Behavior**

* Sharp mid-2021 spike in **Debt/EBITDA** for both the **Finance sector** and the **Isle of Man** suggests possible post-COVID financial strain or overleveraging.
* **Recommendation**: Conduct a drill-down into this period and segment to assess whether elevated leverage was temporary or a structural risk shift. Use findings to inform future risk stress-testing scenarios.

---

### 6. **Implement Risk-Weighted Covenant Enforcement**

* One-size-fits-all covenants are contributing to widespread, possibly uninformative, breach rates.
* **Recommendation**: Tailor covenant thresholds by sector, region, and borrower risk profile to reduce false positives and improve signal-to-noise ratio in risk detection.

---

### 7. **Enhance Portfolio Management Tools**

* The high number of potential breaches (under stricter covenants) highlights the need for scalable risk infrastructure.
* **Recommendation**: Implement automated monitoring tools and dashboard alerts to track covenant breaches in real time, especially under tighter rules.While stricter covenants can enhance early risk detection, they also risk overwhelming monitoring teams and increasing borrower non-compliance. Adopt a **tiered approach**: apply tighter covenants to higher-risk borrowers or sectors only.

