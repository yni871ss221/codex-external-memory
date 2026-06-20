---
date: 2026-06-20
tags: [knowledge, tools, rtk, codex, windows]
project: area-survivors
related: [[area-survivors-current]], [[area-survivors-memory-rules]]
---

# RTK Codex Windows導入メモ

## 概要

- `rtk-ai/rtk` のWindows向けprebuilt binary `rtk 0.42.4` を `C:\Users\yni87\.local\bin\rtk.exe` に導入した。
- ユーザーPATHには `C:\Users\yni87\.local\bin` が含まれているため、Codex/ターミナル再起動後は `rtk` で呼び出せる想定。
- Codex向けに `rtk init -g --codex` を実行し、`C:\Users\yni87\.codex\RTK.md` と `C:\Users\yni87\.codex\AGENTS.md` の参照を作成した。

## AreaSurvivorsでの使い方

- 広い `git status`、`git diff`、`git log`、`rg`/`grep`、長いテスト/ログ出力はRTK経由を優先する。
- Scene/Prefab/YAMLの正確な精査が必要な場合は、RTK要約ではなく対象ファイルを絞った通常diffや専用Validatorで確認する。
- Windowsネイティブでは自動書き換えフックは効かないため、必要なコマンドで `rtk git status` のように明示的に使う。

## 確認済み

- `rtk --version`: `rtk 0.42.4`
- `rtk git status`: AreaSurvivorsで短縮出力を確認。
- `rtk gain --history`: 実ユーザー環境で履歴DBディレクトリ作成後、未記録状態として実行可能。Codexサンドボックス内の通常権限ではAppData書き込み制限で失敗することがある。
## 2026-06-20 高トークン化の自動回避ルール

- 広い `git diff` / `git status` / `rg` / `Get-Content`、Scene/Prefab/YAML全文、Unityログ、Obsidian長文、スクリーンショット反復などでトークン消費が大きくなりそうな場合は、実行前に軽量ルートを自動で選ぶか、必要なら短く提案してから進める。
- 優先順は、`Compact Project Snapshot`、RTK、対象パス指定、専用Validator/Reporter、必要範囲だけのログ/差分確認、最後に限定的な全文確認とする。
