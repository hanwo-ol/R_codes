# install.packages(c("palmerpenguins", "class", "caret")) # Run this line once if packages are not installed
library(palmerpenguins)
library(class) # For k-NN
library(caret) # For confusionMatrix and createDataPartition

# --- 1. Data Preparation ---
data(penguins)
penguins_complete <- na.omit(penguins)
selected_data <- penguins_complete[, c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g", "year", "sex", "species")]
set.seed(123)

# Split data into training (70%) and testing (30%) sets
train_index <- createDataPartition(selected_data$species, p = 0.7, list = FALSE)
training_data <- selected_data[train_index, ]
testing_data <- selected_data[-train_index, ]

# --- 2. Logistic Regression Classifier (Predicting Sex) ---
lg_predictor_variables <- c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g")
lg_target_variable <- "sex"

logistic_model <- glm(
  formula = paste(lg_target_variable, "~", paste(lg_predictor_variables, collapse = " + ")),
  data = training_data,
  family = binomial(link = "logit") # Specify logistic regression
)

logistic_probabilities <- predict(logistic_model, newdata = testing_data, type = "response")
classified_sex <- ifelse(logistic_probabilities > 0.5, "male", "female")
classified_sex <- factor(classified_sex, levels = levels(testing_data$sex))

# --- 3. Evaluate Logistic Regression ---
lg_conf_matrix_details <- confusionMatrix(
  data = classified_sex,                   # Classified classes
  reference = testing_data[[lg_target_variable]] # Actual classes
)
lg_conf_matrix_details$table
lg_conf_matrix_details$overall["Accuracy"]
lg_conf_matrix_details$byClass[c("Precision", "Recall", "Sensitivity", "Specificity", "Pos Pred Value", "Neg Pred Value")]

# --- 4. k-Nearest Neighbors (k-NN) Classifier (Predicting Species) ---
knn_predictor_variables <- c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g", "year")
knn_target_variable <- "species"
training_data_knn <- training_data
testing_data_knn <- testing_data
training_data_knn[knn_predictor_variables] <- scale(training_data_knn[knn_predictor_variables])
testing_data_knn[knn_predictor_variables] <- scale(testing_data_knn[knn_predictor_variables],
                                                   center = attr(scale(training_data[knn_predictor_variables]), "scaled:center"),
                                                   scale = attr(scale(training_data[knn_predictor_variables]), "scaled:scale"))

knn_classification <- knn(
  train = training_data_knn[, knn_predictor_variables], # Training predictors (scaled)
  test = testing_data_knn[, knn_predictor_variables],   # Testing predictors (scaled)
  cl = training_data[[knn_target_variable]],            # True class labels for training data
  k = 5
)

# --- 5. Evaluate k-NN ---
knn_conf_matrix_details <- confusionMatrix(
  data = knn_classification,                      # classified classes
  reference = testing_data[[knn_target_variable]] # Actual classes
)
knn_conf_matrix_details$table
knn_conf_matrix_details$overall["Accuracy"]
knn_conf_matrix_details$byClass[, c("Precision", "Recall")]
