# cdn-hadoop-lab Makefile
.DEFAULT_GOAL := help
.PHONY: help up down clean clean-data status health logs \
        shell-namenode shell-datanode1 shell-datanode2 shell-datanode3 \
        shell-resourcemanager shell-nodemanager shell-proxy \
        restart-namenode restart-datanode3 \
        setup-env jupyter-lab strip

help:
	@echo "🐘✨ Welcome to the Hadoop Lab! The Big Data amusement park! 🎪✨"
	@echo "🚀 Choose your adventure below:"
	@echo ""
	@echo "  🔥 make up               - 🏗️  Starts the Hadoop elephant circus (containers in background)"
	@echo "  🛑 make down             - 😴 Puts the herd to sleep (pauses containers)"
	@echo "  💣 make clean            - ☢️  Destroys containers and DELETES ALL HDFS data (no going back!)"
	@echo "  🧹 make clean-data       - 🗑️  Wipes only local dataset downloads in temp/ (cluster stays up)"
	@echo "  📊 make status           - 📡 Active radar: Lists currently running containers"
	@echo "  ❤️  make health           - 🏥 Shows Docker healthcheck status for all services"
	@echo "  📜 make logs             - 📋 Tails logs from all containers (Ctrl+C to stop)"
	@echo "  🧠 make shell-namenode       - 👨‍✈️ NameNode cockpit (terminal)"
	@echo "  💾 make shell-datanode1      - 👷‍♂️ DataNode 1 factory floor (terminal)"
	@echo "  💾 make shell-datanode2      - 👷‍♂️ DataNode 2 factory floor (terminal)"
	@echo "  💾 make shell-datanode3      - 👷‍♂️ DataNode 3 factory floor (terminal)"
	@echo "  🚦 make shell-resourcemanager - 🚦 YARN ResourceManager (terminal)"
	@echo "  ⚙️  make shell-nodemanager    - ⚙️  YARN NodeManager (terminal)"
	@echo "  🌉 make shell-proxy           - 🌉 HttpFS WebHDFS proxy (terminal)"
	@echo "  🔄 make restart-namenode      - 🔄 Restart the NameNode"
	@echo "  🔄 make restart-datanode3     - 🔄 Restart DataNode 3 (fault tolerance demo)"
	@echo "  🐍 make setup-env        - 🪄  Prepares the Python cauldron by installing dependencies with 'uv'"
	@echo "  📓 make jupyter-lab      - 🚀 Launches the Jupyter Lab ship for you to code"
	@echo ""

up:
	@echo "🐘✨ Starting ignition! Bringing up the Hadoop herd (NameNode, DataNodes, YARN)... 🚀"
	docker compose up -d
	@echo ""
	@echo "🎉 BINGO! All up and running! Your distributed amusement park is ready:"
	@echo "   🧠 NameNode UI (The Master):    http://localhost:9870"
	@echo "   🚦 ResourceManager (The Overseer): http://localhost:8088"
	@echo "   🌉 HttpFS proxy (WebHDFS):      http://localhost:14000"

down:
	@echo "😴 Shhhh... Putting the elephants to sleep very quietly... 🌙🐘"
	docker compose down

clean:
	@echo "💥☢️  RED ALERT! Starting the HDFS apocalypse... Goodbye data! 💀🌪️"
	docker compose down -v
	rm -rf config/hadoop/dfs/name/* config/hadoop/dfs/data/*
	rm -rf temp/*
	@echo "🧹 Poof! Everything cleaned and disintegrated successfully. 🧼✨"

clean-data:
	@echo "🧹 Sweeping local dataset downloads from temp/ (HDFS untouched)... 🗑️"
	rm -rf temp/*
	@echo "✨ temp/ is clean. The cluster and HDFS data are still running."

status:
	@echo "📡 Turning on the radar... Let's peek at what's going on in the containers! 🕵️‍♂️🔍"
	@docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || docker compose ps
	@echo ""
	@echo "💾 HDFS cluster health:"
	@docker exec namenode hdfs dfsadmin -report 2>/dev/null | grep -E '(Live|Dead|Under-replicated|Total) datanodes|Configured Capacity|DFS Used|DFS Remaining' || echo "   (cluster not running)"

health:
	@echo "🏥 Container healthcheck status:"
	@docker compose ps --format "table {{.Name}}\t{{.Status}}" 2>/dev/null || docker compose ps

logs:
	@echo "📜 Tailing logs from all containers (Ctrl+C to stop)..."
	docker compose logs -f

shell-namenode:
	@echo "👨‍✈️🚀 Opening the NameNode hatch... Welcome to the command bridge! 🧠💬"
	docker exec -it namenode /bin/bash

shell-datanode1:
	@echo "👷‍♂️🏭 Going down to the factory floor... Accessing DataNode 1! 💾💬"
	docker exec -it datanode1 /bin/bash

shell-datanode2:
	@echo "👷‍♂️🏭 Going down to the factory floor... Accessing DataNode 2! 💾💬"
	docker exec -it datanode2 /bin/bash

shell-datanode3:
	@echo "👷‍♂️🏭 Going down to the factory floor... Accessing DataNode 3! 💾💬"
	docker exec -it datanode3 /bin/bash

shell-resourcemanager:
	@echo "🚦🚀 Accessing the YARN ResourceManager... The traffic controller! 🚦💬"
	docker exec -it resourcemanager /bin/bash

shell-nodemanager:
	@echo "⚙️🚀 Accessing the YARN NodeManager... The worker foreman! ⚙️💬"
	docker exec -it nodemanager /bin/bash

shell-proxy:
	@echo "🌉🚀 Opening the HttpFS proxy gateway... The bridge to HDFS! 🌉💬"
	docker exec -it proxy /bin/bash

restart-namenode:
	@echo "🔄 Restarting NameNode..."
	docker compose restart namenode

restart-datanode3:
	@echo "🔄 Restarting DataNode 3... Watch HDFS heal itself!"
	docker compose restart datanode3

setup-env:
	@echo "🐍🪄 Preparing the magic Python cauldron... Summoning dependencies with the super-fast 'uv'! ⚡📦"
	uv venv --clear
	uv sync
	git config filter.nbstripout.smudge cat
	git config filter.nbstripout.clean "uv run python3 -c \"import sys,json; nb=json.load(sys.stdin); [c.update({'outputs':[],'execution_count':None}) for c in nb['cells'] if c.get('cell_type')=='code']; json.dump(nb, sys.stdout, indent=1, ensure_ascii=False)\""
	@echo "✅🔥 Spell complete! Your local Python environment is blazing again! 🍾"

jupyter-lab:
	@echo "📓🚀 Countdown to code! Launching Jupyter Lab into the stratosphere... 🌌⌨️"
	uv run jupyter lab --notebook-dir=notebooks

strip:
	@echo "🧹 Stripping notebook outputs..."
	@for f in notebooks/*.ipynb; do \
		uv run python3 -c "import json,sys; f=sys.argv[1]; nb=json.load(open(f)); [c.update(outputs=[], execution_count=None) for c in nb['cells'] if c.get('cell_type')=='code']; json.dump(nb, open(f,'w'), indent=1, ensure_ascii=False); print('  ✓ '+f)" "$$f"; \
	done
