# The Execution Paradigm: Locality, MapReduce and YARN

To understand Hadoop's speed, it is essential to know its execution strategy.

## Data Locality

Traditionally, computing fetches data over the network from a *Storage* server. Hadoop reverses the flow: **"Move the code to where the data is, not the data to where the code is."**
The application's small *scripts* travel to the *DataNodes* over the network and processing is done on local disks, greatly minimizing datacenter network bottlenecks.

## MapReduce

Hadoop's classic execution engine has very simple functions:
1. **Map:** The nodes read the blocked files and create `(Key, Value)` pairs. It works in absolute parallel.
2. **Shuffle & Sort:** The intermediate results travel over the network, being sorted and directed according to their respective key. *(Critical bottleneck)*
3. **Reduce:** Consolidates, counts, sums, or groups the values, delivering the reduced output of the massive process.

## YARN: The Cluster's Operating System

The *Yet Another Resource Negotiator* acts by orchestrating the chaos. Before YARN, the cluster was locked to run MapReduce exclusively. With the **ResourceManager** managing memory and CPU at a global level, and the **NodeManagers** reporting each machine's resource usage, YARN allows any framework (Spark, Flink) to process data that resides in HDFS.

---

## 🧪 Hands-On

Put the execution paradigm to work:

1. **See YARN in action** — Access http://localhost:8088. This is the ResourceManager. Here you can see applications being scheduled on the cluster.
2. **Data Locality in practice** — Run the notebook `notebooks/01_handle_hdfs.ipynb`. When you upload a file with `client.upload()`, the NameNode decides which DataNodes the blocks will land on. Future processing (Spark, MapReduce) will **send the code to those nodes**, not the other way around.
3. **MapReduce via terminal** — Upload a large file and ask Hadoop to count words (the classic WordCount):
   ```bash
   docker exec -it namenode hdfs dfs -put /opt/hadoop/etc/hadoop/*.xml /inputs
   docker exec -it namenode yarn jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar wordcount /inputs /outputs
   docker exec -it namenode hdfs dfs -cat /outputs/part-r-00000
   ```
4. **Track the job** — While MapReduce runs, go back to the ResourceManager at http://localhost:8088 and see the progress of the Map → Shuffle → Reduce stages.
