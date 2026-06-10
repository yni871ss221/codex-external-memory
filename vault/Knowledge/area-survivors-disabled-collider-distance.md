---
date: 2026-06-09
tags: [area-survivors, unity, collider2d, bugfix, harvesting]
project: area-survivors
related: [[Projects/area-survivors-current]]
---

# 無効化した Collider2D に対する Distance 判定

## 現象

プレイヤーがHP 0でダウンすると、接触していないものを含むすべての木・石が採取され始めた。

## 原因

ダウン開始時にプレイヤーの `Collider2D` を無効化していたが、`HarvestableResource` が無効Colliderに対しても `Collider2D.Distance()` を呼んでいた。結果を通常の接触距離として扱ったため、全資源が接触中と誤判定された。

## 対応

- `PlayerController.CanPerformWorldActions` を追加し、死亡・蘇生中・Collider無効時はワールド操作不可とした。
- 採取判定の入口と接触判定の両方で `CanPerformWorldActions` を確認する。
- `Collider2D.Distance()` の前に両Colliderが有効か確認し、結果は `isOverlapped` または距離閾値で判定する。

## 再発防止

無効化されたColliderを距離・接触判定APIへ渡さない。死亡・ダウン・演出中などの操作可否は、個別機能で推測せず、主体側の明示的な行動可能プロパティで判定する。
