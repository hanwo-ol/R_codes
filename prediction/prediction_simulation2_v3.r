# Number of simulations, samples
n_simulations <- 500
n_train <- 100
n_eval <- 100

# Number of predictor variables
n_vars_total <- 10
# Number of predictor variables with non-zero true coefficients
n_vars_true <- 2
# Number of noise variables (total - true)
n_vars_noise <- n_vars_total - n_vars_true

# True regression coefficients
true_beta <- c(5, -3, rep(0, n_vars_noise))

# True intercept
true_intercept <- 2

# Standard deviation of the error term (noise in the Y value)
error_sd <- 3

# --- Initialization ---
rmse_train_all <- numeric(n_simulations) 
rmse_eval_all <- numeric(n_simulations) 

rmse_train_true <- numeric(n_simulations) 
rmse_eval_true <- numeric(n_simulations)  

rmse_train_plus1 <- numeric(n_simulations) 
rmse_eval_plus1 <- numeric(n_simulations) 

# Set seed for reproducibility
set.seed(1015)

# --- Simulation Loop ---

# Loop 50 times
for (i in 1:n_simulations) {
  
  # Generate predictor variables (X) from a standard normal distribution
  X_train_matrix <- matrix(rnorm(n_train * n_vars_total), nrow = n_train, ncol = n_vars_total)
  # Generate the error term (epsilon)
  epsilon_train <- rnorm(n_train, mean = 0, sd = error_sd)
  # Calculate the response variable (Y) using the true model: Y = intercept + X * beta + epsilon
  Y_train_vector <- true_intercept + X_train_matrix %*% true_beta + epsilon_train
  # Combine predictors and response into a data frame (useful for lm function)
  train_df <- data.frame(Y = Y_train_vector, X_train_matrix)
  # Assign meaningful column names
  colnames(train_df) <- c("Y", paste0("X", 1:n_vars_total))
  
  # Generate independent evaluation data using the same process
  X_eval_matrix <- matrix(rnorm(n_eval * n_vars_total), nrow = n_eval, ncol = n_vars_total)
  epsilon_eval <- rnorm(n_eval, mean = 0, sd = error_sd)
  Y_eval_vector <- true_intercept + X_eval_matrix %*% true_beta + epsilon_eval
  eval_df <- data.frame(Y = Y_eval_vector, X_eval_matrix)
  colnames(eval_df) <- c("Y", paste0("X", 1:n_vars_total))
  
  # Model 1: Using all predictor variables
  model_all <- lm(Y ~ ., data = train_df)
  
  # Model 2: Using only the true predictor variables (X1 and X2 in this case)
  true_var_names <- paste0("X", 1:n_vars_true)
  formula_true_str <- paste("Y ~", paste(true_var_names, collapse = " + ")) 
  formula_true <- as.formula(formula_true_str)
  model_true <- lm(formula_true, data = train_df)
  
  # Model 3: Using true predictors + 1 randomly chosen noise predictor
  noise_var_indices <- (n_vars_true + 1):n_vars_total
  chosen_noise_index <- sample(noise_var_indices, 1)
  chosen_noise_var_name <- paste0("X", chosen_noise_index)
  vars_plus1 <- c(true_var_names, chosen_noise_var_name)
  formula_plus1_str <- paste("Y ~", paste(vars_plus1, collapse = " + ")) # Create formula string
  formula_plus1 <- as.formula(formula_plus1_str) # Convert to formula
  model_plus1 <- lm(formula_plus1, data = train_df)
  
  
  # Calculate fitted values using the estimated model on the original training data
  fitted_train_all <- predict(model_all, newdata = train_df)
  fitted_train_true <- predict(model_true, newdata = train_df)
  fitted_train_plus1 <- predict(model_plus1, newdata = train_df)
  
  # Make predictions using the estimated model on the unseen evaluation data
  pred_eval_all <- predict(model_all, newdata = eval_df)
  pred_eval_true <- predict(model_true, newdata = eval_df)
  pred_eval_plus1 <- predict(model_plus1, newdata = eval_df)
  
  # RMSE on training data (using fitted values) - Measures goodness of fit to the training data
  rmse_train_all[i] <- sqrt(mean((train_df$Y - fitted_train_all)^2))
  rmse_train_true[i] <- sqrt(mean((train_df$Y - fitted_train_true)^2))
  rmse_train_plus1[i] <- sqrt(mean((train_df$Y - fitted_train_plus1)^2))
  
  # RMSE on evaluation data (using predicted values) - Measures prediction accuracy on unseen data
  rmse_eval_all[i] <- sqrt(mean((eval_df$Y - pred_eval_all)^2))
  rmse_eval_true[i] <- sqrt(mean((eval_df$Y - pred_eval_true)^2))
  rmse_eval_plus1[i] <- sqrt(mean((eval_df$Y - pred_eval_plus1)^2))

} # End of the simulation loop

# --- Step 6: Create Scatter Plots ---
par(mfrow = c(1, 3), mar = c(4, 4, 3, 1), oma = c(0, 0, 2, 0)) # Adjust margins

# Determine common axis limits for better comparison across plots
all_rmse_values <- c(rmse_train_all, rmse_eval_all,
                     rmse_train_true, rmse_eval_true,
                     rmse_train_plus1, rmse_eval_plus1)
plot_lim <- range(all_rmse_values, na.rm = TRUE)

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
