# The Original Problem and the History of Hadoop

Until the early 2000s, the standard data processing model was **vertical scalability** (*Scale-Up*). When the database filled up, companies bought bigger servers with more RAM, CPUs, and fast disks. This model became financially prohibitive and technically unsustainable with the advent of Web 2.0.

## The Google Papers

In 2003 and 2004, Google solved its internal problem of indexing the web by writing two scientific papers:
1. **Google File System (GFS):** A file system spread across thousands of cheap disks, assuming hardware failures are rules, not exceptions.
2. **MapReduce:** A simple parallel processing model where code is sent to where the data resides.

## The Creation of Hadoop

Doug Cutting and Mike Cafarella implemented Google's ideas in Java in a project called Nutch, and later at Yahoo!, naming it **Hadoop** (named after the yellow stuffed elephant of Doug's son). Hadoop proved capable of building indexes on clusters of thousands of commodity nodes at drastically reduced cost (*Scale-Out*).

By turning 1,000 cheap machines into a logical supercomputer, Hadoop solved the Volume barrier in Big Data, creating a revolution in data engineering.

---

## 🧪 Hands-On

Time to see this history come to life on your computer:

1. **Start the cluster** — Run `make up` in the terminal. You'll see 5 Docker containers appearing, simulating the distributed cluster that Google and Yahoo! built.
2. **See the live components** — Run `make status` and check NameNode, DataNodes, and YARN running.
3. **Explore the UIs** — Open http://localhost:9870 (NameNode) and http://localhost:8088 (ResourceManager). Remember GFS and MapReduce from the Google papers? That's exactly what's running on your machine.
4. **Read doc 02** — Now that the cluster is up, dive into HDFS architecture.
