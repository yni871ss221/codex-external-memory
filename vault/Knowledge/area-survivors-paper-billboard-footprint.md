---
date: 2026-06-02
tags: [unity, area-survivors, 2-5d, billboard, grid]
project: area-survivors
related: [[Projects/area-survivors-2-5d-paper-model]]
---

# PaperBillboardと床面占有範囲の不一致

## 原因

- `PaperMeshVisual`はSpriteのBoundsからQuadを生成する。
- `MeshChild()`はQuadへ`PaperBillboard`を追加し、常にカメラ正面へ向ける。
- 床面Y方向は斜めカメラで画面上の長さが短縮されるが、カメラ正面を向くQuadの高さは短縮されない。
- 床面の縦方向に長い柵へBillboard Quadを使うと、Collider内へ収まるTexture寸法でも画面上では上下へ突き抜けて見える。

## 実測

- 縦20セル柵:
  - Collider高さ: `7.6846`
  - Sprite Quad高さ: `8.0`
  - 画面上のCollider高さ: 約`388px`
  - 画面上のQuad高さ: 約`527px`
- 横20セル柵:
  - Collider幅: `13.972`
  - Sprite Quad幅: `14.0`
  - 画面上のCollider幅: 約`920px`
  - 画面上のQuad幅: 約`922px`

## 対応方針

- 床面Y方向へ長いオブジェクトには、常時カメラ正面を向くBillboard表示をそのまま使わない。
- 縦柵専用に床面へ沿うQuadを使うか、カメラ傾斜を考慮して画面上の占有範囲を補正する。
- Collider寸法だけで完了扱いせず、床面上の範囲と画面上のTexture範囲を比較する。

## 実施した修正

- `MeshChild()`へ`faceCamera`引数を追加した。
- 柵の`Ghost`、`Build Fill`、`Complete`は`faceCamera = false`とし、床面XYへ沿うQuadとして表示する。
- Sprite Boundsから作るQuadへCollider寸法に合わせたScaleを適用した。
- `DefensiveFence`は基準Scaleを保持し、建造中のFill伸縮と完成時のパルスでも床面QuadのScaleを壊さないようにした。

## 修正後の実測

- 縦20セル柵:
  - Collider高さ: `7.6846`
  - 床面Quad高さ: `7.6846`
  - 画面上のCollider高さ: 約`387.66px`
  - 画面上のQuad高さ: 約`387.66px`
- Scene再オープン後、建造完了後、横移動後にも一致を確認した。
