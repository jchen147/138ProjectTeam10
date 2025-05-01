SELECT state, date, positive_increase, LAG(positive_increase, 3) OVER (PARTITION BY state ORDER BY date) AS cases_3_days_ago,
SAFE_DIVIDE(positive_increase - LAG(positive_increase, 3) OVER (PARTITION BY state ORDER BY date), LAG(positive_increase, 3) OVER (PARTITION BY state ORDER BY date)) AS growth_rate_3d
FROM
  `bigquery-public-data.covid19_tracking.state_testing_and_outcomes`
WHERE
  positive_increase IS NOT NULL
QUALIFY
  growth_rate_3d > 0.2 
ORDER BY
  state, date;