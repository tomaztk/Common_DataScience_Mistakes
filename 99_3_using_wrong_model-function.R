cat("\014")
rm(list = ls())
setwd("/Users/tomazkastrun/Documents/Tomaztk_github/Common_datascience_mistakes")


# Example: Using the wrong model and finding the right one

# Load necessary libraries
library(ggplot2)
library(caret)

# Generate sample data with a non-linear relationship
set.seed(123)
x <- seq(0, 2*pi, length.out = 100)
y <- sin(x) + rnorm(length(x), sd = 0.1)
data <- data.frame(x, y)

# Fit a linear model (wrong model for non-linear data)
model_linear <- lm(y ~ x, data = data)

# Plot the linear model
ggplot(data, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Linear Model (Wrong Choice)")

# Fit a non-linear model (correct model for non-linear data)
model_nonlinear <- loess(y ~ x, data = data)

# Plot the non-linear model
ggplot(data, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "loess", se = FALSE, color = "blue") +
  labs(title = "Non-linear Model (Correct Choice)")

# Perform cross-validation to compare model performance
set.seed(456)
cv_linear <- train(y ~ x, data = data, method = "lm", trControl = trainControl(method = "cv"))
cv_nonlinear <- train(y ~ x, data = data, method = "rf", trControl = trainControl(method = "cv"))

# Print cross-validation results
print(cv_linear)
print(cv_nonlinear)
