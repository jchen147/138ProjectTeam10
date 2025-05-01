SELECT
  state,
  date,
  hospitalized_currently,
  LAG(hospitalized_currently, 1) OVER (PARTITION BY state ORDER BY date) AS yesterday_hospitalized,
  (hospitalized_currently - LAG(hospitalized_currently, 1) OVER (PARTITION BY state ORDER BY date)) AS daily_change
FROM
  `bigquery-public-data.covid19_tracking.state_testing_and_outcomes`
WHERE
  hospitalized_currently IS NOT NULL;