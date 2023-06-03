WITH monthly_usage AS (
  SELECT 
    user_id, 
    substr(cast(usage_date as varchar), 1, 7) as usage_yrmonth,
    SUM(time_spent) AS total_time_spent
  FROM 
    usage 
  GROUP BY 
    1, 2
),

cohort AS (
  SELECT 
    user_id,
    substr(cast(registration_date as varchar), 1, 7) as cohort_yrmonth
  FROM 
    users
),

engaged_users AS (
  SELECT 
    user_id, 
    cohort_yrmonth,
    COUNT(DISTINCT(usage_yrmonth)) AS num_engaged_months
  FROM 
    cohort 
    JOIN monthly_usage 
      ON cohort.user_id = monthly_usage.user_id
      AND monthly_usage.month >= cohort.cohort_yrmonth
  WHERE 
    total_time_spent >= 30
  GROUP BY 
    user_id, 
    cohort_yrmonth
)

SELECT 
  cohort_yrmonth,
  COUNT(DISTINCT cohort.user_id) AS total_users,
  ROUND(COALESCE(SUM(CASE WHEN num_engaged_months >= 1 THEN 1 ELSE 0 END) / COUNT(DISTINCT cohort.user_id)::float * 100, 0), 2) AS m1_retention,
  ROUND(COALESCE(SUM(CASE WHEN num_engaged_months >= 2 THEN 1 ELSE 0 END) / COUNT(DISTINCT cohort.user_id)::float * 100, 0), 2) AS m2_retention,
  ROUND(COALESCE(SUM(CASE WHEN num_engaged_months >= 3 THEN 1 ELSE 0 END) / COUNT(DISTINCT cohort.user_id)::float * 100, 0), 2) AS m3_retention
FROM 
  cohort 
  LEFT JOIN engaged_users 
    ON cohort.user_id = engaged_users.user_id 
    AND cohort.cohort_yrmonth = engaged_users.cohort_yrmonth
GROUP BY 
  1
ORDER BY 
  1 ASC