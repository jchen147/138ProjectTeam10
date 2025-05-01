-- Aggregate state-level data
WITH state_summary AS (
  SELECT
    state,
    SUM(death) AS deaths,
    SUM(hospitalized_cumulative) AS total_hospitalized,
    SUM(recovered) AS recovered
  FROM `bigquery-public-data.covid19_tracking.state_testing_and_outcomes`
  GROUP BY state
)




-- Just select county-level (citysql) data directly — no join explosion
SELECT
  ss.state,
  ss.deaths,
  ss.total_hospitalized,
  ss.recovered,
  citysql.location AS county,
  citysql.cases_total AS county_cases
FROM state_summary ss
JOIN `bigquery-public-data.covid19_tracking.city_level_cases_and_deaths` AS citysql
  ON ss.state = citysql.state
ORDER BY ss.state, county;
