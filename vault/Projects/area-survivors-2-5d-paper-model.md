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
