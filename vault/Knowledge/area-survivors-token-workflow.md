---
date: 2026-06-20
tags:
  - project/area-survivors
  - token-efficiency
related:
  - "[[area-survivors-current]]"
---

# AreaSurvivors Token Workflow

## 基本方針

- 高出力になりやすいコマンドは、実行前に安全入口か危険判定を使う。
- 生の広い `git diff`、対象未指定の `rg`、行数制限なしの `Get-Content`、Scene/Prefab YAML全文確認を避ける。
- Unity調査は、まず概要Reporter、必要なら通常Reporter、最後に対象ファイル限定の詳細確認へ進む。

## 日常入口

- `Tools/TokenUsage/safe-status.ps1`
- `Tools/TokenUsage/safe-diff.ps1`
- `Tools/TokenUsage/safe-search.ps1`
- `Tools/TokenUsage/safe-read.ps1`
- `Tools/TokenUsage/token-health.ps1`
- PowerShell関数化: `. Tools/TokenUsage/Import-AreaTokenAliases.ps1`

## 危険判定

- `Tools/TokenUsage/Test-AreaCommandRisk.ps1 -Command "<command>"`
- 危険判定されたら、RTK、安全ラッパー、対象パス指定、Reporter、Validator、件数制限へ切り替える。
- 自動変換: `Tools/TokenUsage/guarded-command.ps1 -Command "<command>"`
- 変換内容確認: `Tools/TokenUsage/Convert-AreaCommandToSafe.ps1 -Command "<command>"`
- 既知の危険コマンドは `safe-diff`、`safe-search`、`safe-read`、`ConsoleErrors` へ自動変換する。
- 未知のコマンドは `-ExecuteOriginalIfSafe` なしでは実行しない。

## Unity Reporter

- C#探索: `Area Survivors/Reports/C# Symbol Overview` → `C# Symbol Index`
- Scene/Prefab探索: `Area Survivors/Reports/Scene Prefab Overview` → `Scene Prefab Structure`
- Scene/Prefab検索: `Area Survivors/Reports/Scene Prefab Search`
- Reporter出力は `TokenReports/UnityReports/` に保存し、Unity Consoleには保存先・行数・文字数だけ出す。
- YAML全文確認は最終手段。

## Unity Commands

- Unity系コマンドは `Tools/TokenUsage/safe-unity.ps1` を使う。
- Actions: `Compile`、`ConsoleErrors`、`Menu`、`Eval`
- `ConsoleErrors` は `-MaxCount` で件数制限する。
- Unity系ベンチを含める場合は `Tools/TokenUsage/token-health.ps1 -IncludeUnity` を使う。

## Screenshots

- 大きいスクリーンショットは、確認前に `Tools/TokenUsage/Optimize-AreaScreenshot.ps1` で縮小またはクロップする。
- 低解像度版は `TokenReports/Screenshots/` に保存する。

## 定期チェック

- 改善作業の前後、または作業終了前に `Tools/TokenUsage/token-health.ps1` を実行する。
- 増加を検知したい場合は `-FailOnIncrease` を使う。
- 日常用ベースラインは `TokenReports/token-daily-baseline.json`。
- Heavyベンチは `Tools/TokenUsage/token-benchmark-heavy.ps1` を明示時だけ使う。
- Heavyベンチのベースラインは `TokenReports/token-benchmark-baseline.json`。
- 作業開始チェック: `Tools/TokenUsage/start-token-check.ps1`
- 作業終了チェック: `Tools/TokenUsage/end-token-check.ps1`
- Unity込みの確認は `-IncludeUnity` を付ける。

## Report Summary

- TokenReportsの原因分析は `Tools/TokenUsage/token-report-summary.ps1` を使う。
- benchmark系レコードはデフォルトで除外する。
- benchmark系も見たい場合は `-IncludeBenchmark` を付ける。
- 種別を絞る場合は `-Kind safe_command,daily_health` のように指定する。
- 対策後だけを見たい場合は `-Since "YYYY-MM-DD HH:mm"` を指定する。
- 重いコマンド、blocked件数、high/critical件数を確認する。

## Report Archive

- 古いTokenReports JSONLは `Tools/TokenUsage/archive-token-reports.ps1` で `TokenReports/Archive/` へ移動する。
- 削除ではなくアーカイブを基本にする。
- 実行前に `-WhatIf` で対象を確認する。

## CLI Scene Search

- CLIからScene/Prefab検索する場合は `Tools/TokenUsage/safe-unity-search.ps1 -Query <検索語>` を使う。
- 検索語をEditorPrefsへ設定し、`Area Survivors/Reports/Scene Prefab Search` を実行して、保存ファイルのパスだけ返す。

## 2026-06-21 追加運用

- 通常作業開始時はObsidianを読まず、AGENTS.md を唯一の入口にする。
- ルール詳細は Docs/AgentRules/*.md に分離し、必要なカテゴリだけ読む。
- Asset整理は次の順で行う:
  - un-unity-report.ps1 -Report asset-references
  - ilter-asset-reference-report.ps1 -Top <件数>
  - 必要時だけ -ExportPath で判定メモを出す
- Sprites/External の整理は容量削減より検索ノイズ削減に効く。総容量だけではなく、巨大Sceneや長いコードを直接読まない運用を優先する。

## 2026-06-23 レポート外消費の補足

- `start-token-check.ps1` は `-UiPercent` / `-BudgetTokens` / `-Note` を受け取り、開始マーカーへUI使用率を保存する。
- `session-coverage.ps1` は最新の `token_start_marker` から開始UI使用率とbudgetを自動取得し、`-CurrentPercent` だけで差分推定できる。
- `record-untracked-usage.ps1` は、会話、長い回答、画像添付、直接ツール出力、推論負荷などTokenReportsに自動記録されない消費を `manual_untracked_usage` として保存する。
- 画像は `-ImagePath` を指定すると画像サイズから概算する。厳密値ではなく、UI使用率差分の未知バケットを小さくするための補助値として扱う。
- `token-report-summary.ps1 -Path TokenReports/YYYY-MM-DD.jsonl` は指定した日別JSONLだけを集計する。`-Days` 集計と混同しない。
- サマリーにはkind別内訳が出るため、`safe_command`、`daily_health`、`manual_untracked_usage`、`token_coverage_snapshot` を分けて読む。
- 完全に取得できないもの: モデル内部推論トークン、Codex固定コンテキストの正確な内訳、画像の実トークン化、UI外で返ったtool resultの厳密値。
- 運用上は「UI使用率差分 - command記録 - manual記録 = 残り未知消費」として見る。

## 2026-06-26 start-task-token-check運用

- 作業開始時は `start-task-token-check.ps1 -Task "<依頼内容>" -UiPercent <開始%> [-BudgetTokens <推定枠>]` を優先する。
- このWrapperは `rule-router.ps1` で読むべき詳細ルールと中核ファイルを表示し、そのまま `start-token-check.ps1` の開始マーカーも記録する。
- 既に読むルールが明確な小修正だけ、従来の `start-token-check.ps1` を直接使う。
- `run-unity-report.ps1` は `Eval` より `Menu.Execute` を優先する。PowerShellスクリプト内からUniCliを呼ぶ場合、環境によってUnity名前付きパイプにアクセスするため権限付き実行が必要になる。
## 2026-07-13 入れ子PowerShellの変数展開事故

- 原因: 外側PowerShellの二重引用文字列内に内側用の変数を含め、内側へ渡る前に外側で空展開された。
- 証拠: 内側コマンドへ `=C:\...` が渡り、`Get-Content` の `LiteralPath` も欠損して終了コード1になった。
- 再発防止: 長い読み取り式を `-Command` に埋め込まず、`Tools/TokenUsage/safe-read.ps1` を `-File` で呼び、対象パスを `-Path` で渡す。
- Obsidian CLIがPATHにない環境では、外部Vault配下のMarkdownだけを許可する `Tools/TokenUsage/append-vault-note.ps1` をファイル入力で使用する。
- 確認: `command-tools-self-test.ps1` 全項目通過、`safe-read` で外部 `SKILL.md` 4件の限定読み取り成功。

## 2026-07-13 検索WrapperのCLI契約とbroken pipe

- `focused-search.ps1` の正式引数は `-Pattern` と既存の `-Path`。`-Query` / `-FilesOnly` は `safe-search.ps1` 専用。
- `powershell -File` で複数Pathをカンマ結合した1文字列にすると、結合パスとして扱われる。1ディレクトリまたは1ファイル単位で呼ぶ。
- `rg -l ... | Select-Object -First N` は早期パイプ閉鎖により `rg` が broken pipe の終了コード `-1` になる場合がある。rg出力と終了コードを先に全取得してから件数制限する。
- `safe-search` / `focused-search` にPath存在検証、rg終了コード伝播、全取得後の件数制限を追加した。
- 確認: `command-tools-self-test.ps1` 13スクリプト・全Guard通過。`safe-search -FilesOnly -First 1` と正式引数の `focused-search` が終了コード0。

## 2026-07-13 WeaponController旧パス

- `area-survivors-attack-animation` Skill内の `Assets/AreaSurvivors/Scripts/Game/WeaponController.cs` は旧パス。
- 現在の本体は `Assets/AreaSurvivors/Scripts/Game/Weapons/WeaponController.cs`。
- `focused-search` のPath存在Validatorで旧パスを実行前に拒否し、`safe-search -FilesOnly` で現パスを確定する。
- `Docs/AgentRules/combat.md` に現パスを固定した。

## 2026-07-13 safe-unity-searchの共有資源・Play Mode境界

- 固定query fileと最新report選択は並列呼出しで競合する。名前付きMutexでWrite→Menu→report照合→deleteを直列化する。
- reportは実行前署名から新規/更新されたものだけを候補にし、先頭 `Query:` の完全一致を必須にする。
- `Menu.Execute` の受付成功はReporterファイル生成完了ではない。Edit Modeではquery fileを保持したまま最大10秒、一致reportを待つ。
- Play Mode中はMenu受付が成功してもreportが生成されない場合があるため、事前 `PlayMode.Status` で `guard_code: 32` として拒否する。
- 確認: Mutexにより並列2件目が待機すること、Play中の限定テストがMenuを実行せず `guard_code: 32` になること、command-tools-self-test全項目通過。

## 2026-07-13 built-in image_gen長時間無応答

- Sword Rushアイコン生成でbuilt-in `image_gen` が約180秒、結果・エラー・保存先なしで継続したためセルを停止した。
- `generated_images` 配下に今回の新規出力はなかった。プロジェクトやUnityではなく画像生成サービス境界で、根本原因は未確定。
- 180秒で停止→保存物確認→簡略プロンプトでbuilt-in再試行1回まで。再発時はblockerとし、明示許可なしにCLI/APIへ切り替えない。
- `generated_images` 全件列挙は高出力になるため、今後は対象セッション/生成結果パスを直接使い、全体 `rg --files` を避ける。

## 2026-07-13 画像Helper用Pythonランタイム

- RTK経由の `python` はPATHに存在せず、直接実行もアクセス拒否で終了コード1になった。
- `py` 等を推測して再試行せず、Codex Workspace DependenciesからPython実体を取得する。
- 現セッションの正規実体は `C:\Users\yni87\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe`。
- 画像生成Skill付属 `remove_chroma_key.py` は、この実体パスで実行する。

## 2026-07-13 RTK・PowerShell・日本語検索の失敗境界

- `rtk pwsh` はこのWindows環境で実体を解決できず、対象スクリプトへ到達しなかった。PowerShellスクリプトの固定入口は `rtk C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe ...` とする。
- `safe-read.ps1` の正式なファイル引数は `-Path`。`-File` は契約外であり、記憶から推測して再試行しない。
- Windows PowerShell 5.1がnative `rg` のUTF-8出力を既定コードページで復号し、`safe-search` の日本語一致行だけが文字化けした。`Safe-Command.ps1` の子PowerShellでConsole入出力と `$OutputEncoding` をUTF-8へ固定した。
- BOMなしUTF-8の `.ps1` に日本語リテラルを直接置くと、Windows PowerShell 5.1がANSIとして読みParserErrorになり得る。限定自己テストの日本語はUnicodeコードポイントから組み立てる。
- `command-tools-self-test.ps1` に日本語を含むnative `rg` の往復検証を追加し、`safe_search_utf8_guard: passed` を確認した。


## 2026-07-13 広域diff checkと既存ユーザー差分の混同防止

- 未コミットのScene/Prefab差分が多数ある状態で広域 `git diff --check` を実行すると、今回の所有範囲外にある既存の末尾空白を大量検出し、実装差分の検証結果と混同する。
- 既存差分はユーザーまたは前作業のものとして触らず、`Tools/TokenUsage/scoped-diff-check.ps1 -Path <file>` で今回変更したファイルを1つずつ検査する。
- Wrapperは対象Pathの存在をgit実行前に検証する。`command-tools-self-test.ps1` の `scoped_diff_path_guard` 通過を再開条件とする。


## 2026-07-13 Editor Runnerの新規依存C#未Import

- `invoke-unity-editor-runner.ps1` が一時Runner本体だけをAssetDatabaseへImportしてCompileしたため、同時追加した`EvolutionChoicePresentation`が未ImportとなりCS0246で停止した。Migration/Menuは未実行。
- Runnerに `-DependencyScriptPaths "Assets/.../A.cs;Assets/.../B.cs"` を追加し、全依存C#の存在検証と明示ImportをCompile前に固定した。
- Missing typeごとのCompile再試行は禁止し、Runner本体・Runtime依存・Validator依存を一括Importしてから残りのCompile予算を使う。
- `command-tools-self-test.ps1` の `editor_runner_dependency_import_guard` 通過を再開条件とする。


## 2026-07-13 safe-unity Console件数引数

- `safe-unity.ps1 -Action ConsoleErrors|ConsoleWarnings` の件数引数は `-MaxCount`。`safe-read`や検索Wrapperの`-First`を渡すとUnityへ到達する前にParameterBindingExceptionで停止する。
- `command-tools-self-test.ps1` に `safe_unity_max_count_contract_guard` を追加し、param定義と内部転送の両方を固定した。


## 2026-07-14 image_gen入力画像方式の排他Guard

- 症状: ローカル参照画像を`referenced_image_paths`へ指定しつつ`num_last_images_to_include=0`も渡したため、built-in画像生成が開始前の引数検証で失敗した。
- 原因: `num_last_images_to_include`は0でも「指定済み」と判定され、2つの画像入力方式を同時指定した扱いになる。
- 対応: ローカル参照方式では`num_last_images_to_include`キー自体を省略する。会話画像方式だけ1〜5を指定する。
- 防止: `Tools/AssetGeneration/imagegen-request-preflight.ps1`を追加し、同時指定を`guard_code: 42`、範囲外を43、不在参照画像を44で生成前拒否する。限定自己テスト通過済み。


## 2026-07-14 新規PNGがAssetDatabase未登録のままMigration停止

- 症状: Unity Menuは`executed=true`だったが、4枚の新規PNGに`.meta`がなく、専用Validatorでimport設定とPrefabアニメータ参照が失敗した。
- 根本原因: `GeneratedSpriteAssetUtility.FindSpritePath`がAssetDatabase登録済みTextureだけを対象にし、外部処理で配置された未登録PNGを見つけられなかった。`ImportSprite`はパスnullで黙って戻り、Migrationがフレーム欠落例外で停止した。
- 再発防止: 正規の直接パスに実ファイルが存在すればそのパスを返し、`AssetDatabase.ImportAsset`でmetaを生成してから設定する。専用Validatorはmeta/import設定/Prefab参照を確認し、成功時だけ完了マーカーを作成する。Menuの`executed=true`単独では完了扱いにしない。

## 2026-07-14 Obsidian追記先の実在確認

- 症状: `append-vault-note.ps1`へ未確認の新規Knowledge名を渡し、`Target note does not exist`で入口拒否された。
- 根本原因: 追記専用Wrapperに新規ノート作成を期待した。
- 再発防止: 直近の証拠で実在確認済みのKnowledgeへ追記し、類似名を推測して再試行しない。新規ノート作成はObsidian記憶ルールに従う別手順とする。

## 2026-07-15 複数ファイル検索へ未確認パスを混在させない

- 症状: 既知の2ファイルと、存在未確認の推測パスを同じ `rtk rg` に渡し、2ファイルの一致は返った一方で推測パスが `os error 2` になった。
- 根本原因: ファイル名から旧候補パスを補完し、検索対象すべての実在確認を事前に行わなかった。
- 再発防止: 複数ファイルを明示列挙する検索は全パスを事前確定する。未知のファイルは指定済みの既存親ディレクトリから `safe-search.ps1 -FilesOnly` で実在パスを確定してから、別の限定読み取りへ渡す。既知パスと推測パスを1コマンドへ混在させない。
- 出力制御: 長い手順書や多数フィールドは全文・広域検索を避け、必要な節または完全一致フィールドだけを80行以内で読む。

## 2026-07-15 safe-searchとsafe-readの固定文字列引数を混同しない

- `safe-read.ps1`の`-LiteralPattern`は`safe-search.ps1`には存在しない。
- `safe-search.ps1 -Pattern`は正規表現として記号を明示エスケープする。単一既知ファイルの固定文字列読取は`safe-read.ps1 -LiteralPattern`を使う。
- Wrapper間でswitchを転用せず、その作業で初めて使う引数は先頭`param(...)`または正式用例を確認する。
