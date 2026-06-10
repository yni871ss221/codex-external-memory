---
date: 2026-06-08
tags: [knowledge, unity, unicli, eval]
project: area-survivors
related: [[area-survivors-enemy-spawn-2026-06-08]]
---

# UniCLI Eval のクォート注意

## 学び

PowerShellから `unicli exec Eval --code` にC#コードを渡すとき、文字列リテラルの引用符が落ちてC#コンパイルエラーになる場合がある。

## 対応

- 文字列リテラルを多く含むEditor処理は、`Eval` で直接流すより、正式なEditorメニューとして実装して `unicli exec Menu.Execute --menuItemPath ...` で呼ぶ方が安定する。
- 一時検証のように文字列リテラルが不要な処理は `Eval` でも問題なく使える。

## 実例

- `GameConfig.asset` の敵スポーン既定値保存は、`AreaSurvivors/Config/Normalize Enemy Spawn Defaults` メニューを追加して `Menu.Execute` で実行した。
- PlayMode中のスポーン時刻短縮は文字列リテラルを使わず、`Eval` で `EnemySpawner` のConfig値を書き換えて検証した。

