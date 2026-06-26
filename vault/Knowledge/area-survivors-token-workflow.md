---
date: 2026-06-20
tags:
  - project/area-survivors
  - token-efficiency
related:
  - "[[area-survivors-current]]"
---

# AreaSurvivors Token Workflow

## 基本方針

- 高出力になりやすいコマンドは、実行前に安全入口か危険判定を使う。
- 生の広い `git diff`、対象未指定の `rg`、行数制限なしの `Get-Content`、Scene/Prefab YAML全文確認を避ける。
- Unity調査は、まず概要Reporter、必要なら通常Reporter、最後に対象ファイル限定の詳細確認へ進む。

## 日常入口

- `Tools/TokenUsage/safe-status.ps1`
- `Tools/TokenUsage/safe-diff.ps1`
- `Tools/TokenUsage/safe-search.ps1`
- `Tools/TokenUsage/safe-read.ps1`
- `Tools/TokenUsage/token-health.ps1`
- PowerShell関数化: `. Tools/TokenUsage/Import-AreaTokenAliases.ps1`

## 危険判定

- `Tools/TokenUsage/Test-AreaCommandRisk.ps1 -Command "<command>"`
- 危険判定されたら、RTK、安全ラッパー、対象パス指定、Reporter、Validator、件数制限へ切り替える。
- 自動変換: `Tools/TokenUsage/guarded-command.ps1 -Command "<command>"`
- 変換内容確認: `Tools/TokenUsage/Convert-AreaCommandToSafe.ps1 -Command "<command>"`
- 既知の危険コマンドは `safe-diff`、`safe-search`、`safe-read`、`ConsoleErrors` へ自動変換する。
- 未知のコマンドは `-ExecuteOriginalIfSafe` なしでは実行しない。

## Unity Reporter

- C#探索: `Area Survivors/Reports/C# Symbol Overview` → `C# Symbol Index`
- Scene/Prefab探索: `Area Survivors/Reports/Scene Prefab Overview` → `Scene Prefab Structure`
- Scene/Prefab検索: `Area Survivors/Reports/Scene Prefab Search`
- Reporter出力は `TokenReports/UnityReports/` に保存し、Unity Consoleには保存先・行数・文字数だけ出す。
- YAML全文確認は最終手段。

## Unity Commands

- Unity系コマンドは `Tools/TokenUsage/safe-unity.ps1` を使う。
- Actions: `Compile`、`ConsoleErrors`、`Menu`、`Eval`
- `ConsoleErrors` は `-MaxCount` で件数制限する。
- Unity系ベンチを含める場合は `Tools/TokenUsage/token-health.ps1 -IncludeUnity` を使う。

## Screenshots

- 大きいスクリーンショットは、確認前に `Tools/TokenUsage/Optimize-AreaScreenshot.ps1` で縮小またはクロップする。
- 低解像度版は `TokenReports/Screenshots/` に保存する。

## 定期チェック

- 改善作業の前後、または作業終了前に `Tools/TokenUsage/token-health.ps1` を実行する。
- 増加を検知したい場合は `-FailOnIncrease` を使う。
- 日常用ベースラインは `TokenReports/token-daily-baseline.json`。
- Heavyベンチは `Tools/TokenUsage/token-benchmark-heavy.ps1` を明示時だけ使う。
- Heavyベンチのベースラインは `TokenReports/token-benchmark-baseline.json`。
- 作業開始チェック: `Tools/TokenUsage/start-token-check.ps1`
- 作業終了チェック: `Tools/TokenUsage/end-token-check.ps1`
- Unity込みの確認は `-IncludeUnity` を付ける。

## Report Summary

- TokenReportsの原因分析は `Tools/TokenUsage/token-report-summary.ps1` を使う。
- benchmark系レコードはデフォルトで除外する。
- benchmark系も見たい場合は `-IncludeBenchmark` を付ける。
- 種別を絞る場合は `-Kind safe_command,daily_health` のように指定する。
- 対策後だけを見たい場合は `-Since "YYYY-MM-DD HH:mm"` を指定する。
- 重いコマンド、blocked件数、high/critical件数を確認する。

## Report Archive

- 古いTokenReports JSONLは `Tools/TokenUsage/archive-token-reports.ps1` で `TokenReports/Archive/` へ移動する。
- 削除ではなくアーカイブを基本にする。
- 実行前に `-WhatIf` で対象を確認する。

## CLI Scene Search

- CLIからScene/Prefab検索する場合は `Tools/TokenUsage/safe-unity-search.ps1 -Query <検索語>` を使う。
- 検索語をEditorPrefsへ設定し、`Area Survivors/Reports/Scene Prefab Search` を実行して、保存ファイルのパスだけ返す。

## 2026-06-21 追加運用

- 通常作業開始時はObsidianを読まず、AGENTS.md を唯一の入口にする。
- ルール詳細は Docs/AgentRules/*.md に分離し、必要なカテゴリだけ読む。
- Asset整理は次の順で行う:
  - un-unity-report.ps1 -Report asset-references
  - ilter-asset-reference-report.ps1 -Top <件数>
  - 必要時だけ -ExportPath で判定メモを出す
- Sprites/External の整理は容量削減より検索ノイズ削減に効く。総容量だけではなく、巨大Sceneや長いコードを直接読まない運用を優先する。

## 2026-06-23 レポート外消費の補足

- `start-token-check.ps1` は `-UiPercent` / `-BudgetTokens` / `-Note` を受け取り、開始マーカーへUI使用率を保存する。
- `session-coverage.ps1` は最新の `token_start_marker` から開始UI使用率とbudgetを自動取得し、`-CurrentPercent` だけで差分推定できる。
- `record-untracked-usage.ps1` は、会話、長い回答、画像添付、直接ツール出力、推論負荷などTokenReportsに自動記録されない消費を `manual_untracked_usage` として保存する。
- 画像は `-ImagePath` を指定すると画像サイズから概算する。厳密値ではなく、UI使用率差分の未知バケットを小さくするための補助値として扱う。
- `token-report-summary.ps1 -Path TokenReports/YYYY-MM-DD.jsonl` は指定した日別JSONLだけを集計する。`-Days` 集計と混同しない。
- サマリーにはkind別内訳が出るため、`safe_command`、`daily_health`、`manual_untracked_usage`、`token_coverage_snapshot` を分けて読む。
- 完全に取得できないもの: モデル内部推論トークン、Codex固定コンテキストの正確な内訳、画像の実トークン化、UI外で返ったtool resultの厳密値。
- 運用上は「UI使用率差分 - command記録 - manual記録 = 残り未知消費」として見る。

## 2026-06-26 start-task-token-check運用

- 作業開始時は `start-task-token-check.ps1 -Task "<依頼内容>" -UiPercent <開始%> [-BudgetTokens <推定枠>]` を優先する。
- このWrapperは `rule-router.ps1` で読むべき詳細ルールと中核ファイルを表示し、そのまま `start-token-check.ps1` の開始マーカーも記録する。
- 既に読むルールが明確な小修正だけ、従来の `start-token-check.ps1` を直接使う。
- `run-unity-report.ps1` は `Eval` より `Menu.Execute` を優先する。PowerShellスクリプト内からUniCliを呼ぶ場合、環境によってUnity名前付きパイプにアクセスするため権限付き実行が必要になる。