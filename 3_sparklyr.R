
##############################
###### 1. DATA PREP ##########
##############################
library(sparklyr)
library(dplyr)
library(tidyr)
library(purrr)

### Note: you may need to set your SPARK_HOME environment variable for R to find spark
### Note: you will need to specify file location
sc <- spark_connect(master = "local")
data_tbl <- spark_read_csv(sc, name = "data", path = "file:///Users/joeblue/western/machineLearning/sample10k.csv", header = TRUE, infer_schema = TRUE, delimiter = ",")

## create partitions table references
partition <- data_tbl %>% 
  mutate(target = as.numeric(target)) %>%
  sdf_partition(train = 0.6, test = 0.4, seed = 542)
train_tbl <- partition$train
test_tbl <- partition$test

############################################
###### 2. TRAIN, INTERPRET MODELS ##########
############################################
## Logistic regression and random forest
ml_formula <- formula(target ~ f1 + f2 + f3 + f4 + f5 + f6 + f7 + f8 + f9 + f10 + f11 + f12)
ml_log <- ml_logistic_regression(train_tbl, ml_formula)
ml_rf <- ml_random_forest(train_tbl, ml_formula, num_trees = 100, max_depth =5)

## show coeffients of logistic regression
ml_log

### feature importance for random forest
feature_importance <- tibble()
feature_importance <- ml_tree_feature_importance(ml_rf) %>%
  mutate(Model = "Random Forest") %>%
  rbind(feature_importance, .)
feature_importance


##########################################
###### 3. EVALUATE MODELS (AUC) ##########
##########################################
# Create a function for scoring
score_test_data <- function(model, data = test_tbl) {
  pred <- sdf_predict(data, model)
  select(pred, target, prediction)
}

ml_models <- list( "Logistic" = ml_log, "Random Forest" = ml_rf)
ml_score <- map(ml_models, score_test_data)

# Function for calculating accuracy
calc_accuracy <- function(data, cutpoint = 0.5){
  data %>% 
    mutate(prediction = if_else(prediction > cutpoint, 1.0, 0.0)) %>%
    ml_classification_eval("prediction", "target", "accuracy")
}

# Calculate AUC and accuracy
perf_metrics <- tibble(
  model = names(ml_score),
  AUC = 100 * map_dbl(ml_score, ml_binary_classification_eval, "target", "prediction"),
  Accuracy = 100 * map_dbl(ml_score, calc_accuracy)
  )
perf_metrics
