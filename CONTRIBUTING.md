# Contributing to cdn-hadoop-lab

## 🐘 How to Contribute

We welcome contributions — whether it's fixing a typo, improving a notebook, adding a new lab, or enhancing the cluster infrastructure.

## 📋 Getting Started

1. Fork the repository and clone your fork.
2. Follow the [Quick Start](README.md#-quick-start-5-minutes) instructions in the README.
3. Ensure `make status` shows all containers running before opening a notebook.
4. Create a branch for your changes: `git checkout -b my-change`.

## 📓 Notebook Guidelines

- Strip outputs before committing: `make strip`
- Keep cell execution counts at `null` — let the user run them.
- Use `.venv` as the kernel name in `kernelspec`.
- Place new labs in the `notebooks/` folder with a descriptive name.
- If your lab downloads external data, use the `temp/` directory (it is git-ignored).

## 💬 Commit Messages

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): short description in lowercase
```

Common types:

| Type     | Usage                                                |
|----------|------------------------------------------------------|
| `feat`   | A new lab, notebook, or feature                      |
| `fix`    | A bug fix                                            |
| `docs`   | Documentation only changes (README, docs/, etc.)     |
| `chore`  | Tooling, dependencies, gitignore, config, Makefile   |
| `refactor` | Code change that neither fixes nor adds a feature |

Scopes examples: `notebooks`, `readme`, `deps`, `makefile`, `gitignore`, `hadoop`, `docker`.

Examples:
```
feat(notebooks): add lab 7 — HDFS Snapshots and Quotas
fix(docker): increase DataNode heap to avoid OOM on lab 4
docs(readme): fix broken link to HttpFS proxy
chore(deps): update pyarrow to 18.x
```

## 🔄 Pull Request Process

1. Ensure the cluster boots cleanly: `make clean && make up`.
2. Run `make strip` on any modified notebooks.
3. Commit with a semantic message and push to your fork.
4. Open a PR against the `main` branch.
5. In the PR description, briefly explain what was changed and why.

## 🐛 Reporting Issues

- Use the [GitHub Issues](https://github.com/hiltonmbr/cdn-hadoop-lab/issues) tab.
- Include the output of `make status` and `docker compose logs` if relevant.
- Mention which lab or documentation page the issue relates to.

## 📄 License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).
