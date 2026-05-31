---
date: 2026-05-31
tags: [project, unity, game, area-survivors]
project: area-survivors
related: [[Projects/codex-external-memory]], [[Knowledge/area-survivors-unity-workflow]], [[Decisions/2026-05-31-area-survivors-naming]]
---

# AreaSurvivors

## 概要

- 仮タイトルは「エリアサバイバー」。
- Unity 2022.3.62f3で開発する、2D斜め見下ろし型の領地防衛ローグライト。
- ヴァンサバ系の大量戦闘に、床の塗り替えと中央塔防衛を組み合わせる。
- ローカルパスは `D:\develop\unity_workspace\AreaSurvivors`。
- GitHubリモートは `https://github.com/yni871ss221/AreaSurvivors.git`。
- 開発ブランチは `feature/01_GameSystemInit`。
- 2026-05-31時点の最新Push済みコミットは `ca45728 Add initial game systems and presentation polish`。

## 実装済み

### ゲーム進行

- 中央塔を守りながら周囲から出現する敵を倒す基本ループ。
- プレイヤーが踏むと青、敵が踏むと赤になる床の領地システム。
- 敵領地上ではプレイヤー、プレイヤー領地上では敵が強く減速する。
- 敵撃破時の経験値オーブ、取得による経験値獲得、レベルアップ時のランダム3択強化。
- ラン終了時のトークン報酬と、ロビーから確認できる永続強化ツリー。
- マップを初期版から上下左右に広げ、障害物の配置範囲も拡張。

### キャラクターと戦闘

- ナイト、アーチャー、メイジの3キャラクター。
- ナイトは前方スラッシュ、アーチャーは自動追尾矢、メイジは着弾時に爆発する火球。
- プレイヤーと敵に上下左右の歩行ドット絵アニメーション。
- プレイヤー死亡時は膝を抱えて点滅し、一定時間後に全回復で復活。
- 敵死亡時は倒れてフェードアウトし、経験値オーブを落とす。
- 塔破壊時は崩壊アニメーション後にゲームオーバー画面へ遷移。
- 敵のHPゲージは非表示。
- ダメージ表記は `TextMesh` ベース。敵は黒縁の白文字、プレイヤーと塔は黒縁の赤文字。膨らんで縮んだ後、上昇しながらフェードアウトする。

### フィールド

- 草原の床は目が疲れにくい低ノイズなドット絵へ差し替え済み。
- 木、岩、池を画像生成したドット絵へ差し替え済み。
- 障害物同士が重ならないように配置。
- 木と岩は根元だけに当たり判定を置き、Y座標ソートでキャラクターが裏側に隠れられる。
- 敵は障害物の回避処理を持つ。

### バリスタ塔

- 中央塔から離れた北東、南東、北西、南西に4基配置。
- 初期状態は半透明。プレイヤーが接触している間だけ建造が進む。
- 建造中は下から上へ実体化し、ゲージとトンカチ振りアニメーションを表示。
- バリスタとトンカチは画像生成した透過ドット絵。
- 建造完了時は本体が一瞬明るく膨らみ、星形の光が回転しながらフェードする。
- 完成後は破壊されず、最寄りの敵へ通常矢の半分サイズの矢を自動発射する。

### 画面

- `01_Title`: タイトル、プレイ、オプション、終了。
- `02_Options`: 音量、キー設定。
- `03_Lobby`: キャラクター選択、ゲーム開始、強化画面への導線。
- `04_Upgrades`: 中央ノードから広がる永続強化ツリー。取得すると次のスキルを表示し、ホバーで説明を表示。
- `05_Game`: ゲーム本体。経験値バー、時間、撃破数、プレイヤーHP、塔HP、レベルアップ選択UI。
- `06_GameOver`: 生存時間、撃破数、総ダメージ、到達レベル、獲得トークン、取得強化、ロビーへ戻るボタン。
- タイトル、ロビー、強化画面には生成済み背景画像と装飾UIを適用。

## 主要ファイル

- `Assets/AreaSurvivors/Editor/AreaSurvivorsBootstrap.cs`: Scene、Prefab、UI、Spriteの初期構築と再生成。
- `Assets/AreaSurvivors/Scripts/Game/GameManager.cs`: ラン進行、経験値、ゲームオーバー集計。
- `Assets/AreaSurvivors/Scripts/Game/TileGrid.cs`: 床の塗り替え。
- `Assets/AreaSurvivors/Scripts/Game/BallistaTower.cs`: バリスタの建造、完成演出、自動攻撃。
- `Assets/AreaSurvivors/Scripts/Game/DamagePopup.cs`: ダメージ表記。
- `Assets/AreaSurvivors/Scripts/Game/YSort.cs`: フィールド上の前後関係。
- `Assets/AreaSurvivors/Scripts/UI/UpgradeScreen.cs`: 永続強化ツリー。

## 現在の状態

- `main` は初期版コミット `e68ca9a`。
- `feature/01_GameSystemInit` は `origin/feature/01_GameSystemInit` へPush済み。
- `AreaSurvivors` の作業ツリーはclean。
- Unity再生成、コンパイル、PlayModeのErrorログ0件まで確認済み。

## 次の確認候補

- Unityエディタ上でダメージ表記の実表示とサイズ感を目視確認する。
- バリスタ完成演出の見え方、建造時間、射程、発射間隔をプレイ感に合わせて調整する。
- オプション画面のキーコンフィグを実入力へ接続する。
