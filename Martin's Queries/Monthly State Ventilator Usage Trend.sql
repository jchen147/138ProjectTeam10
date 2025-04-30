WITH state_monthly AS (
	-- Aggregate state data for each month
	SELECT
    	DATE_TRUNC(date, MONTH) AS report_month,
    	state,
    	AVG(on_ventilator_currently) AS avg_ventilator_usage
	FROM `bigquery-public-data.covid19_tracking.state_testing_and_outcomes`
	GROUP BY report_month, state
)
SELECT
	report_month,
	state,
	avg_ventilator_usage
FROM state_monthly
ORDER BY state, report_month
