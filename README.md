# Fitness Calorie Expenditure Analysis

## Project Overview

This project investigates which factors are associated with calorie expenditure during exercise sessions.

Using 973 workout sessions from the Gym Members Exercise Dataset, the analysis combines PostgreSQL and Python to explore relationships between calorie expenditure, session duration, average heart rate, age, weight, and workout type.

### Research Question

> Which factors are associated with higher calorie expenditure?

Because the dataset is observational, this analysis identifies associations rather than causal effects.

---

## Tools & Technologies

- **PostgreSQL** — data exploration and SQL analysis
- **Python** — statistical modeling and visualization
- **Pandas** — data manipulation
- **Matplotlib & Seaborn** — visualization
- **Statsmodels** — multiple linear regression
- **Scikit-learn** — model performance metrics
- **Google Colab** — Python analysis environment
- **GitHub** — project organization and documentation

---

## Project Structure

```text
fitness-calorie-analysis/
├── data/
│   └── gym_members_exercise_tracking-selected-columns.csv
├── sql/
│   ├── 01_data_exploration.sql
│   ├── 02_eda.sql
│   └── 03_analysis.sql
├── python/
│   └── fitness_calorie_analysis.ipynb
├── .gitignore
├── LICENSE
└── README.md
