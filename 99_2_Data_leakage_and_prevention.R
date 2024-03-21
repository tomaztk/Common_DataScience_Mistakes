cat("\014")
rm(list = ls())
setwd("/Users/tomazkastrun/Documents/Tomaztk_github/Common_datascience_mistakes")


# Example: Data leakage and prevention

# Simulate data for a time-series prediction problem
set.seed(123)
date <- seq(as.Date("2020-01-01"), by = "month", length.out = 24)
target <- sin(2*pi*seq(1, 24, by = 1)/12) + rnorm(24, sd = 0.2)

# Create a dataframe with the target variable and a predictor (which we'll pretend is a future variable that should not be known)
data <- data.frame(date, target, future_variable = rnorm(24))

# Split the data into training and testing sets
train_index <- sample(1:20, 15) # 15 months for training
test_index <- setdiff(1:20, train_index) # Remaining months for testing

train_data <- data[train_index, ]
test_data <- data[test_index, ]

# Fit a model using future_variable (data leakage)
model_leak <- lm(target ~ future_variable, data = train_data)

# Predict on the testing set
test_data$predicted_leak <- predict(model_leak, newdata = test_data)

# Calculate the performance metrics
rmse_leak <- sqrt(mean((test_data$target - test_data$predicted_leak)^2))
cat("RMSE with data leakage:", rmse_leak, "\n")

# Fit a model without using future_variable (preventing data leakage)
model_no_leak <- lm(target ~ date, data = train_data)

# Predict on the testing set
test_data$predicted_no_leak <- predict(model_no_leak, newdata = test_data)

# Calculate the performance metrics
rmse_no_leak <- sqrt(mean((test_data$target - test_data$predicted_no_leak)^2))
cat("RMSE without data leakage:", rmse_no_leak, "\n")
