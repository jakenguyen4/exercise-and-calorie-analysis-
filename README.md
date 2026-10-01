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

## SQL Analysis

PostgreSQL was used for the initial exploratory analysis.

The SQL analysis examined:

- Dataset size and data completeness
- Average calorie expenditure by workout type
- Calorie expenditure across session-duration groups
- Calorie expenditure across heart-rate groups
- Correlations between numerical variables
- Differences in workout characteristics across workout types

### Key SQL Findings

| Variable | Correlation with Calories Burned |
|---|---:|
| Session Duration | **0.908** |
| Average BPM | **0.340** |
| Weight | **0.095** |
| Max BPM | **0.002** |

Session duration had the strongest bivariate association with calorie expenditure.

Average calories by workout type were:

| Workout Type | Average Calories |
|---|---:|
| HIIT | 925.81 |
| Strength | 910.70 |
| Yoga | 903.19 |
| Cardio | 884.51 |

---

## Statistical Modeling

A multiple linear regression model was used to examine the association between calorie expenditure and several predictors simultaneously.

### Predictors

- Session duration
- Average BPM
- Weight
- Age
- Workout type

The model used **HC3 heteroskedasticity-robust standard errors** because diagnostic testing indicated heteroskedasticity.

### Regression Results

| Predictor | Coefficient | Statistical Significance |
|---|---:|---|
| Session Duration | 716.38 | Significant |
| Average BPM | 6.26 | Significant |
| Weight | 1.28 | Significant |
| Age | -3.24 | Significant |
| Workout Type | — | Not significant |

The model explained approximately **96.2% of the observed variation** in calorie expenditure.

### Model Performance

- **R²:** 0.962
- **In-sample MAE:** 41.90 calories
- **In-sample RMSE:** 52.86 calories

---

## Model Diagnostics

A Breusch-Pagan test indicated significant heteroskedasticity in the residuals. HC3 robust standard errors were therefore used for statistical inference.

Variance Inflation Factors (VIFs) were approximately 1 for the numerical predictors, indicating no meaningful multicollinearity.

The residual plot showed increasing residual spread at higher predicted calorie values, consistent with the heteroskedasticity detected by the Breusch-Pagan test.

---

## Key Findings

1. **Session duration had the strongest bivariate association with calorie expenditure**, with a correlation of 0.908.
2. **Average heart rate showed a moderate positive association** with calorie expenditure.
3. **Weight had a weaker positive association** with calorie expenditure.
4. Workout types had relatively similar raw average calorie expenditures.
5. After controlling for the other variables, **session duration, average BPM, weight, and age were statistically significant predictors** in the regression model.
6. **Workout type was not statistically significant** after controlling for the other predictors.
7. The regression model explained **96.2% of the observed variation** in calorie expenditure.

---

## Limitations

- The dataset is observational, so the results should be interpreted as associations rather than causal effects.
- The model performance metrics are calculated on the same observations used to fit the model and therefore represent **in-sample performance**.
- The findings are specific to this dataset and should not automatically be generalized to all exercise populations.

---

## Files

- [`sql/01_data_exploration.sql`](sql/01_data_exploration.sql) — Data quality and initial exploration
- [`sql/02_eda.sql`](sql/02_eda.sql) — Exploratory SQL analysis
- [`sql/03_analysis.sql`](sql/03_analysis.sql) — Additional SQL analysis
- [`python/fitness_calorie_analysis.ipynb`](python/fitness_calorie_analysis.ipynb) — Python visualization, regression, diagnostics, and modeling
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
