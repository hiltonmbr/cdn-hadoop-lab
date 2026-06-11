# Data Lakes and the Cloud: The Modern Transition

Although dedicated DataNode infrastructure has ruled for the last 15 years, the Big Data world is in full migration to the clouds of giants like AWS, Azure, and Google Cloud, abandoning many premises of conventional clusters.

## The Emergence of Data Lakes and the Medallion Architecture

The ability to dump files without typing or structure (JSON, Parquet, CSV, images) into HDFS created the concept of **Data Lake** — the company's raw repository.
This popularized the "layered" flow in the Lake, the most famous being the *Medallion Architecture*:
1.  **Bronze Layer:** Raw data, exactly as it came from the source (classic Data Lake).
2.  **Silver Layer:** Data has been cleaned, filtered, cross-referenced, anonymized, and already meets governance and business typing standards.
3.  **Gold Layer:** Aggregated modeled data, ready for consumption by dashboards (Power BI) and refined Artificial Intelligence models.

## Ephemeral Clusters and Storage as a Service

In the Cloud, companies abandoned traditional HDFS that tied "Disk + CPU" on the same machines. Modern Object Storage (e.g., Amazon S3, Azure Blob) took over the role of the distributed file system at a minimal cost.

This opened the door for a formidable architecture called **Ephemeral Clusters**. A Spark cluster is automatically started, processes Terabytes of data stored in S3, generates the Silver/Gold layer, and within the same minute, the cluster's EC2 instances **are deleted**. The company pays only for the minutes processed without maintaining huge server farms idling overnight.

---

## 🧪 Hands-On

Connect the Data Lakes theory to your local lab:

1. **`data/` as Bronze layer** — The `data/` folder in your project acts as a raw Data Lake. Data placed here (CSVs, JSONs) is available both to the Hadoop containers and your local notebooks. This is your Bronze layer.
2. **Process and transform** — Run the notebook `notebooks/02_handle_hdfs_pandas.ipynb`. It reads raw data from HDFS, processes it with Pandas, and generates treated outputs — exactly the Bronze → Silver flow.
3. **Visualize the Gold result** — Take the treated output from the notebook and save it in `data/gold/`. Now you have the 3 Medallion layers in your lab:
   ```
   data/
   ├── bronze/              ← Raw data (you create)
   ├── silver/              ← Clean data (notebook generates)
   └── gold/                ← Ready for consumption (dashboard)
   ```
4. **Reflect on the cloud** — In your lab, storage and processing are together (traditional HDFS). In the cloud (S3 + ephemeral Spark), they are separated. What advantages does this bring? What challenges?
