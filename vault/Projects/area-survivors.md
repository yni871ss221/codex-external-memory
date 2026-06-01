---
date: 2026-05-31
tags: [project, unity, game, area-survivors]
project: area-survivors
related: [[Projects/codex-external-memory]], [[Knowledge/area-survivors-unity-workflow]], [[Decisions/2026-05-31-area-survivors-naming]]
---

# AreaSurvivors

## 2026-05-31 Level-up keyboard navigation
- `GameManager.ShowLevelUp()` selects the first upgrade button through `EventSystem` whenever the level-up panel opens.
- Closing the panel clears the selected UI object so the next level-up reliably starts from the first choice.
- Existing `InputManager.asset` bindings already provide Up/Down and W/S navigation through `Vertical`, plus Enter and Space confirmation through `Submit`.
- Verified with UniCLI: compile errors `0`, warnings `0`; first button selected after opening; Down navigation selects the second button; submit closes the panel and resumes time; PlayMode error logs `0`.

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
- 2026-06-01に、ナイト、アーチャー、メイジ、敵イノシシの歩行Spriteをカジュアルな太縁デザインへ差し替えた。既存作品のキャラクターや正確な画風は複製せず、シンプルな形、明るい色、コミカルな比率、ゲーム中の判別しやすさを採用した。
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
- 2026-06-01に、草原タイル、木、岩、池、中央塔、バリスタ、縦横の柵、トンカチ、経験値オーブ、矢、火球、スラッシュ、完成時の光を、キャラクターと揃えたカジュアルな太縁デザインへ差し替えた。
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

### 防衛柵

- 4基のバリスタ塔の間を埋める外周壁として、敵の接近を防ぐ木製パリセード柵を4基配置。
- 各辺は1枚の連続した長い柵画像で構成する。
- 横長柵と縦配置専用柵は別画像。縦柵は横柵の回転ではなく、見下ろし視点に合う奥行き付きの専用Spriteを使う。
- 縦配置専用柵は折れや曲がりのない、一直線の縦長Spriteへ差し替え済み。
- 角のバリスタ塔の横には、プレイヤーが通過できる隙間を残す。
- 柵画像は新規生成した透過ドット絵Spriteを使用。
- 初期状態と破壊後は半透明。プレイヤーが接触している間だけ建造が進む。
- 建造中はバリスタと同様に下から上へ実体化し、ゲージとトンカチ振りアニメーションを表示。
- 完成時はHP `70` を持ち、敵との接触中にダメージを受ける。
- HPが0になると破壊され、当たり判定が消える。プレイヤーが再度触れると再建築できる。
- 完成した柵は敵を遮るが、プレイヤーは通過できる。完成時に柵とプレイヤーのColliderペアだけ衝突を無視する。
- 建築Triggerと敵を遮るColliderは見た目に合わせて同寸法にする。横柵は `3.9 x 0.68`、縦柵は `0.34 x 3.9`。
- プレイヤーが柵本体へ触れている間だけ建築が進み、敵も柵本体へ接触している間だけダメージを与える。
- 柵はHPを持つが、HPバーは表示しない。

### 画面

- `01_Title`: タイトル、プレイ、オプション、終了。
- `02_Options`: 音量、キー設定。
- `03_Lobby`: キャラクター選択、ゲーム開始、強化画面への導線。
- `04_Upgrades`: 中央ノードから広がる永続強化ツリー。取得すると次のスキルを表示し、ホバーで説明を表示。
- `05_Game`: ゲーム本体。経験値バー、時間、撃破数、プレイヤーHP、塔HP、レベルアップ選択UI。
- `06_GameOver`: 生存時間、撃破数、総ダメージ、到達レベル、獲得トークン、取得強化、ロビーへ戻るボタン。
- タイトル、ロビー、強化画面には生成済み背景画像と装飾UIを適用。
- 2026-06-01に、タイトル、ロビー、強化画面の背景もカジュアルな草原・拠点・魔法工房のイラストへ差し替えた。Unity UIを重ねやすいよう、各画面の主要領域には余白を残している。

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
- 2026-05-31: 防衛柵追加後もUnity再生成、コンパイル、PlayModeのErrorログ0件を確認済み。
- 防衛柵は4基生成されることを確認済み。自動検証で完成時HP `70`、破壊後のブロッカー無効化、再建築後のHP回復とブロッカー再有効化を確認済み。
- 縦柵もTransformを回転せず配置するため、HPバーは他の設備と同じ左右方向で表示される。
- 自動検証で、完成した柵はプレイヤーColliderとの衝突を無視し、敵Colliderとの衝突は維持することを確認済み。
- 自動検証で、建築Trigger外では進捗 `0`、柵本体への接触中だけ進捗が増加することを確認済み。
- 自動検証で、敵が柵から離れている間はHP `70` のまま、接触後だけHP `66` へ減少することを確認済み。

## 次の確認候補

- Unityエディタ上でダメージ表記の実表示とサイズ感を目視確認する。
- バリスタ完成演出の見え方、建造時間、射程、発射間隔をプレイ感に合わせて調整する。
- オプション画面のキーコンフィグを実入力へ接続する。

## 2026-06-01 フィールドオブジェクトの方針

- 木、石、池、塔、バリスタ、柵、トンカチ、経験値オーブは、細かな陰影を減らしたアイコン調の画像へ差し替える。
- 遠くから形を識別できるよう、太い輪郭と大きな単色面を優先する。
- 塗り床セル `0.7 x 0.385` ワールド単位を配置基準とする。木、石、池の候補位置も塗り床セルの整数倍へ揃える。
- 1セルにつき障害物は最大1個とし、中央の塔周辺には空白を確保する。
- 中央塔とバリスタ塔は `2 x 2` セル、柵は横 `6 x 1` セル・縦 `1 x 6` セルとして、画像キャンバス、Collider、配置位置を調整する。
- 関連する恒久方針: [[Preferences/game-art-style]]

## 2026-06-01 Tile Palette移行

- 座標値とスケールだけで見た目を揃える方式をやめ、Unity標準の `Grid + Tilemap + Tile Palette` 構成へ移行する。
- Game Sceneには `Environment Grid` 配下に `Ground Tilemap`、`Paint Tilemap`、`Object Tilemap` を配置する。
- 草地9216枚は `Ground Tilemap`、木・石・池44枚は `Object Tilemap` にTileとして配置する。
- 木・石・池のColliderはTileの根元位置に対応する別GameObjectとして残し、敵の障害物回避を維持する。
- 中央塔、バリスタ、柵は動的設備のためPrefabのまま維持するが、配置位置は同じTilemapセル中心から取得する。
- `Assets/AreaSurvivors/TilePalette/EnvironmentPalette.prefab` と9種類のTileアセットを追加する。

## 2026-06-01 柵のTilemap向け再調整

- 横柵と縦柵はTilemap配置を前提に別々の画像として再生成する。
- 横柵は6セル幅の低い連続柵、縦柵は下端セルから奥行き方向へ伸びる6セル長の連続柵として扱う。
- 両Spriteのpivotを下端中央 `{x: 0.5, y: 0}` に設定する。
- 横柵は塔の上下 `±6` 行へ配置し、不透明領域で計測した塔との空白を上下とも `0.7709` ワールド単位へ揃える。
- 縦柵は左右 `±6` 列、下端 `-3` 行へ配置し、Collider・建築ゲージ・トンカチ・完成演出を占有6セルの中央へ補正する。

## 2026-06-01 柵の配置拡張

- 上側の横柵は背面方向で塔に近く見えるため、`+7` 行へ移動して視覚上の距離を広げる。
- 下側の横柵は `-6` 行を維持する。
- 左右の縦柵は上側バリスタ付近まで届くよう、継ぎ目のない12セル長画像として再生成する。
- 縦柵は左右 `±6` 列、下端 `-4` 行から上端 `+7` 行まで配置する。
- 縦柵Colliderの高さは `4.62`、中心補正は `2.1175` とする。建築ゲージ、トンカチ、完成演出も同じ中心へ揃える。

## 2026-06-01 バリスタ間を結ぶ外周柵

- 柵は塔基準の短い壁ではなく、4基のバリスタを四隅として結ぶ外周として配置する。
- バリスタ配置 `x = ±6`, `y = ±8` セルに合わせ、横柵は12セル幅で `y = ±8` に配置する。
- 縦柵は16セル高で `x = ±6`, 下端 `y = -8` から上端 `y = +8` まで配置する。
- 横柵は12本支柱、縦柵は16本支柱の継ぎ目がない画像として再生成する。
- Colliderは横幅 `8.4`、縦高 `6.16`、縦中心補正 `3.08` とする。
- プレイヤー初期位置は下柵と重ならないよう、塔の下 `-3` 行へ変更する。
