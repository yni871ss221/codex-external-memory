---
date: 2026-06-09
tags: [area-survivors, testing, unity-editor, decision]
project: area-survivors
related: [[Preferences/testing-workflow]], [[Knowledge/area-survivors-stuck-recovery-proximity-gap]]
---

# 汎用 Gameplay Test Scenario を採用する

## 決定

AreaSurvivors の検証は、Editor専用Scene `90_GameplayTest` と `GameplayTestScenario` Assetを使う。
当初のナビゲーション専用テストから、ゲーム全般を検証できる汎用モジュールへ拡張した。

## 理由

- ランダム配置やスポーンを待たず、問題の座標・敵・自然物を即座に再現できる。
- 固定乱数シードにより同じ条件を繰り返し検証できる。
- 再現条件と期待結果をAssetとして残せるため、修正後の回帰テストに使える。
- テストごとの専用コードを減らし、Inspector設定で多くの状況を構築できる。

## 共通機能

- システム単位の有効・無効切り替え
- 敵、自然物、任意Prefabのセル基準配置
- `GameConfig` public fieldの上書き
- 固定乱数シード
- 時刻指定Action
  - オブジェクト移動
  - ダメージ、回復
  - Active切り替え
  - 破壊
- Assertions
  - 停止個体なし、目標到達
  - 敵数
  - 名前指定オブジェクトの存在
  - 名前指定オブジェクトのHP
  - 木、石、トークン数
  - Config float値

## Editor操作

- Scenario AssetのInspectorから `Use In Gameplay Test` または `Run Scenario`
- `Area Survivors/Test Scenarios/` メニューからScene構築、実行、サンプル選択
- サンプル:
  - `Gameplay_Navigation_Default`
  - `Gameplay_Prefab_Smoke`
  - `Gameplay_Action_Smoke`
