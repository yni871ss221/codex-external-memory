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
- AreaSurvivorsでは引用符または改行を含むEvalを `Tools/TokenUsage/safe-unity.ps1` が `guard_code: 25` で拒否する。エスケープを変えて再試行せず、一時Editor Runnerへ移す。
- Eval serverは受信したコードを生成C#へそのまま埋め込むが、成功・失敗にかかわらず `finally` で生成 `.cs` / `.dll` を削除する。失敗後に生成C#が残る前提で調査せず、先にSafe-Commandのcapture outputを保存する。

## 2026-07-13 原因確定

- 長いHUD移行Evalで、PowerShell→RTK→ネイティブCLIの引数境界を通った時点でC#文字列の引用符が欠落し、`05_Game` などが文字列ではない生成C#になってコンパイルエラーになった。
- UniCLI側の `EvalHandler` は `request.code` を改変せず埋め込んでいたため、失敗境界はEval server内ではなくCLIへ到達する前の引数輸送にある。
- 安全な入口は `invoke-unity-editor-runner.ps1 -Phase RegisterAndRun`。Import→Compile→Menu完全一致確認→Executeを固定し、Menu未登録時にEvalへ自動フォールバックしない。

## 実例

- `GameConfig.asset` の敵スポーン既定値保存は、`AreaSurvivors/Config/Normalize Enemy Spawn Defaults` メニューを追加して `Menu.Execute` で実行した。
- PlayMode中のスポーン時刻短縮は文字列リテラルを使わず、`Eval` で `EnemySpawner` のConfig値を書き換えて検証した。
