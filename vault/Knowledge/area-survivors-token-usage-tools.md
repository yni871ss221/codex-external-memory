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
## 2026-06-26 追加ツール

- `Tools/TokenUsage/start-task-token-check.ps1`
  - `-Task` を受け取り、`rule-router.ps1` と `start-token-check.ps1` を連続実行する。
  - 作業開始時に「読むルールの絞り込み」と「開始UI使用率/予算記録」を同時に行う入口。
- `Tools/TokenUsage/run-unity-report.ps1 -Report skill-tree-layout`
  - `Area Survivors/Reports/Skill Tree Layout` を実行し、スキルツリーのノード参照、アイコン、重なり、リンクをReporterで確認する。
  - 最新確認では `TokenReports/UnityReports/skill-tree-layout-20260626-122758.md` が `Issue Count: 0`。
## 2026-07-13 safe-read Path存在Guard

- 症状: 存在しない推測パスを`safe-read.ps1`へ渡すと、内部`Get-Content`はエラーを出す一方、Wrapper全体が終了コード0に見える場合があった。
- 原因: `safe-read.ps1`がコマンド構築前に対象Pathを既存ファイルとして検証しておらず、PowerShellの非終端エラーを後続処理が正常終了として扱えた。
- 対応: 既存ファイル以外を`guard_code: 33`で入口拒否する。クラス名しか分からない場合は`safe-search.ps1 -FilesOnly`または`focused-search.ps1`で実在パスを確定してから読む。
- 検証: `command-tools-self-test.ps1`へ不在Pathの限定テストを追加し、全自己テスト通過を確認した。

## 2026-07-13 同一Scene内の既存差分とscoped diff

- 症状: `scoped-diff-check.ps1`を今回変更した`07_WeaponBook.unity`だけへ限定しても、以前から同じScene差分に含まれていたUnity YAML空値行（`m_Name: `等）がtrailing whitespaceとして終了コード2になった。
- 原因: scoped検査はファイル境界を分離できるが、同一ファイル内の今回差分と既存未コミット差分までは分離しない。
- 対応: Sceneを整形しない。`Safe-Command.ps1`で同一Sceneのdiffをcaptureし、今回変更したObject名・fileID・serialized fieldだけを`safe-read.ps1 -Pattern`で限定確認する。Reporter/Validator、Compile、Console結果も併用する。
- 確認例: `Evolution Heading Text`の`m_Text`が`進化武器`、武器名・説明Textが`-`、`WeaponBookScreen`の各serialized referenceが同じEvolution Panel配下を指すことを確認した。

## 2026-07-14 Unity Menu同時実行による応答喪失

- 症状: `Sword Rush Evolution` Validator実行中にHUD Guardを開始すると、後発は`Server is busy executing 'unknown'`、先発はEditorログ上でScene検証と例外処理を完了していてもcaptureが0 byteのまま60秒timeoutした。
- 原因: 2つの`safe-unity -Action Menu`を並列に開始し、UniCLIの単一コマンド／named pipe応答境界へ同時接続した。加えて旧Validatorは05/07/08 Sceneを`OpenSceneMode.Single`で往復し、応答経路に不要なScene切替を含んでいた。
- 対応: `Invoke-AreaSafeUnity.ps1`に名前付きMutexを追加し、競合時はUniCLI接続前に`guard_code: 34`で拒否する。Validatorは対象SceneをAdditiveで一時読込して閉じ、現在のActive Sceneとユーザー調整済みUIを切り替えない。
- 検証: `command-tools-self-test.ps1`でMutex・Guardの存在とPowerShell構文を検証する。Unityコマンドは並列実行せず、先発の終了コードを確認してから次を実行する。
- Reporter: `unity-process-report.ps1`のCommandLine出力はopt-inにし、指定時も最大長を制限する。Wrapperが返すJSONLは表示された`report_path`を正とし、`Tools/TokenUsage/TokenReports`など推測パスを直接読まない。

## 2026-07-14 safe-unity named pipe権限Guardの全Action適用

- 症状: サンドボックス内の`AssetRefresh`が`Access to the path is denied`で失敗した際、capture pathは残るが`guard_code: 26`へ正規化されなかった。
- 原因: named pipe権限拒否の判定が`MenuExists`分岐にしか実装されておらず、AssetRefresh・Compile・Console等の一般Actionは生の終了コード1を返していた。
- 対応: 全Actionで`Safe-Command.ps1 -Json`の同一レコードを読み、非ゼロ時のcaptureに権限拒否があれば`guard_code: 26`へ統一する。`command-tools-self-test.ps1`で全Action分岐に判定が存在することを固定した。

## 2026-07-14 focused-searchの件数指定alias

- 症状: `focused-search.ps1`へsafe-searchと同じ感覚で`-First`を渡し、対象検索へ到達する前にParameterBindingExceptionになった。
- 原因: focused-searchの正式パラメータは`-TopFiles`だけで、検索Wrapper間の件数指定名が統一されていなかった。
- 対応: `-TopFiles`へ`First` aliasを追加し、`command-tools-self-test.ps1`で契約を固定した。軽微なUI修正では対象ファイルが判明している場合に追加探索を広げず、既知ファイルの限定読み取りを優先する。

## 2026-07-14 AssetRefresh直後のCompile空応答

- 症状: C#変更を含むAssetRefresh成功直後に`safe-unity -Action Compile`を実行すると、標準出力とSafe-Command JSONLを残さず終了した。
- 原因: AssetRefreshが非同期script compilationを要求した直後に明示Compileを重ね、Domain Reload境界でUniCLI応答経路を失った。Editor.logには変更C#のimportとScriptCompilation要求が記録されていた。
- 対応: AssetRefresh／AssetImport成功時刻を`Library/AreaSafeUnity/last-asset-refresh.utc`へ保存し、30秒以内のCompileを`guard_code: 35`で入口拒否する。自動Compile遷移完了後に必要な明示Compileだけを行う。
- 検証: `command-tools-self-test.ps1`へmarker・cooldown・Guardの静的契約テストを追加した。

## 2026-07-14 UniCLI CompileのDomain Reload busy残留

- 症状: C#変更後の`unicli exec Compile`が空応答になり、次のCompileは`Server is busy executing 'unknown'`で拒否された。
- 原因: CompileHandlerは`CompilationPipeline.RequestScriptCompilation()`後にTaskCompletionSourceを待つため、Domain Reloadで継続が失われるとUniCLIのcurrent commandだけが未完了で残る。Safe-Commandも結果JSONLを確定できない。
- 対応: `safe-unity Compile`から`unicli exec Compile`を除去し、AssetRefreshによるUnity標準の自動Compile後に`verify-unity-script-compilation.ps1`で最新Runtime/Editor C#と`Assembly-CSharp*.dll`の更新時刻を比較する。staleなら成功扱いにしない。
- 今回の結果: Runtime assemblyはcurrent、`SwordRushEvolutionValidator.cs`に対するEditor assemblyはstale。Compile上限2回とserver busyのため、Unity再接続後のCompile／ValidatorをTODOとした。

## 2026-07-14 Compile経路の最終確認完了

- Unity再接続後にAssetRefreshを実行し、30秒cooldown後の`safe-unity Compile`がUniCLI Compileを呼ばず外部assembly freshness検証を実行した。
- Runtime／Editor assemblyはいずれも最新C#より新しく、`unity_script_compilation_verification: passed`。
- `Weapon Book Evolution Panel` Validator成功、`HUD Layout Mutation Guard`成功、Console新規Error 0件。
- `busy unknown`、空応答、Domain Reloadによるpipe応答喪失は再発しなかった。旧TODOは解消済み。

## 2026-07-14 safe-searchの正規表現／glob境界

- 症状: `safe-search.ps1 -FilesOnly -Pattern '*Evolution*'` が`rg`終了コード2になった。
- 原因: `-Pattern`は正規表現契約だが、ファイルglob形式の`*term*`を渡した。先頭の`*`には反復対象がなく、正規表現構文エラーになる。
- 対応: 部分一致は`Evolution`、明示的な前後任意文字は`.*Evolution.*`を使う。`safe-search.ps1`は典型的な`*term*`誤用を`rg`実行前に拒否し、`command-tools-self-test.ps1`で入口Guardを固定する。
- 併発した運用ミス: 入れ子PowerShellの二重引用内で`$_.Name`が外側展開され、`.Name`コマンドとして解釈された。調査用の生`powershell -Command`を避け、`safe-search`、`safe-read`、限定Wrapperの`-File`入口だけを使う。

## 2026-07-14 safe-search複数Pathの位置束縛

- 症状: `safe-search.ps1 -Path path1 path2`で2つ目のパスが`-Extension`へ束縛され、実行`rg`へ`-g '*.path2'`として渡された。終了コード0でも本来の検索結果ではなかった。
- 原因: Windows PowerShellの`-File`呼び出しで、空白区切りの2つ目が次の配列パラメータへ位置束縛された。
- 対応: 1回のWrapper呼び出しでは1つの`-Path`だけを使い、複数対象は独立呼び出しへ分ける。`safe-search.ps1`はパス区切りを含む`-Extension`を入口拒否し、自己テストで固定する。

## 2026-07-14 safe-search HitSummaryの空captureと絶対パス

- 症状: 一致する検索でもHitSummaryのcaptureが空になり、絶対パスの自己テストではファイル名を取得できなかった。
- 原因: `Group-Object`結果をオブジェクトのまま出して直後に`exit 0`したため表示整形が未出力になった。さらに最初のコロンで分割するとWindowsドライブ文字`C:`で切れた。
- 対応: Count／Nameを明示文字列へ変換する。パス抽出は`:<行番号>:`の末尾構造を正規表現で除去する。絶対パス配下の既知ファイル名を使う自己テストを通過させた。

## 2026-07-14 Editor RunnerとAssetImport cooldown

- 症状: `invoke-unity-editor-runner.ps1 -Phase RegisterAndRun`が全依存Import成功後、Compileで`guard_code: 35`になり、Menu移行前に停止した。
- 原因: Runnerが最後のAssetImport直後にCompileを呼び、`safe-unity`の30秒cooldown契約と矛盾していた。
- 対応: Runner自身が`Library/AreaSafeUnity/last-asset-refresh.utc`を読み、31秒経過まで必要分だけ待ってからCompile検証へ進む。RegisterAndRunとRefreshAfterRemovalの両方へ適用し、自己テストで固定した。

## 2026-07-14: Unity Compileのmtime stale誤検知

- 症状: `safe-unity Compile` が、最新C#ソースより `Library/ScriptAssemblies/Assembly-CSharp*.dll` の更新時刻が古いとして終了コード1を返した。
- 根本原因: Editor.logでは最新ソースのCsc、`Tundra build success`、Domain Reloadが完了していた。最新Bee artifactと`ScriptAssemblies`のSHA-256も一致しており、Unityが同一内容の配布先DLLのmtimeを保持したため、時刻だけを見るValidatorが正常Compileをstaleと誤判定した。
- 再発防止: `verify-unity-script-compilation.ps1` はmtimeが古い場合、最新ソース更新後のBee artifactと配布先DLLのSHA-256一致を第二成功条件にする。`command-tools-self-test.ps1`へ、古い配布先mtime＋新しい同一Hash Bee artifactを受理する限定テストを追加した。
- 運用: stale表示だけでC#エラーと断定・再Compileしない。Editor.logのbuild/domain reload、Bee artifact時刻、Hash一致を確認する。Hash不一致またはBee artifactも古い場合だけ真のstaleとして停止する。

## 2026-07-14: Menu.Execute受付成功とMigration完了は別

- 症状: Banana Evolution Migrationが終了コード0・`executed: true`を返したが、専用Validatorでは05/07/08 Sceneの静的参照が未反映だった。
- 根本原因: 05_Game詳細HUDの全パネル直下に`Sword Rush Icon`があると誤って仮定した。実際はSlashパネルにだけ存在し、`DuplicateIcon`が例外終了した。`WithScene`は例外時にSceneを保存しないため05_Gameの先行変更も破棄され、07/08処理には進まなかった。一方UniCLIはMenu受付結果だけを返すため`executed: true`だった。
- 再発防止: Scene Migrationは変更前に全対象数・複製元・保存先をPreflightする。Menu応答だけで成功判定せず、専用Validator、Console Error、処理末尾でだけ作る完了markerのいずれかを確認する。例外後の同一Menu再実行は禁止し、検索条件をReporterで確定してから修正する。

## 2026-07-14: scoped-diff-check複数PathのRTK契約

- 症状: `scoped-diff-check.ps1 -Path 'a','b'`相当の呼び出しが、カンマを含む1つの長い不存在パスとして拒否された。
- 根本原因: `rtk`からWindows PowerShellの`-File`境界へ渡る引数はPowerShell式として再評価されず、カンマ区切りが`string[]`へ展開されない。
- 再発防止: 複数パスの正式契約を引用符付きセミコロン区切り`-Path "a;b"`とし、Wrapper内で分割する。カンマは入口で説明付き拒否し、`command-tools-self-test.ps1`でGuardと転送契約を固定した。

## 2026-07-14: PowerShell -Fileへソースを直接渡さない

- 症状: 並列読み取りの1件で`powershell -File Assets/.../GameManager.cs`となり、`.ps1`ではないため入口で拒否された。
- 原因: `safe-read.ps1 -Path`のWrapper部分をコマンド組み立て時に欠落させた。
- 再発防止: PowerShell `-File`直後は実行する`.ps1` Wrapperだけを置く。C#等の読み取り対象は必ず`safe-read.ps1 -Path`へ渡し、拒否後に`Get-Content`等へ切り替えない。

## 2026-07-14: safe-readのコードリテラル検索

- 症状: `safe-read -Pattern 'kills++'`が意図しない高出力になり、出力Guardに遮断された。
- 原因: `-Pattern`は正規表現契約で、コード記号をリテラルとして扱う入口がなかった。
- 再発防止: `safe-read.ps1 -LiteralPattern`を追加し、内部で`[regex]::Escape`する。未エスケープの`++/**/??`は`guard_code: 36`で拒否する。実対象`GameManager.cs`で`kills++`の1一致を確認し、自己テストはGuard動作とEscape契約を固定した。
- 補足: 同一PowerShell内から子Wrapperの表示出力を変数捕捉する自己テストは実行時表示契約とずれるため、実コマンド限定テストと静的契約テストを分離する。

### `-LiteralPattern`の正式な引数順

`-LiteralPattern`は値を取らないswitch。正式形は`safe-read.ps1 -Path <file> -Pattern "kills++" -LiteralPattern`。`-LiteralPattern "kills++"`と渡すと後続位置引数へ誤束縛されるため禁止する。

## 2026-07-14: safe-readはregex構文を行照合前に検証する

- 症状: `-Pattern 'EnsureWeaponLevels('`の未閉じ括弧が全行の`-match`で反復エラーとなり、高出力Guardに遮断された。
- 原因: safe-readがregexを事前compileせず、生成した行走査へ直接渡していた。
- 再発防止: `[regex]::new($Pattern)`を入口で実行し、無効regexを`guard_code: 37`で拒否する。コード文字列の正式形は`-Pattern "EnsureWeaponLevels(" -LiteralPattern`。自己テストで未閉じ括弧の入口拒否とEscape契約を固定した。

## 2026-07-14 武器進化一括実装中のコマンド境界

- `scoped-diff-check.ps1`は`-Path "a;b" [-PrintOutput]`だけを受け付け、常に`git diff --check`を実行する。差分概要のつもりで`-Mode Summary`等を推測してはならない。
- built-in画像生成結果を複数保存する際、RTK越しの`powershell -Command`へ二重引用符付き配列を埋め込むと、内側PowerShellまでに引用符が剥離し`MissingArgument`になり得る。
- 複数画像の保存は`Tools/AssetGeneration/copy-generated-image-batch.ps1`とUTF-8 manifestを使い、`-ValidateOnly`で全入力・保存先境界を検証してから同じWrapperでコピーする。
- 再発防止は`Tools/TokenUsage/command-tools-self-test.ps1`で固定済み。

## 2026-07-14 safe-search検索起点の正式契約

- `safe-search.ps1`の検索起点は`-Path <既存パス>`であり、`-Root`は受け付けない。
- `-Pattern`はregexであり、`*Name*`のようなglobは入口Guardが拒否する。部分一致は`Name`または正規表現を使う。
- Wrapper help、`Docs/AgentRules/token-tools.md`、`command-tools-self-test.ps1`へ正式契約を固定した。

## 2026-07-14 サブエージェントの依存待ち運用

- 作業担当サブエージェントがLeadの修正完了を待つため`wait_agent`を反復すると、実行中コマンドがないのにrunning状態が続き、hangと区別できない。
- 依存待ちは現状・証拠・再開条件をfinalで返して一度終了し、Leadが条件解消後に`followup_task`で明示的に再開する。
- AGENTS.mdのSubagent Operationへ固定済み。

## 2026-07-14 safe-unity-searchの正式契約

- `safe-unity-search.ps1`は固定Scene/Prefab Reporterの入口で、引数は`-Query <対象名> [-PrintOutput]`だけである。
- 通常検索`safe-search.ps1`の`-Path`を転用しない。検索範囲はReporter側が管理する。
- タスクで初めて使うWrapperは、実行前に先頭`param(...)`または正式用例を確認し、別Wrapperの引数・glob・Modeを推測転用しない。
- この入口はUnity接続とEditor Menu Reporterを実行するため、Unity/Menu実行禁止の委譲タスクでは使用不可。

## 2026-07-14 functions.exec command cellの待機方法

- `functions.exec`が`Script running with cell ID`を返した場合、継続結果は同じcellへ`functions.wait`して回収する。
- `collaboration.wait_agent`はエージェントmailbox専用で、command cellは待てない。mailbox timeoutをコマンド無応答と誤認しない。
- cell未回収のまま同じ依存ロードを再発行せず、元cellの結果または終了状態を先に確定する。

## 2026-07-14: wait_agent最小timeoutと文書patch anchor

- 症状: `collaboration.wait_agent(timeout_ms=1000)` がTool input validationで失敗した。
- 原因: `wait_agent.timeout_ms` の許容範囲は `10000`〜`3600000` だが、即時poll目的で最小値未満を指定した。
- 再発防止: 即時状態確認は `list_agents`、mailbox更新待ちは10秒以上の `wait_agent` に分離する。`AGENTS.md` と command failure playbookへ固定した。
- 追加事象: 再発防止追記時、存在を確認していない見出しを `apply_patch` のanchorに使い、適用前検証が失敗した。ファイル変更は発生していない。
- 追加対策: 既存文書へのpatchは、先に `safe-read` で実在contextを確認し、その最小contextだけをanchorにする。
- 追加事象2: `append-vault-note.ps1`へ存在しない`-VaultPath/-NotePath/-AppendFile`を渡し、入口で拒否された。正式引数は`-VaultRoot/-RelativePath/-ContentPath`。
- 追加対策2: Wrapperの`param(...)`を利用ターンで確認し、正式引数を`command-tools-self-test.ps1`で固定する。別方式でObsidianへ直接追記しない。

### 2026-07-14: 外部Vault追記の権限境界

- `append-vault-note.ps1`の正式引数確認後も、workspace外の外部Vaultはsandbox内実行では`UnauthorizedAccessException`になる。
- これはWrapperや内容の不良ではなくfilesystem permission boundary。captureした同一Wrapper・同一引数を`require_escalated`で承認実行し、正常完了した。
- 別Shellや直接書き込みへ切り替えず、正規Wrapperを維持する。

### 2026-07-14: 並列safe-readの引用符不整合

- 2本のWrapper契約確認を並列生成した際、`Invoke-AreaSafeUnity.ps1`の`-Path`末尾に余分な引用符が入り、PowerShell ParserErrorになった。
- Wrapper到達前の構文失敗で、Unity操作・Compile・状態変更はない。
- Wrapperの初回`param(...)`確認は1本ずつ正規safe-readテンプレートで実行し、契約確認前の並列Shell組み立てをしない。

## 2026-07-14: 進化武器追加中のテストScene差分境界

- 症状: `08_GameTestLauncher.unity`へContent高さとスクロール制御だけを追加した後、HEAD基準の`git diff --stat`が2万行超を示した。
- 原因: 同じ未コミットSceneには、今回以前から進化武器11件と関連UI再配置が含まれていた。ファイル全体のstatは既存差分と今回差分を合算するため、今回の限定変更量を表さない。
- 確認: full diffは`Safe-Command`へcaptureし、今回固有の`Content` fileID、`m_SizeDelta.y: 1145`、`OptionsPanelScrollController` GUIDだけを`safe-read -Pattern`で抽出した。専用Validatorで武器ボタン22件、進化ボタン11件、共通Content、Viewport/Mask、Controller参照、必要高さを確認した。
- 運用: 同一Sceneに以前の未コミット変更がある場合、statの大きさだけで再シリアライズ事故と断定しない。Sceneを整形・再保存せず、Object名・fileID・serialized fieldの限定diffと専用Validator、Compile、Console結果で今回の変更境界を判定する。

## 2026-07-14: 入れ子Scroll Viewの外側Content誤認

- 症状: テストメニューの進化武器UIがSceneビューで見切れたままになった。
- 根本原因: `Tool Scroll View/Viewport/Content`（外側Content、高さ2220）と`Weapon Test Panel`内の武器リスト用`Viewport/Content`が同じSceneに存在した。旧Migration/Validatorは武器ボタンから親をたどり、内側Contentを画面全体のContentと誤認して高さ1145へ変更したため、外側`Tool Scroll View`の高さ600とMaskが残った。
- 証拠: 外側Root `Tool Scroll View` fileID `1486930631`、外側Viewport `157874032`、外側Content `1060991497`。Weapon Test Panelは外側Contentの子でY=-1650、外側Content高は2220。Consoleには外側Root不在・旧ScrollRect残存を専用Validatorが記録した。
- 再発防止: Scroll UIのMigration/Validatorは一意な画面Root名から直下Viewport/Contentを解決し、外側と内側のfileID・高さ・親子関係をPreflightする。子項目起点で最初の`Content`を対象にしない。

## 2026-07-14: 複製した進化武器ボタンのSprite対応漏れ

- 症状: `08_GameTestLauncher.unity`へ追加した進化武器ボタンのうち、ソードラッシュ以外もすべてソードラッシュのアイコンになった。
- 根本原因: `WeaponEvolutionBatchMigration`がソードラッシュのボタンを複製して名前とラベルだけを変更し、子`Icon`の`Image.sprite`を武器種別ごとに差し替えていなかった。旧Validatorもボタンの存在だけを確認していたため、誤ったSprite参照を検出できなかった。
- 修正: 11種の進化武器と期待Spriteの対応表を用い、Scene上の各ボタンの`Icon.sprite`を個別に設定した。専用Validatorも11種すべてについて期待Spriteとの参照一致を検証する。
- 再発防止: アイコン付きUIを複製するMigrationは、ラベル、識別名、Sprite参照を1組の対応表として扱う。完了判定は要素数や存在だけでなく、種別ごとの期待Sprite一致まで含める。Scene上の静的参照を正とし、Runtime差し替えで補正しない。

## 2026-07-14: safe-searchへ推測した不存在ディレクトリを渡した

- 症状: 黄金の弓のテスト起動処理を探す際、存在確認前の`Assets/AreaSurvivors/Scripts/GameTest`を`safe-search.ps1 -Path`へ渡し、Path Guardで入口拒否された。
- 原因: テスト起動コードの実在場所を先に`-FilesOnly`で確定せず、ディレクトリ名を推測した。
- 影響: Guardが検索開始前に拒否したため、Unity操作・ファイル変更・機能実装には到達していない。
- 再発防止: 検索先が未確定なら、既知の直近親ディレクトリを検索起点にして実在ファイルを確定する。存在しないPathの拒否後に類似パスを手打ち再試行しない。既存Path Guardと`command-tools-self-test.ps1`を正式な防止入口とする。

## 2026-07-14: functions.exec内でexec_commandの継続sessionを失った

- 症状: `invoke-unity-editor-runner.ps1`が31秒cooldownへ入ったところで、外側`functions.exec`は完了したが、Compile・Menu実行の後続出力を回収できなかった。
- 原因: 内側`exec_command`が`session_id`付きでyieldした際、呼び出し側が`output`だけを表示し、`session_id`を保持せず終了した。
- 境界: 3スクリプトのAssetDatabase.Import成功と31秒待機開始までは出力で確認済み。Compile／Menu完了は未確認のため、孤立処理へUnityコマンドを重ねない。
- 再発防止: 長時間commandは同一JS内で`exec_command`結果を保持し、`session_id`がある間`write_stdin`を10秒以下でpollする。外側cellは`functions.wait`、内側PTY sessionは`write_stdin`という二層の待機契約を混同しない。

## 2026-07-14: 黄金の弓の矢サイズと一斉発射契約

- 症状: 黄金の矢が通常矢より大きく、単体相手では矢本数があっても1本ずつ周期発射されるため銃のように見えた。
- 原因1: `GoldenBowEffect.png`は128x128キャンバスを96 PPUで表示しており、横長の通常矢よりワールド上のSprite外形が大きかった。
- 原因2: 弓の共通発射処理が`min(矢本数, ターゲット数)`へ減数していた。ターゲットが1体ならLv.10の矢本数を持っていても毎周期1本しか生成されなかった。
- 修正: 黄金の矢だけ160 PPUへ変更して小型化した。通常弓・黄金の弓の共通処理は、矢本数分を同一フレームで生成し、敵が少ない場合は既存ターゲットへ巡回配分する。黄金の弓固有差分は攻撃力、金色Visual、貫通だけとし、射程到達まで消滅しない既存貫通処理を維持した。
- 検証: `Area Survivors/Validate/Golden Bow Evolution`でSprite寸法・160 PPU・Prefab参照・5発/2ターゲットの巡回配分を確認する。Play Modeの見た目と体感はユーザー確認へ委ねる。

### 同種2回目: PlayerControllerの格納先を推測した

- `Assets/AreaSurvivors/Scripts/Game/Player/PlayerController.cs`を実在確認せず`safe-read`へ渡し、`guard_code: 33`で入口拒否された。
- 前回の`Scripts/GameTest`推測と同じ原因であり、ファイル変更・Unity操作には到達していない。
- 同種2回目のため、以後はクラス名しか分からない場合にファイルPathを組み立てない。既知の`Assets/AreaSurvivors/Scripts`を起点とする`safe-search.ps1 -FilesOnly`だけで実在パスを確定し、結果に出たパスをそのまま`safe-read`へ渡す。
- 既存のPath Guardと`command-tools-self-test.ps1`を部品化済みの防止入口として扱い、推測パスの手打ち再試行を禁止する。

### 再発: alternationと未閉じコード句読点を混在させた

- `safe-read -Pattern 'WeaponController|Configure('`を渡し、未閉じ`(`のため`guard_code: 37`で入口拒否された。対象ファイルの読み取り・変更・Unity操作には到達していない。
- 複数語を1本にまとめる場合でも、regex alternationと未エスケープのコード句読点を混在させない。コード文字列は1語ずつ独立した`-LiteralPattern`へ分ける。
- 既存のregex事前compile Guardと`command-tools-self-test.ps1`を正式な防止入口として維持する。

## 2026-07-14 訂正: 黄金の弓は通常弓と同じ一斉射・同一サイズを維持する

- 前節の「160 PPUで近似縮小」「敵が少ない場合は同じ敵へ巡回配分」は、ユーザーの実機再確認により仕様不一致と判明したため撤回する。
- 正しい契約は、1クールタイムにつき1回だけ、`min(矢本数, 射程内の敵数)`本を同一フレームで別々の対象へ発射すること。矢本数4・敵4なら4本を1斉射し、4本を4回発射してはならない。
- 「通常の弓矢と同じサイズ」はPPUによる近似ではなく、通常矢Prefabと同じSprite、Transform Scale、Colliderを使い、黄金の弓固有差分は金色Tintと貫通、指定された基礎ステータスだけに限定する。
- 共通弓処理へ次回一斉射時刻のガードを持たせ、同一WeaponControllerから同一クールタイム内に重複した一斉射要求が来ても1回に制限する。専用Validatorは4本/4対象=4、4本/1対象=1、通常矢とのSprite/Scale一致、クールタイムガードの存在を確認する。

## 2026-07-14: 管理スクリプトのRoot定数を読まずアセットパスを推測した

- 失敗コマンドは`safe-read.ps1`へ`Assets/AreaSurvivors/Prefabs/Projectiles/GoldenArrow.prefab`と`Assets/AreaSurvivors/Sprites/Generated/GoldenBowEffect.png.meta`を渡し、双方とも`guard_code: 33`、終了コード1、timeoutなしで入口拒否された。captureは`safe-command-9ef3a5676991469da888f1757c4feaab.txt`と`safe-command-e94309b654cc4088a26345afd531f347.txt`の直前調査系列に保存された。
- 根本原因は、既知の`WeaponEvolutionBatchMigration`にある`PrefabRoot = Assets/AreaSurvivors/Prefabs/Weapons/`と`GeneratedWeaponRoot = Assets/AreaSurvivors/Sprites/Generated/Weapons/`を先に読まず、一般的な分類名を推測で補ったこと。
- 再発防止として、Migration、Validator、Importerに対象Root定数がある場合は既知ファイルを先に読み、定数から実在パスを解決する。`Docs/AgentRules/command-failure-playbook.md`にも同じ入口規則を追加した。

## 2026-07-14: 黄金の弓の複数斉射は静的構成だけでは再現できていない

- ユーザー実機では黄金の弓が1クールタイム中に対象へ複数回射撃している。サイズ修正は確認済み。
- 静的調査では、`ArrowLoop`の開始箇所は1つ、発射入口は`ShootArrowsAtNearestTargets`の1つ、Player Prefabの`WeaponController`は1個、05_Game Sceneの`GameManager`は1個、GoldenArrow Prefabの`Projectile`は1個だった。`AdvancedWeaponRuntime`は通常弓・黄金の弓を発射していない。
- 前回Validatorは本数計算HelperとタイマーFieldの存在しか確認せず、実際のvolley呼び出し回数を検証していなかった。この検証不足が修正を誤って完了扱いした原因であり、ゲーム側の複数射撃根本原因はまだ未確定。
- 次回は、4本が同一フレームで重なる現象か、4本の斉射が時間差で繰り返される現象かを実機traceで区別する。根本原因を確定するまで追加の推測修正は行わない。

## 2026-07-14: safe-unityの内部Compile失敗が外側で終了コード0になった

- `Invoke-AreaSafeUnity.ps1 -Action Compile`は内部の`verify-unity-script-compilation.ps1`でstale assemblyを検出し、Safe-Command記録は終了コード1、timeoutなし、capture `safe-command-a737ed8b8df34531a44ba90d0a7e36cc.txt`だった。
- しかしWrapperは`$global:LASTEXITCODE = $safeExitCode`だけでPowerShellプロセスを終了しておらず、外側`exec_command`は0を返したため、呼び出し側がConsole確認まで進んだ。
- Wrapper末尾を`exit $safeExitCode`へ修正し、自己テストで終了コード伝播行を必須化した。直前に編集したC#は`Compile`検証を反復せず、Editor RunnerのImport→Compile→Menuを一体で使う。

### 同時に発生した並列safe-read手組み事故

- 同一ファイルの2範囲を読む並列コマンドで、2本目の`-File`へ`safe-read.ps1`ではなく対象Wrapperを置き、未定義`-StartLine`で終了コード1になった。対象処理・状態変更には到達していない。
- 同種再発のため`safe-read-batch.ps1 -Path <file> -Ranges "start-end;start-end"`を追加し、1つの固定入口から範囲検証後に直列読取する。`command-tools-self-test.ps1`で正常2範囲と不正range拒否を確認済み。

## 2026-07-14: サブエージェントへ現行パスを渡さず旧分類パスを推測させた

- 黄金の弓調査Agentが`safe-search.ps1 -Path Assets/AreaSurvivors/Scripts/Game/Player`を実行し、存在しない検索起点のため終了コード2、timeoutなしでPath Guard停止した。状態変更・Unity操作には到達していない。
- 正しい現行ファイルは`Assets/AreaSurvivors/Scripts/Game/Characters/PlayerController.cs`で、Leadは既に把握していたが依頼文へ明記していなかった。
- 再発防止として、Leadが既知の現行ファイルと既存親ディレクトリをサブエージェント依頼へ必ず列挙する規則を`AGENTS.md`とcommand failure playbookへ追加した。未知のパスは指定済み既存親からFilesOnlyで確定し、Skillの旧パスや分類名を補完しない。

### 2026-07-14 Golden Bow根本調査中の検索Wrapper引数ミス

- `safe-read-batch.ps1` に `start:end,start:end` を渡し、契約の `start-end;start-end` と不一致でGuardに拒否された。
- 続けて `focused-search.ps1` へ未定義の `-Include '*.cs'` を推測で渡し、PowerShellの部分一致によって `IncludeUnityYaml` と後続の整数引数へ誤バインドされた。
- 再発防止として `focused-search.ps1` に明示的な `Include` Aliasと `*.cs` 正規化を追加し、`command-tools-self-test.ps1` で契約を固定した。複数範囲の区切り規約も `command-failure-playbook.md` に明記した。
- 原因確定と限定自己テスト通過前にはGolden Bow実装へ戻らなかった。

### 2026-07-14 黄金の弓再現準備でPlay中Evalを要求した

- `safe-unity.ps1 -Action Eval`でPlay中に`RunState.SetNextWeaponTest(GoldenBow)`とScene遷移を要求したが、既知の`guard_code: 27`により実行前拒否された。生成C#、Domain Reload、Scene遷移には到達せず、PlayExitは同じ安全Wrapperで成功した。
- 原因は、`command-failure-playbook.md`にある「Play中Eval禁止・事前Compile済みHookを使う」規則を実行前に適用しなかったこと。
- 黄金の弓の自動再現は、Editorで事前CompileしたPlay Mode状態HookをMenuからarmし、`safe-unity PlayEnter`後の`EnteredPlayMode`で通常の`RunState.SetNextWeaponTest`と05_Game遷移を行う。Play中Evalへ戻さない。

### 2026-07-14 safe-read-batchへ未定義AllowManyを渡した

- `safe-read-batch.ps1`で80行超の範囲を読む際、`safe-read.ps1`にある`-AllowMany`も使えると推測して渡し、ParameterBindingで処理前停止した。
- batch Wrapperへ正式な`AllowMany` switchと各safe-read呼び出しへの転送を追加し、`command-tools-self-test.ps1`でパラメータ存在と81行範囲の通過を固定した。
- 複数範囲は`start-end;start-end`、80行超は`-AllowMany`という契約をcommand failure playbookへ明記した。

### 2026-07-14 safe-unity Screenshotへ絶対パスを渡した

- Play中のGolden Bow診断画面取得で`ScreenshotPath`へ絶対パスを渡し、保存前の既存Guardに拒否された。Unity画面取得・ファイル生成には到達していない。
- 正式契約はプロジェクト相対の`Temp/<name>.png`または`TokenReports/<name>.png`である。既存の`screenshot_path_guard`自己テストは通過済み。
- Play回数上限2回へ到達したため、追加Playや別Screenshot方式へ切り替えず、安全WrapperでPlayExitして静的原因調査へ戻した。

## 2026-07-14 safe-read対話出力Guard

- 症状: `safe-read -PrintOutput`で260行の範囲読取を別の読取と並列実行し、`functions.exec`の合算出力がコンテキスト上限を超えて切り捨てられた。続く`MaxMatches=10 / Context=8`の読取も221行・約5,558 tokenとなり、同じ境界を再確認した。
- 原因: `-AllowMany`は読取件数の意図確認だけで、会話へ流す標準出力量を制限していなかった。個別コマンド成功と、呼出し全体の安全な出力予算は別の境界だった。
- 対応: `safe-read.ps1`は`-PrintOutput`の推定出力が160行を超える場合を`guard_code: 39`で実行前拒否する。範囲・一致数・Contextを狭め、読取は直列化する。単一出力の予算を明示確保した場合のみ`-AllowHighOutput`を使い、他の出力と並列化しない。
- 検証: `command-tools-self-test.ps1`に161行の拒否と、標準出力を伴わない明示許可のテストを追加し、全項目通過を確認した。


## 2026-07-14 safe-unity-search Query空白Guard

- 症状: `safe-unity-search -Query " Icon"`はUnity Menu実行が成功し`Query: Icon`のレポートを生成したが、Wrapperは先頭空白付きヘッダーの完全一致を10秒待って`guard_code: 30`になった。
- 原因: Wrapperは入力をそのまま期待値へ使い、Unity ReporterはQueryをtrimして記録していた。
- 対応: `Invoke-AreaUnitySearch.ps1`は空文字と先頭・末尾空白を`guard_code: 40`でUnity接続前に拒否する。検索語はtrim済みで渡す。
- 検証: `command-tools-self-test.ps1`へ先頭空白Queryの入口拒否テストを追加し、全項目通過を確認した。


## 2026-07-14 safe-unity CompileとC# Import境界

- 症状: Unity外でRuntime/Editor C#を変更した直後に`safe-unity -Action Compile`を実行し、旧Assembly/Bee artifactのままstale判定になった。
- 原因: Compile Actionは再Compile要求ではなく、現行Assemblyの鮮度検証専用でありAssetDatabase Importを行わない。詳細ルールが「追加したEditorスクリプト」に限定して書かれており、既存Runtime/Editor C#の外部変更にも同じ境界があることが不明瞭だった。
- 対応: 変更した全C#を明示Importする。Editor Menuを続けて実行する場合は`invoke-unity-editor-runner -Phase RegisterAndRun -DependencyScriptPaths ...`へ全依存を列挙し、Import→Compile→Menu確認→実行を固定する。staleは`guard_code: 41`で分類する。
- 検証: verifierの説明文、詳細ルール、自己テストを更新し、全項目通過を確認した。


## 2026-07-14 武器HUD参照欠落と武器図鑑旧アイコン残留

- 武器HUDの症状: 獲得武器の名前とLvは表示されるが、左側の大アイコンだけ空欄になった。
- 原因: `WeaponEvolutionBatchMigration.UpdateGameScene`が`WeaponHudCompactIconSlot.icons`を進化武器だけの新規配列で置換し、Sceneに残っていた通常武器11種の参照を脱落させた。
- 対応: Migrationは既存の非進化Entryを保持して進化Entryを追加する。既に壊れたSceneは、Source Imageを変更せず、各slot直下の既存Imageと`WeaponCatalog.IconResource`のSprite一致から通常11種を再接続する限定Menuで修復する。
- 防止: `WeaponEvolutionBatchValidator`は3slotすべてについて通常11種＋進化11種のWeaponType・GameObject・Sprite一致を検証する。
- 武器図鑑の症状: 黄金の弓アイコンの背面にソードラッシュのシルエットが薄く残った。
- 原因: 型別`evolutionIcons`経路が旧`evolutionDiscoveredIcon/evolutionUndiscoveredIcon`を非表示へ戻していなかった。
- 対応: 型別アイコンを切り替える前に旧フォールバック2種を必ず非表示にし、07_WeaponBookのScene既定も非表示へ修復する。Validatorで型別配列使用時の旧フォールバックactiveを拒否する。


## 2026-07-14 safe-read出力合算によるコンテキスト切り捨て

- 症状: `safe-read.ps1 -PrintOutput`が単体の推定96行で成功したが、長いコード行と残りコンテキスト量により結果が切り捨てられた。さらに複数の読み取りを1回の`functions.exec`へまとめると、各コマンドが小さくても合算出力が上限を超えた。
- 根本原因: Wrapperの入口上限が160行と緩く、`functions.exec`単位の合算出力を運用ルールで制限していなかった。
- 再発防止: `safe-read`の標準出力上限を80行へ下げ、`-PrintOutput`は`functions.exec` 1回につき1件だけ実行する。複数対象は別呼び出しで直列取得し、切り捨て後に同じ大範囲を再発行しない。
- 検証: `command-tools-self-test.ps1`で81行要求が`guard_code: 39`により入口拒否されることを固定する。

## 2026-07-14 safe-search標準検索の件数打ち切り

- 症状: 結果が20件を超える標準検索で表示結果は得られたが、`rg`の終了コードが`-1`になった。
- 根本原因: `rg -n ... | Select-Object -First N`がN件到達時にnative入力パイプを閉じていた。FilesOnlyでは既に対策済みだったが標準検索へ水平展開されていなかった。
- 再発防止: 標準検索も`rg`の全出力と終了コードを先に取得し、実エラーだけを伝播してから先頭N件へ絞る。終了コード1は一致なしとして成功へ正規化する。
- 自己テスト注意: `rg`と`Select-Object`が同じ生成コマンド内に存在するだけでは、配列取得後の安全な絞り込みも偽陽性になる。旧式の正確な字句`$pathArgs | Select-Object -First`だけを拒否する。

## 2026-07-14 Editor Runnerの長大出力とcommand cell回収

- 症状: 長時間のEditor Runnerを会話側で待機した際、戻り値が残存contextを超えて結果表示が切れ、完了済みcellも後から回収できなかった。
- 原因: Runnerが成功した各Safe Unityサブコマンドのpayloadを全量返していた。さらにcell待機を`functions.exec`内の`tools.wait`として誤って呼び、元処理とは別の入口エラーを発生させた。
- 対応: `invoke-unity-editor-runner.ps1 -Concise`を追加し、成功時は段階名だけ、失敗時は末尾40行とcapture情報だけを返す。command cellは外側の`functions.wait(cell_id)`だけで回収し、cell消失時は再実行せずTokenReportsとSafe-Command captureで終了状態を確定する。
- 検証: `command-tools-self-test.ps1`でConcise switch、成功payload抑止、失敗証拠40行上限を固定し、全テスト通過を確認した。

## 2026-07-14 dirty worktreeでのstatus出力

- 症状: 既存差分が多い作業ツリーへ生の`git status --short`を実行し、224行の対象外変更一覧で会話出力がtruncatedになった。
- 原因: 既存の`safe-status.ps1`入口を使わず、Git出力を直接会話へ展開した。
- 対応: 状態確認は`safe-status.ps1`でcaptureへ保存し、今回所有ファイルの品質確認は`scoped-diff-check.ps1`へ分離する。`command-tools-self-test.ps1`の構文検査対象にも`safe-status.ps1`を追加した。

## 2026-07-15 safe-readのPrintOutput行数予算

- 症状: `safe-read -Pattern -PrintOutput`で`Context=12, MaxMatches=4`などを指定し、80行Guardを複数ファイルで再発させた。
- 原因: 推定行数`MaxMatches × (Context × 2 + 4)`を実行前に計算せず、各値だけを小さく見積もった。
- 対応: 実行前に式で80行以下を確認する。複数範囲は引数調整を繰り返さず`safe-read-batch.ps1`へ固定する。既存Guardとコマンド自己テストを成功条件にする。

## 2026-07-15 Editor Runner session回収と読み取り直列化

- Runnerが31秒cooldown中に`exec_command`の30秒yieldへ達し、`exit_code`未定義・`session_id`ありで返ったが、呼び出し側がsession_idを表示せず継続ハンドルを失った。以後は両項目を必ず保存し、失った場合は再発行せずTokenReportsから診断する。
- `Get-TokenReportSummary.ps1`へ`timeout_seconds`、`timed_out`、`capture_path`と`-FailedOnly`を追加した。これにより失敗コマンドのcaptureを限定取得できる。
- 今回のCompile停止はC#エラーではなく、AssetImport後31秒でもEditor Assembly／Bee artifactが最新Validatorより古い`guard_code: 41`だった。固定待機ではなく、単一Compile検証内で鮮度をtimeoutまで待つ必要がある。
- 同一`safe-read-batch.ps1`をRTK経由で並列起動すると、一方だけ`-File`境界が崩れ対象スクリプトへ`-Ranges`が渡った。PowerShell読み取りWrapperは直列実行し、複数範囲は1回のRangesへまとめる。
- 複数ファイルを含む`apply_patch`は1件の文脈不一致で全体が失敗する。失敗対策やルール更新は実在行を確認し、1ファイル1パッチに分離する。

## 2026-07-15 Unity 2022.3 Custom Sprite PivotとCompile診断

- 2回目Compileは`verify-unity-script-compilation`が110秒待機後も`guard_code: 41`となり、Console Errorは0件だった。
- 権限付き`safe-read -Last 80`でEditor.logを確認すると、Bee buildは`TextureImporter.spriteAlignment`が存在しないCS1061で終了していた。Assembly鮮度待機はC#エラーを直接表示しないため、timeout後のEditor.log末尾確認が必要。
- Unity 2022.3のCustom Pivotは`TextureImporterSettings`を生成し、`ReadTextureSettings`→`settings.spriteAlignment`／`settings.spritePivot`→`SetTextureSettings`→`SaveAndReimport`で設定する。Validatorも同じSettingsを読み取って検証する。
- Compile上限2回に達したため、正しいAPIへコード修正後も3回目Compile／Migration／Validatorはユーザー追加許可まで実行しない。

## 2026-07-15 safe-read-batchの80行自動分割

- 症状: `safe-read-batch -Ranges "1-105"`や`"1-100"`を渡し、内部safe-readの80行Guardを同じ調査中に2回発生させた。
- 原因: batch入口が範囲構文だけを検証し、1範囲の行数を分割せずsafe-readへ転送していた。利用側が毎回80行境界を手計算する必要があった。
- 対応: `-AllowMany`なしで80行を超える範囲は、safe-read-batch自身が`1-80`、`81-...`へ自動分割する。自己テストで`1-81`が2チャンクになることを固定した。

### 2026-07-15: 長いスレッドでのSkill読み取りと外部ルート検索

- `SKILL.md`を生の`Get-Content -Raw`で会話へ展開すると、内容が短くても長いスレッドでは残りcontextを超えて結果回収不能になる。filesystem-backed Skillも`safe-read-batch.ps1`へ単一範囲を渡し、80行単位で直列回収する。
- `safe-search.ps1 -Pattern/-Query`は正規表現であり、`param(`のような不正な式は従来`rg`終了コード2まで進んでいた。Wrapperで正規表現を事前コンパイルし、`guard_code: 43`で入口拒否する。
- `C:/Users/<user>/.codex`直下には`.sandbox-secrets`等のアクセス制限された稼働領域があり、広域`rg`は終了コード2になる。`.codex`ルート指定を`guard_code: 44`で拒否し、`.codex/skills`等の既知サブディレクトリだけを検索する。
- `command-tools-self-test.ps1`でSkill分割読み取り、正規表現Guard、制限サブツリー除外、`.codex`ルートGuardを固定する。

### 2026-07-15: scoped diff Wrapper名の推測禁止

- 差分検査Wrapperの正式名は`Tools/TokenUsage/scoped-diff-check.ps1`。`scoped-diff.ps1`へ短縮して推測するとPath Guard (`guard_code: 33`)で拒否される。
- 初回利用時は`Docs/AgentRules/token-tools.md`の正式用例か`safe-search.ps1 -FilesOnly`で実在名を確定してから実行する。既存の`command-tools-self-test.ps1`にある`scoped_diff_path_guard`を維持する。

### 2026-07-15: Wrapper Preflightの呼び先固定

- 対象Wrapperの`param(...)`を読む時は、`safe-read-batch.ps1 -Path <対象Wrapper.ps1> -Ranges "1-80" -PrintOutput`を使う。
- 対象Wrapper自体へ`-Ranges`等の読み取り引数を渡すと、`NamedParameterNotFound`で入口拒否される。読むWrapperと読まれる対象Wrapperをコマンド上で分離する。

### 2026-07-15: インラインPowerShellの変数展開事故

- `powershell -Command "..."`へ`$_`を含む処理を埋め込むと、外側Shellで展開されて`.FullName`等へ欠落し、意図しないPathエラーになる。
- `$`を含む処理はインライン再構成せず、既存の`safe-read`系Wrapperまたは検証付き専用Wrapperの`-File`入口へ固定する。

### 2026-07-15: 永続AnimationClipのEvent保存API

- Unity 2022.3でAssetとして保存する`AnimationClip`へ`clip.events = ...`を使うと、`Please use Editor.AnimationUtility to add persistent animation events`となりEventが永続化されない。
- Editor Migrationでは`AnimationUtility.SetAnimationEvents(clip, events)`を使い、保存後のValidatorでEvent名・時刻をAssetから再読込して確認する。
- Arrow Showerでは着弾Eventが欠落するとRuntime側の`ImpactDelaySeconds`が0秒になるため、Clip曲線だけでなくEventも完了条件に含める。

### 2026-07-15: Arrow Shower Animator移行の追加調査

- `AnimationUtility.SetAnimationEvents`はUnity公式の永続Event置換APIだが、現在のMigration 2回目後も生成済み`ArrowShowerFall.anim`の`m_Events`は空だった。API名の問題ではなく、Asset作成・再読込・Dirty/Saveの順序またはMigration実行時のAsset状態を次回Compile前にReporterで切り分ける。
- 100fps Clipでは最終Spriteキー0.33秒に対して`m_StopTime`と`AnimationClip.length`が0.34秒になる。Validatorは最終キー時刻とClip長を同一視せず、1サンプル分の終了保持を考慮するか相対条件で検証する。
- Compile上限2回に達したため、追加コード変更とCompile 3回目はユーザー許可まで停止した。

## 2026-07-15 Web資料取得の出力超過と安全なopen境界

- 複数の公式API検索を1回へ集約すると検索結果が出力上限で切れ、後続の参照IDを保持できない。
- 切れた結果から公式URLを直接`open`すると、Webツールが安全な参照先として認識せず非再試行エラーになる場合がある。
- 今後は単一クエリまたは既知ページ1件を`response_length: short`で取得し、返された参照IDを開く。
- 複数ファイルの全文読み取りも1回へ集約しない。`safe-read`/`safe-read-batch`で1ファイルずつ80行以下に分ける。

## 2026-07-15 safe-read推定行数Guardの事例

- `safe-read -Context 12 -MaxMatches 4 -PrintOutput`は推定112行となり、80行上限の`guard_code: 39`で対象読取前に拒否された。
- 実行前に`MaxMatches × (Context × 2 + 4)`を計算し、最初から80行以下にする。
- Guard拒否は対象ファイルやUnityの異常ではなく、読取要求の出力予算超過として扱う。

## 2026-07-15 Arrow Shower Animator移行の最終構成

- `AnimationUtility.GetAnimationEvents`では着弾Eventを取得できても、保存後の`ArrowShowerFall.anim`は`m_Events: []`のままで、Editorキャッシュとディスク永続化を区別できなかった。
- 着弾タイミングをAnimation Eventへ依存させず、`GroundStrikeAnimatorPlayback.impactDelaySeconds`をPrefabへ`0.22`としてシリアライズした。
- AnimationClipはSpriteRendererの高・中・着弾・着弾保持の4キーだけを保持し、着弾キー時刻`0.22`とPrefab値の一致を専用Validatorで固定した。
- 旧`GroundStrikeVisualAnimator`と旧`PaperMeshVisual`はフォールバック用の参照を残し、Component無効・GameObject非活性にして通常表示から外した。
- Compile、専用Validator、Console Error 0件、`.anim`の`m_Events: []`、Prefabの`impactDelaySeconds: 0.22`を確認した。Play Modeの見た目確認はユーザー担当とする。

## 2026-07-15 safe-read出力Guardの再指定支援

- `Context 24 × MaxMatches 2`を指定して推定104行となり、`guard_code: 39`で対象読取前に拒否された。
- 同じ計算ミスが再発したため、`safe-read.ps1`のGuardへ`Context`から計算した`suggested_max_matches`を追加した。
- 今後はGuard後に手計算で候補を試さず、エラーが提示した値以下へ1回で限定する。
- `command-tools-self-test.ps1`で提案値計算の存在を固定する。

## 2026-07-15 Editorスクリプトの推測パス禁止

- `CombatAnimatorMigration.cs`を実在確認せず`Assets/AreaSurvivors/Scripts/Editor`配下と補完し、`safe-read-batch`が`guard_code: 33`で拒否した。実在先は`Assets/AreaSurvivors/Editor`だった。
- 既知なのがファイル名だけの場合、過去の一般的な配置やSkill記載から親ディレクトリを補完しない。最初に既知の実在親`Assets/AreaSurvivors`へ`safe-search.ps1 -FilesOnly`を1回実行して実在パスを確定し、その返却パスだけを`safe-read`へ渡す。
- Path Guard拒否は対象処理へ未到達なので、別候補Pathを手打ち再試行せず、同じ入口系の実在確認へ戻る。

## 2026-07-15 生成画像コピーWrapperの文書・実体不一致

- `Docs/AgentRules/token-tools.md`は`copy-generated-image-batch.ps1`を正式入口としていたが、現行`Tools/TokenUsage`に実体がなく、Preflightが`guard_code: 33`で拒否した。別のCopy/Evalへ切り替えず、Wrapper実体を追加した。
- 正式契約は`-SourceDirectory`、`-ManifestPath`、`-DestinationDirectory`、`-ValidateOnly`。CSV manifestは`source,destination`列を持ち、相対PNGパスだけを許可する。
- Wrapperは入力存在、source/destinationのディレクトリ境界、プロジェクト外保存、重複先、既存ファイル上書きをコピー前に拒否する。初回は必ず`-ValidateOnly`を通す。
- `command-tools-self-test.ps1`でWrapperの存在・構文・正式4引数を固定した。

## 2026-07-15 Obsidian CLI未登録時の追記入口

- `obsidian`はPATH未登録で`CommandNotFoundException`となり、ノート処理へ到達しなかった。
- 既存ローカルノートの追記は `Tools/TokenUsage/append-vault-note.ps1` を固定入口とし、`-WhatIf`で既存ノート・Vault境界・UTF-8入力を先に検証する。
- Obsidian CLI固有機能が必要な場合だけ、状態変更前に`Get-Command obsidian`で利用可否を確認する。実行ファイル候補やPATHを推測して再試行しない。

## 2026-07-15 Apply Patch空戻り値とUniCLI ImportWorker PID上書き

- `functions.exec`内で`text(await tools.apply_patch(patch))`を使うと、Patch自体は反映済みでも成功戻り値が`undefined`相当となり、cell出力が空になる場合があった。同じPatchを再適用せず、明示メッセージを返して`safe-read -LiteralPattern`と`scoped-diff-check`でsentinelを検証する。
- ファイアミサイル追尾実装のC# Compileは終了コード0だったが、Domain Reload後の`Menu.List`が2回ともpipe接続timeoutになった。メインUnity PIDは47704、`Library/UniCli/server.pid`はMainWindowHandle 0のAssetImportWorker PID 5996を指していた。
- UniCLI v1.5.0の`UniCliServerBootstrap.EnsurePidFile()`はAssetImportWorkerでも実行されるため、メインEditorのPIDファイルを上書きし得る。Compile成功とserver再接続は別境界として扱う。
- `safe-unity`へ`guard_code: 45`を追加し、Compile以外のUniCLI操作前にPID、Unity process、MainWindowHandleを検証する。不一致時は接続を開始せず、Import完了後にユーザーがメインEditorでStart Serverを1回押すまで停止する。PIDのShell上書きやPackageCache改変は行わない。
- `command-tools-self-test.ps1`でPID Guardの存在と既存AssetPath／Screenshot Guard順序を固定し、全自己テスト通過を確認した。

## 2026-07-15 Frost Storm画像処理時のコマンド境界

- `safe-search.ps1`へ他ツール由来の`-MaxResults`を渡してParameterBindingExceptionになった。正式な件数指定は`-First`であり、初回はhelpまたは`param(...)`を確認する。
- managed sandbox内の`Get-Command python`は空だったが、同じ確認を承認済み外側PowerShellで行うと`C:\Users\yni87\AppData\Local\Programs\Python\Python310\python.exe`が確認できた。Python欠落ではなく権限境界ごとのPATH差が原因。
- Pythonが必要な画像処理では、別名や推測パスへ切り替えず、権限境界を証拠へ残したうえで確認済み絶対パスを固定入口として使う。

## 2026-07-15 safe-read First上限とPatch境界

- `safe-read -First 100 -PrintOutput`は80行上限の`guard_code: 39`で対象読取前に拒否された。同種Guardが再発したため、`safe-read.ps1`へ`suggested_first=80`を追加し、`command-tools-self-test.ps1`で固定した。
- 複数ファイルの`apply_patch`でhunk末尾へ不要な`@@`を残すと、次の`*** Update File`がhunk本文扱いとなり、検証段階で対象未変更のまま拒否される。再送時はShellへ切り替えず、ファイル単位のpatchへ分割する。

## 2026-07-15 未確認Testsパスの再発

- テスト検索で`Assets/AreaSurvivors/Tests`を実在確認せず補完し、`safe-search`のPath Guardで検索前に拒否された。
- Guardは正常に機能した。候補パスを試さず、実在確認済みの親`Assets/AreaSurvivors`から`-FilesOnly`で1回だけ検索する。検索結果上、この機能の専用Testsフォルダはなく、既存検証入口はEditor Validatorだった。

## 2026-07-15 safe-read行範囲の包含境界

- `safe-read -StartLine 40 -EndLine 120`は両端を含むため81行となり、80行上限の`guard_code: 39`で対象読取前に拒否された。
- `safe-read.ps1`のRange Guardへ`suggested_end_line`と`use_safe_read_batch=1`を追加した。80行超の元範囲は終了行を手打ち調整せず、`safe-read-batch.ps1`へ渡して自動分割する。
- `command-tools-self-test.ps1`で両方の提案トークンを固定し、全21スクリプトの自己テスト通過を確認した。

## 2026-07-15: AssetImportWorkerによるUniCLI PID上書きの恒久対策

- 症状: メインEditorでStopServer→StartServerを実行しても、`Library/UniCli/server.pid`がMainWindowHandle 0のAssetImportWorker PIDへ戻り、Editor Runnerが`guard_code: 45`で停止した。
- 確定原因: UniCLI Server v1.5.0の`UniCliServerBootstrap`は`[InitializeOnLoad]`のstatic constructorでプロセス種別を判定せず`EnsurePidFile()`を呼ぶため、AssetImportWorkerも同一PIDファイルを書き換える。StartServer操作だけではWorkerの後続書き込みを防げない。
- 恒久対策: `Packages/com.yucchiy.unicli-server`を埋め込みパッケージとして保持し、static constructorと`StartServer()`の先頭で`AssetDatabase.IsAssetImportWorkerProcess()`を判定してWorkerを終了させる。`Library/PackageCache`は直接編集しない。
- 再発防止入口: UniCLI更新後または`guard_code: 45`発生後は、接続再試行前に`Tools/TokenUsage/validate-unicli-worker-guard.ps1`を実行する。Validatorは埋め込みpackage、直接依存、PID書き込み前のWorker guard、StartServer guardを検査する。
- 復旧手順: Guardの静的検証後、Unityへ埋め込みpackageをImportさせ、メインEditorでStartServerを1回実行する。その後に失敗した同一Runnerだけを再開する。

## 2026-07-15: Temp複数Delete patchの適用前停止

- 原因: 前工程で既に消えた`Temp/AgentAssets`ファイルを古い作業一覧から複数Delete patchの先頭へ含め、`apply_patch`の適用前検証が後続削除も止めた。
- 再発防止: `Tools/TokenUsage/temp-file-presence-report.ps1`を追加し、Temp削除候補を1件ずつ存在確認してから、存在する対象だけを1ファイル単位でDelete patchへ渡す。対象外Pathは`guard_code: 46`で拒否する。
- 自己テスト: `command-tools-self-test.ps1`へ既消去ファイルの`false`判定とTemp外Path拒否を追加し、23 scriptsのparse/guard検証を通した。

## 2026-07-15 safe-unityのMainWindowHandle権限誤判定

- 症状: `safe-unity -Action AssetImport`が接続前に`guard_code: 45`で停止したが、`server.pid`のPIDを権限外の`unity-process-report.ps1 -IncludeCommandLine`で確認すると、非0のMainWindowHandleとUnity画面タイトルを持つ応答中のメインEditorだった。
- 確定原因: sandbox内の`Get-Process`では、権限境界によりメインEditorの`MainWindowHandle`が0に見える場合がある。旧PID Guardは0をAssetImportWorkerと即断し、Worker command lineを確認する前に誤分類していた。
- 恒久対策: PIDがUnityでMainWindowHandle=0の場合だけ`Get-CimInstance Win32_Process`でcommand lineを確認する。取得が権限拒否なら`guard_code: 26`として同じ`safe-unity`コマンドの権限昇格を案内し、`AssetImportWorker`または`-batchMode`を確認できた場合だけ`guard_code: 45`とする。
- 検証: `validate-unicli-worker-guard.ps1`と`command-tools-self-test.ps1`が成功。`server.pid`の手動書き換えやStart Serverの反復は行わない。

## 2026-07-15 external-memoryのCRLF→LF予告とdiff check

- `codex-external-memory`はWindows側の`core.autocrlf=true`と`.gitattributes`のMarkdown `eol=lf`を併用している。
- この状態で作業ツリーにCRLFがあると、`git diff --check`は空白エラー行がなくても「CRLF will be replaced by LF」をstderrへ出し、RTK境界で終了コード1になる場合がある。
- 警告本文、`git config --get core.autocrlf`、`git check-attr text eol -- <note>`で改行正規化の予告だけと確定する。内容エラーと誤認してノートを書き換えない。
- 通常の`git add`でindexへLF正規化した後、`git diff --cached --check`を最終内容検査にする。別Shellや別diff方式へ切り替えない。
