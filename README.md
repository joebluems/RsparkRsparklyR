# Machine-learning options for R language on a MapR cluster
Generate some simulated data with a python script. Then, execute machine-learning code 
(read data, split into train/test, build model , interpret results and calculate metrics) 
using three different versions of R that highlight the capabilities of each when dealing with a distributed data platform: <br>
- **R** or **RStudio** <br>
- from the **SparkR** shell <br>
- **sparklyR** from R or RStudio <br>
<br>

### Step 1 - Get the code and create the data
```
log into your cluster or edge node
cd /mapr/<cluster>/user/<user>
git clone https://github.com/joebluems/RsparkRsparklyR
cd RsparkRsparklyR
python synth.py 10000 > sample10k.csv
python synth.py 100000 > sample100k.csv
```

### Step 2 - run from R or RStudio
```
in separate terminal, open 1_vanillaR.R in order to paste commands
launch R and verify you have libraries installed
library(ROCR)
library(randomForest)
Use install.packages('ROCR') etc. if you need to add
if you launched R from your user folder the "./" path should work
execute the blocks of code to run and examine output
<ctrl-d> to exit R
```

### Step 3 - run the SparkR shell
```
Find your spark home and launch the SparkR shell
Example: /opt/mapr/spark/spark-2.3.2/bin/sparkR
Verify you have the dpylr installed: library(dplyr)
Install dplyr if needed: install.packages('dplyr')
in separate terminal, open 2_sparkR.R in order to paste commands
execute the blocks of code to run and examine output
<ctrl-d> to exit sparkR shell
```

### Step 4 - run sparklyr from R or RStudio
```
in separate terminal, open 3_sparklyr.R in order to paste commands
<ctrl-d> to exit R
```
