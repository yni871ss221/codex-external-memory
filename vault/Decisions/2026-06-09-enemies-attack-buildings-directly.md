---
date: 2026-06-09
tags: [area-survivors, enemy-ai, buildings, collision]
project: area-survivors
related: [[Preferences/testing-workflow]], [[Knowledge/area-survivors-stuck-recovery-proximity-gap]]
---

# 敵は柵とバリスタを避けず接触攻撃する

## 決定

- 敵AIの回避対象は `Obstacle` を持つ自然障害物だけにする。
- 柵とバリスタは回避せず、そのまま接触して破壊を試みる。
- 接触攻撃時は衝突Colliderの親階層から `Health`、`DefensiveFence`、`BallistaTower` を探索する。

## 理由

- 防衛建造物が敵の進路を塞ぎ、攻撃を受け止める役割を持てる。
- 建造物のColliderが子オブジェクトにある場合でも、接触攻撃を確実に成立させるため。
