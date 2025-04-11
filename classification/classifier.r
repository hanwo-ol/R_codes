# install.packages(c("palmerpenguins", "rpart", "class", "caret")) 
library(palmerpenguins)
library(rpart)
library(class) # For k-NN
library(caret) # For confusionMatrix and createDataPartition

# --- 1. Data Preparation ---
data(penguins)
penguins_complete <- na.omit(penguins)

# Select features and the target variable
# Target: species
selected_data <- penguins_complete[, c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g", "year", "species")]

# Set seed for reproducibility
set.seed(123)

# Split data into training (70%) and testing (30%) sets
# Stratified split based on the target variable 'species'
train_index <- createDataPartition(selected_data$species, p = 0.7, list = FALSE)
training_data <- selected_data[train_index, ]
testing_data <- selected_data[-train_index, ]

# --- 2. Decision Tree Classifier (Using 4 Predictors) ---

# Define predictors for Decision Tree
dt_predictor_variables <- c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g")
target_variable <- "species"

decision_tree_model <- rpart(
  formula = paste(target_variable, "~", paste(dt_predictor_variables, collapse = " + ")),
  data = training_data,
  method = "class" # Specify classification tree
)

# Make predictions on the testing data
decision_tree_predictions <- predict(decision_tree_model, testing_data, type = "class")

# --- 3. Evaluate Decision Tree ---

# Calculate Confusion Matrix and Statistics using caret's confusionMatrix
dt_conf_matrix_details <- confusionMatrix(
  data = decision_tree_predictions,       # Predicted classes
  reference = testing_data[[target_variable]]
)

# Decision Tree Results
dt_conf_matrix_details
dt_conf_matrix_details$overall["Accuracy"]
dt_conf_matrix_details$byClass[, c("Precision", "Recall")]

# --- 4. k-Nearest Neighbors (k-NN) Classifier (Using 5 Predictors) ---
# Define predictors for k-NN
knn_predictor_variables <- c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g", "year")
training_data_knn <- training_data
testing_data_knn <- testing_data

# Scale numeric features for k-NN (important for distance-based algorithms)
training_data_knn[knn_predictor_variables] <- scale(training_data_knn[knn_predictor_variables])

# Apply the same scaling parameters (center and scale from training data) to testing data
testing_data_knn[knn_predictor_variables] <- scale(testing_data_knn[knn_predictor_variables],
                                                   center = attr(scale(training_data[knn_predictor_variables]), "scaled:center"),
                                                   scale = attr(scale(training_data[knn_predictor_variables]), "scaled:scale"))

# Perform k-NN classification
knn_predictions <- knn(
  train = training_data_knn[, knn_predictor_variables], # Training predictors (scaled)
  test = testing_data_knn[, knn_predictor_variables],   # Testing predictors (scaled)
  cl = training_data[[target_variable]],                # True class labels for training data
  k = 5
)

# --- 5. Evaluate k-NN ---

# Calculate Confusion Matrix and Statistics using caret's confusionMatrix
knn_conf_matrix_details <- confusionMatrix(
  data = knn_predictions,                     # Predicted classes
  reference = testing_data[[target_variable]] # Actual classes
)

# k-NN Results
knn_conf_matrix_details
knn_conf_matrix_details$overall["Accuracy"]
knn_conf_matrix_details$byClass[, c("Precision", "Recall")]