# ------------topic 2--------------------#


# --- Simulation Parameters ---

# Number of simulations (repetitions of the entire process)
n_simulations <- 500

# Number of samples in training and evaluation sets
n_train <- 100
n_eval <- 100

# Number of predictor variables
n_vars_total <- 10
# Number of predictor variables with non-zero true coefficients
n_vars_true <- 2
# Number of noise variables (total - true)
n_vars_noise <- n_vars_total - n_vars_true

# True regression coefficients
# First n_vars_true coefficients are non-zero (e.g., 5 and -3), the rest are 0.
true_beta <- c(5, -3, rep(0, n_vars_noise))

# True intercept
true_intercept <- 2

# Standard deviation of the error term (noise in the Y value)
error_sd <- 3

# --- Initialization ---

# Create empty numeric vectors to store the RMSE results for each simulation.
# We need storage for training and evaluation RMSE for each of the 3 models.
rmse_train_all <- numeric(n_simulations) # Model with all predictors (Training RMSE)
rmse_eval_all <- numeric(n_simulations)  # Model with all predictors (Evaluation RMSE)

rmse_train_true <- numeric(n_simulations) # Model with only true predictors (Training RMSE)
rmse_eval_true <- numeric(n_simulations)  # Model with only true predictors (Evaluation RMSE)

rmse_train_plus1 <- numeric(n_simulations) # Model with true + 1 noise predictor (Training RMSE)
rmse_eval_plus1 <- numeric(n_simulations)  # Model with true + 1 noise predictor (Evaluation RMSE)

# Set seed for reproducibility
set.seed(1015)

# fisrt, How to simulate once? then, use simulation loop

# --- Simulation Once ---
# --- Step 1: Generate Training Data ---
# Generate predictor variables (X) from a standard normal distribution
X_train_matrix <- matrix(rnorm(n_train * n_vars_total), nrow = n_train, ncol = n_vars_total)
dim(X_train_matrix)

# Generate the error term (epsilon)
epsilon_train <- rnorm(n_train, mean = 0, sd = error_sd)
dim(epsilon_train)

# Calculate the response variable (Y) using the true model: Y = intercept + X * beta + epsilon
# '%*%' performs matrix multiplication
Y_train_vector <- true_intercept + X_train_matrix %*% true_beta + epsilon_train
dim(Y_train_vector)

# Combine predictors and response into a data frame (useful for lm function)
train_df <- data.frame(Y = Y_train_vector, X_train_matrix)

# Assign meaningful column names
colnames(train_df) <- c("Y", paste0("X", 1:n_vars_total))
head(train_df)


# --- Step 2: Generate Evaluation Data ---
# Generate independent evaluation data using the same process
X_eval_matrix <- matrix(rnorm(n_eval * n_vars_total), nrow = n_eval, ncol = n_vars_total)
epsilon_eval <- rnorm(n_eval, mean = 0, sd = error_sd)

Y_eval_vector <- true_intercept + X_eval_matrix %*% true_beta + epsilon_eval
eval_df <- data.frame(Y = Y_eval_vector, X_eval_matrix)

colnames(eval_df) <- c("Y", paste0("X", 1:n_vars_total))
head(eval_df)


# --- Step 3: Fit Regression Models (Estimation) ---
# Estimate model parameters using the training data

# Model 1: Using all predictor variables
# Formula 'Y ~ .' tells lm to use Y as response and all other columns as predictors
model_all <- lm(Y ~ ., data = train_df)
# model_all


# Model 2: Using only the true predictor variables (X1 and X2 in this case)
true_var_names <- c("X1", "X2") 
formula_true_str <- paste("Y ~", paste(true_var_names, collapse = " + ")) # Create "Y ~ X1 + X2"
formula_true <- as.formula(formula_true_str) # Convert string to formula object
model_true <- lm(formula_true, data = train_df)
# model_true

# Model 3: Using true predictors + 1 randomly chosen noise predictor
# Identify the indices of noise variables
noise_var_indices <- (n_vars_true + 1):n_vars_total
noise_var_indices

# Randomly sample one index from the noise variables
chosen_noise_index <- sample(noise_var_indices, 1)
chosen_noise_index

chosen_noise_var_name <- paste0("X", chosen_noise_index) # Get its name
chosen_noise_var_name

# Combine true variable names and the chosen noise variable name
vars_plus1 <- c(true_var_names, chosen_noise_var_name)

# print(paste(vars_plus1, collapse = " + "))
# formula_plus1_str <- paste("Y ~", paste(vars_plus1, collapse = " + ")) # Create formula string
formula_plus1 <- as.formula("Y ~ X1 + X2 + X5") 
model_plus1 <- lm(formula_plus1, data = train_df)

# --- Step 4: Calculate Fitted Values (Training) and Predictions (Evaluation) ---

# Calculate fitted values using the estimated model on the original training data
# These values show how well the model fits the data it was trained on.
# Alternatively, could use model_all$fitted.values, etc.
fitted_train_all <- predict(model_all, newdata = train_df)
fitted_train_true <- predict(model_true, newdata = train_df)
fitted_train_plus1 <- predict(model_plus1, newdata = train_df)

# Make predictions using the estimated model on the unseen evaluation data
# These values assess the model's ability to generalize to new data.
pred_eval_all <- predict(model_all, newdata = eval_df)
pred_eval_true <- predict(model_true, newdata = eval_df)
pred_eval_plus1 <- predict(model_plus1, newdata = eval_df)

# --- Step 5: Calculate Root Mean Squared Error (RMSE) ---
# RMSE = sqrt(mean((actual - calculated_value)^2))

# RMSE on training data (using fitted values) - Measures goodness of fit to the training data
rmse_train_all <- sqrt(mean((train_df$Y - fitted_train_all)^2))
rmse_train_true <- sqrt(mean((train_df$Y - fitted_train_true)^2))
rmse_train_plus1 <- sqrt(mean((train_df$Y - fitted_train_plus1)^2))

# RMSE on evaluation data (using predicted values) - Measures prediction accuracy on unseen data
rmse_eval_all <- sqrt(mean((eval_df$Y - pred_eval_all)^2))
rmse_eval_true <- sqrt(mean((eval_df$Y - pred_eval_true)^2))
rmse_eval_plus1 <- sqrt(mean((eval_df$Y - pred_eval_plus1)^2))

(rmse_train_all); (rmse_train_true); (rmse_train_plus1)

(rmse_eval_all); (rmse_eval_true); (rmse_eval_plus1)

# now, lets use Loop!
# --- Simulation Loop ---

# Loop 50 times
for (i in 1:n_simulations) {
  
  # --- Step 1: Generate Training Data ---
  # Generate predictor variables (X) from a standard normal distribution
  X_train_matrix <- matrix(rnorm(n_train * n_vars_total), nrow = n_train, ncol = n_vars_total)
  # Generate the error term (epsilon)
  epsilon_train <- rnorm(n_train, mean = 0, sd = error_sd)
  # Calculate the response variable (Y) using the true model: Y = intercept + X * beta + epsilon
  # '%*%' performs matrix multiplication
  Y_train_vector <- true_intercept + X_train_matrix %*% true_beta + epsilon_train
  # Combine predictors and response into a data frame (useful for lm function)
  train_df <- data.frame(Y = Y_train_vector, X_train_matrix)
  # Assign meaningful column names
  colnames(train_df) <- c("Y", paste0("X", 1:n_vars_total))
  
  # --- Step 2: Generate Evaluation Data ---
  # Generate independent evaluation data using the same process
  X_eval_matrix <- matrix(rnorm(n_eval * n_vars_total), nrow = n_eval, ncol = n_vars_total)
  epsilon_eval <- rnorm(n_eval, mean = 0, sd = error_sd)
  Y_eval_vector <- true_intercept + X_eval_matrix %*% true_beta + epsilon_eval
  eval_df <- data.frame(Y = Y_eval_vector, X_eval_matrix)
  colnames(eval_df) <- c("Y", paste0("X", 1:n_vars_total))
  
  # --- Step 3: Fit Regression Models (Estimation) ---
  # Estimate model parameters using the training data
  
  # Model 1: Using all predictor variables
  # Formula 'Y ~ .' tells lm to use Y as response and all other columns as predictors
  model_all <- lm(Y ~ ., data = train_df)
  
  # Model 2: Using only the true predictor variables (X1 and X2 in this case)
  true_var_names <- paste0("X", 1:n_vars_true) # Get names "X1", "X2"
  formula_true_str <- paste("Y ~", paste(true_var_names, collapse = " + ")) # Create "Y ~ X1 + X2"
  formula_true <- as.formula(formula_true_str) # Convert string to formula object
  model_true <- lm(formula_true, data = train_df)
  
  # Model 3: Using true predictors + 1 randomly chosen noise predictor
  # Identify the indices of noise variables
  noise_var_indices <- (n_vars_true + 1):n_vars_total
  # Randomly sample one index from the noise variables
  chosen_noise_index <- sample(noise_var_indices, 1)
  chosen_noise_var_name <- paste0("X", chosen_noise_index) # Get its name (e.g., "X5")
  # Combine true variable names and the chosen noise variable name
  vars_plus1 <- c(true_var_names, chosen_noise_var_name)
  formula_plus1_str <- paste("Y ~", paste(vars_plus1, collapse = " + ")) # Create formula string
  formula_plus1 <- as.formula(formula_plus1_str) # Convert to formula
  model_plus1 <- lm(formula_plus1, data = train_df)
  
  # --- Step 4: Calculate Fitted Values (Training) and Predictions (Evaluation) ---
  
  # Calculate fitted values using the estimated model on the original training data
  # These values show how well the model fits the data it was trained on.
  # Alternatively, could use model_all$fitted.values, etc.
  fitted_train_all <- predict(model_all, newdata = train_df)
  fitted_train_true <- predict(model_true, newdata = train_df)
  fitted_train_plus1 <- predict(model_plus1, newdata = train_df)
  
  # Make predictions using the estimated model on the unseen evaluation data
  # These values assess the model's ability to generalize to new data.
  pred_eval_all <- predict(model_all, newdata = eval_df)
  pred_eval_true <- predict(model_true, newdata = eval_df)
  pred_eval_plus1 <- predict(model_plus1, newdata = eval_df)
  
  # --- Step 5: Calculate Root Mean Squared Error (RMSE) ---
  # RMSE = sqrt(mean((actual - calculated_value)^2))
  
  # RMSE on training data (using fitted values) - Measures goodness of fit to the training data
  rmse_train_all[i] <- sqrt(mean((train_df$Y - fitted_train_all)^2))
  rmse_train_true[i] <- sqrt(mean((train_df$Y - fitted_train_true)^2))
  rmse_train_plus1[i] <- sqrt(mean((train_df$Y - fitted_train_plus1)^2))
  
  # RMSE on evaluation data (using predicted values) - Measures prediction accuracy on unseen data
  rmse_eval_all[i] <- sqrt(mean((eval_df$Y - pred_eval_all)^2))
  rmse_eval_true[i] <- sqrt(mean((eval_df$Y - pred_eval_true)^2))
  rmse_eval_plus1[i] <- sqrt(mean((eval_df$Y - pred_eval_plus1)^2))
  
  # Optional: Print progress
  print(paste("Simulation", i, "completed."))
  
} # End of the simulation loop

# --- Step 6: Create Scatter Plots ---
# Why dont you set `n_simulations` = 500?? (Simulation Parameters)
# Set up plotting area to display 3 plots side-by-side (1 row, 3 columns)
par(mfrow = c(1, 3), mar = c(4, 4, 3, 1), oma = c(0, 0, 2, 0)) # Adjust margins

# Determine common axis limits for better comparison across plots
# Calculate the overall range across all RMSE values
all_rmse_values <- c(rmse_train_all, rmse_eval_all,
                     rmse_train_true, rmse_eval_true,
                     rmse_train_plus1, rmse_eval_plus1)
plot_lim <- range(all_rmse_values, na.rm = TRUE) # Use na.rm just in case

# Plot 1: All Predictors
plot(x = rmse_train_all, y = rmse_eval_all,
     main = "Model: All Predictors",
     xlab = "Training RMSE (Fit)",       
     ylab = "Evaluation RMSE (Predict)",  
     pch = 19, col = "dodgerblue",
     xlim = plot_lim, # Use common limits
     ylim = plot_lim)
abline(a = 0, b = 1, col = "red", lty = 2) # y=x line

# Plot 2: True Predictors Only
plot(x = rmse_train_true, y = rmse_eval_true,
     main = "Model: True Predictors",
     xlab = "Training RMSE (Fit)",
     ylab = "Evaluation RMSE (Predict)",
     pch = 19, col = "forestgreen",
     xlim = plot_lim,
     ylim = plot_lim)
abline(a = 0, b = 1, col = "red", lty = 2)

# Plot 3: True + 1 Noise Predictor
plot(x = rmse_train_plus1, y = rmse_eval_plus1,
     main = "Model: True + 1 Noise",
     xlab = "Training RMSE (Fit)",
     ylab = "Evaluation RMSE (Predict)",
     pch = 19, col = "darkorange",
     xlim = plot_lim,
     ylim = plot_lim)
abline(a = 0, b = 1, col = "red", lty = 2)

# Add an overall title to the figure
mtext("Training RMSE (Goodness of Fit) vs. Evaluation RMSE (Prediction Accuracy)", outer = TRUE, cex = 1.2) # More descriptive title

# Reset plotting parameters to default (1 plot per device)
par(mfrow = c(1, 1), mar = c(5.1, 4.1, 4.1, 2.1), oma = c(0, 0, 0, 0))

# --- Optional: Display Results Summary ---
# Combine results into a data frame
results_summary <- data.frame(
  Simulation = 1:n_simulations,
  RMSE_Train_All = rmse_train_all,
  RMSE_Eval_All = rmse_eval_all,
  RMSE_Train_True = rmse_train_true,
  RMSE_Eval_True = rmse_eval_true,
  RMSE_Train_Plus1 = rmse_train_plus1,
  RMSE_Eval_Plus1 = rmse_eval_plus1
)


# Print summary statistics for the RMSE values
print("Summary statistics for RMSE:")
summary(results_summary[, -1]) # Exclude the Simulation column
