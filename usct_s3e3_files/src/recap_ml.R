# Read truthed training and testing data set from GitHub
truth_data = read.csv(
  "https://raw.githubusercontent.com/atet/ml_maneuver/main/dat/turns.csv")
str(truth_data) # Examine structure of the data
print("1. Data loaded.")

# Convert numeric labels to factor data class
truth_data$label = as.factor(truth_data$label)
# Split data to train and test sets
train = truth_data[truth_data$split == "train",]
test = truth_data[truth_data$split == "test",]
print("2. Data prepped.")

# Train a Random Forest algorithm with training data
if(!require("randomForest")){
  install.packages("randomForest") # Install Random Forest package
}
library(randomForest) # Load Random Forest package
rf_model = randomForest(
  label ~ .,
  data = train[,-c(2,3,14)]
)
print("3. Training complete.")

# Use trained Random Forest model on hold-out test set
prediction = predict(
  rf_model, 
  newdata = test[,-c(1,2,3,14)])
print("4. Testing complete.")

# Confusion matrix shows if model is mispredicting classes
confusion_matrix = table(unlist(test[,1]), prediction)
print("5. Evaluating performance:")
print(confusion_matrix)
