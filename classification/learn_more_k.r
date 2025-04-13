# Load necessary packages
# install.packages(c("palmerpenguins", "caret", "e1071")) # e1071 is often needed by caret for certain models/functions
library(palmerpenguins)
library(caret)
library(class) 

# --- 1. Data Preparation (Similar to before) ---
data(penguins)

# Remove rows with missing values
penguins_complete <- na.omit(penguins)

# Select relevant numeric predictors and the target variable 'species'
# Using only numeric predictors simplifies scaling for k-NN
predictor_variables <- c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g")
target_variable <- "species"
selected_data <- penguins_complete[, c(predictor_variables, target_variable)]

# Ensure the target variable is a factor
selected_data$species <- as.factor(selected_data$species)

# Set seed for reproducibility
set.seed(456) 

# Split data into training (70%) and testing (30%) sets
train_index <- createDataPartition(selected_data$species, p = 0.7, list = FALSE)
training_data <- selected_data[train_index, ]
testing_data <- selected_data[-train_index, ]

# --- 2. Finding the Optimal 'k' using Cross-Validation ---

# The 'caret' package provides excellent tools for this.

# Define the control parameters for cross-validation
# method = "cv" specifies k-fold cross-validation
# number = 10 means 10-fold cross-validation
train_control <- trainControl(
  method = "cv",
  number = 10 # Number of folds
)

# Define the grid of 'k' values to try
k_grid <- expand.grid(k = seq(from = 1, to = 25, by = 2))

# Train the k-NN model using caret's 'train' function
knn_tuned_model <- train(
  species ~ .,                # Formula: predict species using all other variables
  data = training_data,       # Use the training data
  method = "knn",             # Specify the k-NN algorithm
  trControl = train_control,  # Use the cross-validation settings defined above
  preProcess = c("center", "scale"), # Automatically center and scale predictors *within CV*
  tuneGrid = k_grid           # Specify the 'k' values to test
)

# --- 3. Analyzing the Results ---

# Print the results of the cross-validation
knn_tuned_model

# Get the best value of 'k' found during cross-validation
best_k <- knn_tuned_model$bestTune$k
best_k
# Plot the results (Accuracy vs. k)
plot(knn_tuned_model)

# --- 4. Evaluating the Final Model with the Best 'k' on the Test Set ---
test_predictions <- predict(knn_tuned_model, newdata = testing_data)

# Calculate the confusion matrix and statistics on the test set
final_conf_matrix <- confusionMatrix(
  data = test_predictions,
  reference = testing_data$species
)
final_conf_matrix$table
final_conf_matrix$overall["Accuracy"]

