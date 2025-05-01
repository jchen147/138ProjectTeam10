SELECT
    EXTRACT(month FROM DATE) AS month,
    SUM(death_confirmed) AS totaldeaths,
    state
FROM `bigquery-public-data.covid19_tracking.state_testing_and_outcomes`
WHERE death_confirmed != 0 -- months with no data are null and not shown
GROUP BY state, month
ORDER by STATE, month ASC;
