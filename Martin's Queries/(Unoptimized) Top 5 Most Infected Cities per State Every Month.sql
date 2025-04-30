-- (Unoptimized) Top 5 Most Infected Cities per State Every Month
WITH city_cases AS (
	-- Aggregate State’s City Data by Month
  SELECT 
    DATE_TRUNC(date, MONTH) AS report_month,
    state,
    location,
		SUM(cases_total) AS total_monthly_cases
	FROM `bigquery-public-data.covid19_tracking.city_level_cases_and_deaths`
	WHERE city_or_county = 'City'
	GROUP BY report_month, state, location
)
SELECT
	c1.report_month,
	c1.state,
	c1.location,
	c1.total_monthly_cases
-- Self-join by state and month that allows comparison of city cases
FROM city_cases c1
WHERE (
	SELECT COUNT(DISTINCT c2.location)
	FROM city_cases c2
	WHERE c1.state = c2.state AND c1.report_month = c2.report_month AND c1.total_monthly_cases < c2.total_monthly_cases
) < 5
ORDER BY c1.state, c1.report_month, c1.total_monthly_cases DESC;
