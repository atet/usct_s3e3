library(plumber)
if(!require("randomForest")) install.packages("randomForest")
library(randomForest) # randomForest version 4.7-1.1

# Example of NOT_LEFT: "0,-0.01762569,54.85037,-0.0626019,109.7007,-1.306231,164.5511,1.019284,219.4015,-0.184418"
# Example of LEFT:     "5.530219,0.5318008,40.17718,3.525679,71.90004,18.09912,90.27125,47.64923,97.61228,83.74682"

# Using model from earlier training hosted on GitHub
rf_model = readRDS(gzcon(url("https://github.com/atet/usct_s3e3/raw/main/usct_s3e3_files/dat/rf_model.rds")))

#* @apiTitle Random Forest Inference API
#* @apiDescription Your trained random forest model as a service!

#* Returns classification of sample (ten features, comma separated)
#* @param csv
#* @post /rf_test
function(csv){
  unknown_data = as.numeric(strsplit(csv, ",")[[1]])
  unknown_data = data.frame(
    feature_1 = unknown_data[1],
    feature_2 = unknown_data[2],
    feature_3 = unknown_data[3],
    feature_4 = unknown_data[4],
    feature_5 = unknown_data[5],
    feature_6 = unknown_data[6],
    feature_7 = unknown_data[7],
    feature_8 = unknown_data[8],
    feature_9 = unknown_data[9],
    feature_10 = unknown_data[10],
    stringsAsFactors = FALSE)
  prediction = predict(rf_model, newdata = unknown_data)
  prediction = as.character(prediction)
  if(prediction == "0"){
    prediction = "Not_Left"
  }else{
    prediction = "Left"
  }
  return(prediction)
}
