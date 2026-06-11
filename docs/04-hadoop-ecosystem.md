# The Hadoop Ecosystem

The foundation provided by HDFS (storage), YARN (orchestration), and MapReduce (processing) was robust, but very limited for modern requirements of speed and usability in Big Data. The community then built a series of fantastic interconnected projects.

## Apache Spark: The in-memory revolution

MapReduce wrote intermediate processing stages directly to disks. For continuous processes or machine learning, the I/O impact on disk in MapReduce made fast executions unfeasible. **Apache Spark** adopted in-memory (RAM) processing, using abstractions that sped up **10 to 100 times** the performance compared to MapReduce. It runs perfectly on top of YARN.

## Apache Hive: SQL for Engineers and Analysts

Writing robust algorithms in Java via MapReduce required highly technical engineering teams. **Hive** emerged to translate instructions from the popular SQL language directly into parallel processing *jobs* on HDFS, democratizing data for Business Analysts and Data Scientists.

## Other Pieces of the Puzzle

*   **HBase:** The columnar NoSQL equivalent hosted on top of HDFS for when you need to read a single record extremely fast, without reading huge blocks.
*   **Kafka, Sqoop, and Flume:** Technologies responsible for extracting data at the source (relational databases, *logs*, or social networks) and transferring it in real-time or in large *batches* into the HDFS cluster.

---

## 🧪 Hands-On

Go beyond MapReduce and explore the ecosystem:

1. **HDFS via WebHDFS API** — The `hdfs` library you use in the notebooks makes HTTP requests to WebHDFS. You can do the same with `curl`:
   ```bash
   # List HDFS root via WebHDFS API
   curl -i "http://localhost:9870/webhdfs/v1/?op=LISTSTATUS"

   # Read the contents of a file
   curl -L "http://localhost:9870/webhdfs/v1/user/root/data.csv?op=OPEN"
   ```
   This is the entry point for any language or tool to communicate with HDFS.

2. **Pandas + HDFS** — The notebook `notebooks/02_handle_hdfs_pandas.ipynb` shows how to read data from HDFS directly into a Pandas DataFrame. It's the bridge between distributed Big Data and desktop analysis.

3. **Reflect on the ecosystem** — HDFS solves storage, YARN orchestrates resources, and the Python client (`hdfs` lib) accesses data via WebHDFS. Each piece of the ecosystem has a role: understand which one solves which pain point. Spark would be needed if you required distributed in-memory processing — but for your goal (putting and reading data), the `hdfs` lib + Pandas is enough.
