-- Fitness Calorie Expenditure Analysis
-- Basic data exploration

-- 1. Count total workout sessions
SELECT COUNT(*) AS total_sessions
FROM gym_members;

-- 2. Check for missing values
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT("Age") AS missing_age,
    COUNT(*) - COUNT("Weight_kg") AS missing_weight,
    COUNT(*) - COUNT("Avg_BPM") AS missing_avg_bpm,
    COUNT(*) - COUNT("Session_Duration_Hours") AS missing_duration,
    COUNT(*) - COUNT("Calories_Burned") AS missing_calories,
    COUNT(*) - COUNT("Workout_Type") AS missing_workout_type
FROM gym_members;

-- 3. Overall calorie expenditure summary
SELECT
    COUNT(*) AS sessions,
    ROUND(AVG("Calories_Burned"), 2) AS avg_calories,
    ROUND(MIN("Calories_Burned"), 2) AS min_calories,
    ROUND(MAX("Calories_Burned"), 2) AS max_calories
FROM gym_members;
