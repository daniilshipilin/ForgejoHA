# Home Assistant Forgejo Addon

- Run a self-hosted **Forgejo** instance within Home Assistant.
- Forgejo is a lightweight, community-managed Git forge (Gitea fork) for hosting repositories, issues, pull requests, and more.
- Supports SSH git access and HA Ingress out of the box.

## About

Self-hosted lightweight software forge. A community-managed Gitea fork.

## Installation

1. Add this repository to your Home Assistant Add-on store.
2. Install the **Forgejo** add-on.
3. Configure the add-on (see options below).
4. Start the add-on.
5. Open the web UI via Ingress or at `http://<ha-ip>:3000`.
6. Complete the initial setup wizard on first launch.

## Configuration

| Option | Required | Description |
|--------|----------|-------------|
| `domain` | No | The public domain name for your Forgejo instance (e.g. `git.example.com`). Used to generate clone URLs. Leave empty to use the IP address. |
| `ssh_port` | Yes | The external SSH port for git operations. Default: `22`. |
| `ssl` | Yes | Enable HTTPS. Requires `certfile` and `keyfile`. Default: `false`. |
| `certfile` | No | SSL certificate file path. Default: `/ssl/fullchain.crt`. |
| `keyfile` | No | SSL private key file path. Default: `/ssl/privkey.pem`. |

## Data Storage

All Forgejo data (repositories, configuration, uploads) is stored in `/share/forgejo` and persists across add-on restarts and updates.

## Ports

| Port | Description |
|------|-------------|
| `3000/tcp` | Web interface (not required when using Ingress) |
| `22/tcp` | SSH for git push/pull operations |

## Notes

- On first start, Forgejo will present an installation wizard to configure the database, admin account, and other settings.
- The built-in SQLite3 database is used by default and requires no additional setup.
- For SSH git access, map port `22` in the add-on network settings.
