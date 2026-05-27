---
date: 2026-05-27
tags: [project, codex, obsidian, github]
project: codex-external-memory
related: [[Preferences/profile]]
---

# codex-external-memory

## Status

- Obsidian vault and Codex memory skill are managed in Git.
- Remote repository: `https://github.com/yni871ss221/codex-external-memory`
- Obsidian Local REST API & MCP Server is used for Codex read/write access.
- GitHub MCP is configured in Codex via `GITHUB_PERSONAL_ACCESS_TOKEN`.
- Memory structure now follows `Knowledge/`, `Decisions/`, `Projects/`, and `Preferences/`.
- On this PC, Codex skill files are copied into `C:\Users\yni87\.codex\skills\obsidian-memory` by `setup/install-windows.ps1`.
- Removed the old duplicate OneDrive vault at `C:\Users\yni87\OneDrive\ドキュメント\CodexMemory`; the canonical vault is `D:\develop\codex-external-memory\vault`.
- Removed temporary Codex config backups from `C:\Users\yni87\.codex`.
