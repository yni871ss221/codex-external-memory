---
date: 2026-05-28
tags: [project, codex, obsidian, github]
project: codex-external-memory
related: [[Preferences/profile]], [[Preferences/language]]
---

# codex-external-memory

## 状態

- Obsidian VaultとCodex用スキルをGitで管理している。
- リモートリポジトリは `https://github.com/yni871ss221/codex-external-memory`。
- Codexからの読み書きにはObsidian Local REST API & MCP Serverを使う。
- GitHub MCPは `GITHUB_PERSONAL_ACCESS_TOKEN` 環境変数経由でCodexに設定している。
- 記憶構造は `Knowledge/`、`Decisions/`、`Projects/`、`Preferences/` の4分類。
- このPCでは `setup/install-windows.ps1` が `C:\Users\yni87\.codex\skills` にrepo管理スキル一式をコピーする。
- 旧OneDrive側の重複Vault `C:\Users\yni87\OneDrive\ドキュメント\CodexMemory` は削除済み。正本は `D:\develop\codex-external-memory\vault`。
- 一時的なCodex設定バックアップ `C:\Users\yni87\.codex\config.toml.bak-*` は削除済み。
- `kepano/obsidian-skills` を `skills/` に取り込み、セットアップ時に全スキルをCodexへ反映する。
- ノート要約は `obsidian-markdown`、構造化された一覧・集計ビューは `obsidian-bases` を使う。
- Obsidianの外部記憶ノートは、ユーザーが別言語を指定しない限り日本語で記録する。
