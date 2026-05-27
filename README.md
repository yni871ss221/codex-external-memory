# Codex External Memory

This repository stores the portable parts of Codex external memory:

- `vault/`: Obsidian vault content and non-secret plugin files.
- `skills/`: Codex skills, including this repo's memory rules and vendored `kepano/obsidian-skills`.
- `setup/install-windows.ps1`: Per-PC setup script.

Do not commit local API keys, Codex auth files, or machine-specific Codex config.

## First setup on a Windows PC

1. Install Obsidian.
2. Clone this repository.
3. Run `setup/install-windows.ps1` from this repository.
4. Open the `vault/` folder in Obsidian.
5. Enable Community Plugins and enable `Local REST API & MCP Server`.
6. Restart Codex Desktop.

The setup script creates a per-PC API key in `vault/.obsidian/plugins/obsidian-local-rest-api/data.json`, links or copies all skills into `%USERPROFILE%\.codex\skills`, and updates `%USERPROFILE%\.codex\config.toml`.

Vendored Obsidian skills from `kepano/obsidian-skills`:

- `obsidian-markdown`
- `obsidian-bases`
- `json-canvas`
- `obsidian-cli`
- `defuddle`

Use `obsidian-markdown` when summarizing or rewriting notes. Use `obsidian-bases` when creating structured indexes, filtered collections, or summary views across many notes.

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

Keep durable memory in:

- `vault/Knowledge/` for reusable technical knowledge and solved issues.
- `vault/Decisions/` for decisions and rationale.
- `vault/Projects/` for project state.
- `vault/Preferences/` for user profile and working style.

## GitHub remote

After creating a private GitHub repository, connect this local repository:

```powershell
setup/connect-github-remote.ps1 -RemoteUrl "https://github.com/USER_OR_ORG/codex-external-memory.git" -Push
```

HTTPS works with Git Credential Manager and a GitHub personal access token. Do not commit the token.

## GitHub MCP

GitHub MCP is optional for memory sync. It is useful when Codex should manage GitHub repository metadata, issues, pull requests, and actions.

This repository's setup expects the token to live outside Git:

```powershell
setx GITHUB_PERSONAL_ACCESS_TOKEN "github_pat_..."
```

Restart Codex Desktop after setting the environment variable.
