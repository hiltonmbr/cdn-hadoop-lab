# Essential HDFS Commands (Cheatsheet)

Interacting with HDFS via the command line is very similar to using the Linux terminal, as most commands inherit the same basic syntax, preceded by `hdfs dfs`.

If you are using our Docker lab, you should run these commands inside the NameNode container (or use `make shell-namenode`):

```bash
docker exec -it namenode hdfs dfs -<command>
```

---

## 📂 Directory Navigation and Manipulation

### List files (`-ls`)
Lists the contents of a directory. Use `-R` to list recursively.
```bash
hdfs dfs -ls /
hdfs dfs -ls -R /user/data
```

### Create directory (`-mkdir`)
Creates a new folder in HDFS. The `-p` flag creates parent directories if they don't exist.
```bash
hdfs dfs -mkdir /raw_data
hdfs dfs -mkdir -p /user/admin/projects
```

### Check used size (`-du`)
Shows disk space used by files and directories. `-h` formats for human readability (MB, GB).
```bash
hdfs dfs -du -h /raw_data
```

---

## 🔄 Data Ingestion and Extraction (Upload/Download)

### Upload file to HDFS (`-put` or `-copyFromLocal`)
Copies a file from your local machine (or local container) into HDFS.
```bash
hdfs dfs -put local_file.csv /raw_data/
```

### Download file from HDFS (`-get` or `-copyToLocal`)
Copies a file from HDFS to your local machine.
```bash
hdfs dfs -get /raw_data/local_file.csv ./my_file.csv
```

---

## 📝 File Manipulation

### View content (`-cat`)
Prints the contents of a text file directly to the terminal. Be careful with very large files!
```bash
hdfs dfs -cat /raw_data/sample.txt
```

### Read the end of the file (`-tail`)
Displays the last kilobyte of the file. Very useful for viewing the end of log files.
```bash
hdfs dfs -tail /logs/system.log
```

### Copy files within HDFS (`-cp`)
```bash
hdfs dfs -cp /raw_data/file.csv /backup/file.csv
```

### Move / Rename files (`-mv`)
```bash
hdfs dfs -mv /raw_data/old.csv /raw_data/new.csv
```

### Delete files (`-rm`)
Deletes a file. To delete an entire directory and all its contents, use `-r`.
```bash
hdfs dfs -rm /raw_data/wrong_file.csv
hdfs dfs -rm -r /old_folder
```

---

## 🛡️ Permissions and Ownership

HDFS has a permission system very similar to POSIX (Linux).

### Change permissions (`-chmod`)
```bash
hdfs dfs -chmod 755 /raw_data
hdfs dfs -chmod -R 777 /public_folder
```

### Change owner (`-chown`)
```bash
hdfs dfs -chown admin:users /raw_data
```

---

## 🩺 Cluster Administration

These commands (using `dfsadmin`) are useful for checking the overall health of the system:

### Health and Block Report
Displays a detailed report of capacity, live DataNodes, dead nodes, and corrupted blocks.
```bash
hdfs dfsadmin -report
```

### Safe Mode
HDFS enters Safe Mode (read-only) automatically when starting up to ensure all blocks are safe. You can manipulate it manually:
```bash
hdfs dfsadmin -safemode get    # Check if active
hdfs dfsadmin -safemode leave  # Force exit from safe mode
hdfs dfsadmin -safemode enter  # Force entry
```
