---
date: 2026-07-15
tags: [windows, powershell, rtk, command-failure]
project: AreaSurvivors
---

# WindowsでのPowerShell実行ファイル選択

## 原因

AreaSurvivorsのWindows環境では `pwsh` がPATH上に存在しない。RTK配下で `rtk pwsh ...` を実行すると、RTKの直接実行フォールバックでも解決できず、`program not found` で終了する。

## 再発防止

- PowerShell Wrapperは存在確認済みの `powershell.exe` を使う。
- `pwsh` など別の実行ファイルを使う必要がある場合は、コマンドを組み立てる前に存在確認と正式用例の確認を行う。
- Windows環境で`head`、`tail`などUnix系の補助コマンドが存在すると仮定しない。出力件数制御は`safe-read.ps1`、`safe-search.ps1`などの既存Wrapperへ任せる。
- 引用符を含む複雑な検証式を `powershell.exe -Command` に埋め込まない。既存の `-File` Wrapperまたは限定Validatorへ分離する。
- 実行ファイル未検出時は別Shellを推測で連続試行せず、失敗出力から原因を確定してルールへ反映する。

## 確認結果

- 失敗コマンド: `rtk pwsh -NoLogo -NoProfile -File ...`
- 結果: `Binary 'pwsh' not found on PATH` / `program not found`
- 経過時間: 2.9秒
- Unity、Scene、Prefab、ゲームコードへの状態変更なし
- 修正後の `rtk powershell.exe ...` は終了コード0で動作した。

## 追加事例

外側のコマンド文字列へ引用符を含む検証式を埋め込んだ結果、`The string is missing the terminator` で終了した。手打ち修正の反復は行わず、以後は `safe-read.ps1` などの既存Wrapperを使って確認する。

`rg`の出力制限に`head`を連結した結果、Windows PATH上に実行ファイルがなく`program not found`で終了した。RTKが直接実行へフォールバックしても解決できないため、別コマンドを連結せず、最初から件数制限を持つ安全Wrapperを使う。

`powershell.exe -File Tools/TokenUsage/safe-search.ps1`で`-Path`を同一呼び出し内に複数回記述すると、`ParameterAlreadyBound`で実行前に停止する。検索先が複数ある場合も1呼び出し1 Pathとし、必要なら独立したWrapper呼び出しへ分ける。

## 追加事例: 多重PowerShellの変数先行展開

`exec_command`から`powershell.exe -Command "$log=..."`を実行した際、外側PowerShellが`$log`を先に空展開し、内側には`=C:\...`が渡って失敗した。既存規則どおり、`-Command`へ変数や複雑な式を埋め込まず、既存`-File` Wrapperまたは固定引数の限定検索を使う。Shell文字列内に`$`があるコマンドは実行前に拒否する。
