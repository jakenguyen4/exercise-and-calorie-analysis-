# Fitness Calorie Expenditure Analysis

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/jakenguyen4/fitness-calorie-analysis/blob/main/python/fitness_calorie_analysis.ipynb)

## Project Overview

This project investigates which factors are associated with calorie expenditure during exercise.

Using 973 records from the Gym Members Exercise Dataset, the analysis combines PostgreSQL and Python to explore relationships between calorie expenditure, session duration, average heart rate, age, weight, and workout type.

### Research Question

> Which factors are associated with higher calorie expenditure?

Because the dataset is observational, this analysis identifies associations rather than causal effects.

> **Note on the data:** This dataset is publicly available on Kaggle and is not documented as real-world measurement data; it is widely believed to be synthetic. [TODO: verify on the dataset page and state plainly which it is.] The results below should therefore be read as a demonstration of analytical methods, not as evidence about real exercise physiology.

---

## Dataset

- **Source:** Gym Members Exercise Dataset (Kaggle). [TODO: add author name, URL, and license from the dataset page.]
- **Size:** 973 rows. [TODO: confirm whether each row is one gym member with a single recorded session, or multiple sessions per member. This README refers to rows as "records" until confirmed.]
- **Columns used:** `Age`, `Weight_kg`, `Avg_BPM`, `Max_BPM`, `Session_Duration_Hours`, `Workout_Type`, `Calories_Burned`
- **Columns not used:** [TODO: list the columns in the original dataset that were dropped (e.g., gender, experience level, body fat percentage) and why.]
- **Variable selection:** `Max_BPM` was examined in the SQL analysis but excluded from the regression. [TODO: state your actual reason.] Note that excluding a variable only because its bivariate correlation is near zero is a weak criterion, since a variable can matter once others are controlled for.

---

## Tools & Technologies

- **PostgreSQL**: data exploration and SQL analysis
- **Python**: statistical modeling and visualization
- **Pandas**: data manipulation
- **Matplotlib & Seaborn**: visualization
- **Statsmodels**: multiple linear regression
- **Scikit-learn**: model performance metrics and cross-validation
- **Google Colab**: Python analysis environment
- **GitHub**: project organization and documentation

---

## How to Reproduce

1. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```
2. **Set up the database:** create a PostgreSQL database and run the SQL files in order:
   ```bash
   psql -d <your_database> -f sql/00_create_table.sql
   psql -d <your_database> -f sql/01_data_exploration.sql
   psql -d <your_database> -f sql/02_eda.sql
   psql -d <your_database> -f sql/03_analysis.sql
   ```
   `00_create_table.sql` creates the `gym_members` table and loads `data/gym_members_exercise_tracking-selected-columns.csv`.
3. **Run the Python analysis:** open `python/fitness_calorie_analysis.ipynb` in Google Colab (badge above) or locally in Jupyter, and run all cells. The notebook reads the CSV from `data/`.

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

### Group Definitions

The duration and heart-rate groups use fixed cutoffs chosen for readability, not derived from the data:

| Variable | Low | Medium | High |
| --- | --- | --- | --- |
| Session duration | < 0.75 h (Short) | 0.75 to < 1.25 h (Medium) | ≥ 1.25 h (Long) |
| Average BPM | < 110 (Low) | 110 to < 130 (Medium) | ≥ 130 (High) |

[TODO: add one line on why these cutoffs were chosen, or switch to tertiles using `NTILE(3)`.] Results can change with different cutoffs.

### Key SQL Findings

| Variable | Correlation with Calories Burned |
| --- | --- |
| Session Duration | **0.908** |
| Average BPM | **0.340** |
| Weight | **0.095** |
| Max BPM | **0.002** |

Session duration had the strongest bivariate association with calorie expenditure. The correlation between session duration and average BPM was [TODO: add the result of the query in `03_analysis.sql`].

Average calories by workout type:

| Workout Type | Average Calories |
| --- | --- |
| HIIT | 925.81 |
| Strength | 910.70 |
| Yoga | 903.19 |
| Cardio | 884.51 |

The differences between workout types are small relative to the overall spread in calories burned.

---

## Statistical Modeling

A multiple linear regression model was used to examine the association between calorie expenditure and several predictors simultaneously.

### Predictors

- Session duration (hours)
- Average BPM (beats per minute)
- Weight (kg)
- Age (years)
- Workout type (categorical; reference category: [TODO: state the reference category])

The model used **HC3 heteroskedasticity-robust standard errors** because diagnostic testing indicated heteroskedasticity.

### Regression Results

Coefficients are expressed in calories, holding the other predictors constant.

| Predictor | Interpretation | Coefficient | 95% CI | p-value |
| --- | --- | --- | --- | --- |
| Session Duration | calories per additional hour | 716.38 | [TODO] | [TODO] |
| Average BPM | calories per additional bpm | 6.26 | [TODO] | [TODO] |
| Weight | calories per additional kg | 1.28 | [TODO] | [TODO] |
| Age | calories per additional year | -3.24 | [TODO] | [TODO] |

**Workout type** was assessed with a joint test of all workout-type coefficients (Wald/F-test), rather than judging each dummy variable separately: F([TODO]) = [TODO], p = [TODO]. [TODO: if this test has not been run yet, run it, for example with `model.wald_test` on the dummy terms or by comparing nested models with `anova_lm`, and report the result here. Only describe workout type as "not significant" if the joint test supports it.]

### Model Performance

In-sample (fit and evaluated on the same data):

- **R²:** 0.962
- **MAE:** 41.90 calories
- **RMSE:** 52.86 calories

Out-of-sample (5-fold cross-validation):

- **R²:** [TODO]
- **MAE:** [TODO]
- **RMSE:** [TODO]

[TODO: run cross-validation or a train/test split and fill in these values. In-sample metrics can overstate how well the model predicts new data.]

---

## Model Diagnostics

A Breusch-Pagan test indicated significant heteroskedasticity in the residuals. HC3 robust standard errors were therefore used for statistical inference.

Variance Inflation Factors (VIFs) were approximately 1 for the numerical predictors, indicating no meaningful multicollinearity.

The residual plot showed increasing residual spread at higher predicted calorie values, consistent with the Breusch-Pagan result. Robust standard errors correct the inference but not the underlying pattern; a log-transformed outcome or weighted least squares could be explored as alternatives. [TODO: mention if you tried either.]

---

## Key Findings

1. **Session duration had the strongest bivariate association with calorie expenditure** (correlation 0.908). In the regression, each additional hour was associated with roughly 716 more calories, holding the other variables constant.
2. **Average heart rate** showed a moderate positive bivariate association (0.340) and a positive association in the regression (about 6.3 calories per bpm).
3. **Weight** had a weaker positive association (about 1.3 calories per kg in the regression).
4. **Age** was negatively associated with calorie expenditure (about 3.2 fewer calories per year) after controlling for the other variables.
5. Raw average calories were similar across workout types.
6. [TODO: update to match the joint test result for workout type.]
7. The model explained approximately **96.2% of the variation** in calorie expenditure in-sample. [TODO: add the cross-validated figure.]

---

## Limitations

- **Observational data.** Results are associations, not causal effects. For example, heart rate is partly a consequence of exercise intensity, so it should not be read as a lever that independently raises calorie burn.
- **Possibly synthetic data.** The dataset is not documented as real measurements and is widely believed to be synthetic. The very high R² and near-zero multicollinearity are consistent with that. Findings may reflect how the data was generated and should not be generalized to real exercise populations.
- **In-sample metrics.** R², MAE, and RMSE above are calculated on the data used to fit the model unless the cross-validated results are filled in.
- **Omitted variables.** Only a subset of the dataset's columns was used. Excluded variables (such as `Max_BPM` and [TODO: other excluded columns]) could change the estimated coefficients.
- **Arbitrary group cutoffs.** The duration and heart-rate groups in the SQL analysis use fixed thresholds, and the group averages depend on them.
- **Measurement.** Calories burned and heart rate are presumably device-estimated or generated, not directly measured. [TODO: confirm from the dataset documentation.]
- **Heteroskedasticity.** Residual spread grows at higher predicted values. Robust standard errors address inference, but prediction intervals from a standard OLS model would be unreliable.

---

## Files

- [`sql/00_create_table.sql`](sql/00_create_table.sql): Table definition and data load
- [`sql/01_data_exploration.sql`](sql/01_data_exploration.sql): Data quality and initial exploration
- [`sql/02_eda.sql`](sql/02_eda.sql): Exploratory SQL analysis
- [`sql/03_analysis.sql`](sql/03_analysis.sql): Additional SQL analysis
- [`python/fitness_calorie_analysis.ipynb`](python/fitness_calorie_analysis.ipynb): Python visualization, regression, diagnostics, and modeling
- [`visualizations/`](visualizations/): Saved figures from the analysis
- [`requirements.txt`](requirements.txt): Python dependencies

## Project Structure

```
fitness-calorie-analysis/
├── data/
│   └── gym_members_exercise_tracking-selected-columns.csv
├── sql/
│   ├── 00_create_table.sql
│   ├── 01_data_exploration.sql
│   ├── 02_eda.sql
│   └── 03_analysis.sql
├── python/
│   └── fitness_calorie_analysis.ipynb
├── visualizations/
├── .gitignore
├── LICENSE
├── README.md
└── requirements.txt
```

## License & Data Attribution

The code in this repository is released under the [MIT License](LICENSE). The MIT license covers the code only. The dataset is subject to its own license and terms: [TODO: add dataset license and attribution from the Kaggle page].
