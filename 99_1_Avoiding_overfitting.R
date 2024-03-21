cat("\014")
rm(list = ls())
setwd("/Users/tomazkastrun/Documents/Tomaztk_github/Common_datascience_mistakes")


# Example: Avoiding overfitting and identifying it using cross-validation

# Load necessary libraries
library(ggplot2)
library(caret)

# Generate sample data
set.seed(123)
x <- seq(0, 2, by = 0.1)
y <- x^3 - 2*x^2 + 3*x + rnorm(length(x))
data <- data.frame(x, y)

# Fit a high-degree polynomial (overfitting)
model_overfit <- lm(y ~ poly(x, 10), data = data)

# Plot the overfitted model
plot(x, y)
curve(predict(model_overfit, newdata = data.frame(x = x)), add = TRUE, col = "red")

# Fit a simpler model (avoiding overfitting)
model_simple <- lm(y ~ x, data = data)

# Plot the simpler model
curve(predict(model_simple, newdata = data.frame(x = x)), add = TRUE, col = "blue")

# Perform cross-validation to identify overfitting
set.seed(456)
cv_overfit <- train(y ~ poly(x, 10), data = data, method = "lm", trControl = trainControl(method = "cv"))
cv_simple <- train(y ~ x, data = data, method = "lm", trControl = trainControl(method = "cv"))

# Print cross-validation results
print(cv_overfit)
print(cv_simple)
