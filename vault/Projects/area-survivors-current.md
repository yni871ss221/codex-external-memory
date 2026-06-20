---
title: AreaSurvivors Current
type: project-current
updated: 2026-06-20
tags:
  - project/area-survivors
  - codex/current
related:
  - "[[area-survivors-token-workflow]]"
  - "[[area-survivors-history]]"
---

# AreaSurvivors Current

## 現在の状態

- Repository: `C:\Develop\unity_workspace\AreaSurvivors`
- Unity: `2022.3.62f3`
- Main Scene: `Assets/AreaSurvivors/Scenes/05_Game.unity`
- Gameplay Test Scene: `Assets/AreaSurvivors/Scenes/90_GameplayTest.unity`
- Current Branch: `feature/02_GameSystemUpdate`
- Recent Commits:
  - `39e14eb` Add token report freshness tools
  - `8ed7eed` Split daily token health from heavy benchmarks
  - `03d32b9` Add token workflow automation
  - `49313da` Add Unity token guardrails
  - `f897090` Center build mode camera on tower
- History: [[area-survivors-history]]
- Token workflow: [[area-survivors-token-workflow]]

## 重要ルール

- ユーザーへの説明、作業報告、Obsidian記録は日本語で行う。
- 作業前に `AGENTS.md` を読む。AreaSurvivorsの恒久ルールは `AGENTS.md` を正とする。
- Scene/Prefab/HUDはEditor調整を尊重し、Runtimeで既存配置やSpriteを固定値へ戻さない。
- 既存の未コミット変更はユーザーまたは前作業のものとして扱い、勝手に戻さない。
- 画像素材追加・差し替えは、必要に応じてAreaSurvivors用skillを使う。

## トークン節約ルール

- 広い `git status`、広い `git diff`、巨大Scene YAML、広すぎる `rg`、高解像度スクショ反復を避ける。
- `git status` は必要時のみ、可能なら対象パス指定で実行する。
- `git diff` は原則対象ファイル指定、または `--name-only` / `--stat` / 件数制限を使う。
- Unity Scene/Prefab作業では、YAML全文確認より専用Validator、Reporter、Compile、Console Error確認を優先する。
- UI/Scene見た目調整では、座標表・グリッド・Validatorで潰してから、初回と最終を中心にスクリーンショット確認する。
- 長いスレッドでトークン消費が大きくなった場合は、新規チャットへ移ることを提案し、`AGENTS.md`、このノート、現在ブランチ、直近コミット、直近検証結果だけを読み込んで続行する。

## Token Tooling

- `Tools/TokenUsage/Safe-Command.ps1`
  - 大量出力が疑われるコマンドを包む。
  - 出力トークンを概算し、閾値超過時にブロックまたはトリムする。
- `Tools/TokenUsage/Run-TokenBenchmark.ps1`
  - 固定の高出力コマンド群で、改善前後の推定トークン量を比較する。
  - ベースラインは `TokenReports/token-benchmark-baseline.json`。
- `Tools/TokenUsage/Invoke-AreaSafeCommand.ps1`
  - `Status`、`DiffStat`、`DiffNameOnly`、`Search`、`Read` などの日常調査入口。
  - 生の広い `git diff` / `rg` / `Get-Content` の代わりに使う。
- `Tools/TokenUsage/Invoke-AreaTokenHealth.ps1`
  - ベンチマークを短いヘルスチェックとして表示する。
  - `-FailOnIncrease` でトークン増加検知を終了コードにできる。
- Short wrappers:
  - `safe-status.ps1`、`safe-diff.ps1`、`safe-search.ps1`、`safe-read.ps1`、`safe-unity.ps1`、`token-health.ps1`
- `Tools/TokenUsage/Test-AreaCommandRisk.ps1`
  - 生の危険コマンドを実行前に判定する。
- `Tools/TokenUsage/guarded-command.ps1`
  - 既知の危険コマンドを安全ラッパーへ自動変換して実行する。
- `Tools/TokenUsage/Convert-AreaCommandToSafe.ps1`
  - 生コマンドがどの安全コマンドへ変換されるか確認する。
- `Tools/TokenUsage/token-report-summary.ps1`
  - TokenReportsから重いコマンド、blocked件数、high/critical件数を要約する。
  - `-Kind`、`-Since`、`-IncludeBenchmark` で分析対象を絞る。
- `Tools/TokenUsage/archive-token-reports.ps1`
  - 古いJSONLを `TokenReports/Archive/` へ移動する。
- `Tools/TokenUsage/token-health.ps1`
  - 日常用の軽量チェック。`TokenReports/token-daily-baseline.json` と比較する。
- `Tools/TokenUsage/token-benchmark-heavy.ps1`
  - 過去の巨大出力固定ケース用。明示時だけ実行する。
- `Tools/TokenUsage/safe-unity-search.ps1`
  - CLIからScene/Prefab検索を実行し、保存レポートのパスだけ返す。
- `Tools/TokenUsage/start-token-check.ps1` / `end-token-check.ps1`
  - 作業開始・終了時の軽量チェック入口。
- 詳細運用: [[area-survivors-token-workflow]]
- Unity menu: `Area Survivors/Reports/C# Symbol Overview`
- Unity menu: `Area Survivors/Reports/C# Symbol Index`
  - C#構造探索用の軽量レポート。
  - 広い検索や大量ファイル読み込みの代替に使う。
- Unity menu: `Area Survivors/Reports/Scene Prefab Overview`
- Unity menu: `Area Survivors/Reports/Scene Prefab Structure`
  - Scene/Prefab構造探索用の軽量レポート。
  - Scene/Prefab YAML全文読み込みの代替に使う。
- Unity menu: `Area Survivors/Reports/Scene Prefab Search`
  - GameObject名、Component名、RectTransform情報を検索語で絞る。
- Reporter output: `TokenReports/UnityReports/`
- Screenshot lite output: `TokenReports/Screenshots/`

## 最近の検証

- `Tools/TokenUsage/end-token-check.ps1`: 成功。
- `safe-unity Compile`: 成功、`0 errors / 0 warnings`。
- `ConsoleErrors --maxCount 30`: エラー表示なし。
- `token-health`: 日常用5件比較で `0 increased, 0 improved`。
- Console Error確認: エラーログ表示なし。
- Heavyベンチは `token-benchmark-heavy.ps1` へ分離済み。通常の開始/終了チェックでは実行しない。

## 建造画面カメラ修正

- 建造画面を開いたとき、中心塔が画面中央に来るように調整済み。
- Key Files:
  - `Assets/AreaSurvivors/Scripts/Game/BuildModeCameraController.cs`
  - `Assets/AreaSurvivors/Scripts/Game/GameManager.cs`
- Commit: `f897090 Center build mode camera on tower`

## トークン削減対応

- `AGENTS.md` にトークン節約運用ルールを追記済み。
- Safe/guarded command、safe-unity、Reporter保存、日常用token-health、Heavyベンチ分離、TokenReports鮮度管理を追加済み。
- Latest commit: `39e14eb Add token report freshness tools`

## 次にやるとよいこと

- トークン削減をさらに行う場合は、通常は `token-health.ps1` で日常用ベースラインと比較し、巨大出力の退行確認が必要な時だけ `token-benchmark-heavy.ps1` を明示実行する。
- UIやScene作業では、まず対象オブジェクトと座標を絞り、Validator/Reporterで確認してから最終スクリーンショットを見る。
- 外部メモリ更新や締め作業では、AreaSurvivors本体と `codex-external-memory` の両方を対象にする。
