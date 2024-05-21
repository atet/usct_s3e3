#!/usr/bin/env Rscript

# INSTRUCTIONS
# To train the Random Forest model in CLI, run the following on Posit Cloud in the same directory:
#
#    $ Rscript rf_train.R "https://raw.githubusercontent.com/atet/ml_maneuver/main/dat/turns.csv"
#
# This script will output a trained Random Forest model in the same directory, "./rf_model.rds"

# Must install this package in Posit Studio IDE and/or CLI
cat("\n### 0. Loading packages...\n")
if(!require("randomForest")) install.packages("randomForest")
library(randomForest) # randomForest version 4.7-1.1

# Capture CLI arguments (i.e., path to truthed data)
args = commandArgs(trailingOnly = TRUE)
cat("### 1. Reading truthed data from: \"", args[1], "\"...\n", sep = "")
# Read truthed data *.csv file (local or from internet)
truth_data = read.csv(args[1])

# Cast truthed data labels to factor (required for randomForest package)
cat("### 2. Preparing training and hold out testing data...\n")
truth_data$label = as.factor(truth_data$label)
# Split truthed data to training and hold out testing set
train = truth_data[truth_data$split == "train",]
test = truth_data[truth_data$split == "test",]

# Train Random Forest algorithm on training data to create trained model
cat("### 3. Training Random Forest algorithm...\n")
rf_model = randomForest(label ~ ., data = train[,-c(2,3,14)])

# Test the trained model on test data to determine performance
cat("### 4. Testing trained model for performance...\n")
prediction = predict(rf_model, newdata = test[,-c(1,2,3,14)])

# Calculate trained model performance
cat("### 5. Model performance calculations...\n")
# Create confusion matrix
confusion_matrix = table(unlist(test[,1]), prediction)
#print(confusion_matrix)
# Print performance
sens = (confusion_matrix[2,2] / (confusion_matrix[2,2] + confusion_matrix[1,2])) * 100
cat("###### Senstivity  (a.k.a., True Positive Rate) = ", sens, "%\n", sep = "")
spec = (confusion_matrix[1,1] / (confusion_matrix[1,1] + confusion_matrix[2,1])) * 100
cat("###### Specificity (a.k.a., True Negative Rate) = ", spec, "%\n", sep = "")

# Saving trained Random Forest model to disk
cat("### 6. Saving trained Random Forest Model as \"./rf_model.rds\"...\n")
saveRDS(rf_model, "./rf_model.rds")

cat("### 7. Random Forest Model creation complete!\n\n")
