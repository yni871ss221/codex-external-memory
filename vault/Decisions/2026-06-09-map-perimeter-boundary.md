---
date: 2026-06-09
tags: [area-survivors, map, boundary, collider, testing]
project: area-survivors
related: [[Preferences/testing-workflow]], [[Knowledge/area-survivors-unity-workflow]]
---

# マップ外周の描画と進行不可境界

## 決定

- マップ外周の見た目と進行不可判定は分離する。
- `MapPerimeterController` をScene上に配置し、Inspectorまたは `Area Survivors/Map/Rebuild Map Perimeter` から再生成できるようにする。
- 進行不可判定はマップ実寸から自動計算した四辺の `BoxCollider2D` で構成する。
- 仮の外周描画は既存の `Forest8` と `Rock8` をColliderなしで外側へ並べる。
- 外周装飾は自然物のセル占有・採取・敵回避ロジックへ登録しない。
- 外周の森・山・Colliderは `Map Perimeter/Perimeter Content` 配下のSceneオブジェクトとして保存し、ゲーム開始時には再生成しない。
- 森・山より外側や装飾間の描画抜けは、Main CameraのSkyboxを無効化し、暗色のSolid Color背景で埋める。

## 関連対応

- 外周Collider追加後に敵がマップ外へスポーンして閉じ込められないよう、敵サイズ込みでスポーン位置をマップ内側へ補正する。
- 汎用テストAssertion `AllMonitoredObjectsInsideGrid` とサンプル `Gameplay_Map_Perimeter` を追加した。

## 検証

- `Gameplay_Map_Perimeter`: マップ外の目標へ進む敵がマップ内に留まりPASS。
- `Gameplay_Navigation_Default`: 既存ナビゲーションへの回帰なし。
- `05_Game`: 通常起動時のConsole Errorなし。
- 画面端へカメラを移動し、外周より外側が暗色で埋まることを確認。

## 今後

- 仮の `Forest8` / `Rock8` は、専用の森外周チャンクまたは山外周チャンクへ差し替え可能。
- 見た目を変更しても四辺Colliderの構造は維持できる。
