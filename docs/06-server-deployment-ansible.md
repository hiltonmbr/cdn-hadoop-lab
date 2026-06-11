# Server Deployment and Automation with Ansible

So far, we've explored the Hadoop ecosystem through simulated Docker containers locally. However, in traditional corporate scenarios, Hadoop is deployed on real servers (*Bare Metal* or Virtual Machines).

Below, we present the fundamental concepts and steps to set up a real cluster and automate its infrastructure.

## 1. Server Architecture (Master and Slaves)

In a classic cluster, you allocate machines according to HDFS and YARN roles. For example, on a network with 3 Ubuntu servers:
- **Master Node:** Hosts the `NameNode` and `ResourceManager`.
- **Slave Nodes:** Host the `DataNodes` and `NodeManagers`.

### Passwordless Communication (SSH)
Hadoop requires the master node to be able to send commands to slaves via SSH without human intervention. To do this, RSA public keys are generated on the master and copied to the slaves, allowing unrestricted access:

```bash
# 1. Connect to the master node
ssh cdn@192.168.68.115

# 2. Generate the SSH key (leave passphrase empty)
ssh-keygen -t rsa

# 3. Copy the key to the servers (master and slaves)
ssh-copy-id cdn@localhost
ssh-copy-id cdn@192.168.68.116
ssh-copy-id cdn@192.168.68.117
```

## 2. Manual Hadoop Installation

To manually deploy Hadoop on an Ubuntu server, the fundamental steps are:
1.  **Prerequisites:** Install Java (OpenJDK 8 or higher), as the entire ecosystem runs on the JVM.
2.  **Download:** Obtain the compressed binaries from the Apache website (`wget` and `tar -xzf`).
3.  **Environment Variables:** Configure `JAVA_HOME` and `HADOOP_HOME` in the `~/.bashrc` file.
4.  **Network Configuration:** Map IPs to friendly domain names in the `/etc/hosts` file (e.g., `192.168.68.115 namenode`).
5.  **XML Files:** Edit the `core-site.xml`, `hdfs-site.xml`, `yarn-site.xml`, and `mapred-site.xml` files on the master.
6.  **Workers List:** Add the DataNodes IPs to the `workers` file.
7.  **Distribution:** Exact copy of the already configured Hadoop folder (`/opt/hadoop`) from the master to all slaves via `scp`.
8.  **Formatting and Startup:** Execute the `hdfs namenode -format` command (only once) and start the system with `start-dfs.sh` and `start-yarn.sh`.

## 3. Infrastructure Automation with Ansible

Doing the 8 steps above manually on 100 servers would be impossible. This is where **Ansible** comes in, a provisioning automation tool based on YAML.

### Ansible Features
- **Agentless:** Unlike other tools, Ansible does not require installing any client software on slave servers. It only acts by connecting to servers via **SSH**.
- **Idempotent:** You describe the desired final state. If the machine is already configured, Ansible will do nothing.

### Key Components
1.  **Inventory:** A YAML or INI file that lists the IP addresses of servers grouped by categories.
    *Example of `inventory.yml`:*
    ```yaml
    all:
      children:
        namenodes:
          hosts:
            192.168.68.115:
        datanodes:
          hosts:
            192.168.68.116:
            192.168.68.117:
    ```

2.  **Modules:** Commands packaged by Ansible to execute specific tasks.
    *Example of module usage (`package.yml`):*
    ```yaml
    - name: Install Java JDK 8
      apt:
        name: openjdk-8-jdk
        state: present
        update_cache: yes
    ```

3.  **Playbooks:** YAML files containing the "recipe". An ordered list of tasks and modules that Ansible will execute on the server groups defined in the inventory.
    *Example of `playbook.yml`:*
    ```yaml
    - name: Configure Hadoop Servers
      hosts: all
      become: yes
      tasks:
        - name: Update packages and install Java
          apt:
            name: openjdk-8-jdk
            state: present
            update_cache: yes
            
        - name: Ensure the Hadoop directory exists
          file:
            path: /opt/hadoop
            state: directory
            owner: cdn
            group: cdn
    ```

> **💡 Practical Tip:** The real automation of a Hadoop cluster based on these practices can be seen in a dedicated Infrastructure as Code (IaC) repository, using tools like Ansible.
