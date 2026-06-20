---
date: 2026-06-20
tags: [knowledge, tokens, benchmark, workflow]
project: area-survivors
related: [[area-survivors-token-usage-tools]], [[area-survivors-token-spikes]]
---

# AreaSurvivors トークン使用量ベンチマーク

## 目的

トークン消費改善の前後比較に使う固定ベンチマーク。本文はチャットへ流さず、`Tools/TokenUsage/Run-TokenBenchmark.ps1` で推定tokenだけ取得する。

## 実行コマンド

```powershell
powershell -ExecutionPolicy Bypass -File Tools/TokenUsage/Run-TokenBenchmark.ps1
```

既定の比較範囲は、旧mainから統合後までの `e68ca9a..2771c1c`。

## 2026-06-20 基準値

| command | estimated tokens | risk | lines | chars |
| --- | ---: | --- | ---: | ---: |
| `git diff --stat e68ca9a..2771c1c` | 20,140 | critical | 934 | 64,446 |
| `git diff --name-only e68ca9a..2771c1c` | 18,713 | high | 933 | 59,881 |
| `git diff e68ca9a..2771c1c -- Assets/AreaSurvivors/Scenes/05_Game.unity` | 388,733 | critical | 40,947 | 1,243,945 |
| `git diff e68ca9a..2771c1c -- Assets/AreaSurvivors/Scripts/Game/GameManager.cs` | 28,902 | critical | 1,909 | 92,485 |
| `git grep -n public -- Assets/AreaSurvivors/Scripts` | 40,830 | critical | 1,208 | 130,656 |
| `Get-ChildItem -Recurse Assets/AreaSurvivors \| Select-Object FullName,Length` | 36,302 | critical | 964 | 116,166 |

## 読み取り

- Scene YAML全文diffが約39万token見込みで最大の危険源。
- `git diff --stat` / `--name-only` でも、Unityの大量ファイル範囲では2万token前後になる。
- 広い `git grep` や再帰ファイル一覧も4万token級になり得る。
- 改善確認では、同じスクリプトを実行し、上記値より下がったかを見る。