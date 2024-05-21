#!/usr/bin/env Rscript

# INSTRUCTIONS
# To use the trained Random Forest model on unknown data in CLI, run the following on Posit Cloud in the same directory:
#
#    # This data represents a "NOT LEFT" class
#    $ Rscript rf_test.R ./rf_model.rds 0 -0.01762569 54.85037 -0.0626019 109.7007 -1.306231 164.5511 1.019284 219.4015 -0.184418
#
#    # This data represents a "LEFT" class
#    $ Rscript rf_test.R ./rf_model.rds 5.530219 0.5318008 40.17718 3.525679 71.90004 18.09912 90.27125 47.64923 97.61228 83.74682
#
#    # NOTE: You can also load the same rf_model.rds from the internet
#    $ Rscript rf_test.R "https://github.com/atet/usct_s3e3/raw/main/usct_s3e3_files/dat/rf_model.rds" 5.530219 0.5318008 40.17718 3.525679 71.90004 18.09912 90.27125 47.64923 97.61228 83.74682
#
# This script will output a visualization in the same directory, "./<TIMESTAMP>_prediction.png"

# Must install this package in Posit Studio IDE and/or CLI
cat("\n### 0. Loading packages...\n")
if(!require("randomForest")) install.packages("randomForest")
library(randomForest) # randomForest version 4.7-1.1

# Capture CLI arguments (i.e., Random Forest model and features from unknown data)
args = commandArgs(trailingOnly = TRUE)
cat("### 1. Loading trained Random Forest model from: \"", args[1], "\"...\n", sep = "")
# Read trained Random Forest model file (local or from internet)
filepath = args[1]
if(grepl("http",filepath)){
  rf_model = readRDS(gzcon(url(filepath)))
}else{
  rf_model = readRDS(filepath)  
}

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
cat("### 6. Saving visualization to: \"", filename,"\"...\n", sep = "")
png(filename, width = 256, height = 256, res = 48)
plot(plot_data$x, plot_data$y, type = "b", xlim = c(0,255), ylim = c(-5,145), xlab = "Feet", ylab = "Feet", main = title)
null = dev.off()

cat("### 7. Prediction of unknown data complete!\n\n")
