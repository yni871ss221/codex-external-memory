---
date: 2026-06-15
tags: [unity, area-survivors, grid, collider, visual-standard, buildings]
project: area-survivors
related: [[Projects/area-survivors-current]], [[area-survivors-paper-billboard-footprint]], [[area-survivors-stencil-occlusion-silhouette]]
---

# AreaSurvivors GridObjectVisual規格

## 目的

建造物や自然物を追加するたびに、画像位置、Collider位置、中心セル、青エリア判定、アップグレード表示を個別調整しないための共通規格。

## 基本仕様

- Grid上オブジェクトは「中心セル」と「占有セル数」を持つ。
- Root Transformは、占有セル範囲の下端中央に配置する。
- 画像は下端中央アンカーでRootに配置する。
- Colliderは占有セル範囲のBoxColliderを使う。
- Grid登録、青エリア判定、自然物配置、アップグレード表示は同じ中心セルを使う。

## 実装要点

- `GridObjectVisual.AlignRootToFootprint(TileGrid grid, Vector3Int originCell)` は、中心セルとfootprintからRootを占有セル下端中央へ配置する。
- `GridObjectVisual.FootprintBottomCenterToWorld(...)` はRoot配置の共通計算。
- `GridObjectVisual.FootprintOriginToWorld(...)` は中心セルのWorld座標を返す。
- `GridObjectMarker.Register(...)` は、`GridObjectVisual` が中心セルを持つ場合はそれをGrid登録に使う。
- `GridObjectVisual.ConfigureFootprintBox(...)` は、占有セル範囲のBoxColliderを設定する。

## 注意点

- 「中心塔だけYを下げる」「アップグレード画像だけoffsetを足す」のような個別補正を追加しない。
- 新規建造物・アップグレード画像・大型自然物は、まず中心セルとfootprintを定義し、この規格に乗せる。
- 画像サイズは横幅を占有セル幅に合わせ、縦方向は画像比率を維持する。下端がRootに合うよう、画像自体の下端を使いやすく加工する。
- Playerや敵のColliderはPrefab設定を優先する。実行時にColliderを勝手に作り直すとInspector調整が反映されない。

## 2026-06-15の修正

- 中心塔を旧 `Textured Model` 表示から `PaperMeshVisual` の `Base Tower Image` へ切り替えた。
- 中心塔Rootを3x3占有セルの下端中央へ配置するようにした。
- 通常中心塔、アップグレード中心塔、Collider、Grid登録、青エリア基準を同じ中心セルから計算するようにした。
- 中心塔の位置ずれは、個別Y offsetではなくRoot基準の統一で解消した。

## 2026-06-17 Prefab表示を正とする追加ルール

- GridObjectVisual規格は「セル基準のRoot位置とCollider」を決めるためのもの。画像の比率補正やRotate補正をランタイムで行うためのものではない。
- 建造物Prefabでは、通常表示、ゴースト、建造中表示、完成表示、アップグレード後表示を同じ下端アンカー/同じ幅基準でそろえる。
- ランタイム側は建造物VisualのScale、Rotation、Y伸縮を原則変更しない。見た目が合わない場合は、処理済みPNGまたはPrefab内Transformを修正する。
- アップグレード画像を追加する場合も、元画像とアップグレード画像の両方を同じ占有セル横幅で加工し、Prefab参照まで更新する。

## 2026-06-26 Scale/Rotation禁止の強化

- 建造物、敵、プレイヤー、ProjectileはPrefab/子VisualのScaleを原則 `1`、Rotation X/Yを `0` にする。Projectileの飛翔角度としてRotation Zを変えるのは許容する。
- 見た目サイズはScaleではなく、透過・トリミング・キャンバス余白・PNG解像度・PPU/import設定で合わせる。
- 破壊画像、アップグレード画像、弓矢画像などは、通常画像と同じ基準で処理済みSpriteを作り、Prefab参照を差し替える。
- 黒背景透過では、境界接続した背景だけを抜き、オブジェクト内部の黒を透過しない。