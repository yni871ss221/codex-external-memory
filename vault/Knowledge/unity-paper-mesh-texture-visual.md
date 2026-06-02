---
date: 2026-06-02
tags: [knowledge, unity, mesh, texture, 2-5d]
project: area-survivors
related: [[Projects/area-survivors-2-5d-paper-model]]
---

# Unityで紙モデル風のQuad Mesh表示を作る

## 方針

- 物理判定と移動は2Dルートへ残す。
- 子Visualへ`MeshFilter + MeshRenderer`を置き、Quad Meshへ透過Textureを指定する。
- Spriteの`bounds`から頂点、`textureRect`からUVを生成する。
- 子Visualだけをカメラへ正対させる。

## 注意点

- エディタ生成中に作った一時MeshとMaterialをSceneへ保存するとYAMLが肥大化する。
- 一時資源へ`HideFlags.HideAndDontSave`を設定し、必要な時点で再構築する。
- 歩行アニメーションでは同じSpriteが続く場合に再構築を省略する。
