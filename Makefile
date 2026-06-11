# cdn-hadoop-lab Makefile
.DEFAULT_GOAL := help
.PHONY: help up down clean status shell-namenode shell-datanode1 shell-datanode3 setup-env jupyter-lab strip

help:
	@echo "🐘✨ Welcome to the Hadoop Lab! The Big Data amusement park! 🎪✨"
	@echo "🚀 Choose your adventure below:"
	@echo ""
	@echo "  🔥 make up               - 🏗️  Starts the Hadoop elephant circus (containers in background)"
	@echo "  🛑 make down             - 😴 Puts the herd to sleep (pauses containers)"
	@echo "  💣 make clean            - ☢️  Destroys containers and DELETES ALL HDFS data (no going back!)"
	@echo "  📊 make status           - 📡 Active radar: Lists currently running containers"
	@echo "  🧠 make shell-namenode   - 👨‍✈️ Enters the NameNode cockpit (terminal)"
	@echo "  💾 make shell-datanode1  - 👷‍♂️ Goes to the factory floor (terminal) of DataNode 1"
	@echo "  💾 make shell-datanode3  - 👷‍♂️ Goes to the factory floor (terminal) of DataNode 3"
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
	@echo "   📁 data/                        ./data (Local VIP access)"

down:
	@echo "😴 Shhhh... Putting the elephants to sleep very quietly... 🌙🐘"
	docker compose down

clean:
	@echo "💥☢️  RED ALERT! Starting the HDFS apocalypse... Goodbye data! 💀🌪️"
	docker compose down -v
	rm -rf config/hadoop/dfs/name/* config/hadoop/dfs/data/*
	rm -rf temp/*
	@echo "🧹 Poof! Everything cleaned and disintegrated successfully. 🧼✨"

status:
	@echo "📡 Turning on the radar... Let's peek at what's going on in the containers! 🕵️‍♂️🔍"
	docker compose ps

shell-namenode:
	@echo "👨‍✈️🚀 Opening the NameNode hatch... Welcome to the command bridge! 🧠💬"
	docker exec -it namenode /bin/bash

shell-datanode1:
	@echo "👷‍♂️🏭 Going down to the factory floor... Accessing DataNode 1! 💾💬"
	docker exec -it datanode1 /bin/bash

shell-datanode3:
	@echo "👷‍♂️🏭 Going down to the factory floor... Accessing DataNode 3! 💾💬"
	docker exec -it datanode3 /bin/bash

setup-env:
	@echo "🐍🪄 Preparing the magic Python cauldron... Summoning dependencies with the super-fast 'uv'! ⚡📦"
	uv venv --clear
	uv sync
	git config filter.nbstripout.smudge cat
	git config filter.nbstripout.clean "uv run python3 -c \"import sys,json; nb=json.load(sys.stdin); [c.update({'outputs':[],'execution_count':None}) for c in nb['cells']]; json.dump(nb, sys.stdout, indent=1, ensure_ascii=False)\""
	@echo "✅🔥 Spell complete! Your local Python environment is blazing again! 🍾"

jupyter-lab:
	@echo "📓🚀 Countdown to code! Launching Jupyter Lab into the stratosphere... 🌌⌨️"
	uv run jupyter lab --notebook-dir=notebooks

strip:
	@echo "🧹 Stripping notebook outputs..."
	uv run python3 -c "
import json, glob
for f in glob.glob('notebooks/*.ipynb'):
    with open(f) as fh:
        nb = json.load(fh)
    for cell in nb['cells']:
        cell['outputs'] = []
        cell['execution_count'] = None
    with open(f, 'w') as fh:
        json.dump(nb, fh, indent=1, ensure_ascii=False)
    print(f'  ✓ {f}')
"
