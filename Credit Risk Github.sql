--- DEFAULTED AND WATCHLIST LOANS DETAILS

---COMPANIES WHICH HAVE MULTIPLE DEFAULTED LOANS
SELECT 
    B.company_name,
    B.borrower_id,
    COUNT(L.loan_id) AS defaulted_loans
FROM loans_table L
JOIN borrower_data B ON L.borrower_id = B.borrower_id
WHERE L.status = 'Defaulted' OR L.status = 'Watchlist' 
GROUP BY B.company_name, B.borrower_id,status
HAVING COUNT(L.loan_id) > 1
ORDER BY defaulted_loans DESC;

---LOAN HEALTH OF BORROWERS WHO HAS REPAYMENT 'BULLET' 
SELECT 
	loan_id,
	L.borrower_id,
	B.company_name,
	status
FROM
loans_table L
JOIN borrower_data B ON L.borrower_id = B.borrower_id
WHERE
	payment_frequency = 'Bullet'  and status = 'Defaulted' or status = 'Watchlist'



--What % of our bullet LOANS ARE DEFAULTED?	
SELECT 
	ROUND(SUM(CASE WHEN status = 'Defaulted' THEN 1 ELSE 0 END)*100.0 
	/ COUNT(*) ,2) AS Defaulted_Bullet_Loans 
FROM
loans_table
WHERE
	payment_frequency = 'Bullet'


--Statistics of Bullet Loans
SELECT 
	SUM(CASE WHEN payment_frequency = 'Bullet' THEN 1 ELSE 0 END) AS TOTAL_BULLET_LOANS,
	SUM(CASE WHEN payment_frequency = 'Bullet' THEN 1 ELSE 0 END)*100.00/(COUNT(*)) AS PCT_BULLET_LOANS,
	SUM(CASE WHEN payment_frequency = 'Bullet' AND status = 'Defaulted' THEN 1 ELSE 0 END)*100.00/
	SUM(CASE WHEN payment_frequency = 'Bullet' THEN 1 ELSE 0 END)AS PCT_DEFAULTED_BULLET_LOANS,
	SUM(CASE WHEN payment_frequency = 'Bullet' AND status = 'Watchlist' THEN 1 ELSE 0 END)*100.00/
	SUM(CASE WHEN payment_frequency = 'Bullet' THEN 1 ELSE 0 END) AS PCT_WATCHLIST_BULLET_LOANS
FROM loans_table


---What percentage of our high-risk (rating 4-5) borrowers have breached covenants?
SELECT 
	COUNT(DISTINCT B.borrower_id)*100.0/
	SUM(CASE WHEN V.risk_status = 'At Risk'  THEN 1 ELSE 0 END)
FROM
borrower_data B
JOIN View_ATRISKLOANS V 
ON B.company_name = V.company_name
WHERE
	V.risk_rating = 4 OR V.risk_rating = 5


---Q1.What percentage of our SME loan portfolio is currently at risk due to covenant breaches or deteriorating 
--financials?

--- % OF COVENANT BREACHED LOANS
SELECT 
    COUNT(DISTINCT l.loan_id) AS total_loans,
    COUNT(DISTINCT V.loan_id) AS risky_loans,
    (COUNT(DISTINCT V.loan_id) * 100.0 / COUNT(DISTINCT l.loan_id)) AS par_percentage
FROM loans_table l
LEFT JOIN View_ATRISKLOANS V ON l.loan_id = V.loan_id


----Q2: Which sectors or regions have the highest risk or early warning indicators
---RISK BY SECTOR

SELECT 
	sector,
	COUNT(*) AS TOTAL_AT_RISK_LOANS,
	SUM(CASE WHEN risk_status = 'At Risk' THEN 1 ELSE 0 END) AS AT_RISK_LOANS,
	CAST(SUM(CASE WHEN risk_status = 'At Risk' THEN 1 ELSE 0 END)*100
		/COUNT(*) AS DECIMAL(5,2)) AS PERCENT_AT_RISK
FROM View_ATRISKLOANS V
GROUP BY sector
ORDER BY PERCENT_AT_RISK;


---RISK BY REGION

SELECT 
	region,
	COUNT(*) AS TOTAL_BREACHED_LOANS,
	SUM(CASE WHEN risk_status = 'At Risk' THEN 1 ELSE 0 END) AS AT_RISK_LOANS,
	CAST(SUM(CASE WHEN risk_status = 'At Risk' THEN 1 ELSE 0 END)*100
		/COUNT(*) AS DECIMAL(5,2)) AS PERCENT_AT_RISK
FROM View_ATRISKLOANS
GROUP BY region
ORDER BY PERCENT_AT_RISK;


---Q.3. How effective are our current covenant types 
---(LTV, DSCR, Debt/EBITDA) in predicting loan distress?

WITH CTE_CovenantBreaches AS
	(
		SELECT 
			c.loan_id,
        c.covenant_type,
        l.status AS loan_status,
        -- Compute breach conditions
        CASE 
            WHEN c.covenant_type = 'DSCR' 
                 AND (operating_profit / NULLIF(interest_paid, 0)) < c.threshold_min THEN 1
            WHEN c.covenant_type = 'LTV' 
                 AND (total_debt / NULLIF(total_assets, 0)) > c.threshold_max THEN 1
            WHEN c.covenant_type = 'Current Ratio' 
                 AND (current_assets / NULLIF(current_liabilities, 0)) < c.threshold_min THEN 1
            WHEN c.covenant_type = 'Debt/EBITDA'
                 AND (total_debt / NULLIF(operating_profit, 0)) > c.threshold_max THEN 1
            ELSE 0
        END AS is_breached
		FROM covenants_table c
		JOIN loans_table l ON l.loan_id = c.loan_id
		JOIN borrower_data b ON b.borrower_id = l.borrower_id
		JOIN financials_data f ON f.borrower_id = b.borrower_id
		AND f.reporting_date =
			(
				SELECT MAX(f2.reporting_date)
				FROM financials_data f2
				WHERE f2.borrower_id = b.borrower_id

			)
)
SELECT 
	covenant_type,
	COUNT(*) AS TOTAL_LOANS,
	SUM(CASE WHEN is_breached = 1 THEN 1 ELSE 0 END ) AS Breached_lOANS,
	SUM(CASE WHEN is_breached = 1 AND loan_status = 'Defaulted' THEN 1 ELSE 0 END) AS breached_and_defaulted,
    CAST(SUM(CASE WHEN is_breached = 1 AND loan_status = 'Defaulted' THEN 1 ELSE 0 END) * 100.0 / NULLIF(SUM(CASE WHEN is_breached = 1 THEN 1 ELSE 0 END), 0) AS DECIMAL(5,2)) AS breach_predictive_power_percent
FROM CTE_CovenantBreaches
GROUP BY
	covenant_type
ORDER BY breach_predictive_power_percent DESC;



---Q4.What is the historical trend in overall covenant breaches across the portfolio?
WITH CTE_FinancialsWithRatios AS (
    SELECT 
        f.reporting_date,
        l.loan_id,
        c.covenant_type,
        c.threshold_min,
        c.threshold_max,
        -- Ratios
        (f.operating_profit / NULLIF(f.interest_paid, 0)) AS dscr,
        (f.total_debt / NULLIF(f.total_assets, 0)) AS ltv,
        (f.current_assets / NULLIF(f.current_liabilities, 0)) AS current_ratio,
        (f.total_debt / NULLIF(f.operating_profit, 0)) AS debt_ebitda
    FROM financials_data f
    JOIN loans_table l ON f.borrower_id = l.borrower_id
    JOIN covenants_table c ON l.loan_id = c.loan_id
),

CTE_CovenantBreaches AS (
    SELECT 
        reporting_date,
        loan_id,
        covenant_type,
        CASE 
            WHEN covenant_type = 'DSCR' AND dscr < threshold_min THEN 1
            WHEN covenant_type = 'LTV' AND ltv > threshold_max THEN 1
            WHEN covenant_type = 'Current Ratio' AND current_ratio < threshold_min THEN 1
            WHEN covenant_type = 'Debt/EBITDA' AND debt_ebitda > threshold_max THEN 1
            ELSE 0
        END AS breached
    FROM CTE_FinancialsWithRatios
)

SELECT
		FORMAT(reporting_date, 'yyyy-MM') AS Breach_Month,
        COUNT(DISTINCT loan_id) AS Total_Loans_Checked,
        SUM(BREACHED) AS Total_Breaches,
		CAST(SUM(BREACHED)*100.0/COUNT(DISTINCT loan_id) AS DECIMAL(5,2)) AS BREACH_RATE_PCT
FROM CTE_CovenantBreaches
GROUP BY FORMAT(reporting_date, 'yyyy-MM');


---Q5.Which sectors or regions show the fastest increase in debt-to-EBITDA over the past year?
WITH CTE_FinancialsWithRatios AS (
    SELECT 
        f.reporting_date,
        b.sector,
        b.region,
        f.total_debt,
        f.operating_profit,
        (f.total_debt / NULLIF(f.operating_profit, 0)) AS debt_ebitda
    FROM financials_data f
    JOIN borrower_data b ON f.borrower_id = b.borrower_id
),

CTE_AvgDebtEbitdaByPeriod AS (
    SELECT 
        FORMAT(reporting_date, 'yyyy-MM') AS period,
        sector,
        region,
        AVG(debt_ebitda) AS avg_debt_ebitda
    FROM CTE_FinancialsWithRatios
    GROUP BY FORMAT(reporting_date, 'yyyy-MM'), sector, region
),

CTE_DebtEbitdaWithLag AS (
    SELECT 
        *,
        LAG(avg_debt_ebitda) OVER (PARTITION BY sector, region ORDER BY period) AS prev_avg_debt_ebitda
    FROM CTE_AvgDebtEbitdaByPeriod
)

SELECT 
    period,
    sector,
    region,
    avg_debt_ebitda,
    prev_avg_debt_ebitda,
    (100.0 * (avg_debt_ebitda - prev_avg_debt_ebitda) / NULLIF(prev_avg_debt_ebitda, 0) ) AS pct_change
FROM CTE_DebtEbitdaWithLag 
ORDER BY pct_change , period DESC;


---Q6. if we tighten covenant thresholds (e.g., LTV ≤ 0.65, Debt/EBITDA ≤ 3), how many loans would be in breach?
WITH CTE_FinancialRatios AS (
    SELECT 
        f.borrower_id, 
        l.loan_id,
        f.reporting_date,
        (f.total_debt / NULLIF(f.total_assets, 0)) AS ltv,
        (f.total_debt / NULLIF(f.operating_profit, 0)) AS debt_ebitda,
        (f.current_assets / NULLIF(f.current_liabilities, 0)) AS current_ratio
    FROM financials_data f
    JOIN loans_table l ON f.borrower_id = l.borrower_id
),

CTE_HypotheticalBreaches AS (
    SELECT
        loan_id,
        reporting_date,
        CASE WHEN ltv > 0.65 THEN 1 ELSE 0 END AS ltv_breach,
        CASE WHEN debt_ebitda > 3 THEN 1 ELSE 0 END AS debt_ebitda_breach,
        CASE WHEN current_ratio < 1.2 THEN 1 ELSE 0 END AS current_ratio_breach
    FROM CTE_FinancialRatios
)
SELECT 
    COUNT(DISTINCT loan_id) AS loans_breaching_stricter_thresholds,
    SUM(CASE WHEN ltv_breach = 1 THEN 1 ELSE 0 END) AS ltv_breaches,
    SUM(CASE WHEN debt_ebitda_breach = 1 THEN 1 ELSE 0 END) AS debt_ebitda_breaches,
    SUM(CASE WHEN current_ratio_breach = 1 THEN 1 ELSE 0 END) AS current_ratio_breaches
FROM CTE_HypotheticalBreaches
WHERE ltv_breach = 1 OR debt_ebitda_breach = 1 OR current_ratio_breach = 1;



---Early Warning Signals
--Q.7 Revenue Decline (YoY)
WITH CTE_latest_financials AS (
    SELECT 
        f.borrower_id, 
		B.company_name,
        reporting_date, 
        revenue,
        LAG(revenue, 4) OVER (PARTITION BY f.borrower_id ORDER BY reporting_date) AS revenue_prev_year  -- Quarterly data: 4 periods = 1 year
    FROM financials_data f
	JOIN borrower_data b ON b.borrower_id = f.borrower_id
)
SELECT 
    borrower_id,
	company_name,
    revenue AS CURRENT_REVENUE,
    revenue_prev_year,
    (revenue - revenue_prev_year) / NULLIF(revenue_prev_year, 0) * 100 AS yoy_change_percentage,
    CASE 
        WHEN (revenue - revenue_prev_year) / NULLIF(revenue_prev_year, 0) < -0.10 THEN '>10% Decline' 
        ELSE 'Stable' 
    END AS revenue_trend
FROM CTE_latest_financials
WHERE reporting_date = (SELECT MAX(reporting_date) FROM financials_data);