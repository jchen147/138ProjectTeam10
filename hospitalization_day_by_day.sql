SELECT state, date, positive_increase
FROM
  `bigquery-public-data.covid19_tracking.state_testing_and_outcomes`
WHERE
  positive_increase IS NOT NULL
ORDER BY
  state, date;