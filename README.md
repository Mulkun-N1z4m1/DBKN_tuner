# DBKN_tuner
It is a virtual assistant for RDBMS tuner such Oracle and SQL based (postgre, mysql, mariadb, sqlserver)

# DBKN Tuner — AI-Powered RDBMS Advisory Application

An application that leverages local LLM models (via **LM Studio**) to analyze database
configurations and generate actionable tuning advice log files.

## Supported RDBMS

| Database | Versions |
|---|---|
| PostgreSQL | 17 |
| MariaDB / MySQL | 10.x / 8.x+ |
| SQL Server | 2019 / 2022 |
| Oracle | 19C / 21C |

## Supported Deployment OS

- Ubuntu 22.04 / 24.04 LTS
- RHEL 8 / 9
- Oracle Linux 8 / 9
- Windows 11 / Windows Server 2022

## Quick Start

```bash
# 1. Install
pip install -e .

# 2. Start LM Studio and load a model (e.g. qwen3-30b)

# 3. Analyze a database config
dbkn-tuner analyze --rdbms postgresql --config samples/postgresql.conf.sample

# 4. Check output
ls output/logs/
```

## Security Features

- **HMAC-SHA256** integrity verification on all generated logs
- **AES-256-GCM** optional encryption for log files at rest
- **Chain-of-custody** audit trail linking consecutive logs
- **OS hardening scripts** for each supported deployment OS
- **No direct database connections** — operates on exported configs only

## Project Structure

```
DBKN_Tuner/
├── config.yaml
├── pyproject.toml
├── Dockerfile
├── src/dbkn_tuner/
│   ├── main.py
│   ├── config_loader.py
│   ├── engine/
│   │   ├── client.py
│   │   ├── prompts.py
│   │   └── log_generator.py
│   ├── advisors/
│   │   ├── postgresql.py
│   │   ├── mariadb_mysql.py
│   │   ├── sqlserver.py
│   │   └── oracle.py
│   └── security/
│       ├── integrity.py
│       └── encryption.py
├── scripts/
│   ├── deploy.sh
│   ├── setup-ubuntu.sh
│   ├── setup-rhel.sh
│   ├── setup-oraclelinux.sh
│   └── setup.ps1
├── samples/
├── tests/
└── secrets/
```
