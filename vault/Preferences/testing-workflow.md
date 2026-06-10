---
date: 2026-06-09
tags: [area-survivors, testing, workflow, unity]
project: area-survivors
related: [[Decisions/2026-06-09-navigation-test-scenarios]]
---

# AreaSurvivors の検証ルール

## 原則

- 機能追加・バグ修正の検証は、原則として `GameplayTestScenario` を介して行う。
- 通常はコンパイル後に関連するGameplayTestを1件だけ実行する。複数テスト、通常ゲーム起動、スクリーンショットは必要時だけ行う。
- ランダムな通常プレイで事象の発生を待つ前に、固定配置・固定シードの再現シナリオを作成または再利用する。
- シナリオには再現条件だけでなく、可能な限り `Assertions` で期待結果も設定する。
- 通常の `05_Game` プレイテストは、統合確認・操作感確認・テストモジュールでは表現できない場合の最終確認に使う。

## 共通化ルール

- 特定バグ専用のテストコードを増やす前に、配置・時刻指定Action・Assertion・Config Overrideの組み合わせで表現できないか確認する。
- 同種の検証で繰り返し必要になる操作は、個別シナリオへ直書きせず `GameplayTestScenario` の共通機能として追加する。
- 敵種、Prefab、自然物、座標、時間、閾値はScenario AssetのInspectorから変更可能にする。
- 再現性が必要なテストでは `Use Fixed Random Seed` を有効にする。
- テスト対象を見たい場合は `Focus Camera On Setup` と `Camera Focus Cell Offset` を使う。
- 通常は `Auto Exit Play Mode On Complete` を有効にし、確認のため停止したい場合だけ `Pause On Complete` を使う。
- Gameplay Test Sceneは必要な構造変更時だけ再構築し、通常実行では既存Sceneを再利用する。

## 検証手順

1. 既存Scenarioを複製するか、新規 `GameplayTestScenario` Assetを作る。
2. 配置、Config Override、Scheduled Actions、Assertionsを設定する。
3. Scenario Inspectorの `Run Scenario` から実行する。
4. `[GameplayTest] PASS/FAIL` とConsole Errorを確認する。
5. 最後に必要な場合だけ `05_Game` で統合確認する。
