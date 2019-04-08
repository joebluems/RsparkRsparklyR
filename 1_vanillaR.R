
##############################
###### 1. DATA PREP ##########
##############################
library(randomForest)
library(ROCR)

### read CSV - you may need to change your file name & location ###
data <- read.csv(file="./sample10k.csv", header=TRUE, sep=",")
summary(data)
sapply(data, sd)

### 60/40 split for train and test ###
set.seed(873)
smp_size <- floor(0.60 * nrow(data))
train_ind <- sample(seq_len(nrow(data)), size = smp_size)
train <- data[train_ind, ]
test <- data[-train_ind, ]

##############################
### 2. LOGISTIC REG (glm)  ###
##############################

### train logistic regression & interpret ###
logit <- glm(target ~ f1 + f2 + f3 + f4 + f5 + f6 + f7 + f8 + f9 + f10 + f11 + f12, 
   data = train, family = "binomial")
summary(logit)
exp(coef(logit))

### evaluate AuROC ##
test$lrscore <- predict(logit, test , type = "response")
pr1 <- prediction(test$lrscore,test$target)
auc1 <- performance(pr1, measure = "auc")
auc1@y.values[[1]]


##############################
#### 3. RANDOM FOREST ########
##############################

###  train the RF model (100 trees, max depth=5) & get feature importance
rforest = randomForest(target ~ ., data=subset(train,select=-c(id)), ntree=100, mtry=5, importance=TRUE)
rforest
importance(rforest)

### evaluate AuROC ##
test$rfscore <- predict(rforest, test , type = "response")
pr2 <- prediction(test$rfscore,test$target)
auc2 <- performance(pr2, measure = "auc")
auc2@y.values[[1]]
