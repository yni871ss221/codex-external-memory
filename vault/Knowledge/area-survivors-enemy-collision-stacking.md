---
date: 2026-06-08
tags: [knowledge, unity, physics2d, enemy, area-survivors]
project: area-survivors
related: [[area-survivors-enemy-spawn-2026-06-08]]
---

# AreaSurvivors 敵同士の衝突スタック

## 問題

大型敵や多数の敵が出現した際、敵同士が物理Colliderで押し合い、木・石・建造物付近でスタックしやすくなった。

## 対応

- `EnemyController.Awake()` で既存の敵を探し、自身のColliderと他敵Colliderの組み合わせに `Physics2D.IgnoreCollision(..., true)` を設定する。
- 敵同士だけを重なれるようにし、プレイヤー・塔・建造物・木石との当たり判定は維持する。

## 補足

将来的に敵数が非常に増える場合は、Enemy専用Layerを追加して `Physics2D.IgnoreLayerCollision(enemyLayer, enemyLayer, true)` に移行すると、スポーン時のペア設定コストを減らせる。

