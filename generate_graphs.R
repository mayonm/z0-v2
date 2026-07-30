local_library <- file.path(getwd(), ".r-lib")
if (dir.exists(local_library)) .libPaths(c(local_library, .libPaths()))

library(glmnet)
dir.create("graphs", showWarnings = FALSE)
set.seed(20260730)

speed_dating_data <- read.csv(
  "data/Speed_Dating_Data.csv",
  na.strings = c("", "NA"),
  stringsAsFactors = FALSE,
  check.names = FALSE
)

model_variables <- c(
  "dec", "gender", "age", "race", "age_o", "race_o", "samerace",
  "imprace", "imprelig", "goal", "date", "go_out", "career_c",
  "sports", "tvsports", "exercise", "dining", "museums", "art",
  "hiking", "gaming", "clubbing", "reading", "tv", "theater",
  "movies", "concerts", "music", "shopping", "yoga", "exphappy"
)

dat <- speed_dating_data[, model_variables]
dat$decision <- as.integer(dat$dec == 1)
dat$dec <- NULL
categorical_variables <- c(
  "gender", "race", "race_o", "goal", "date", "go_out", "career_c"
)
dat[categorical_variables] <- lapply(dat[categorical_variables], factor)
dat <- dat[complete.cases(dat), ]
dat$decision <- factor(dat$decision, levels = c(0, 1))

yes_rows <- which(dat$decision == 1)
no_rows <- which(dat$decision == 0)
train_rows <- c(
  sample(yes_rows, floor(0.80 * length(yes_rows))),
  sample(no_rows, floor(0.80 * length(no_rows)))
)

x_all <- model.matrix(decision ~ ., dat)[, -1, drop = FALSE]
x_train <- x_all[train_rows, , drop = FALSE]
x_test <- x_all[-train_rows, , drop = FALSE]
y_train <- as.integer(as.character(dat$decision[train_rows]))
y_test <- as.integer(as.character(dat$decision[-train_rows]))

cv_lasso <- cv.glmnet(
  x_train, y_train,
  family = "binomial",
  alpha = 1,
  type.measure = "auc",
  nfolds = 10,
  standardize = TRUE
)
lambda_used <- cv_lasso$lambda.1se
lasso_fit <- glmnet(
  x_train, y_train,
  family = "binomial",
  alpha = 1,
  lambda = lambda_used,
  standardize = TRUE
)
probability <- as.numeric(predict(lasso_fit, newx = x_test, type = "response"))
predicted <- as.integer(probability >= 0.5)

# 1. Cross-validation curve.
png("graphs/01_cross_validation.png", width = 1800, height = 1400, res = 180)
plot(cv_lasso, main = "10-fold cross-validation for LASSO logistic regression")
dev.off()

# 2. Coefficient paths.
png("graphs/02_coefficient_paths.png", width = 1800, height = 1400, res = 180)
plot(cv_lasso$glmnet.fit, xvar = "lambda", label = TRUE,
     main = "LASSO coefficient paths")
abline(v = log(lambda_used), lty = 2, col = "#B2182B", lwd = 2)
dev.off()

# 3. Selected coefficients.
coefficient_matrix <- as.matrix(coef(lasso_fit))
coefficient_table <- data.frame(
  Variable = rownames(coefficient_matrix),
  Coefficient = as.numeric(coefficient_matrix[, 1]),
  row.names = NULL
)
coefficient_table <- subset(
  coefficient_table,
  Variable != "(Intercept)" & Coefficient != 0
)
coefficient_table$Odds_Ratio <- exp(coefficient_table$Coefficient)
coefficient_table <- coefficient_table[order(coefficient_table$Coefficient), ]
write.csv(coefficient_table, "graphs/selected_variables.csv", row.names = FALSE)

png("graphs/03_selected_coefficients.png", width = 1800, height = 1400, res = 180)
par(mar = c(5, 11, 4, 2) + 0.1)
barplot(
  coefficient_table$Coefficient,
  names.arg = coefficient_table$Variable,
  horiz = TRUE,
  las = 1,
  col = ifelse(coefficient_table$Coefficient > 0, "#2166AC", "#B2182B"),
  main = "Nonzero LASSO coefficients",
  xlab = "Coefficient on the log-odds scale",
  cex.names = 0.75
)
abline(v = 0, lty = 2)
par(mar = c(5, 4, 4, 2) + 0.1)
dev.off()

# 4. Confusion matrix heatmap.
confusion_matrix <- table(
  Actual = factor(y_test, levels = c(0, 1)),
  Predicted = factor(predicted, levels = c(0, 1))
)
png("graphs/04_confusion_matrix.png", width = 1400, height = 1200, res = 180)
image(
  x = 1:2, y = 1:2, z = confusion_matrix,
  col = colorRampPalette(c("#DEEBF7", "#2171B5"))(100),
  axes = FALSE, xlab = "Predicted decision", ylab = "Actual decision",
  main = "Confusion matrix"
)
axis(1, at = 1:2, labels = c("No (0)", "Yes (1)"))
axis(2, at = 1:2, labels = c("No (0)", "Yes (1)"))
for (i in 1:2) for (j in 1:2) {
  text(i, j, confusion_matrix[i, j], cex = 1.4)
}
box()
dev.off()

# ROC curve and ROC-AUC.
ord <- order(probability, decreasing = TRUE)
actual_ordered <- y_test[ord]
tpr <- c(0, cumsum(actual_ordered == 1) / sum(actual_ordered == 1), 1)
fpr <- c(0, cumsum(actual_ordered == 0) / sum(actual_ordered == 0), 1)
roc_auc <- sum(diff(fpr) * (head(tpr, -1) + tail(tpr, -1)) / 2)
png("graphs/05_roc_curve.png", width = 1600, height = 1400, res = 180)
plot(fpr, tpr, type = "s", lwd = 2, col = "#2166AC",
     xlab = "False positive rate", ylab = "True positive rate",
     main = sprintf("ROC curve (AUC = %.3f)", roc_auc))
abline(0, 1, lty = 2, col = "grey50")
dev.off()

# Precision-recall curve and PR-AUC.
tp <- cumsum(actual_ordered == 1)
fp <- cumsum(actual_ordered == 0)
precision_curve <- c(1, tp / (tp + fp))
recall_curve <- c(0, tp / sum(actual_ordered == 1))
pr_auc <- sum(diff(recall_curve) *
  (head(precision_curve, -1) + tail(precision_curve, -1)) / 2)
png("graphs/06_precision_recall_curve.png", width = 1600, height = 1400, res = 180)
plot(recall_curve, precision_curve, type = "s", lwd = 2, col = "#B2182B",
     xlab = "Recall", ylab = "Precision",
     main = sprintf("Precision-recall curve (AUC = %.3f)", pr_auc))
abline(h = mean(y_test == 1), lty = 2, col = "grey50")
dev.off()

# Calibration plot.
calibration_data <- data.frame(actual = y_test, probability = probability)
calibration_data$bin <- cut(
  calibration_data$probability, breaks = seq(0, 1, by = 0.1),
  include.lowest = TRUE
)
calibration_summary <- aggregate(
  cbind(actual, probability) ~ bin,
  data = calibration_data,
  FUN = mean
)
png("graphs/07_calibration_plot.png", width = 1600, height = 1400, res = 180)
plot(calibration_summary$probability, calibration_summary$actual,
     type = "b", pch = 19, lwd = 2, col = "#4D9221",
     xlim = c(0, 1), ylim = c(0, 1),
     xlab = "Mean predicted probability",
     ylab = "Observed proportion saying Yes",
     main = "Calibration plot")
abline(0, 1, lty = 2, col = "grey50")
dev.off()

tn <- confusion_matrix["0", "0"]
fp_value <- confusion_matrix["0", "1"]
fn <- confusion_matrix["1", "0"]
tp_value <- confusion_matrix["1", "1"]
accuracy <- (tp_value + tn) / sum(confusion_matrix)
precision_value <- tp_value / (tp_value + fp_value)
recall_value <- tp_value / (tp_value + fn)
f1_value <- 2 * precision_value * recall_value /
  (precision_value + recall_value)
write.csv(
  data.frame(
    Metric = c("Accuracy", "Precision", "Recall", "F1 Score", "ROC-AUC", "PR-AUC"),
    Value = c(accuracy, precision_value, recall_value, f1_value, roc_auc, pr_auc)
  ),
  "graphs/metrics.csv", row.names = FALSE
)
cat(sprintf("ROC-AUC: %.4f\nPR-AUC: %.4f\n", roc_auc, pr_auc))
