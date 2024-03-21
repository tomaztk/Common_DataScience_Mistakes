cat("\014")
rm(list = ls())
setwd("/Users/tomazkastrun/Documents/Tomaztk_github/Common_datascience_mistakes")


### Not good example!!!
# Example: Ignoring model evaluation metrics other than accuracy

# Load necessary libraries
library(caret)

# Generate a binary classification dataset
set.seed(123)
n <- 1000
x <- rnorm(n)
y <- factor(sample(c(0, 1), size = n, replace = TRUE))

# Create dataset
data <- data.frame(x, y)

# Create an imbalanced dataset
data$y <- factor(ifelse(data$y == 1, "Positive", "Negative"))
table(data$y)

# Fit a logistic regression model
model <- glm(y ~ x, data = data, family = "binomial")

# Predict on the training data
predicted_classes <- ifelse(predict(model, type = "response") > 0.5, "Positive", "Negative")

# Calculate accuracy
accuracy <- mean(predicted_classes == data$y)
cat("Accuracy:", accuracy, "\n")

# Calculate precision, recall, and F1-score
confusion_matrix <- table(data$y, predicted_classes)
precision <- confusion_matrix["Positive", "Positive"] / sum(predicted_classes == "Positive")
recall <- confusion_matrix["Positive", "Positive"] / sum(data$y == "Positive")
f1_score <- 2 * (precision * recall) / (precision + recall)

cat("Precision:", precision, "\n")
cat("Recall:", recall, "\n")
cat("F1-score:", f1_score, "\n")
