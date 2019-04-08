# Machine-learning options for R language on a MapR cluster
Generate some simulated data with a python script (a 10k file and a 100k file - you could try 1M and 10M too). This data is simulated and will not identify any insights - the intent here is to share code and the workflow irrespective of the actual data, eventually being replaced with your own (real) data.
Then, execute machine-learning code (read data, split into train/test, build model , 
interpret results and calculate metrics) using three different versions of R that highlight 
the capabilities of each when dealing with a distributed data platform: <br>
- **R** or **RStudio** <br>
- from the **SparkR** shell <br>
- **sparklyR** from R or RStudio <br>
<br>
For the purposes of illustrating the options of R, we are training a linear model (Logistic Regression) whose coefficients will tell help us interpret the scores and provide reason codes, and a tree-based model (Random Forest). The feature importance from RF will help us understand the which features are influential in being selected for trees for further interpretation.  

## R vs SparkR vs sparklyr on MapR
With a distributed file systems comes unlimited storage and compute capability (if enough nodes are added). But there is no free lunch. Regular R code will run on MapR but use local resources (of whatever machine you've launched R). You need to enhance your R with other libraries to use the cluster and that will limit your access to core R functions. It is important to know which tool to use in which scenario and also understand what resources you will be leveraging. <br>
### R
Use R when... <br>
### SparkR
Use SparkR when ... <br>
### sparklyr
Use sparklyr when ... <br>

## R installation Notes
It's  unlikely that you will have all the necessary R packages to run all of this code. <br>
Unless you're the MapR cluster admin, you won't have access to add libraries for all users 
but you should be able to install it for yourself. You will be able to run code as your user but others will have to install it for themselves. <br>
The general syntax for installing libraries in R -> install.packages('package'). <br>


## Step 1 - Get the code and create the data
```
log into your cluster or edge node
cd /mapr/<cluster>/user/<user>
git clone https://github.com/joebluems/RsparkRsparklyR
cd RsparkRsparklyR
python synth.py 10000 > sample10k.csv
python synth.py 100000 > sample100k.csv
```

## Step 2 - run from R or RStudio
```
In separate terminal, open 1_vanillaR.R in order to paste commands
launch R and verify you have libraries installed
library(ROCR)
library(randomForest)
Use install.packages('ROCR') etc. if you need to add
Execute the blocks of code to run and examine output
If you launched R from your user folder the "./" path should work
Try with the 10,000 record csv file. Regular might choke on the 100k file when it comes to random forest.
<ctrl-d> to exit R
```

## Step 3 - run the SparkR shell
```
Find your spark home and launch the SparkR shell
MapR cluster example: /opt/mapr/spark/spark-2.3.2/bin/sparkR
Verify you have the dpylr installed: library(dplyr)
Install dplyr if needed: install.packages('dplyr')
In separate terminal, open 2_sparkR.R in order to paste commands
Execute the blocks of code to run and examine output
The path in SparkR is relative to the MapR file system (e.g. /mapr/<cluster>) so you may need to edit file location
Try these commands with the 10,000 and 100,000 csv files. Spark should have no trouble with the larger files.
<ctrl-d> to exit sparkR shell
```

### Step 4 - run sparklyr from R or RStudio
```
Some extra setup is needed to run sparklyr:
First, verify your $SPARK_HOME variable is set (echo $SPARK_HOME)
If SPARK_HOME not set: export SPARK_HOME=/opt/mapr/spark/spark-2.3.2
Second, set your LD_LIBRARY_PATH: export LD_LIBRARY_PATH=/usr/lib/oracle/18.3/client64/lib::/opt/mapr/lib:/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.201.b09-2.el7_6.x86_64/jre/lib/amd64/server/:/home/mapr/anaconda3/lib
Once you have those env variables setup, you should be ready to run commands. Note: you can put these commands into a startup script so that you don't need to do it every time.
In separate terminal, open 3_sparklyr.R in order to paste commands
Launch R and check for sparklyr, dplyr, tidyr, purrr libraries
Install libraries as needed
The path needs to be fully qualifed for the file (i.e. file:///mapr/<cluster>/user/<user>/RsparkRsparklyR/)
Try these commands with the 10,000 and 100,000 csv files. sparklyr should have no trouble with the larger files.
Try to execute in yarn mode with sc <- spark_connect(master = "yarn")
<ctrl-d> to exit R
```
