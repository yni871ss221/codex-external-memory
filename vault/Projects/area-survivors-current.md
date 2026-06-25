---
title: AreaSurvivors Current
type: project-current
updated: 2026-06-25
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
- Reboot status: Phase 0〜7 のリブート作業は実装・検証・整理まで完了扱い。
- Worktree at closeout: clean.
- Remote status at closeout: `origin/feature/02_GameSystemUpdate` へ `4ba7f50` までpush済み。

## 直近コミット

- `4ba7f50` Update HUD and weapon progression
- `2345003` Track unreported token usage
- `a63ee73` Align weapon level data with weapon types
- `ff72df4` Add stage progression gameplay test
- `da5f05f` Verify reboot gameplay integration
- `de2634a` Record prefab visual verification
- `c799dba` Trim legacy lobby and spawn config
- `2887ae5` Remove retired lobby and time upgrades
- `1833f63` Allow sparkle scale in prefab visual report
- `8abd477` Tighten fixed slot state restore

## 2026-06-25 完了内容

- ロビーから不要になった建造画面遷移ボタンと建造モード起動導線を削除した。
- ゲームHUDを更新し、エリア塗り状況を上部パネル化、トークン/塗りパネル背景と透明化挙動を調整した。
- プレイヤーステータスと武器ステータスをScene配置HUDとして整理し、武器別パネル、アイコン、表形式、未取得武器の空表示/取得後表示を実装した。
- HUD項目は `05_Game.unity` 上のScene配置を正とし、`GameManager` は既存UIのバインド、値更新、表示切替だけを行う方針へ戻した。
- レベルアップ画面の武器仕様を、武器Lv上昇から「新武器獲得」または「取得済み武器の個別ステータス強化」へ変更した。
- 火の玉は進行方向へ飛び、敵衝突または射程到達で爆発する。道中と爆発範囲に塗りが発生する。
- 中心塔/バリスタの攻撃は塗りを行わずダメージのみ発生する。
- 建造物セルに敵用衝突判定を持たせ、プレイヤーとは衝突しないよう整理した。
- 壁を1x1セル画像へ差し替え、通常/アップグレード画像を透過加工して `Sprites/Generated` へ配置した。
- 固定配置建造物を仕様画像に合わせ、壁/バリスタ/中心塔の配置を整理した。
- スキルツリーを仕様画像ベースへ再構成し、以後はジャンルパネルを崩さずノード内だけ差し替える運用をスキル化した。
- エリート出現率UPの旧ロジックを廃止し、0:30/1:30 のエリート出現数UPとして扱う仕様へ変更した。

## 残す互換

- `CharacterType.Archer` / `CharacterType.Mage` は旧セーブ / 旧表示分岐互換としてのみ残す。武器データのキーには使わない。
- 廃止 `UpgradeType` と `SavedBuildingKind` の一部は旧セーブ互換と retired 判定用に残す。
- これらはリブート未完了ではなく、既存セーブ互換のための残置。

## 直近検証

- `rtk unicli exec Compile`: 成功、`0 errors / 0 warnings`。
- `rtk unicli exec Console.GetLog`: ログ0件。
- `git diff --check -- Assets\AreaSurvivors\Scripts Assets\AreaSurvivors\Editor Docs\AgentRules`: 問題なし。
- Scene差分はHUD/スキルツリー/固定配置の更新を含むため本文diffは読まず、`git diff --stat` とUnity Compile/Consoleで確認した。

## 重要ルール

- ユーザーへの説明、作業報告、Obsidian記録は日本語で行う。
- 通常作業開始時のObsidian外部記憶読み込みは行わない。履歴確認・記録・締め作業を明示された時だけ使う。
- Scene/Prefab/HUDはEditor調整を尊重し、Runtimeで既存配置やSpriteを固定値へ戻さない。
- HUD/ロビー/メニュー/スキルツリーなど調整対象UIはScene配置を正とし、Runtimeは既存参照の値更新・接続・表示切替だけを行う。
- HUDを追加/修正するとき、`GameManager` / `GameHudController` に `CreatePanel`、`CreateText`、`Ensure*`、`new GameObject` による新規HUD生成を追加しない。
- 既存の未コミット変更はユーザーまたは前作業のものとして扱い、勝手に戻さない。

## トークン集計/節約

- 作業開始は `Tools/TokenUsage/start-token-check.ps1 -UiPercent <開始%> [-BudgetTokens <推定枠tokens>] -Note <作業名>` を使う。
- 作業終了は `Tools/TokenUsage/end-token-check.ps1 -CurrentPercent <現在%>` を使う。
- レポート外消費は `Tools/TokenUsage/record-untracked-usage.ps1` で手動記録する。
- 日別確認は `Tools/TokenUsage/token-report-summary.ps1 -Path TokenReports/YYYY-MM-DD.jsonl -Top <件数>` を使う。
- Heavyベンチは明示時だけ実行する。

## 次チャットの推奨入口

1. `AGENTS.md` を読む。
2. 必要ならこのノートの「現在の状態」「直近検証」「重要ルール」だけ読む。
3. 通常開発に戻るなら、武器の数値バランス、レベルアップ候補の表示調整、実プレイ後の敵出現/塗り/HUD微調整から着手する。
4. リブート未完了として扱うものは現時点ではない。
