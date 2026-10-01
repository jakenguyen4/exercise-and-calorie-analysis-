# Fitness Calorie Expenditure Analysis

## Project Overview

This project investigates factors associated with calorie expenditure during exercise using SQL and Python.

The primary research question is:

> **Which factors are associated with higher calorie expenditure?**

The analysis combines PostgreSQL for data exploration and SQL-based analysis with Python for exploratory data analysis, multiple linear regression, and model diagnostics.

The goal is to demonstrate practical skills in SQL, exploratory data analysis, statistical modeling, data visualization, and interpretation of statistical results.

Because the dataset is observational, the relationships identified in this project should be interpreted as associations rather than causal effects.

---

## Dataset

This project uses the **Gym Members Exercise Dataset** by Valakhorasani, available on [Kaggle](https://www.kaggle.com/datasets/valakhorasani/gym-members-exercise-dataset). See the dataset page for its license and terms.

The dataset contains 973 records and the following variables (not all were used in the analysis):

- Age
- Gender
- Weight (kg)
- Height (m)
- Max BPM
- Avg BPM
- Resting BPM
- Session Duration (hours)
- Calories Burned
- Workout Type

Data-quality checks found no missing values in the variables used for analysis.

> **Note:** The dataset's provenance is not documented, and the unusually clean statistics (R² of 0.96, VIFs near 1) suggest caution. This project is intended as a demonstration of analytical methods rather than as evidence about real-world exercise physiology.

### Variables Used in the Regression Model

The final multiple linear regression model used:

- Age
- Weight (kg)
- Avg BPM
- Session Duration (hours)
- Workout Type

Gender, height, maximum BPM, and resting BPM were not included in the final regression model.

---

## Tools & Technologies

- **PostgreSQL**: Database storage and SQL analysis
- **pgAdmin 4**: PostgreSQL database management
- **Python**: Statistical analysis and visualization
- **Google Colab**: Python development environment
- **Pandas**: Data manipulation
- **NumPy**: Numerical computing
- **Matplotlib / Seaborn**: Data visualization
- **Statsmodels**: Regression modeling and statistical diagnostics
- **Scikit-learn**: Model performance metrics
- **GitHub**: Version control and project documentation

---

## Project Workflow

### 1. Data Quality Checks

`sql/01_data_exploration.sql`

The dataset was imported into PostgreSQL and stored in the `gym_members` table.

Initial checks included:

- Number of records
- Missing-value checks
- Overall summary of calories burned (average, minimum, maximum)

The dataset contained **973 records**, with no missing values in the variables used for analysis.

### 2. SQL Exploratory Analysis

`sql/02_eda.sql` and `sql/03_analysis.sql`

SQL was used to investigate relationships between calorie expenditure and several variables:

- Calorie expenditure by workout type
- Calorie expenditure by session duration
- Calorie expenditure by heart-rate category
- Pearson correlations with calorie expenditure
- Comparisons of workout types across participant characteristics
- Correlation between session duration and average BPM

### 3. Python Exploratory Data Analysis

`python/fitness_calorie_analysis.ipynb`

Python was used to visualize relationships between calorie expenditure and key variables:

- Session duration vs. calories burned
- Average BPM vs. calories burned
- Average calories burned by workout type
- Correlation analysis

### 4. Multiple Linear Regression

A multiple linear regression model was developed to examine the association between calorie expenditure and session duration, average BPM, weight, age, and workout type.

HC3 robust standard errors were used because diagnostic testing indicated heteroskedasticity.

### 5. Model Diagnostics

- Breusch-Pagan test for heteroskedasticity
- Variance Inflation Factors (VIF)
- Residual analysis
- Wald test for the overall Workout Type effect

### 6. Model Performance

Model performance was evaluated using R², Mean Absolute Error (MAE), and Root Mean Squared Error (RMSE). These metrics are based on the same data used to fit the model and are therefore **in-sample metrics**.

---

## SQL Analysis

### Workout Type

Average calorie expenditure by workout type:

| Workout Type | Records | Avg. Calories |
|---|---:|---:|
| HIIT | 221 | 925.81 |
| Strength | 258 | 910.70 |
| Yoga | 239 | 903.19 |
| Cardio | 255 | 884.51 |

These are raw group averages and do not control for other variables.

### Session Duration

Session duration was grouped into three categories:

- **Short:** less than 0.75 hours
- **Medium:** 0.75 to less than 1.25 hours
- **Long:** 1.25 hours or more

| Duration | Records | Avg. Calories |
|---|---:|---:|
| Long | 508 | 1097.76 |
| Medium | 380 | 750.75 |
| Short | 85 | 447.41 |

Longer sessions had substantially higher average calorie expenditure in the dataset.

### Heart-Rate Categories

Average heart rate was grouped using fixed thresholds: **Low** (below 110 bpm), **Medium** (110 to below 130 bpm), and **High** (130 bpm or above).

| Heart-Rate Category | Records | Avg. Calories |
|---|---:|---:|
| High | 775 | 935.62 |
| Medium | 198 | 787.21 |
| Low | 0 | n/a |

No records fell into the Low category, and about 80% fall into High, so these groups are highly unbalanced. The correlation analysis below gives a more informative picture of the heart-rate relationship.

### Correlations

Pearson correlations with calorie expenditure were calculated for several numerical variables:

| Variable | Correlation with Calories |
|---|---:|
| Session Duration | **0.908** |
| Avg BPM | **0.340** |
| Weight | **0.095** |
| Max BPM | **0.002** |

Session duration had the strongest bivariate association with calorie expenditure.

The correlation between session duration and average BPM was **0.016**, indicating that the two variables were nearly uncorrelated in this dataset.

---

## Multiple Linear Regression

The final regression model was:

```text
Calories Burned ~ Session Duration + Avg BPM + Weight + Age + Workout Type
```

### Regression Results

Coefficients are in calories, holding the other predictors constant. Test statistics are Wald tests using HC3 robust standard errors.

| Predictor | Interpretation | Coefficient | Wald χ² (df = 1) | p-value |
|---|---|---:|---:|---|
| Session Duration | calories per additional hour | 716.38 | 13,377.1 | < 0.001 |
| Avg BPM | calories per additional bpm | 6.26 | 2,261.2 | < 0.001 |
| Weight | calories per additional kg | 1.28 | 354.9 | < 0.001 |
| Age | calories per additional year | -3.24 | 623.6 | < 0.001 |

**Workout Type** was tested jointly across all of its categories (Wald test): χ²(3) = 0.72, p = 0.87. There is no evidence that workout type is associated with calorie expenditure after controlling for the other variables.

### Model Diagnostics

- **Heteroskedasticity:** A Breusch-Pagan test indicated significant heteroskedasticity. HC3 robust standard errors were used for inference. The residuals vs. predicted values plot showed increasing spread at higher predicted calorie values, consistent with this result.
- **Multicollinearity:** VIFs were approximately 1 for the numerical predictors, indicating little to no multicollinearity. This is consistent with the near-zero correlation between session duration and average BPM.

### Model Performance (in-sample)

- **R²:** 0.962
- **MAE:** 41.90 calories
- **RMSE:** 52.86 calories

---

## Key Findings

1. **Session duration had the strongest association with calorie expenditure** (correlation 0.908). Each additional hour was associated with roughly 716 more calories, holding the other variables constant.
2. **Average heart rate** was moderately associated with calories burned (correlation 0.340) and positively associated in the regression (about 6.3 calories per bpm).
3. **Weight** was weakly positively associated (about 1.3 calories per kg in the regression).
4. **Age** was negatively associated with calorie expenditure (about 3.2 fewer calories per year) after controlling for the other variables.
5. **Workout type was not significantly associated with calorie expenditure** after controlling for the other predictors (joint Wald test p = 0.87). Raw averages ranged only from about 885 to 926 calories.
6. The model explained approximately **96.2% of the variation** in calorie expenditure in-sample.

---

## Limitations

- **Observational data.** Results are associations, not causal effects. Heart rate, for example, is partly a consequence of exercise intensity, so it should not be read as an independent lever on calorie burn.
- **In-sample performance.** R², MAE, and RMSE were calculated on the data used to fit the model. They do not measure how well the model would predict new data.
- **Data provenance.** The dataset's origin is not documented, and its unusually clean statistics suggest caution. Findings should not be generalized to real exercise populations.
- **Omitted variables.** Gender, height, maximum BPM, and resting BPM were not included in the regression, and could change the estimated coefficients.
- **Fixed cutoffs.** The duration and heart-rate categories in the SQL analysis use fixed thresholds, and the group averages depend on them.

---

## Repository Structure

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
```

The code in this repository is released under the [MIT License](LICENSE). The dataset has its own license, listed on its Kaggle page.
