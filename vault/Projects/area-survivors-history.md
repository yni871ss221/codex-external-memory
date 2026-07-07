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

## 2026-06-25

- `4ba7f50` Update HUD and weapon progression をAreaSurvivors本体へコミットし、`origin/feature/02_GameSystemUpdate` へpushした。
- ロビーの建造画面導線と建造モード起動を削除し、ゲーム開始導線を現仕様へ寄せた。
- ゲームHUDをScene配置前提で再整理し、エリア塗り状況上部パネル、トークン/塗りパネル背景、近接時透明化、プレイヤー/武器ステータス表を調整した。
- 武器ステータスはスラッシュ/弓/火の玉のパネルをScene上に置き、未取得武器は中身を空表示、取得後にアイコン/名称/4項目ステータスを表示する仕様へ変更した。
- HUD追加をRuntime生成してしまった再発ミスを受け、`Docs/AgentRules/ui-and-hud.md` と外部メモリへ「HUD新規生成禁止、Scene配置と既存参照更新のみ」を再記録した。
- 火の玉は進行方向へ飛び、敵衝突または射程到達で爆発する仕様へ変更。道中/爆発範囲には塗りが発生し、中心塔/バリスタ攻撃は塗りなしダメージのみとした。
- 中心塔以外の建造物セルにも敵用衝突判定を持たせ、プレイヤーとは衝突しない形へ整理した。
- 壁を1x1セル画像へ差し替え、通常/石壁アップグレード画像の背景切り抜きと `Sprites/Generated` 取り込みを行った。
- 固定配置建造物を仕様画像に合わせ、壁/バリスタ/中心塔の配置を整理した。
- スキルツリーは仕様画像を「配置・No対応・スキル一覧」として扱い、ジャンルパネルを維持したままノード/接続/スキル内容を差し替える運用へ変更した。以後のメンテ用に `area-survivors-skill-tree-maintenance` skill を作成済み。
- エリート出現率UPの旧ロジックを廃止し、0:30/1:30時点のエリート出現数UPとして処理する仕様へ変更した。
- レベルアップ画面は、武器Lv上昇から「新武器獲得」または「取得済み武器の個別ステータス強化」へ変更。3枠が埋まるまでは未取得武器が候補に出現し、埋まった後は取得済み武器の4項目強化のみ出現する。
- 直近検証: `rtk unicli exec Compile` 成功、`0 errors / 0 warnings`。`rtk unicli exec Console.GetLog` ログ0件。`git diff --check -- Assets\AreaSurvivors\Scripts Assets\AreaSurvivors\Editor Docs\AgentRules` 問題なし。

## 2026-06-26

- 建造物破壊画像を壁/バリスタ/監視塔の通常・アップグレードに割り当て、Prefab/Scene参照ベースで破壊時に表示されるよう整理した。Scale調整は禁止し、画像加工でセルサイズに合わせる方針を強化した。
- 建造物スキルNo1/No5で壁/バリスタを出現、No12/No13でNo1/No5配置分のみアップグレードする仕様へ変更した。中心塔No6アップグレードも実装した。
- スキルツリーアイコンをScene上の参照として差し替え、RuntimeでのSprite差し替えを行わないルールを再確認した。
- 不要になった門を削除し、Prefab/Sprite/TilePalette/実装参照の残骸整理を実施した。
- Stage 3（スケルトン/スケルトンナイト/リッチ）とStage 4（リザード/リザードマン/ドラゴン）を追加した。ロビーにはStage 3テスト導線を追加済み。
- Spineは試行後、素材分割とセットアップ負荷が高いため採用を一旦中止。導入済みランタイムは残し、プレイヤーへの埋め込み実装は削除した。
- 敵/プレイヤーのScaleとRotation補正を見直し、PrefabのScale `1`、Rotation `0` を基本に戻した。横向き歩行フレームの膨らみはフレーム幅/Importer側を揃えて修正した。
- 弓矢は射程内ターゲットのみを対象にし、複数本は近い順に別ターゲットへ飛ぶ仕様へ変更した。初期射程は約10セル、プレイヤー矢はバリスタ矢と別Prefab/画像に分離してサイズ調整した。
- トークン負荷対策として `rule-router.ps1` を強化し、`start-task-token-check.ps1` を追加。作業開始時にルール選択と開始マーカーを同時に扱えるようにした。
- `SkillTreeLayoutReporter` を追加し、`run-unity-report.ps1 -Report skill-tree-layout` でスキルツリーの配置/参照/接続を検出できるようにした。最新レポートはIssue 0。
- `GameManager` から武器HUDバインド/更新を `WeaponHudPanelBinding` へ分割した。
- 直近検証: `unicli exec Compile` 成功、`0 errors / 0 warnings`。`skill-tree-layout` レポート実行成功、Issue 0。PowerShell構文チェックOK。
## 2026-06-30

- BGM/効果音の導入、音量初期値/倍率調整、ゲーム終了時BGM停止を実装した。
- タイトル/オプション/ロビー/一時停止/ゲーム終了などのUIをScene配置へ寄せ、タイトルとゲームオーバーには段階表示アニメーションを追加した。
- プレイヤー/敵Colliderを足元BoxCollider基準へ変更し、壁下スタックはログ調査で原因を確定して修正した。建造物HPバー、アウトライン/シルエットのPrefab参照化も実施した。
- スキルツリーでは弓/ファイアボール/シールド/追加7武器をアンロック式に変更し、武器3枠上限、取得順HUD、武器図鑑、武器タイプアイコンを追加した。
- 建造物では監視塔4隅出現、外周壁②追加/アップグレードを仕様画像に合わせて実装した。
- ゲーム終了画面をScene配置へ移行し、ランリザルトの段階表示、効果音、到達ステージ表示を追加した。
- Gameplay Test Launcher Sceneを追加し、Stage 2〜4開始と武器別Stage 1開始をScene配置ボタンで起動できるようにした。
- 新武器としてシールド、旗、ブーメランソード、オーラソード、アローレイン、銃、フロスト、サンダーボールを実装し、HUD/レベルアップ/武器図鑑/効果音/特殊効果/テスト導線へ接続した。
- ブーメランソードはMultiSurvivors相当の投げ戻り挙動へ寄せ、剣画像をロジックで回転させる仕様にした。
- アローレインは固定位置・10セル先・楕円エリア・塗り・矢雨アニメーションへ変更し、横並びセット問題はフレーム画像を散布配置に再生成して修正した。
- フロストは足元固定発生、楕円エリア、霜が舞うアニメーションへ変更した。旗/アローレイン/フロストは斜め視点向け楕円表示にした。
- ブーメランソード/オーラソードの軌道、アローレインの発生エリアが青く塗られるよう `TileGrid` に楕円塗りAPIを追加した。
- 直近検証: `unicli exec Compile` 成功、`0 errors / 0 warnings`。`unicli exec Console.GetLog --logType Error --maxCount 30` は0件。
## 2026-07-02

- レリック機能を追加した。宝箱、所持レリック画面、レア度、被り時トークン変換、永続強化、HUD即時反映、テスト画面での取得/リセットを接続した。
- コモン/アンコモン/レアのレリック群と生成アイコンを追加し、出現率と被り変換トークンを仕様化した。
- 中心塔スキルに「ボス撃破時建造物復活」と「開幕宝箱出現」を追加し、ボス撃破時宝箱ドロップも実装した。
- 中心塔破壊/ボス初回撃破時にゲーム停止、カメラ低速移動、崩壊/潰れアニメーション、専用効果音、ゲーム終了遷移を行う演出へ変更した。
- 旗/フロスト/アローレイン/サンダーボールの楕円エリアを整理し、見た目、当たり判定、塗り範囲が一致するよう修正した。フロストは氷床と短い氷トゲの2フレームアニメーションへ差し替えた。
- 監視塔に範囲ダメージを追加し、スキル/アップグレードによるダメージ強化、Scene/Prefab正の範囲表示、地面優先の表示順へ整理した。
- ゲーム終了画面を3親パネル構成へ変更し、取得レリックと、中心塔/バリスタ/監視塔/武器枠ごとの総ダメージ・DPSを表示するようにした。
- ロビー倍速モード削除、LobbySceneBuilder削除、GameEnd系Editor生成メニュー無効化により、手調整済みSceneレイアウトが再生成で戻るリスクを下げた。
- リザードマン左右アニメ、ボスYソート、ゲーム終了時SE停止、HUD透明化、破壊建造物の開始時リセット、GoblinLord白背景、ノックバック耐性、ダメージ表記などの不具合を修正した。
- 直近検証: `unicli exec Compile` 成功、`0 errors / 0 warnings`。Consoleログ0件。

## 2026-07-06

- 敵全般の常時バウンドと、Stage 1〜4ボス専用攻撃を実装した。オークキング衝撃波、ゴブリンロード闇の玉、リッチ召喚魔法陣、ドラゴンブレス火球/爆発を追加し、各種画像・効果音・攻撃範囲・ターゲット処理を接続した。
- ボス/武器/レリックのテスト起動画面を拡張し、ボス出現方向指定、ステージ別開始、レリック取得状態切替、取得済み/未取得の視認性改善を追加した。
- ロビーを整理し、ステージ難易度、ステージ解放ポップアップ、MISSION COMPLETE、トークン/撃破/プレイ回数表示、戻る系アイコン統一、製品版でのテストボタン非表示を実装した。
- レリックHUD、ツールチップ、所持レリック一覧の並び順、発動中/非発動表示、武器装備条件つき活性判定、レジェンダリー4種と出現率/被りトークンを追加した。
- 塗りエリア到達トークン獲得スキルと、プレイヤープレハブ基準のトークン取得ポップアップを追加した。
- HUD/テスト画面/レリックUIの文字可読性やアイコンサイズを調整した。
- HUDレイアウトをRuntime/Editorで戻すミスを受け、既存HUDのRectTransform/Transform/Sprite/Collider/Scale/Rotation上書きを禁止するルールと `GameHudLayoutMutationGuard` を追加した。
- 直近検証: `git diff --check` は警告のみ。`unicli exec PlayMode.Exit` 成功。`unicli exec Compile` 成功、`0 errors / 0 warnings`。Console Error 0件。

## 2026-07-07

- スキルツリー大幅調整を開始し、プレイヤー/建造物/中心塔の配置、接続線、必要トークン、強化回数、強化内容を仕様に合わせて整理した。
- 永続強化画面をScene全体スキルツリー化し、固定ヘッダー、ツールチップ、ズーム/パン、パネル内レベル表示、MAXアウトライン表示、アンロック可能ノードのみ表示を実装した。
- オプション画面を一般/サウンド/グラフィック/コントロールのパネル構成へ変更し、ウィンドウ/フルスクリーン、解像度プリセット、カスタムサイズ表示を追加した。
- 終了時トークン獲得を見直し、固定獲得、敵10体撃破ごと、30秒経過ごとの獲得を追加。序盤で最初のスキルを獲得しやすくした。
- 難易度5の負荷調査と最適化を行い、敵アニメMesh作成、Meshキャッシュ、敵陣地塗り頻度間引き、敵アニメLOD、YSort/アウトライン更新抑制、接触判定最適化を実施した。
- ビルドで不足していたシェーダをAlways Included Shadersへ追加し、敵アウトライン、建物裏シルエット、ヒット時白フラッシュのビルド反映を修正した。
- Slash、TowerCannonball、ProjectileImpact、ProjectileExplosionHitboxをPrefab化し、弓/火球/砲弾の着弾演出・爆発HitboxをPrefab参照生成へ移行した。
- Arrow/PlayerArrowをBoxCollider2D化し、FireballのPrefab Sprite参照を修正。TowerCannonballはユーザー調整済みColliderとPrefabサイズをRuntimeで上書きしないようにした。
- 直近検証: `unicli exec Compile` 成功、`0 errors / 0 warnings`。Consoleログ0件。ユーザー実機確認で難易度5の負荷、陣地塗り見た目、YSort、矢/砲弾当たり判定は問題なし。
