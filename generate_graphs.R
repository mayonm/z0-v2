# Generate figures for the ordinary logistic-regression classifier.
# Run with: Rscript generate_graphs.R

dir.create(file.path("graphs", "logistic_regression"), recursive = TRUE, showWarnings = FALSE)
graph_dir <- file.path("graphs", "logistic_regression")
set.seed(20260730)

speed_dating_data <- read.csv(
  "data/Speed_Dating_Data.csv",
  na.strings = c("", "NA"),
  stringsAsFactors = FALSE,
  check.names = FALSE
)

model_variables <- c(
  "dec", "gender", "age", "race", "age_o", "race_o", "samerace",
  "attr", "sinc", "intel", "fun", "amb", "shar"
)

dat <- speed_dating_data[, model_variables]
dat$decision <- as.integer(dat$dec == 1)
dat$dec <- NULL
categorical_variables <- c("gender", "race", "race_o")
dat[categorical_variables] <- lapply(dat[categorical_variables], factor)
dat <- dat[complete.cases(dat), ]
dat$decision <- factor(dat$decision, levels = c(0, 1))

yes_rows <- which(dat$decision == 1)
no_rows <- which(dat$decision == 0)
train_rows <- c(
  sample(yes_rows, floor(0.80 * length(yes_rows))),
  sample(no_rows, floor(0.80 * length(no_rows)))
)

train <- dat[train_rows, , drop = FALSE]
test <- dat[-train_rows, , drop = FALSE]
y_test <- as.integer(as.character(test$decision))

logistic_fit <- glm(decision ~ ., data = train, family = binomial())
probability <- as.numeric(predict(logistic_fit, newdata = test, type = "response"))
predicted <- as.integer(probability >= 0.50)

coefficient_table <- data.frame(
  Variable = names(coef(logistic_fit)),
  Coefficient = as.numeric(coef(logistic_fit)),
  row.names = NULL
)
coefficient_table <- subset(coefficient_table, Variable != "(Intercept)")
coefficient_table$Odds_Ratio <- exp(coefficient_table$Coefficient)
coefficient_table <- coefficient_table[order(coefficient_table$Coefficient), ]
write.csv(coefficient_table, file.path(graph_dir, "coefficient_estimates.csv"), row.names = FALSE)

# 1. Coefficients on the log-odds scale.
png(file.path(graph_dir, "01_coefficient_estimates.png"), width = 1800, height = 1400, res = 180)
par(mar = c(5, 11, 4, 2) + 0.1)
barplot(
  coefficient_table$Coefficient,
  names.arg = coefficient_table$Variable,
  horiz = TRUE,
  las = 1,
  col = ifelse(coefficient_table$Coefficient > 0, "#2166AC", "#B2182B"),
  main = "Logistic-regression coefficient estimates",
  xlab = "Coefficient on the log-odds scale",
  cex.names = 0.75
)
abline(v = 0, lty = 2)
dev.off()

# 2. Odds ratios.
odds_ratio_table <- coefficient_table[order(coefficient_table$Odds_Ratio), ]
png(file.path(graph_dir, "02_odds_ratios.png"), width = 1800, height = 1400, res = 180)
par(mar = c(5, 11, 4, 2) + 0.1)
barplot(
  odds_ratio_table$Odds_Ratio,
  names.arg = odds_ratio_table$Variable,
  horiz = TRUE,
  las = 1,
  col = "#4D9221",
  main = "Logistic-regression odds ratios",
  xlab = "Odds ratio",
  cex.names = 0.75
)
abline(v = 1, lty = 2)
dev.off()

# 3. Confusion matrix.
confusion_matrix <- table(
  Actual = factor(y_test, levels = c(0, 1), labels = c("No", "Yes")),
  Predicted = factor(predicted, levels = c(0, 1), labels = c("No", "Yes"))
)
png(file.path(graph_dir, "03_confusion_matrix.png"), width = 1400, height = 1200, res = 180)
plot(NA, xlim = c(0, 2), ylim = c(0, 2), axes = FALSE,
     xlab = "", ylab = "", main = "Logistic-regression confusion matrix")
for (row in seq_len(2)) {
  for (column in seq_len(2)) {
    left <- column - 1
    bottom <- 2 - row
    fill <- if (row == column) "#CFEADC" else "#F8D2D2"
    rect(left, bottom, left + 1, bottom + 1, col = fill, border = "white", lwd = 2)
    text(left + 0.5, bottom + 0.5, confusion_matrix[row, column], cex = 1.5)
  }
}
axis(1, at = c(0.5, 1.5), labels = colnames(confusion_matrix), tick = FALSE)
axis(2, at = c(1.5, 0.5), labels = rownames(confusion_matrix), tick = FALSE, las = 1)
mtext("Predicted decision", side = 1, line = 2.3)
mtext("Actual decision", side = 2, line = 2.3)
box()
dev.off()

# 4. ROC curve and ROC-AUC.
ordering <- order(probability, decreasing = TRUE)
ordered_actual <- y_test[ordering]
true_positive <- cumsum(ordered_actual == 1)
false_positive <- cumsum(ordered_actual == 0)
tpr <- c(0, true_positive / sum(ordered_actual == 1))
fpr <- c(0, false_positive / sum(ordered_actual == 0))
roc_auc <- sum(diff(fpr) * (head(tpr, -1) + tail(tpr, -1)) / 2)

png(file.path(graph_dir, "04_roc_curve.png"), width = 1600, height = 1400, res = 180)
plot(fpr, tpr, type = "s", lwd = 2, col = "#2166AC",
     xlab = "False positive rate", ylab = "True positive rate",
     main = sprintf("ROC curve (ROC-AUC = %.3f)", roc_auc))
abline(0, 1, lty = 2, col = "grey50")
legend(
  "bottomright",
  legend = c(sprintf("Logistic regression: ROC-AUC = %.3f", roc_auc),
             "No-discrimination reference"),
  col = c("#2166AC", "grey50"), lty = c(1, 2), lwd = c(2, 1), bty = "n"
)
dev.off()

# 5. Precision-recall curve, PRC-AUC, and average precision.
precision_curve <- c(1, true_positive / seq_along(ordered_actual))
recall_curve <- c(0, true_positive / sum(ordered_actual == 1))
prc_auc <- sum(diff(recall_curve) *
  (head(precision_curve, -1) + tail(precision_curve, -1)) / 2)
average_precision <- sum(diff(recall_curve) * tail(precision_curve, -1))

png(file.path(graph_dir, "05_precision_recall_curve.png"), width = 1600, height = 1400, res = 180)
plot(recall_curve, precision_curve, type = "s", lwd = 2, col = "#B2182B",
     xlab = "Recall", ylab = "Precision",
     main = sprintf("Precision-recall curve (PRC-AUC = %.3f)", prc_auc))
abline(h = mean(y_test), lty = 2, col = "grey50")
legend(
  "bottomleft",
  legend = c(
    sprintf("Logistic regression: PRC-AUC = %.3f", prc_auc),
    sprintf("Average precision = %.3f", average_precision),
    sprintf("No-skill average Yes rate = %.3f", mean(y_test))
  ),
  col = c("#B2182B", "#B2182B", "grey50"),
  lty = c(1, 1, 2), lwd = c(2, 2, 1), cex = 0.80, bty = "n"
)
dev.off()

# 6. Calibration plot.
bins <- cut(probability, breaks = seq(0, 1, by = 0.1), include.lowest = TRUE)
calibration <- data.frame(
  mean_prediction = as.numeric(tapply(probability, bins, mean)),
  observed_yes_rate = as.numeric(tapply(y_test, bins, mean))
)
calibration <- calibration[complete.cases(calibration), , drop = FALSE]

png(file.path(graph_dir, "06_calibration_plot.png"), width = 1600, height = 1400, res = 180)
plot(calibration$mean_prediction, calibration$observed_yes_rate,
     type = "b", pch = 19, lwd = 2, col = "#4D9221",
     xlim = c(0, 1), ylim = c(0, 1),
     xlab = "Mean predicted probability",
     ylab = "Observed Yes rate",
     main = "Calibration plot")
abline(0, 1, lty = 2, col = "grey50")
dev.off()

tn <- confusion_matrix["No", "No"]
fp <- confusion_matrix["No", "Yes"]
fn <- confusion_matrix["Yes", "No"]
tp <- confusion_matrix["Yes", "Yes"]
accuracy <- (tp + tn) / sum(confusion_matrix)
precision <- tp / (tp + fp)
recall <- tp / (tp + fn)
f1_score <- 2 * precision * recall / (precision + recall)

write.csv(
  data.frame(
    Metric = c(
      "Accuracy", "Precision", "Recall", "F1 Score",
      "ROC-AUC", "PRC-AUC", "Average precision"
    ),
    Value = c(
      accuracy, precision, recall, f1_score,
      roc_auc, prc_auc, average_precision
    )
  ),
  file.path(graph_dir, "metrics.csv"),
  row.names = FALSE
)

cat(sprintf(
  "Logistic regression: ROC-AUC %.4f, PRC-AUC %.4f, average precision %.4f\n",
  roc_auc, prc_auc, average_precision
))

