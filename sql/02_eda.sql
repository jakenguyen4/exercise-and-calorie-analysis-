-- Fitness Calorie Expenditure Analysis
-- Exploratory data analysis

-- 1. Average calories by workout type
SELECT
    "Workout_Type",
    COUNT(*) AS sessions,
    ROUND(AVG("Calories_Burned"), 2) AS avg_calories,
    ROUND(MIN("Calories_Burned"), 2) AS min_calories,
    ROUND(MAX("Calories_Burned"), 2) AS max_calories
FROM gym_members
GROUP BY "Workout_Type"
ORDER BY avg_calories DESC;


-- 2. Average calories by session duration group
SELECT
    CASE
        WHEN "Session_Duration_Hours" < 0.75 THEN 'Short'
        WHEN "Session_Duration_Hours" < 1.25 THEN 'Medium'
        ELSE 'Long'
    END AS duration_group,
    COUNT(*) AS sessions,
    ROUND(AVG("Calories_Burned"), 2) AS avg_calories
FROM gym_members
GROUP BY duration_group
ORDER BY avg_calories DESC;


-- 3. Average calories by heart-rate group
SELECT
    CASE
        WHEN "Avg_BPM" < 110 THEN 'Low'
        WHEN "Avg_BPM" < 130 THEN 'Medium'
        ELSE 'High'
    END AS heart_rate_group,
    COUNT(*) AS sessions,
    ROUND(AVG("Calories_Burned"), 2) AS avg_calories
FROM gym_members
GROUP BY heart_rate_group
ORDER BY avg_calories DESC;


-- 4. Correlations with calorie expenditure
SELECT
    ROUND(CORR("Session_Duration_Hours", "Calories_Burned")::numeric, 3)
        AS duration_calorie_correlation,
    ROUND(CORR("Avg_BPM", "Calories_Burned")::numeric, 3)
        AS bpm_calorie_correlation,
    ROUND(CORR("Weight_kg", "Calories_Burned")::numeric, 3)
        AS weight_calorie_correlation,
    ROUND(CORR("Max_BPM", "Calories_Burned")::numeric, 3)
        AS max_bpm_calorie_correlation
FROM gym_members;


-- 5. Compare workout types by duration, heart rate, and calories
SELECT
    "Workout_Type",
    COUNT(*) AS sessions,
    ROUND(AVG("Session_Duration_Hours"), 2) AS avg_duration,
    ROUND(AVG("Avg_BPM"), 2) AS avg_bpm,
    ROUND(AVG("Calories_Burned"), 2) AS avg_calories
FROM gym_members
GROUP BY "Workout_Type"
ORDER BY avg_calories DESC;
