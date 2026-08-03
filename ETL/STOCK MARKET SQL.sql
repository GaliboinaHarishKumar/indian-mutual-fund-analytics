/*Exapance ratio by fund house*/
SELECT
    fund_house,
    scheme_name,
    expense_ratio_pct
FROM `mutel_funds`.`01_fund_master`;
/* avarege expance ratio by fund house*/
select 
fund_house,
avg(expense_ratio_pct) as avarege_expance_ratio
from`mutel_funds`.`01_fund_master`
group by fund_house
order by avarege_expance_ratio
limit 5;
/* fund mangers by risk categeory*/
select
fund_manager,
risk_category,
min_sip_amount
from`mutel_funds`.`01_fund_master`;

/*plan wise subscription by fund house*/
select
fund_house,
count(plan) as num_plans
from `mutel_funds`.`01_fund_master`
group by fund_house;
/*joins*/
SELECT
    fm.amfi_code,
    fm.scheme_name,
    fm.fund_house,
    ROUND(AVG(nh.nav), 2) AS avg_nav
FROM `mutel_funds`.`01_fund_master` AS fm
INNER JOIN `mutel_funds`.`02_nav_history` AS nh
ON fm.amfi_code = nh.amfi_code
GROUP BY
    fm.amfi_code,
    fm.scheme_name,
    fm.fund_house
ORDER BY avg_nav DESC
LIMIT 5;
/*Monthly Trends as nav*/
SELECT
    fm.scheme_name,
    fm.fund_house,
    nh.date,
    ROUND(nh.nav, 2) AS nav
FROM `mutel_funds`.`01_fund_master` AS fm
INNER JOIN `mutel_funds`.`02_nav_history` AS nh
ON fm.amfi_code = nh.amfi_code
ORDER BY nh.nav DESC
LIMIT 10;
/* hinght stock price */
SELECT
fm.fund_house,
fm.scheme_name,
st.stock_symbol,
st.stock_name,
st.sector,
st.market_value_cr
FROM `mutel_funds`.`01_fund_master` AS fm
INNER JOIN `mutel_funds`.`09_portfolio_holdings` AS st
ON fm.amfi_code=st.amfi_code
order by st.market_value_cr desc
limit 10;
/*Top 5 stocks in inr*/
SELECT 
fm.fund_house,
st.stock_name,
st.current_price_inr
FROM `mutel_funds`.`01_fund_master` AS fm
INNER JOIN `mutel_funds`.`09_portfolio_holdings` AS st
ON fm.amfi_code=st.amfi_code
order by st.current_price_inr desc
limit 5;
/*CTE FUNCTION*/
WITH avg_market_value_cr AS (
    SELECT
        AVG(st.market_value_cr) AS avg_market_cr,
        fm.fund_house,
        st.stock_name
     FROM `mutel_funds`.`01_fund_master` AS fm
    INNER JOIN `mutel_funds`.`09_portfolio_holdings` AS st
        ON fm.amfi_code = st.amfi_code
    GROUP BY
        fm.fund_house,
        st.stock_name
)

SELECT
    stock_name,
    avg_market_cr
FROM avg_market_value_cr
ORDER BY avg_market_cr DESC
LIMIT 5;
/*Top 5 expance ratio  by fund house*/
WITH fund_house AS (
    SELECT
        fund_house,
        scheme_name,
        plan,
        AVG(expense_ratio_pct) AS avg_expense_ratio
    FROM `mutel_funds`.`01_fund_master`
    GROUP BY
        fund_house,
        scheme_name,
        plan
)

SELECT
    fund_house,
    avg_expense_ratio
FROM fund_house
ORDER BY avg_expense_ratio desc
LIMIT 5;
/*hinght values per the seccoter*/
WITH ranked_stocks AS (
    SELECT
        stock_name,
        sector,
        market_value_cr,
        ROW_NUMBER() OVER (
            PARTITION BY sector
            ORDER BY market_value_cr DESC
        ) AS rn
    FROM `mutel_funds`.`09_portfolio_holdings`
)

SELECT
    stock_name,
    sector,
    market_value_cr
FROM ranked_stocks
WHERE rn = 1;


