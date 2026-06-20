---
date: 2026-06-20
tags: [knowledge, unity, camera, build-mode]
project: area-survivors
related: [[area-survivors-current]], [[area-survivors-unity-workflow]]
---

# 建造モードカメラの中心合わせ

## 問題

- 建造画面を開いたとき、中心塔が画面中央より下に寄り、画面中央の地面位置が上側へずれて見えた。
- 斜めカメラのOrthographic表示では、`Camera.transform.position.x/y` を対象位置へ直接合わせても、画面中央レイが地面に当たる位置は対象と一致しない。

## 対応

- `BuildModeCameraController` は、カメラ位置そのものではなく、Viewport中央レイと地面平面の交点を基準に `focusTarget` へ合わせる。
- 建造モード開始時は `GameManager.ConfigureBuildModeCamera()` から中心塔Transformを渡す。
- 通常の `CameraFollow` が残ってカメラを戻さないよう、建造モード開始時に `target` / `anchor` をnullにし、`enabled = false` にする。
- 初期化直後の数フレームだけ再センタリングし、ユーザーがホイール/ドラッグ操作した後は邪魔しない。

## 検証

- `unicli exec Compile` 0 errors / 0 warnings。
- `Console.GetLog --logType Error --maxCount 30` 0件。