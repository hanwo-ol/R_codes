# Set seed for reproducibility
set.seed(123)

# --- Simulation Parameters ---

# Number of repetitions for the entire process
n_repetitions <- 50

# Number of data points in training and test sets
n_samples <- 100

# Parameters for the Normal distribution
true_mean <- 3
true_variance <- 9
true_sd <- sqrt(true_variance) # rnorm uses standard deviation

# --- Initialize Vectors to Store Results ---

# Vector to store the Mean Squared Sum (SS_average) for training data for each repetition
train_mse_results <- numeric(n_repetitions)

# Vector to store the Mean Squared Sum for test data for each repetition
test_mse_results <- numeric(n_repetitions)

# --- Start the Simulation Loop ---

for (i in 1:n_repetitions) {

  # 1. Generate Training Data
  # Generate n_samples from a Normal distribution with the specified mean and sd
  train_data <- rnorm(n_samples, mean = true_mean, sd = true_sd)

  # 2. Calculate the Sample Mean from Training Data
  train_sample_mean <- mean(train_data)

  # 3. Calculate MSE on Training Data
  # Calculate the squared differences between each training data point and the training sample mean
  train_squared_diff <- (train_data - train_sample_mean)^2
  # Calculate the average of these squared differences (Mean Squared Error for training)
  train_mse <- mean(train_squared_diff)
  # Store the result
  train_mse_results[i] <- train_mse

  # 4. Generate Test Data (Evaluation Data)
  # Generate n_samples from the *same* Normal distribution
  test_data <- rnorm(n_samples, mean = true_mean, sd = true_sd)

  # 5. Calculate MSE on Test Data using the Training Sample Mean
  # Calculate the squared differences between each test data point and the *training* sample mean
  test_squared_diff <- (test_data - train_sample_mean)^2
  # Calculate the average of these squared differences (Mean Squared Error for test)
  test_mse <- mean(test_squared_diff)
  # Store the result
  test_mse_results[i] <- test_mse

  # Optional: Print progress (can be removed if not needed)
  # cat("Repetition", i, "done.\n")

} # End of the simulation loop

# --- Visualize the Results ---

# Create a scatter plot comparing the MSE on training data vs. MSE on test data
plot(train_mse_results, test_mse_results,
     main = "Comparison of Training MSE and Test MSE (50 Repetitions)",
     xlab = "MSE on Training Data",
     ylab = "MSE on Test Data",
     pch = 19, # Use solid circles for points
     col = "blue")

# Add a diagonal line (y=x) for reference
# Points below this line mean test MSE was lower than train MSE for that repetition
# Points above this line mean test MSE was higher than train MSE for that repetition
abline(a = 0, b = 1, col = "red", lty = 2) # lty=2 makes the line dashed

# Add a legend
legend("topleft", legend = "y = x line", col = "red", lty = 2)

# Print the first few results (optional)
# print("First 6 Training MSEs:")
# print(head(train_mse_results))
# print("First 6 Test MSEs:")
# print(head(test_mse_results))
