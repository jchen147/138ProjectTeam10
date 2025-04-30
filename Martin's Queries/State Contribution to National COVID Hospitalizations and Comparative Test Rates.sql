WITH national_monthly AS (
	-- Aggregate national data for each month
	SELECT
		DATE_TRUNC(date, MONTH) AS report_month,
		SUM(hospitalized_currently) AS national_hospitalized,
		SUM(negative) AS national_negative,
		SUM(positive) AS national_positive,
		SUM(total_test_results) AS national_total_tests
	FROM `bigquery-public-data.covid19_tracking.national_testing_and_outcomes`
	GROUP BY report_month
),
state_monthly AS (
	-- Aggregate state data for each month
	SELECT
		DATE_TRUNC(date, MONTH) AS report_month,
		state,
		SUM(hospitalized_currently) AS state_hospitalized,
		SUM(negative) AS state_negative,
		SUM(positive) AS state_positive,
		SUM(total_test_results) AS state_total_tests
	FROM `bigquery-public-data.covid19_tracking.state_testing_and_outcomes`
	GROUP BY report_month, state
)
-- Join tables for comparison data
SELECT
	s.report_month,
	s.state,
	-- State hospitalization % of National
	(s.state_hospitalized * 100.0 / NULLIF(n.national_hospitalized, 0)) AS current_state_hospitalizations_to_national_percentage,

	-- state_positive / state_total_tests
	(s.state_positive * 100.0 / NULLIF(s.state_total_tests, 0)) AS state_positives_to_total_state_tests_percentage,

	-- national_positive / national_total_tests
	(n.national_positive * 100.0 / NULLIF(n.national_total_tests, 0)) AS national_positives_to_total_national_tests_percentage,

	-- state_negative / state_total_tests compared to National
	(s.state_negative * 100.0 / NULLIF(s.state_total_tests, 0)) AS state_negatives_to_total_state_tests_percentage,

	-- national_negative / national_total_tests
	(n.national_negative * 100.0 / NULLIF(n.national_total_tests, 0)) AS national_negatives_to_total_national_tests_percentage
FROM national_monthly n
JOIN state_monthly s ON s.report_month = n.report_month
ORDER BY s.state, s.report_month;
