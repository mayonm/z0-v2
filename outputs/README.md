# Analysis output gallery

This folder contains the graphs and tables generated from `final.Rmd`. Open
[the detailed output report](analysis_outputs.md) to view all tables, model
metrics, confusion matrices, coefficients, and numerical results.

## Exploratory data analysis

### Race distribution

![Race distribution](figures/eda/01_race_distribution.png)

### Decisions by same-race status

![Decisions by same-race status](figures/eda/02_decisions_by_same_race.png)

### Race decision heatmap

![Race decision heatmap](figures/eda/03_race_decision_heatmap.png)

### Ratings by same-race status

- [Attractiveness](figures/eda/04_attractiveness_boxplots.png)
- [Fun](figures/eda/05_fun_boxplots.png)
- [Sincerity](figures/eda/06_sincerity_boxplots.png)
- [Shared interests](figures/eda/07_shared_interests_boxplots.png)
- [Ambition](figures/eda/08_ambition_boxplots.png)
- [Intelligence](figures/eda/09_intelligence_boxplots.png)

## Logistic regression

![Logistic-regression ROC curve](figures/logistic_regression/01_roc_curve.png)

![Logistic-regression precision-recall curve](figures/logistic_regression/02_precision_recall_curve.png)

![Logistic-regression calibration plot](figures/logistic_regression/03_calibration_plot.png)

![Logistic-regression coefficient plot](figures/logistic_regression/04_coefficient_plot.png)

## Neural network

- [Class balance](figures/neural_network/01_class_balance.png)
- [Confusion matrix](figures/neural_network/02_confusion_matrix.png)
- [ROC curve](figures/neural_network/03_roc_curve.png)
- [Precision-recall curve](figures/neural_network/04_precision_recall_curve.png)
- [Probability distribution](figures/neural_network/05_probability_distribution.png)
- [Calibration plot](figures/neural_network/06_calibration_plot.png)
- [Permutation importance](figures/neural_network/07_permutation_importance.png)

## Random forest

![Random-forest OOB error](figures/random_forest/01_oob_error.png)

![Random-forest variable importance](figures/random_forest/02_variable_importance.png)

![Random-forest ROC curve](figures/random_forest/03_roc_curve.png)

![Random-forest precision-recall curve](figures/random_forest/04_precision_recall_curve.png)

![Random-forest calibration plot](figures/random_forest/05_calibration_plot.png)
