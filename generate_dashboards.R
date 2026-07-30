# Presentation-style dashboards for the logistic-regression and neural-network classifiers.
# Run with: Rscript generate_dashboards.R

local_library <- file.path(getwd(), ".r-lib")
if (dir.exists(local_library)) .libPaths(c(local_library, .libPaths()))

if (!requireNamespace("nnet", quietly = TRUE)) {
  stop("Install nnet before running this script.")
}

library(nnet)

set.seed(20260730)

title_brown <- "#4A241B"
aqua_background <- "#DDF6F6"
logistic_blue <- "#2E86D1"
nn_orange <- "#F58518"
pr_red <- "#C43D4A"
grid_gray <- "#E7E7E7"

model_variables <- c(
  "dec", "gender", "age", "race", "age_o", "race_o", "samerace",
  "attr", "sinc", "intel", "fun", "amb", "shar"
)

dat <- read.csv(
  "data/Speed_Dating_Data.csv",
  na.strings = c("", "NA"),
  stringsAsFactors = FALSE,
  check.names = FALSE
)[, model_variables]

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

x_all <- model.matrix(decision ~ ., dat)[, -1, drop = FALSE]
x_train <- x_all[train_rows, , drop = FALSE]
x_test <- x_all[-train_rows, , drop = FALSE]
train <- dat[train_rows, , drop = FALSE]
test <- dat[-train_rows, , drop = FALSE]
y_train <- as.integer(as.character(dat$decision[train_rows]))
y_test <- as.integer(as.character(dat$decision[-train_rows]))

curve_data <- function(actual, scores) {
  ordering <- order(scores, decreasing = TRUE)
  ordered_actual <- actual[ordering]
  positive_total <- sum(ordered_actual == 1)
  negative_total <- sum(ordered_actual == 0)
  true_positive <- cumsum(ordered_actual == 1)
  false_positive <- cumsum(ordered_actual == 0)

  roc <- data.frame(
    fpr = c(0, false_positive / negative_total),
    tpr = c(0, true_positive / positive_total)
  )
  pr <- data.frame(
    recall = c(0, true_positive / positive_total),
    precision = c(1, true_positive / seq_along(ordered_actual))
  )

  list(
    roc = roc,
    pr = pr,
    roc_auc = sum(diff(roc$fpr) * (head(roc$tpr, -1) + tail(roc$tpr, -1)) / 2),
    prc_auc = sum(diff(pr$recall) *
      (head(pr$precision, -1) + tail(pr$precision, -1)) / 2),
    average_precision = sum(diff(pr$recall) * tail(pr$precision, -1))
  )
}

open_dashboard <- function(filename, model_name, subtitle) {
  png(filename, width = 2400, height = 1400, res = 180, bg = aqua_background)
  par(mfrow = c(2, 2), oma = c(0, 0, 5.5, 0), bg = aqua_background)
  list(model_name = model_name, subtitle = subtitle)
}

draw_dashboard_header <- function(header) {
  title_size <- if (nchar(header$model_name) > 28) 1.55 else 2.0
  mtext(header$model_name, outer = TRUE, side = 3, line = 2.7,
        cex = title_size, font = 2, col = title_brown)
  mtext(header$subtitle, outer = TRUE, side = 3, line = 1.15,
        cex = 0.78, col = "#587078")
}

plot_panel <- function(plotting_function, margins = c(4.5, 4.2, 3.8, 1.0)) {
  par(mar = margins, bg = "white", xaxs = "i", yaxs = "i")
  plotting_function()
  box(col = "#D9E2E5")
}

white_plot_background <- function() {
  plot_limits <- par("usr")
  rect(
    plot_limits[1], plot_limits[3], plot_limits[2], plot_limits[4],
    col = "white", border = NA
  )
  grid(col = grid_gray, lwd = 0.7)
}

plot_roc_panel <- function(curves, line_color, panel_number) {
  function() {
    plot(
      curves$roc$fpr, curves$roc$tpr,
      type = "n",
      xlim = c(0, 1), ylim = c(0, 1),
      xlab = "False Positive Rate", ylab = "True Positive Rate",
      main = sprintf("%02d ROC Curve", panel_number)
    )
    white_plot_background()
    lines(curves$roc$fpr, curves$roc$tpr, type = "s", lwd = 2.3, col = line_color)
    mtext(sprintf("Held-out test set · ROC-AUC = %.3f", curves$roc_auc),
          side = 3, line = 0.35, cex = 0.70, col = line_color)
    abline(0, 1, lty = 2, col = "#AAB7B8")
    legend(
      "bottomright",
      legend = c(sprintf("ROC-AUC = %.3f", curves$roc_auc), "No-discrimination"),
      col = c(line_color, "#AAB7B8"), lty = c(1, 2), lwd = c(2.3, 1),
      cex = 0.68, bty = "n"
    )
  }
}

plot_pr_panel <- function(curves, line_color, prevalence, panel_number) {
  function() {
    plot(
      curves$pr$recall, curves$pr$precision,
      type = "n",
      xlim = c(0, 1), ylim = c(0, 1),
      xlab = "Recall", ylab = "Precision",
      main = sprintf("%02d Precision-Recall Curve", panel_number)
    )
    white_plot_background()
    lines(curves$pr$recall, curves$pr$precision, type = "s", lwd = 2.3, col = line_color)
    mtext(
      sprintf("PRC-AUC = %.3f · Average precision = %.3f",
              curves$prc_auc, curves$average_precision),
      side = 3, line = 0.35, cex = 0.66, col = line_color
    )
    abline(h = prevalence, lty = 2, col = "#AAB7B8")
    legend(
      "bottomleft",
      legend = c(
        sprintf("PRC-AUC = %.3f", curves$prc_auc),
        sprintf("Average precision = %.3f", curves$average_precision),
        sprintf("No-skill average Yes rate = %.3f", prevalence)
      ),
      col = c(line_color, line_color, "#AAB7B8"),
      lty = c(1, 1, 2), lwd = c(2.3, 2.3, 1),
      cex = 0.58, bty = "n"
    )
  }
}

plot_metric_summary <- function(curves, title, accuracy = NULL) {
  function() {
    plot(NA, xlim = c(0, 1), ylim = c(0, 1), axes = FALSE,
         xlab = "", ylab = "", main = title)
    rect(0, 0, 1, 1, col = "white", border = NA)
    text(0.50, 0.76, sprintf("ROC-AUC  %.3f", curves$roc_auc),
         cex = 1.30, font = 2, col = logistic_blue)
    text(0.50, 0.51, sprintf("PRC-AUC  %.3f", curves$prc_auc),
         cex = 1.30, font = 2, col = pr_red)
    text(0.50, 0.27, sprintf("Average precision  %.3f", curves$average_precision),
         cex = 1.10, col = title_brown)
    if (!is.null(accuracy)) {
      text(0.50, 0.10, sprintf("Accuracy at 0.50 threshold  %.3f", accuracy),
           cex = 0.82, col = "#587078")
    }
  }
}

dashboard_dir <- file.path("graphs", "dashboards")
dir.create(dashboard_dir, recursive = TRUE, showWarnings = FALSE)

# Logistic-regression model and dashboard.
logistic_fit <- glm(decision ~ ., data = train, family = binomial())
logistic_probability <- as.numeric(predict(logistic_fit, newdata = test, type = "response"))
logistic_curves <- curve_data(y_test, logistic_probability)
logistic_prediction <- as.integer(logistic_probability >= 0.50)
logistic_accuracy <- mean(logistic_prediction == y_test)

logistic_header <- open_dashboard(
  file.path(dashboard_dir, "logistic_regression_dashboard.png"),
  "Logistic Regression",
  "Ordinary binomial model · held-out categorical Yes/No predictions"
)

plot_panel(function() {
  coefficient_data <- data.frame(
    variable = names(coef(logistic_fit)),
    coefficient = as.numeric(coef(logistic_fit)),
    row.names = NULL
  )
  coefficient_data <- subset(coefficient_data, variable != "(Intercept)")
  coefficient_data <- coefficient_data[
    order(abs(coefficient_data$coefficient), decreasing = TRUE),
    , drop = FALSE
  ]
  coefficient_data <- head(coefficient_data, 12)
  coefficient_data <- coefficient_data[order(coefficient_data$coefficient), , drop = FALSE]
  barplot(
    coefficient_data$coefficient,
    names.arg = coefficient_data$variable,
    horiz = TRUE, las = 1,
    col = ifelse(coefficient_data$coefficient > 0, logistic_blue, pr_red),
    main = "01 Largest Logistic-Regression Coefficients",
    xlab = "Coefficient on the log-odds scale",
    cex.names = 0.72
  )
  abline(v = 0, lty = 2, col = "#AAB7B8")
}, margins = c(4.5, 8.0, 3.8, 1.0))

plot_panel(plot_roc_panel(logistic_curves, logistic_blue, 2))
plot_panel(plot_pr_panel(
  logistic_curves, pr_red, mean(y_test), 3
))
plot_panel(plot_metric_summary(
  logistic_curves, "04 Held-Out Performance Summary", logistic_accuracy
))
draw_dashboard_header(logistic_header)
dev.off()

# Feedforward neural-network model and dashboard.
train_means <- colMeans(x_train)
train_sds <- apply(x_train, 2, sd)
train_sds[is.na(train_sds) | train_sds == 0] <- 1
x_train_scaled <- sweep(sweep(x_train, 2, train_means, "-"), 2, train_sds, "/")
x_test_scaled <- sweep(sweep(x_test, 2, train_means, "-"), 2, train_sds, "/")

nn_fit <- nnet(
  x = x_train_scaled,
  y = y_train,
  size = 8,
  decay = 0.001,
  maxit = 500,
  entropy = TRUE,
  linout = FALSE,
  trace = FALSE,
  MaxNWts = 10000
)
nn_probability <- as.numeric(predict(nn_fit, x_test_scaled, type = "raw"))
nn_prediction <- as.integer(nn_probability >= 0.50)
nn_curves <- curve_data(y_test, nn_probability)
nn_confusion <- table(
  Actual = factor(y_test, levels = c(0, 1), labels = c("No", "Yes")),
  Predicted = factor(nn_prediction, levels = c(0, 1), labels = c("No", "Yes"))
)
nn_accuracy <- sum(diag(nn_confusion)) / sum(nn_confusion)

nn_header <- open_dashboard(
  file.path(dashboard_dir, "neural_network_dashboard.png"),
  "Feedforward Neural Network",
  "One hidden layer · held-out categorical Yes/No predictions"
)

plot_panel(function() {
  plot(
    NA, xlim = c(0, 2), ylim = c(0, 2), axes = FALSE,
    xlab = "", ylab = "", main = "01 Held-Out Confusion Matrix"
  )
  rect(0, 0, 2, 2, col = "white", border = NA)
  mtext(
    sprintf("Threshold = 0.50 · Accuracy = %.3f", nn_accuracy),
    side = 3, line = 0.35, cex = 0.72, col = nn_orange
  )
  for (row in seq_len(2)) {
    for (column in seq_len(2)) {
      left <- column - 1
      bottom <- 2 - row
      fill <- if (row == column) "#CFEADC" else "#F8D2D2"
      rect(left, bottom, left + 1, bottom + 1, col = fill, border = "white", lwd = 2)
      text(left + 0.5, bottom + 0.5, nn_confusion[row, column], cex = 1.7, font = 2)
    }
  }
  axis(1, at = c(0.5, 1.5), labels = colnames(nn_confusion), tick = FALSE, line = -0.5)
  axis(2, at = c(1.5, 0.5), labels = rownames(nn_confusion), tick = FALSE, las = 1, line = -0.5)
  mtext("Predicted decision", side = 1, line = 2.2)
  mtext("Actual decision", side = 2, line = 2.2)
})

plot_panel(plot_roc_panel(nn_curves, nn_orange, 2))
plot_panel(plot_pr_panel(
  nn_curves, nn_orange, mean(y_test), 3
))
plot_panel(plot_metric_summary(
  nn_curves, "04 Held-Out Performance Summary", nn_accuracy
))
draw_dashboard_header(nn_header)
dev.off()

cat(sprintf(
  "Logistic regression: ROC-AUC %.3f, PRC-AUC %.3f, average precision %.3f\n",
  logistic_curves$roc_auc, logistic_curves$prc_auc, logistic_curves$average_precision
))
cat(sprintf(
  "Neural network: ROC-AUC %.3f, PRC-AUC %.3f, average precision %.3f\n",
  nn_curves$roc_auc, nn_curves$prc_auc, nn_curves$average_precision
))
