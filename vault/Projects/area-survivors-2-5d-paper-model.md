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
