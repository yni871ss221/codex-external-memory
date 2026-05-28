---
date: 2026-05-28
tags: [codex, skills, projects, setup]
project: codex-external-memory
related: [[Projects/area-survivors]], [[Projects/codex-external-memory]]
---

# Codexスキルのプロジェクト適用範囲

`C:\Users\yni87\.codex\skills` に配置したCodexスキルは、特定プロジェクト専用ではなくユーザー環境全体のスキルとして扱われる。

AreaSurvivorsで反映されていないように見える場合は、以下を確認する。

- Codex Desktopを再起動したか。
- スキル追加前から開いていたスレッドを使い続けていないか。
- `C:\Users\yni87\.codex\skills` に対象スキルが存在するか。
- `codex mcp list --json` で `obsidian` が有効か。
- プロジェクト配下に `.codex` などの上書き設定がないか。
