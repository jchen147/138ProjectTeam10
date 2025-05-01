-- Pre-aggregate state data and filter top city per state in one go
WITH state_summary AS (
  SELECT
    state,
    SUM(death) AS deaths,
    SUM(hospitalized_cumulative) AS total_hospitalized,
    SUM(recovered) AS recovered
  FROM `bigquery-public-data.covid19_tracking.state_testing_and_outcomes`
  GROUP BY state
),
top_city AS (
  SELECT  
    state,
    location AS city,
    cases_total,
    deaths_total
  FROM (
    SELECT
      state,
      location,
      cases_total,
      deaths_total,
      ROW_NUMBER() OVER (PARTITION BY state ORDER BY cases_total DESC) AS rn
    FROM `bigquery-public-data.covid19_tracking.city_level_cases_and_deaths`
  )
  WHERE rn = 1
)


SELECT
  ss.state,
  ss.deaths,
  ss.total_hospitalized,
  ss.recovered,
  tc.city,
  tc.cases_total AS city_cases,
  tc.deaths_total AS city_deaths
FROM state_summary ss
LEFT JOIN top_city tc
  ON ss.state = tc.state
ORDER BY ss.state;