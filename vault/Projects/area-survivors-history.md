---
date: 2026-06-20
tags:
  - project/area-survivors
  - history
related:
  - "[[area-survivors-current]]"
---

# AreaSurvivors History

## 2026-06-20

- `2771c1c` Add compact project reporter
- `624eeac` Add token usage guardrails
- `f897090` Center build mode camera on tower
- `Projects/area-survivors-current.md` を短縮し、現在状態中心のノートへ圧縮。
- トークン削減用にSafe Command、Benchmark、C# Symbol Index Reporter、Scene Prefab Structure Reporterを追加。
- 追加対応として、安全ショートカット、危険コマンド判定、Reporter概要メニュー、Token Health入口、Obsidian分割を導入。
- Unity系トークン対策として `safe-unity.ps1`、Reporterファイル保存＋要約表示、Unity系Token Health、Scene/Prefab検索Reporter、スクショ軽量化ツールを追加。
- 追加で `49313da Add Unity token guardrails` を作成し、以後の差分を見やすくした。TokenReports要約、CLI Scene/Prefab検索、作業開始/終了チェック、`guarded-command` 標準入口ルールを追加。
- `token-health.ps1` を日常用軽量チェックへ変更し、Heavy固定ベンチを `token-benchmark-heavy.ps1` に分離。`token-report-summary.ps1` はbenchmark系をデフォルト除外に変更。
- TokenReports鮮度管理として、古いJSONLのアーカイブ、summaryの `-Kind` / `-Since` フィルタ、終了チェックのsafe/daily系summary化を追加。
- 締め作業としてAreaSurvivors本体のトークン対策コミット群を確認し、`safe-unity Compile`、`end-token-check`、`git diff --check` を通した。外部メモリrepoには今回のルール・履歴・知識ノートを記録して反映する。

## 2026-06-21

- トークン削減の運用を低トークン入口ベースへ整理し、AGENTS.md を短縮、詳細を Docs/AgentRules/*.md へ分離した。
- Obsidian は通常作業開始時には読まず、履歴確認・記録・締め作業時だけ使う方針へ変更した。
- safe-search / safe-read / safe-diff / guarded-command / 	oken-report-summary / 	oken-health / start-token-check / end-token-check を強化した。
- ule-router.ps1、ocused-search.ps1、project-weight-report.ps1、game-manager-responsibility-report.ps1、eporter-candidates.ps1、alidation-preset.ps1 を追加した。
- Unity Reporterとして HUD Layout、Construction Menu Layout、Building Prefab Visuals、Asset References を追加した。
- un-unity-report.ps1 と ilter-asset-reference-report.ps1 を追加し、Asset整理を sset-references レポート + eview-candidate 抽出で進める標準手順を作った。
- AssetReferenceReporter を実行し、TokenReports/UnityReports/asset-references-20260621-164153.md を生成できることを確認した。
- ilter-asset-reference-report.ps1 -ExportPath ... で判定メモ sset-review-notes.md を出せるようにした。
- プロジェクトサイズを確認し、総容量よりも大きい .unity / .prefab / .asset と長いコード読込がトークン消費に効くことを確認した。

## 2026-06-23

- AreaSurvivorsリブート作業をPhase 0〜7まで完了扱いにした。不要機能停止から本削除、固定スロット建造化、HUD整理、塗り/セル占有整理、武器仕様整理、敵出現/Stage進行、Prefab画像Scale正規化まで実装・検証済み。
- HUD/Scene疎結合方針を再確認し、塗り内訳ゲージとトークン獲得数パネルはScene配置を正とする形へ整理した。
- 武器ラインナップはスラッシュ / 弓 / 火の玉の3種で確定。`slashWeaponLevels` / `arrowWeaponLevels` / `fireballWeaponLevels` と `WeaponType` へデータ構造を整理した。
- Stage 1/2 の敵出現とボス討伐Stage進行を固定仕様として整理し、`Gameplay_Stage_Progression` で検証した。
- 建造物Prefab画像サイズは、建造物本体/アップグレード本体の child Transform Scale `1,1,1` を正とし、`Completion Sparkle` だけ演出例外にした。
- トークン消費調査を行い、TokenReports上の巨大値はbenchmark/command_estimateが主因で、実際のUI消費は固定コンテキスト・会話・画像・直接ツール出力などレポート外要素が大きいと整理した。
- レポート外消費を補足するため、`record-untracked-usage.ps1`、`start-token-check.ps1 -UiPercent`、`session-coverage.ps1` の開始値自動取得、`token-report-summary.ps1 -Path`、kind別summaryを追加した。
- 直近検証: Compile成功、Console Error表示なし、`Gameplay_Reboot_Weapons` PASS、`Gameplay_Stage_Progression` PASS、`git diff --check` 問題なし。
- AreaSurvivors本体の直近コミット: `2345003` Track unreported token usage、`a63ee73` Align weapon level data with weapon types、`ff72df4` Add stage progression gameplay test、`da5f05f` Verify reboot gameplay integration。
