# ------------topic 1--------------------#

# --- Simulation Parameters ---

# Number of simulations (repetitions of the entire process)
n_simulations <- 50

# Number of data points in training and evaluation sets
n_samples <- 100

# Parameters for the normal distribution
population_mean <- 3
population_variance <- 9
# Standard deviation is the square root of the variance
population_sd <- sqrt(population_variance)

# --- Initialization ---

# Create empty numeric vectors to store the results from each simulation.
# We know the size beforehand (n_simulations), so we pre-allocate memory.
train_sse_results <- numeric(n_simulations)
eval_sse_results <- numeric(n_simulations)

# Set a seed for the random number generator for reproducibility.
# Anyone running this code will get the same "random" numbers.
set.seed(1015)

# --- Simulation Loop ---

# Loop 50 times (from 1 to n_simulations)
for (i in 1:n_simulations) {
  
  # --- Step 1: Generate Training Data ---
  # Draw n_samples random numbers from a normal distribution
  # with the specified mean and standard deviation.
  train_data <- rnorm(n = n_samples, mean = population_mean, sd = population_sd)
  
  # --- Step 2: Calculate Training Sample Mean ---
  # Calculate the arithmetic mean of the generated training data.
  train_sample_mean <- mean(train_data)
  
  # --- Step 3: Generate Evaluation Data ---
  # Draw another n_samples random numbers from the *same* normal distribution.
  # This data is independent of the training data.
  eval_data <- rnorm(n = n_samples, mean = population_mean, sd = population_sd)
  
  # --- Step 4: Calculate Sum of Squared Errors (SSE) on Training Data ---
  # Calculate the squared difference between each training data point and the train_sample_mean.
  # Then, sum up these squared differences. SSE = Sum[(X_train - train_sample_mean)^2]
  sse_train <- sum((train_data - train_sample_mean)^2)
  
  # --- Step 5: Calculate Sum of Squared Errors (SSE) on Evaluation Data ---
  # Calculate the squared difference between each evaluation data point and the *training* sample mean.
  # Note: We use the mean calculated from the *training* data to evaluate the *evaluation* data.
  # Then, sum up these squared differences. SSE = Sum[(X_eval - train_sample_mean)^2]
  sse_eval <- sum((eval_data - train_sample_mean)^2)
  
  # --- Step 6: Store Results ---
  # Store the calculated SSE values for this iteration (i) in our results vectors.
  train_sse_results[i] <- sse_train
  eval_sse_results[i] <- sse_eval
  
  # Optional: Print progress (uncomment if desired)
  print(paste("Simulation", i, "completed."))
  
} # End of the simulation loop

# --- Step 7: Create Scatter Plot ---

# Create a scatter plot using the stored results.
# x-axis: SSE calculated on the training data for each simulation.
# y-axis: SSE calculated on the evaluation data for each simulation.
plot(x = train_sse_results,
     y = eval_sse_results,
     main = "Training SSE vs. Evaluation SSE (50 Simulations)", # Title of the plot
     xlab = "Sum of Squared Errors (Training Data)",          # Label for the x-axis
     ylab = "Sum of Squared Errors (Evaluation Data)",         # Label for the y-axis
     pch = 19,                                               # Use solid circles for points
     col = "blue")                                           # Set the color of the points

# Add a diagonal line (y=x) for reference.
# Points above this line mean evaluation SSE was higher than training SSE for that simulation.
# Points below mean training SSE was higher.
abline(a = 0, b = 1, col = "red", lty = 2) # a=intercept, b=slope, lty=line type (dashed)

# Add a legend (optional)
legend("topleft", legend=c("Simulation Result", "y = x line"),
       col=c("blue", "red"), pch=c(19, NA), lty=c(NA, 2))

# --- Optional: Display Results Summary ---
# Create a data frame to view the results together
results_df <- data.frame(
  Simulation = 1:n_simulations,
  Training_SSE = train_sse_results,
  Evaluation_SSE = eval_sse_results
)

# Print the first few rows of the results data frame
print("First 6 simulation results:")
print(head(results_df))

# Print summary statistics of the SSE results
print("Summary statistics for SSE:")
summary(results_df[, -1]) # Exclude the 'Simulation' column from summary
