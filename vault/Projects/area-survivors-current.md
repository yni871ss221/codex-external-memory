---
title: AreaSurvivors Current
type: project-current
updated: 2026-06-26
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
- Worktree at closeout: AreaSurvivors本体は多数の変更あり。締め作業でまとめてcommit/push予定。
- Reboot status: Phase 0〜7 完了扱い。現在は追加ステージ、建造物スキル、HUD/素材整理フェーズ。

## 2026-06-26 完了内容

- 破壊済み建造物画像を追加し、壁/バリスタ/監視塔の通常・アップグレード破壊表示をPrefab/Scene参照ベースで差し替えるよう整理した。
- 破壊画像や建造物/敵/弾画像はScaleで合わせず、PNG加工とImport設定でScale `1`、Rotation `0` を維持するルールを強化した。
- 建造物スキルNo1/No5取得時に、初期固定配置の壁/バリスタが出現する仕様へ変更した。
- 建造物スキルNo12/No13取得時に、No1/No5で追加した固定配置分だけ壁/バリスタがアップグレードされるようにした。将来外周配置分とは分離する方針。
- バリスタ/壁など建造物の表示優先度を、セル位置的に手前のオブジェクトが手前へ出るよう調整した。
- スキルツリーの各ジャンルアイコンをScene上の `Source Image` 参照として差し替え、RuntimeコードによるSprite差し替えを禁止ルール化した。
- 門を不要建造物として削除した。Prefab、Sprite、TilePalette、実装参照、スキル/保存データ互換周りの残骸整理を実施した。
- Stage 3を追加。スケルトン、スケルトンナイト、リッチ（ボス）を追加し、ロビーにStage 3テストボタンを用意した。
- Spine導入を試行したが、プレイヤー歩行に適用するには部位分割素材やセットアップ負荷が高いため中止。導入済みランタイムは残し、プレイヤー実装からは削除した。
- Stage 4を追加。リザード、リザードマン、ドラゴン（ボス）を追加し、リザードの横向きサイズを2セル幅相当に調整した。
- 中心塔スキルNo6取得時に中心塔がアップグレードされるよう実装した。
- エリート出現数UPスキルは最大Lv4に制限した。
- ステージ2オーガなど、横向き歩行フレームで膨らむ/縮むように見える箇所を調査し、Sprite import/フレーム幅の揃え込みで修正した。
- 弓矢は射程内の敵だけを対象にし、複数本は近い順に別敵へ飛ぶ仕様へ変更した。射程内の敵が足りない場合は本数を減らす。
- プレイヤー初期弓射程を約10セル分へ縮小した。
- プレイヤー矢はバリスタ矢と分離した `PlayerArrow` 画像/Prefabへ変更し、Scale `1`、Rotation X/Y `0` のまま見た目サイズを調整した。
- トークン負荷対策として `start-task-token-check.ps1` を追加し、作業開始時にルールルーティングと開始マーカーを同時実行できるようにした。
- `SkillTreeLayoutReporter` を追加し、スキルツリーのノード、アイコン、接続、重なりを `run-unity-report.ps1 -Report skill-tree-layout` で確認できるようにした。
- `GameManager` 内の武器HUDバインド/更新処理を `WeaponHudPanelBinding` へ分割した。

## 残す互換/注意

- `CharacterType.Archer` / `CharacterType.Mage` は旧セーブ / 旧表示分岐互換としてのみ残す。武器データのキーには使わない。
- 廃止 `UpgradeType` と `SavedBuildingKind` の一部は旧セーブ互換と retired 判定用に残す。
- Spineランタイムは導入済みだが、現時点ではプレイヤーや敵の実装に使っていない。削除不要の指示済み。
- 生成済みゲーム用Spriteは `Assets/AreaSurvivors/Sprites/Generated` に統一し、`Resources/Generated` は新規追加しない。
- Static/Visual/UI/SkillTreeアイコンはScene/Prefab参照を正とする。Runtimeで新規配置・生成・Sprite差し替えをしない。

## 直近検証

- `unicli exec Compile`: 成功、`0 errors / 0 warnings`。
- `powershell -ExecutionPolicy Bypass -File Tools/TokenUsage/run-unity-report.ps1 -Report skill-tree-layout`: 成功（権限付き実行）。
- 最新 `TokenReports/UnityReports/skill-tree-layout-20260626-122758.md`: `Issue Count: 0`。
- `Tools/TokenUsage/*.ps1` のPowerShell構文チェック: OK。
- Scene/Prefab差分は大きいため本文diffは読まず、`git status`、対象diff、Compile、Reporterで確認した。

## 重要ルール

- ユーザーへの説明、作業報告、Obsidian記録は日本語で行う。
- 通常作業開始時のObsidian外部記憶読み込みは行わない。履歴確認・記録・締め作業を明示された時だけ使う。
- Scene/Prefab/HUDはEditor調整を尊重し、Runtimeで既存配置やSpriteを固定値へ戻さない。
- ゲーム実行中にGameObject/UI/静的Visualを新規配置・生成・差し替えしない。静的オブジェクトはSceneへ直接配置、動的オブジェクトはPrefab化して参照から生成する。
- スキルツリー、HUD、建造メニューなどのアイコンや `Source Image` はScene/Prefab上の参照を正とし、RuntimeコードでSpriteを差し替えない。
- 建造物、敵、プレイヤー、Projectileの見た目サイズはScaleではなく元画像加工で合わせる。Prefab/子VisualのScaleは原則 `1`、Rotation X/Yは `0`、必要なProjectile向きだけRotation Zを許容する。
- 敵歩行アニメーションは、元画像を変形して作るのではなく、向き別・歩行フレーム別に「その向きを向いたキャラ画像」を生成/用意する。
- 画像透過では背景に接続した黒だけを透過し、オブジェクト内部の黒を抜かない。
- 既存の未コミット変更はユーザーまたは前作業のものとして扱い、勝手に戻さない。

## トークン集計/節約

- 作業開始は `Tools/TokenUsage/start-task-token-check.ps1 -Task "<依頼内容>" -UiPercent <開始%> [-BudgetTokens <推定枠tokens>]` を優先する。
- 作業終了は `Tools/TokenUsage/end-token-check.ps1 -CurrentPercent <現在%>` を使う。
- レポート外消費は `Tools/TokenUsage/record-untracked-usage.ps1` で手動記録する。
- 日別確認は `Tools/TokenUsage/token-report-summary.ps1 -Path TokenReports/YYYY-MM-DD.jsonl -Top <件数>` を使う。
- Heavyベンチは明示時だけ実行する。

## 次チャットの推奨入口

1. `AGENTS.md` を読む。
2. このノートの「現在の状態」「直近検証」「重要ルール」だけ読む。
3. 必要なら `TokenReports/UnityReports/skill-tree-layout-20260626-122758.md` を確認する。
4. 次の作業は、実プレイ確認後のStage 3/4敵サイズ・弓矢射程/サイズ・スキルツリー表示・建造物破壊表示の微調整から着手しやすい。