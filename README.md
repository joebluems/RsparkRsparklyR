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

### Step 3 - run the SparkR shell

### Step 4 - run sparklyr from R or RStudio
