---
date: 2026-06-10
tags: [preferences, area-survivors, workflow, credit-saving, testing]
project: area-survivors
related: [[Preferences/testing-workflow]], [[Knowledge/area-survivors-unity-workflow]]
---

# AreaSurvivors の効率・クレジット節約ルール

## 標準作業

- 関連する小規模修正はまとめて実装し、修正ごとにUnityコンパイルやPlayMode検証を行わない。
- 通常は「コード確認 + コンパイル1回 + 関連GameplayTest 1件」を標準検証とする。
- 中間報告は重要な判断、問題発生、長時間化した場合だけ簡潔に行う。

## 検証レベル

- 簡易: コード確認とコンパイルのみ。
- 標準: コンパイル + 関連GameplayTest 1件。通常はこちらを使う。
- 完全: 複数GameplayTest + `05_Game` 統合確認 + 必要なスクリーンショット確認。
- 完全検証は大規模変更、再発バグ、見た目確認が必要な変更、ユーザー指定時だけ行う。

## 避ける処理

- Scene全体やHUD全体の再生成は原則行わず、必要なオブジェクトだけ変更する。
- Gameplay Test Sceneは毎回再構築せず、既存SceneとScenarioを再利用する。
- 成功時のスクリーンショットは原則撮影しない。
- 通常ゲームでランダムな事象発生を待つ検証は避ける。

## 調査

- 原因調査が約10分以上長引く、または複数の大規模な修正案がある場合は、推測実装を進めず状況と選択肢を報告する。
- 仕様判断が必要な新機能は実装前に認識を合わせる。

## Obsidian

- 軽微な修正は記録しない。
- 再発し得る原因と解決策、長期的な設計判断、作業ルール、作業終了時の重要な進捗だけ記録する。
