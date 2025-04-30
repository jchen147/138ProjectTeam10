-- (Optimized) Top 5 Most Infected Cities per State Every Month
WITH city_cases AS (
  -- Aggregate State's City Data by Month
  SELECT
    DATE_TRUNC(date, MONTH) AS report_month,
    state,
    location,
    SUM(cases_total) AS total_monthly_cases
  FROM `bigquery-public-data.covid19_tracking.city_level_cases_and_deaths`
  WHERE city_or_county = 'City'
  GROUP BY report_month, state, location
),
ranked_cities AS (
  -- Rank cities within each state by total cases on a monthly basis
  SELECT
    report_month,
    state,
    location,
    total_monthly_cases,
    ROW_NUMBER() OVER(PARTITION BY state, report_month ORDER BY total_monthly_cases DESC) AS city_rank
  FROM city_cases
)
-- Filter only top 5 cities per state per month
SELECT
  report_month,
  state,
  location,
  total_monthly_cases
FROM ranked_cities
WHERE city_rank <= 5
ORDER BY state, report_month, total_monthly_cases DESC;
