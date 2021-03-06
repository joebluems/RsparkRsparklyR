
##############################
###### 1. DATA PREP ##########
##############################
library(dplyr)    

### read csv ###
### note: you will have to change the name of source file ###
### if on a MapR cluster, path is relative to /mapr/<your_cluster/
data <- read.df("./sample10k.csv", source = "csv", inferSchema = "true",header="true")
summary(data)
head(data)

### 60/40 split for train and test ###
seed <- 873
trainTest <-randomSplit(data,c(0.6,0.4), seed)
train = trainTest[[1]]
test = trainTest[[2]]

################################
### 2. LOGISTIC REG (logit)  ###
################################

### train logistic regression ###
logistic <- spark.logit(train, target ~ f1 + f2 + f3 + f4 + f5 + f6 + f7 + f8 + f9 + f10 +f11 + f12, family = "binomial")
### print coefficients ###
summary(logistic)

### evaluate AuROC ##
scorelr <- predict(logistic, test)
collectlr = SparkR::collect(scorelr)    
probslr = collectlr %>%
            rowwise() %>%
            mutate("probabilities" = list(SparkR:::callJMethod(probability,"toArray"))) %>%
            mutate("score" = probabilities[[2]])

##############################
#### 3. RANDOM FOREST ########
##############################

###  train the RF model 
rforest <- spark.randomForest(train, target ~ f1 + f2 + f3 + f4 + f5 + f6 + f7 + f8 + f9 + f10 +f11 + f12, "classification", maxDepth=5, numTrees = 100)

### print out the trees ###
summary(rforest)

### TODO: feature importance ###

### evaluate AuROC ##
scorerf <- predict(rforest, test)
collectrf = SparkR::collect(scorerf)
probsrf = collectrf %>%
            rowwise() %>%
            mutate("probabilities" = list(SparkR:::callJMethod(probability,"toArray"))) %>%
            mutate("score" = probabilities[[2]])

