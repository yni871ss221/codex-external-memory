---
date: 2026-06-10
tags: [area-survivors, skill-tree, progression, decision]
project: area-survivors
related: [[Projects/area-survivors]], [[Preferences/efficient-development-workflow]]
---

# スキルツリー大幅改修

## 方針

- 永続スキルは既存の `UpgradeType` と `ProgressionStore` を拡張する。
- アンロック系スキルは最大レベル1、数値強化系は最大レベル10とする。
- 未実装機能も将来接続用の `UpgradeType` を用意し、ツリー上では「予定」ノードとして表示する。
- 「予定」ノードは内容を確認できるが、トークンを消費して購入できない。
- 前提スキルを未取得のノードもツリー上に表示し、`LOCK` と表示する。

## 実動作まで接続済み

- 初期木材・初期石材増加
- バリスタの建造アンロック
- バリスタ射程増加
- プレイヤーの伐採速度・伐採数増加
- プレイヤーの採掘速度・採掘数増加
- 中心塔の初期青エリア増加
- 中心塔のHP自動回復
- ラン終了時トークン増加
- 通常スポーンがエリートに置き換わる確率増加

## 予約ノード

- 監視塔、大型作業場、中心塔大砲、中心塔アップグレード
- 防衛キャラクター、クラスチェンジ
- 大工小屋、自動建造、自動建造速度
- 作業小屋、自動伐採速度、自動採掘速度

## 調整

効果量は `GameConfig` の `Permanent Skill Effects` および資源設定からInspector調整可能。
