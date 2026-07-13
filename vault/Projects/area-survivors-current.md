---
title: AreaSurvivors Current
type: project-current
updated: 2026-07-13
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
- Worktree at closeout: 2026-07-09作業分をまとめてcommit/push予定。Scene/Prefabのユーザー調整を正として扱う。
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

## 2026-07-07 作業終了時点

- Current Branch: `feature/02_GameSystemUpdate`。
- スキルツリーの大幅調整を実施した。プレイヤー/建造物/中心塔スキルのNo配置、接続線、必要トークン、強化回数、強化内容を整理し、後半ネタバレ防止としてアンロック可能ノードと接続線のみ表示する仕様にした。
- 永続強化画面は背景パネルではなくScene全体をスキルツリーとして扱い、固定ヘッダー、所持トークン表示、ズーム/パン、ツールチップ、スキルパネル内レベル表示、MAX時アウトライン色を整備した。
- オプション画面を一般/サウンド/グラフィック/コントロールの縦スクロール構成へ整理し、フルスクリーン/ウィンドウ、解像度プリセット、手動リサイズ時カスタム扱いを追加した。
- トークン獲得仕様を調整した。終了時固定獲得、敵10体撃破ごとの獲得、30秒経過ごとの獲得を追加し、序盤で最初のスキルへ届くようにした。
- 難易度5の負荷調査と最適化を実施した。敵アニメMesh作成、Meshキャッシュ、敵陣地塗り頻度間引き、敵アニメ更新LOD、YSort/アウトライン更新抑制、接触判定最適化を進め、ユーザー確認で難易度5が重くない状態まで改善した。
- ビルド時に抜けていたシェーダをAlways Included Shadersへ追加し、敵アウトライン、建物裏シルエット、ヒット時白フラッシュがビルドでも出るよう整理した。
- Slash、TowerCannonball、ProjectileImpact、ProjectileExplosionHitboxをPrefab化した。弓/火球/中心塔砲弾の着弾演出と爆発HitboxはPrefab参照から生成し、RuntimeでGameObject構築しない方針へ寄せた。
- Arrow/PlayerArrowはBoxCollider2Dへ変更し、矢全体に当たり判定を持たせた。FireballはPrefab上のSprite参照を正しいGenerated Sprite GUIDへ修正した。TowerCannonballはユーザー調整済みColliderを正とし、RuntimeでScale/Colliderを上書きしない。
- ゲーム終了画面でレジェンダリーレリックの取得欄アイコンが出ない問題を修正した。
- 直近検証: `unicli exec Compile` 成功、`0 errors / 0 warnings`。`unicli exec Console.GetLog` は0件。ユーザー確認で難易度5の重さ、敵陣地塗り見た目、YSort、弓/砲弾当たり判定は問題なし。
- `git diff --check` はUnity YAML由来の `m_Name: ` / `m_EditorClassIdentifier: ` trailing whitespace を多数検出。Unity Scene/Prefabシリアライズ由来のため、今回は機械的整形せず既知警告扱い。

## 次チャットの推奨入口

1. `AGENTS.md` を読む。
2. このノートの「2026-07-07 作業終了時点」と `Knowledge/mistakes.md` の2026-07-07追記を確認する。
3. 次はビルド版で弓、Fireball、TowerCannonball、敵アウトライン、建物裏シルエット、ヒットフラッシュを通し確認するのが自然。
4. 攻撃Prefabを触る場合は、Sprite/Collider/ScaleはPrefabを正とし、Runtimeは進行方向Rotation Z、ステータス依存の爆発半径など必要最小限に限定する。

## 2026-07-09 作業終了時点

- Current Branch: `feature/02_GameSystemUpdate`。
- オプション画面をタイトル/ゲーム内で縦スクロール構成に整理し、一般/サウンド/グラフィック/コントロール、表示モード/ウィンドウサイズ、設定初期化、タイトル専用データ初期化ダイアログを実装した。
- キーボード/マウスとコントローラーのキーコンフィグを追加し、入力待ち方式、×決定/〇キャンセル、ゲーム中キャンセルで一時停止、音量選択中の左右1%変更、フォーカス自動追従を調整した。
- 全画面共通のUIフォーカス移動を見直し、画面外へフォーカスが消えにくく、マウス操作とパッド操作の優先を切り替えるよう整理した。マウススクロール時はスクロールを優先し、パッド移動時だけ追従する。
- スキルツリーに開幕レベルアップを追加し、画像生成アイコンを割り当てた。獲得済み回数に応じてゲーム開始時にレベルアップパネルを複数回表示する。
- 難易度アンロックを調整し、初回ボス撃破時は難易度1〜2解放、以後は難易度2/3/4ボス撃破で次難易度を解放しつつゲーム継続する仕様にした。
- トークン獲得ログをゲームフォルダ配下 `logs` に出力し、到達ステージ、ボスクリア情報、補助的なランタイム/Material診断ログを残すようにした。
- ビルド実行時の中心塔破壊クラッシュ調査から、建造物完成色のMaterial増殖を `MaterialPropertyBlock` / `sharedMaterials` へ置き換えて対策した。ログ上の使用メモリは大幅に改善した。
- 敵/建造物アウトラインを黒塗りつぶし方式へ寄せ、ヒット時白ハイライトと建物裏シルエットも同じ領域を使うよう調整した。シルエットは視認上カクつかない更新頻度へ戻した。
- ファイアボール軌道の床塗りを復旧した。監視塔破壊時の赤床は陣地消失による見え方で仕様上問題なしと判断した。
- スラッシュ攻撃範囲を初期時点から広げ、レベルアップごとの伸び幅を調整した。Prefab側の当たり判定/見た目を正としつつ横幅と距離のバランスを取った。
- オークキング衝撃波は倍率1の24ダメージへ戻し、固定値ダメージ追加フィールドは削除した。ゴブリンロード闇玉は多段Hitを考慮して1Hit 12ダメージ相当へ半減した。
- プレイヤー復活後の無敵を2秒にし、復活直後は床ペナルティも受けない。レベルアップごとにHP+10、移動速度+0.1、防御力+0.5を得るようにした。
- ゲーム終了画面は親パネル単位の段階表示へ変更し、ボス初回撃破時は崩壊アニメーション後にトークン/宝箱/レリック獲得を済ませてからリザルトへ遷移する。
- 日本語漢字が簡体字風に見える問題へ、Windowsの日本語フォントをRuntime/Editorプレビュー双方で適用する仕組みを追加した。
- 直近検証: 複数回 `unicli exec Compile` 成功。HUD Layout Mutation Guard 実行済み。ユーザー実機確認で、フォント文字化け、スラッシュ伸び幅、ヒット時優先度、シルエット、ファイアボール塗り、操作系の主要修正は概ね確認済み。
- 既知注意: `git diff --stat` 上、Scene/Prefab差分が大きい。ユーザーがEditorで調整したHUD/オプション/ロビー/スキルツリー配置を戻さないこと。

## 次チャットの推奨入口

1. `AGENTS.md` を読む。
2. このノートの「2026-07-09 作業終了時点」と `Knowledge/area-survivors-ui-navigation.md`、`Knowledge/mistakes.md` の2026-07-09追記を確認する。
3. 次はビルド版で長時間プレイし、`Build/logs/application.log` と `Build/logs/token_run_log.jsonl` を使ってトークン獲得量とクラッシュ再発有無を確認するのが自然。
4. UIを触る場合はScene/Prefab上の配置を正とし、Runtime/EditorセットアップでRectTransform、Sprite、Collider、Scale、Rotationを戻さない。

## 2026-07-10 作業終了時点

- Current Branch: `feature/02_GameSystemUpdate`。
- Asset全体を用途別フォルダへ整理し、Prefab、Runtime Script、Editor Script、生成画像、外部素材を移動した。未参照素材と一時Setup/Rebuild/Testメニューを削除し、複数回のユーザー実プレイ確認で問題なし。
- タイトル画面へクレジット、ゲームスタジオロゴ起動画面、アプリケーションアイコンを追加した。スタジオロゴはアプリ起動時の1回だけ表示し、タイトルへ戻る際は再表示しない。
- タイトル、強化、武器図鑑、所持レリック、ゲーム終了画面へ背景画像を追加した。ゲーム終了画面は敗北時とクリア時で背景を分けた。
- タイトル背景はユーザー提供の最終画像を正式採用した。タイトルScene上の既存レイアウトを正とし、位置を戻さない。
- 自陣と非自陣の境界へ青色境界線を追加した。敵陣の赤境界線は見た目確認後に取り下げ、青境界だけを残した。
- キーボード/マウスとパッドの入力モード切替、共通フォーカス表示、直感的な方向移動、スクロール追従、Dropdown、Slider、レベルアップ決定処理を共通化・修正した。
- レベルアップ画面へスキップとリロールを追加した。各ラン3回まで使用でき、残数をボタンへ表示し、0回で無効化する。スキップは強化を取らずに完了し、リロールはパネルを閉じず選択肢だけを再抽選する。
- スキップ/リロールのフォーカスは、Scene上の既存Image/Outlineだけで明るい背景と太い白アウトラインを表示する。RuntimeでUIやフォーカスVisualを生成しない。
- `.codex/config.toml` と役割別agent設定を追加したが、運用判断を見直し、サブエージェントはユーザーがその作業で明示指定した場合にだけ使うことを `AGENTS.md` に明記した。
- 直近検証: UnityのBee/Roslynレスポンスファイルを使ったC#コンパイル成功。`git diff --check` は改行警告のみ。HUD Layout Mutation Guardはスキップ/リロール初期実装時に合格。最終フォーカス調整後はAsset RefreshでUniCLIサーバーが停止し、再実行できていない。
- TODO: 次チャットでスキップ/リロールをマウス・パッド双方で操作し、各3回、残数0、開幕連続レベルアップ、明るい背景と太い白枠を確認する。Unity/UniCLI復帰後に必要ならHUD Layout Mutation Guardを再実行する。

## 次チャットの推奨入口（2026-07-10）

1. `AGENTS.md` を読む。サブエージェントはユーザーの明示指定がない限り使わない。
2. このノートの「2026-07-10 作業終了時点」と `Knowledge/mistakes.md` の2026-07-10追記だけ確認する。
3. 最初にレベルアップ画面のスキップ/リロールをPlay Modeで確認する。
4. Asset整理後の移動・削除はユーザー確認済み。旧パスへ戻したり、削除済みSetup/Rebuild/Testメニューを復元しない。


## 2026-07-13 作業終了時点

- Current Branch: `feature/02_GameSystemUpdate`。
- 強化画面にスキル接続線の伸長と到達先パネルのバウンス、レベルアップ画面に武器アイコン枠、`NEW`装飾、レリック取得風の背面光、生成背景を追加した。
- ロビー開始時の暗転とゲーム開始時の明転を実装し、開始時レベルアップ等は明転完了後に実行する。ゲーム内アナウンスは全幅パネル上を左から中央、停止後に右へ流れる。
- バリスタ、中心塔、監視塔は攻撃成立時に上方向へ膨らんで戻るスクワッシュアニメーションを行う。
- 日英ローカライズを全画面へ展開した。武器HUD、武器名、レリック、スキル、レベルアップ、オプション等は言語変更やデータ更新イベント時だけ更新し、毎フレーム翻訳しない。
- `Localization Coverage` Validatorを追加し、Production Scene、UI Prefab、スキル説明、武器説明に日本語残存がないことを検証できる。
- スタジオロゴはアプリ起動セッションの最初だけ表示する。タイトルへ戻った際やEditorでLobbyから開始した場合に再表示されない。
- 6枚構成のOpening StoryをTitle Sceneと保守Prefabへ実装した。フェード＋連続スライド、任意入力スキップ、36秒BGM、テスト起動メニューからの再生を持つ。
- Opening Story画像は01/05基準のコミカルなドット絵へ統一し、変更前画像を `External/UI/OpeningStory/Archive/BeforeStyleUnification_20260712` に保存した。
- Opening Storyの通常起動再生は `RuntimeFeatureFlags.PlayOpeningStoryOnApplicationLaunch = false` で一時無効。Scene、画像、BGM、テスト再生機能は残している。
- 「初期スラッシュ削除」取得時、空き武器枠があればレベルアップ候補にスラッシュが `NEW` として出現し、選択するとLv1で再取得できる。
- ユーザーが英語タイトルのTitle Label幅を修正した。翻訳値は `AREA SURVIVORS` だが、旧430px幅では折り返された2行目が切れて `AREA` だけ表示されていた。
- Steam公開準備では、まずSteamworks登録・Steam Direct費用支払い・Coming Soonページ公開を先行し、生成AI使用はContent SurveyのPre-Generatedとして申告する方針。

## 直近検証（2026-07-13）

- `unicli exec Compile`: 成功、`0 errors / 0 warnings`。
- `Area Survivors/Validate/HUD Layout Mutation Guard`: 合格。
- `Area Survivors/Validate/Localization Coverage`: 全Production Scene、UI Prefab、スキル説明、武器説明で合格。
- `unicli exec Console.GetLog --logType Error --maxCount 30`: Error 0件。
- `git diff --check -- Assets/AreaSurvivors/Scripts Assets/AreaSurvivors/Editor Docs/AgentRules AGENTS.md`: 問題なし。

## 次チャットの推奨入口（2026-07-13）

1. `AGENTS.md` とこのセクションを読む。
2. 通常起動で `スタジオロゴ → タイトル` となりOpening Storyが再生されないことを確認する。Storyはテスト起動メニューから確認可能。
3. 「初期スラッシュ削除」取得データで、レベルアップ候補へスラッシュの `NEW` が出ることを実プレイ確認する。
4. Steam Coming Soonページ向けに、正式タイトル、価格、カプセル画像、1920x1080ゲームプレイスクリーンショット、日英説明文を準備する。