---
date: 2026-06-20
tags: [knowledge, tokens, tooling, powershell]
project: area-survivors
related: [[area-survivors-token-spikes]], [[rtk-codex-windows]]
---

# AreaSurvivors トークン使用量計測ツール

## 追加したもの

- `Tools/TokenUsage/Estimate-TokenCost.ps1`
  - ファイルまたはコマンド出力を捕捉し、行数、文字数、byte数、推定token、risk、adviceを表示する。
  - `-Command` は実際にコマンドを実行するが、出力本文をチャットへ流さず一時ファイルへ保存する。
- `Tools/TokenUsage/Run-WithTokenReport.ps1`
  - コマンドを実行し、結果を `TokenReports/YYYY-MM-DD.jsonl` に記録する。
  - 大きい出力は本文表示を抑止し、必要時のみ `-PrintOutput` で表示する。
- `Tools/TokenUsage/TokenUsageCommon.ps1`
  - 推定token、risk判定、JSONL記録の共通処理。
- `TokenReports/` は `.gitignore` に追加済み。

## 使い方

```powershell
powershell -ExecutionPolicy Bypass -File Tools/TokenUsage/Estimate-TokenCost.ps1 -File AGENTS.md
powershell -ExecutionPolicy Bypass -File Tools/TokenUsage/Estimate-TokenCost.ps1 -Command "git diff --stat" -SaveReport
powershell -ExecutionPolicy Bypass -File Tools/TokenUsage/Run-WithTokenReport.ps1 -Command "git status --short --branch"
```

## 注意

- Codex内部の実課金tokenや思考tokenの完全内訳ではなく、コマンド/ファイル出力の推定tokenを記録する仕組み。
- `-Command` はコマンド自体を実行するため、読み取り系・安全なコマンドで使う。
- 大きな出力が予想される場合は、このツール、RTK、専用Reporter/Validatorを優先する。