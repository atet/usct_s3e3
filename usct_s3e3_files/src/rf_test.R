#!/usr/bin/env Rscript

# Must install this package in Posit Studio IDE and/or CLI
cat("\n### 0. Loading packages...\n")
if (!require("randomForest")) install.packages("randomForest")
library(randomForest) # randomForest version 4.7-1.1

# Capture CLI arguments (i.e., Random Forest model and features from unknown data)
args = commandArgs(trailingOnly = TRUE)
cat("### 1. Loading trained Random Forest model from: ", args[1], "...\n", sep = "")
# Read trained Random Forest model file (local or from internet)
rf_model = readRDS(args[1])

# Read ten features from unknown data
unknown_data = data.frame(feature_1 = as.numeric(args[2]), feature_2 = as.numeric(args[3]), feature_3 = as.numeric(args[4]), feature_4 = as.numeric(args[5]), feature_5 = as.numeric(args[6]), feature_6 = as.numeric(args[7]), feature_7 = as.numeric(args[8]), feature_8 = as.numeric(args[9]), feature_9 = as.numeric(args[10]), feature_10 = as.numeric(args[11]), stringsAsFactors = FALSE)
cat("### 2. Loading ten features from unknown data: ", paste(unknown_data, collapse = ", "), "...\n", sep = "")

# Predict class from unknown data features
cat("### 3. Predicting class from unknown data features...\n", sep = "")
prediction = predict(rf_model, newdata = unknown_data)
prediction = as.character(prediction)
if(prediction == "0"){
  prediction = "Not Left"
}else{
  prediction = "Left"
}
cat("### 4. Predicted class: ", prediction,"...\n", sep = "")

# Creating visualization of unknown data and labeling with Random Forest model prediction
cat("### 5. Preparing visualization...\n", sep = "")
plot_data = data.frame(
  x = c(unknown_data[1,1], unknown_data[1,3], unknown_data[1,5], unknown_data[1,7], unknown_data[1,9]),
  y = c(unknown_data[1,2], unknown_data[1,4], unknown_data[1,6], unknown_data[1,8], unknown_data[1,10]),
  stringsAsFactors = FALSE)
timestamp = Sys.time()
title = paste(Sys.time(), "\nRandom Forest Prediction = ", prediction, sep = "")
filename = paste(gsub(" ","_",timestamp), "_prediction.png", sep = "")
cat("### 6. Saving visualization to: '", filename,"'...\n", sep = "")
png(filename, width = 256, height = 256, res = 48)
plot(plot_data$x, plot_data$y, type = "b", xlim = c(0,255), ylim = c(-5,145), xlab = "Feet", ylab = "Feet", main = title)
null = dev.off()

cat("### 7. Prediction of unknown data complete!\n\n")
