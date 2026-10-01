-- Fitness Calorie Expenditure Analysis
-- Additional analysis

-- 1. Compare workout types across participant characteristics
SELECT
    "Workout_Type",
    ROUND(AVG("Age"), 2) AS avg_age,
    ROUND(AVG("Weight_kg"), 2) AS avg_weight,
    ROUND(AVG("Session_Duration_Hours"), 2) AS avg_duration,
    ROUND(AVG("Avg_BPM"), 2) AS avg_bpm,
    ROUND(AVG("Calories_Burned"), 2) AS avg_calories
FROM gym_members
GROUP BY "Workout_Type"
ORDER BY avg_calories DESC;


-- 2. Examine the relationship between session duration
-- and average heart rate
SELECT
    ROUND(
        CORR(
            "Session_Duration_Hours",
            "Avg_BPM"
        )::numeric,
        3
    ) AS duration_bpm_correlation
FROM gym_members;
