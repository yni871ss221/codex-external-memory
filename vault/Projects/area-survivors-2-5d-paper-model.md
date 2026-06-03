---
date: 2026-06-02
tags: [project, unity, game, area-survivors, 2-5d]
project: area-survivors
related: [[Projects/area-survivors]], [[Preferences/area-survivors-2-5d-style]], [[Knowledge/area-survivors-tilemap-tint]]
---

# AreaSurvivors 2.5D紙モデル表示

## 実装内容

- 既存の2D移動、Collider、領地塗りロジックを維持し、描画だけを斜め固定Perspectiveカメラへ移行した。
- `PaperBillboard` を追加し、キャラクター、敵、塔、バリスタ、柵、障害物、経験値オーブ、Projectile、ワールドUIをカメラへ正対させた。
- `Object Tilemap` は配置データとして残し、木、石、池の画面表示は同じセルに置いた紙モデルVisualへ切り替えた。
- カメラはPerspective、FOV `50`、角度 `-40`、追従offset `(0, -12, -14)` とした。
- 紙モデルの足元へ地面平面に寝た楕円影を追加した。
- SlashとProjectileは紙モデル表示を維持したまま、攻撃方向へrollする。
- プレイヤー、敵、塔の死亡演出は子VisualのRendererと`PaperBillboard.rollDegrees`を使うよう追従修正した。
- 領地TileのTintが白く表示される問題は、Tile配置後に`TileFlags.None`を設定して解消した。

## 検証

- UniCLI Compile: `0 errors / 0 warnings`
- 24秒PlayMode: Errorログ `0件`
- Game Viewスクリーンショットで奥行き表示、敵の進入、青赤の領地Tintを確認した。

## 2026-06-02 Quad Meshへの移行

- 紙モデルVisualを`SpriteRenderer`から`PaperMeshVisual`へ移行した。
- `PaperMeshVisual`は`MeshFilter + MeshRenderer`へQuad Meshを構築し、元Spriteの画像を透過TextureとしてMaterialへ指定する。
- SpriteのpivotとtextureRectから頂点とUVを生成するため、アニメーション用Sprite差し替え後も接地位置と透過を維持する。
- Quad MeshとMaterialは`HideAndDontSave`として一時生成し、Game Sceneへ埋め込まない。
- キャラクター、敵、塔、バリスタ、柵、木、石、池、弾、経験値オーブ、Slash、地面影をQuad Mesh表示へ統一した。
- 2DのRigidbody、Collider、領地塗りロジックは変更していない。
- UniCLI Compile: `0 errors / 0 warnings`
- 24秒PlayMode: ログ `0件`

## 2026-06-02 防衛柵の外周配置整理

- 防衛柵を四隅のバリスタを結ぶ長方形として整理した。
- バリスタは`(x, y) = (±6, ±8)`セルへ配置する。
- 横柵は`(0, ±8)`セルへ配置し、左右のバリスタ間を結ぶ。
- 縦柵は`(±6, 0)`セルへ配置し、上下のバリスタ間だけを結ぶ。
- 縦柵のSprite pivot、Collider、建造演出、ゲージ位置を中央基準へ統一した。
- 斜めPerspective視点で上下辺から突き抜けないよう、縦柵Visualへ`0.62`の奥行き方向スケールを適用した。
- UniCLI Compile: `0 errors / 0 warnings`
- 20秒PlayMode: ログ `0件`

## 2026-06-02 防衛柵のセル単位化

- 長尺の横柵・縦柵画像を1辺ごとに配置する方式を廃止した。
- `FenceCellHorizontal`と`FenceCellVertical`の短いTextureを生成し、1セルにつき1Prefabを配置する。
- 四隅のバリスタを除き、上下辺はそれぞれ11セル、左右辺はそれぞれ15セルの柵パーツで構成する。
- 各柵パーツは独立した建造Trigger、Collider、HP、建造演出を持つ。
- 横移動時に縦柵列が斜めに収束する原因はPerspectiveカメラだったため、斜め角度を維持したOrthographicカメラへ切り替えた。
- Orthographic化により、カメラ追従後もセル列の平行関係と同一サイズを維持する。
- UniCLI Compile: `0 errors / 0 warnings`
- 横移動を含むPlayMode確認と20秒PlayMode: ログ `0件`

## 2026-06-02 セル柵の生成Texture差し替え

- `FenceCellHorizontal`と`FenceCellVertical`を、画像生成したカジュアルな太縁パリセードTextureへ差し替えた。
- 組み込み`image_gen`で緑背景付き素材を生成し、ローカル処理で透過化、トリミング、セル向け縮小を行った。
- 横柵は`128 x 96`、縦柵は`96 x 128`の透過PNGとした。
- 元の生成画像は`Assets/AreaSurvivors/Sprites/External/GeneratedFenceCell*Source.png`へ保存した。
- `CreateSprites()`から簡易Pixel版のセル柵生成を外し、再生成時も生成Textureを維持する。
- ワールド寸法を維持するため、セル柵TextureのPixels Per Unitは`128`とした。
- UniCLI Compile: `0 errors / 0 warnings`
- 横移動を含む20秒PlayMode: ログ `0件`

## 2026-06-02 縦2セル柵の見た目修正

- 配置座標は2セル間隔だったが、縦柵Textureが`96 x 256`で高さ`2.0`ワールドあり、床の2セル間隔`0.77`ワールドに対して重なりすぎていた。
- 縦柵を「上端・中央継ぎ目・下端」の3本の主要杭で読める2セル用Textureとして再生成した。
- `FenceDoubleVertical.png`を`96 x 128`へ変更し、表示高さを`1.0`ワールドへ縮小した。
- 縦柵の足元影を`(0.42, 1.16)`から`(0.42, 0.78)`へ変更した。
- 中央表示と横移動後のGame Viewで、左右の縦柵が2セル部品として安定表示されることを確認した。
- UniCLI Compile: `0 errors / 0 warnings`
- PlayMode: ログ `0件`

## 2026-06-03 3D防衛柵の見た目調整

- 低ポリ3D柵が縦方向では一本の帯に見えやすかったため、支柱とレールの配置を調整した。
- 支柱を細くし、上部キャップを少し大きくした。
- 長いレールを中央線から左右へ離し、奥行き方向でも2本の横板として読めるようにした。
- 各支柱へ短い横木を追加し、縦柵が連続した柱ではなく柵の部品列に見えるようにした。
- 数か所に斜め補強を追加し、木組みの柵としてのシルエットを強めた。
- Scene再オープン後、Prefab更新だけで反映されることを確認した。
- UniCLI Compile: `0 errors / 0 warnings`
- PlayMode: ログ `0件`

## 2026-06-03 防衛柵の3D低ポリ化試作

- 床面Quad化は平面的に見えすぎたため、防衛柵本体を低ポリ3Dオブジェクトへ置き換えた。
- 柵はCube製の支柱、上段レール、下段レールで構成し、横柵・縦柵とも20セル分の1Prefabを維持する。
- `DefensiveFence`は紙モデル専用の`PaperMeshVisual`に加えて、3D本体用の`ghostObject`、`buildObject`、`completeObject`を扱えるようにした。
- 未建造、建造中、完成状態は同じ3D形状を使い、建造中はZ方向へ下から伸びる。
- 3D柵用Materialを`Assets/AreaSurvivors/Materials`へ追加した。
- 既存の2D Collider、建造Trigger、建造ゲージ、トンカチ、完成Sparkleは維持した。
- Scene再オープン後、Prefab更新だけで既存Sceneへ反映されることを確認した。
- UniCLI Compile: `0 errors / 0 warnings`
- PlayMode: ログ `0件`

## 2026-06-02 防衛柵を各辺1オブジェクトへ統合

- 5セル柵4本で構成していた各辺を、20セル分のTextureを持つPrefab 1本へ統合した。
- 生成済み5セル素材をローカルで4連結し、継ぎ目と縮尺を維持した。
- `FenceTwentyHorizontal.png`は`1792 x 96`、`FenceTwentyVertical.png`は`96 x 1024`の透過PNGとした。
- 横柵を`(0, ±10)`、縦柵を`(±10, 0)`セルへ配置した。
- Scene内の防衛柵は横2本、縦2本、合計4オブジェクトとなった。
- Collider、建造Trigger、足元影、建造ゲージ位置を20セル寸法へ合わせた。
- UniCLI Compile: `0 errors / 0 warnings`
- Scene再オープン後のPlayMode: ログ `0件`

## 2026-06-02 防衛柵を床面Quad表示へ変更

- 柵Textureをカメラ正面へ向けるBillboard表示から、床面XYへ沿うQuad表示へ変更した。
- 柵の`Ghost`、`Build Fill`、`Complete`だけ`PaperBillboard.faceCamera = false`とした。
- QuadはCollider寸法へ正規化し、建造中のFill伸縮と完成時パルスでも基準Scaleを維持する。
- 縦20セル柵はCollider高さ、床面Quad高さともに`7.6846`、画面上の高さも約`387.66px`で一致した。
- Scene再オープン後、横移動後、縦柵建造完了後の表示を確認した。
- UniCLI Compile: `0 errors / 0 warnings`
- PlayMode: ログ `0件`

## 2026-06-02 防衛柵を5セル単位の20セル四方へ変更

- 2セル柵では上下辺が12セル、左右辺が16セルで非対称だったため、5セルPrefabへ置き換えた。
- `FenceFiveHorizontal.png`は`448 x 96`、`FenceFiveVertical.png`は`96 x 256`の透過PNGとした。
- 四隅のバリスタを`(±10, ±10)`セルへ配置した。
- 各辺の柵中心は`-7.5, -2.5, 2.5, 7.5`セルとし、5セル柵4本で20セル分を構成する。
- 半セル中心の配置に対応するため、`CellToWorld(TileGrid, Vector2)`を追加した。
- 防衛区画の内側と外周付近を障害物候補セルから除外し、木、岩、池が柵やバリスタへ重ならないようにした。
- Sceneを防衛線のみ同期し、横柵8本、縦柵8本、防衛区画内の障害物0件を確認した。
- UniCLI Compile: `0 errors / 0 warnings`
- PlayMode: ログ `0件`

## 2026-06-02 防衛柵を2セル単位へ変更

- 防衛柵の反復が細かすぎたため、1セルPrefabから2セルPrefabへ変更した。
- `FenceDoubleHorizontal`は`256 x 96`、`FenceDoubleVertical`は`96 x 256`の透過PNGとした。
- 組み込み`image_gen`で2セル用の太縁パリセードTextureを生成し、透過化、トリミング、縮小を行った。
- 上下辺はそれぞれ6本、左右辺はそれぞれ8本の2セル柵で構成する。
- Collider、建造Trigger、足元影、建造ゲージ位置を2セル寸法へ合わせた。
- 旧`FenceCell*`Textureと生成元画像を削除し、`FenceDouble*`へ置き換えた。
- UniCLI Compile: `0 errors / 0 warnings`
- 横移動を含む20秒PlayMode: ログ `0件`
