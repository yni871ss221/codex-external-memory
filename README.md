# Codex External Memory

This repository stores the portable parts of Codex external memory:

- `vault/`: Obsidian vault content and non-secret plugin files.
- `skills/obsidian-memory/`: Codex skill that tells Codex how to use the vault.
- `setup/install-windows.ps1`: Per-PC setup script.

Do not commit local API keys, Codex auth files, or machine-specific Codex config.

## First setup on a Windows PC

1. Install Obsidian.
2. Clone this repository.
3. Run `setup/install-windows.ps1` from this repository.
4. Open the `vault/` folder in Obsidian.
5. Enable Community Plugins and enable `Local REST API & MCP Server`.
6. Restart Codex Desktop.

The setup script creates a per-PC API key in `vault/.obsidian/plugins/obsidian-local-rest-api/data.json`, links or copies the skill into `%USERPROFILE%\.codex\skills`, and updates `%USERPROFILE%\.codex\config.toml`.

## Daily use

Before starting work on another PC:

```powershell
git pull
```

After updating memories:

```powershell
git status
git add vault skills
git commit -m "Update Codex memory"
git push
```

Keep durable memory in `vault/10_Codex/Memory.md`.

## GitLab remote

After creating a private GitLab project, connect this local repository:

```powershell
setup/connect-gitlab-remote.ps1 -RemoteUrl "git@gitlab.com:USER_OR_GROUP/codex-external-memory.git" -Push
```

Use SSH when possible. HTTPS also works, but GitLab credentials or a personal access token must be configured separately.

GitLab MCP is optional. It is useful for managing GitLab issues, merge requests, CI pipelines, and repository metadata through Codex, but it is not required for memory sync. Memory sync only needs normal Git.
