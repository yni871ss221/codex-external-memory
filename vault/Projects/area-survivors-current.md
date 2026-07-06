---
title: AreaSurvivors Current
type: project-current
updated: 2026-07-06
tags:
  - project/area-survivors
  - codex/current
related:
  - "[[area-survivors-history]]"
  - "[[area-survivors-unity-workflow]]"
  - "[[area-survivors-attack-visuals]]"
---

# AreaSurvivors Current

## 現在の状態

- Repository: `C:\Develop\unity_workspace\AreaSurvivors`
- Unity: `2022.3.62f3`
- Main Scene: `Assets/AreaSurvivors/Scenes/05_Game.unity`
- Gameplay Test Scene: `Assets/AreaSurvivors/Scenes/90_GameplayTest.unity`
- Current Branch: `feature/02_GameSystemUpdate`
- Worktree at closeout: 2026-06-30作業分をまとめてcommit/push予定。`tmp/` と `__pycache__/` は `.gitignore` へ追加し、コミット対象から除外する。
- Reboot status: Phase 0〜7完了後の追加UI/音声/コライダー/建造物/武器拡張フェーズ。

## 2026-06-30 完了内容

- BGM/効果音を導入し、タイトル/オプション、ロビー/強化、ゲーム通常、ボス、武器発射、ヒット、経験値、レベルアップ、ゲーム終了などへ割り当てた。音量初期値とBGM/SE倍率も調整した。
- AudioManagerのEditor実行時 `DontDestroyOnLoad` エラーを修正し、ゲーム終了画面遷移時にゲーム中BGMが残らないようにした。
- 一時停止メニューを追加し、Escで停止、オプション、諦める確認、再開を実装した。オプション画面はタイトル/ゲーム内で共有し、Scene配置へ寄せた。
- タイトル画面、ゲーム終了画面、オプション、HUD関連をRuntime生成からScene配置へ移行し、タイトル/ゲームオーバー演出アニメーションを追加した。
- プレイヤー/敵Colliderを足元BoxCollider基準へ調整し、壁下からのスタックはTileGridの移動判定ロジックを調査して修正した。調査ログは削除済み。
- 敵アウトライン/シルエット/輪郭表示をPrefab参照ベースへ移行し、ランタイムでは色や状態変更中心にした。
- 建造物HPバーを追加し、満タン時非表示、被ダメージ時だけ頭上に表示されるよう調整した。
- スキルツリーで弓/ファイアボール/シールド/追加7武器をアンロック式へ変更し、武器3枠上限と取得順HUD表示を整理した。
- 建造物スキルとして監視塔4隅出現、外周壁②追加/アップグレードを仕様画像に合わせて実装・配置調整した。
- 武器図鑑Sceneを追加し、ロビー導線、ロック表示、武器タイプアイコン、特徴/初期ステータス/特殊効果表示を実装した。
- 武器タイプ（近接/遠距離/魔法/防御）と画像生成アイコンを追加し、武器図鑑、レベルアップ画面、HUDに反映した。
- 特殊効果を追加した。スラッシュ/弓/ファイアボール/シールド/追加武器はエリア占有率に応じて発動し、HUDの発動後パラメータは赤表示される。
- シールド、旗、ブーメランソード、オーラソード、アローレイン、銃、フロスト、サンダーボールを追加した。各武器のPrefab/画像/効果音/ステータス/HUD/レベルアップ/武器図鑑/テスト起動を接続済み。
- Gameplay Test Launcher Sceneを追加し、ロビーから遷移できるテスト画面にStage 2〜4開始と武器別Stage 1開始ボタンを配置した。
- ブーメランソードはMultiSurvivors相当の投げ戻り挙動へ寄せ、実際に剣画像を回転させる仕様へ変更した。
- アローレインは固定位置に出現し、10セル先へ発生、楕円エリア、円内への塗り、矢雨アニメーションを追加した。横並びセットに見えた原因はフレーム画像自体だったため、散布配置の8フレームへ再生成した。
- フロストはプレイヤー足元に固定発生し、楕円エリアと霜が舞うアニメーションへ変更した。
- 旗/アローレイン/フロストのエリア表示を斜め視点向けの楕円へ変更した。旗の初期範囲は半径3セルへ調整した。
- ブーメランソードとオーラソードの攻撃軌道、アローレイン発生エリアが青色に塗られるよう `TileGrid.PaintEllipse` 等を追加した。
- サンダーボールに攻撃範囲の楕円表示を追加した。

## 残す互換/注意

- Static/Visual/UI/SkillTreeアイコンはScene/Prefab参照を正とする。Runtimeで新規配置・生成・Sprite差し替えをしない。
- 動的攻撃/Projectile/AreaはPrefab参照から生成する。見た目調整はPrefab/画像/Importer側を正とし、ランタイムで固定Scale/Rotationへ戻さない。
- 武器HUDは最大3枠。新武器候補は3枠が埋まったら出さず、取得済み武器アップグレード候補にする。
- アローレインのような多フレーム攻撃演出は、コードで位置ブレを足す前に、フレーム画像そのものが横並び/セット化していないか確認する。
- 生成済みゲーム用Spriteは `Assets/AreaSurvivors/Sprites/Generated` に統一し、`Assets/AreaSurvivors/Resources/Generated` は新規追加しない。
- `tmp/` と `__pycache__/` はコミット対象外。

## 直近検証

- `unicli exec Compile`: 成功、`0 errors / 0 warnings`。
- `unicli exec Console.GetLog --logType Error --maxCount 30`: `logs: []`、`totalCount: 0`。
- `git diff --check -- Assets\AreaSurvivors\Editor\AdvancedWeaponsSetup.cs Assets\AreaSurvivors\Scripts\Game\ArrowRainAreaVisual.cs Assets\AreaSurvivors\Prefabs\Weapons\ArrowRainArea.prefab`: 問題なし。
- Scene/Prefab差分は大きいため本文diffは読まず、status/stat、対象ファイル確認、Unity Compile/Consoleで確認した。

## 次チャットの推奨入口

1. `AGENTS.md` を読む。
2. このノートの「現在の状態」「直近検証」「残す互換/注意」だけ読む。
3. 次は実プレイで追加武器（特にアローレイン、フロスト、サンダーボール、ブーメランソード）の見た目・当たり判定・塗り範囲を微調整するのが自然。
4. 必要なら `Assets/AreaSurvivors/Scenes/08_GameTestLauncher.unity` から武器別Stage 1確認を行う。
## 2026-07-02 作業終了時点

- Current Branch: `feature/02_GameSystemUpdate`。
- レリック機能を追加した。宝箱取得、所持レリック画面、レア度、被り時トークン変換、永続効果、ゲーム中即時反映、テスト画面での取得/リセットを実装済み。
- レリックはコモン/アンコモン/レアの出現率と被りトークンを持ち、既存5件に加えて多数の効果・生成アイコンを追加した。
- 中心塔スキルに「ボス撃破時建造物復活」と「開幕宝箱出現」を追加し、開始時宝箱はスキル獲得時のみ出現する仕様にした。ボス撃破時の宝箱ドロップも実装済み。
- ボス初回撃破と中心塔破壊ではゲーム停止、カメラの低速移動、対象の潰れ/崩壊アニメーション、効果音再生後にゲーム終了画面へ遷移する。
- 旗/フロスト/アローレイン/サンダーボールの楕円エリアは、表示・当たり判定・塗り範囲の基準をそろえた。VisualのRotation Xは0を正とし、斜め視点補正で固定回転を入れない。
- 監視塔は自動塗りに加えて楕円範囲ダメージを持つ。範囲表示はScene/Prefab側の設定を正とし、RuntimeでSortingやアウトラインを固定上書きしない。
- ゲーム終了画面は、ランリザルト、取得レリック、総ダメージ/DPSの3親パネル構成に変更。中心塔/バリスタ/監視塔/武器枠ごとの総ダメージとDPSを集計する。
- ロビー倍速モードは不要になったため削除済み。`LobbySceneBuilder` など、レイアウトを旧状態へ戻す恐れがあるEditor生成ツールも削除/無効化済み。
- 不具合修正として、リザードマン左右アニメ、ボスのYソート、ゲーム終了時SE停止、HUD透明化、破壊建造物の開始時リセット、GoblinLord白背景、ノックバック耐性、ダメージ表記のオーバーキル表示などを対応済み。
- 直近検証: `unicli exec Compile` 成功、`0 errors / 0 warnings`。`unicli exec Console.GetLog --logType All --maxCount 100 --stackTraceLines 2` は0件。

## 次チャットの推奨入口

1. `AGENTS.md` を読む。
2. このノートの「2026-07-02 作業終了時点」と `Knowledge/mistakes.md` の2026-07-02追記だけ確認する。
3. Scene/Prefab上のユーザー調整を正として扱い、RuntimeやEditorメニューで既存UI/Visualの位置・サイズ・Rotation・Sortingを戻さない。

## 2026-07-06 作業終了時点

- Current Branch: `feature/02_GameSystemUpdate`。
- 敵全般に常時縦Scaleのバウンドアニメーションを追加し、0.5秒で膨らむ→0.5秒で戻るテンポへ調整した。
- Stage 1〜4ボスに専用攻撃を追加した。オークキングはターゲット方向へ連続衝撃波、ゴブリンロードは闇の玉、リッチは召喚魔法陣からスケルトン/スケルトンナイト召喚、ドラゴンは溜めブレス火球と爆発を行う。
- ボス攻撃画像・効果音・赤色攻撃範囲表示・テスト起動導線を整備し、テスト画面からステージ/ボス出現方向/武器/レリック状態を確認できるようにした。
- ロビーを整理し、テスト用ボタンの製品版非表示、ステージ難易度1〜5、クリア後ステージ解放ポップアップ、MISSION COMPLETE演出、トークン/累計撃破/プレイ回数表示、戻る系アイコン統一を実装した。
- 中心塔スキルに塗りエリア500到達ごとのトークン獲得を追加し、プレイヤープレハブ基準のトークン取得ポップアップと効果音を実装した。
- HUDに所持レリック横並びパネル、発動中アウトライン/バウンス、非発動白黒、ツールチップを追加した。所持レリック一覧とHUD表示順はレア度順かつ強化ジャンル順へ整理した。
- レリックにレジェンダリーを追加し、出現率/被りトークンを `Common 50%/5`、`Uncommon 30%/10`、`Rare 15%/30`、`Legendary 5%/50` に変更した。近接3種、遠距離3種、魔法3種、累計撃破1000ごとの攻撃力上昇レリックを追加した。
- HUD/テスト画面の文字可読性、レリックアイコンサイズ、取得済み/未取得表示、武器装備時のみ活性扱いにするレリック判定を調整した。
- HUDレイアウトをRuntime/Editorメニューで固定値へ戻す処理を削除・抑止し、`GameHudLayoutMutationGuard` と `Docs/AgentRules/ui-and-hud.md` の禁止ルールを強化した。
- 直近検証: `git diff --check -- Assets\AreaSurvivors\Scripts Assets\AreaSurvivors\Editor Docs\AgentRules AGENTS.md` は警告のみ。`unicli exec PlayMode.Exit` 成功。`unicli exec Compile` 成功、`0 errors / 0 warnings`。`unicli exec Console.GetLog --logType Error --maxCount 30` は0件。

## 次チャットの推奨入口

1. `AGENTS.md` を読む。
2. このノートの「2026-07-06 作業終了時点」と `Knowledge/mistakes.md` の2026-07-06追記を確認する。
3. HUD/ロビー/テスト画面/所持レリック画面の配置はSceneを正とし、RuntimeやEditorメニューでRectTransform、Scale、Rotation、Spriteを固定値へ戻さない。
4. 次に自然なのは、製品版ビルド確認、ボス攻撃の実プレイ微調整、レリック効果の数値バランス調整。
