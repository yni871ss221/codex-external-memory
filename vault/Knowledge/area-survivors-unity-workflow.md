---
date: 2026-05-31
tags: [knowledge, unity, unicli, area-survivors]
project: area-survivors
related: [[Projects/area-survivors]]
---

# AreaSurvivorsのUnity再生成・検証手順

## SceneとPrefabの再生成

`Assets/AreaSurvivors/Editor/AreaSurvivorsBootstrap.cs` を変更した場合は、Unityで以下の順に実行する。

```powershell
unicli exec PlayMode.Exit
unicli exec Compile
unicli exec Menu.Execute --menuItemPath "Area Survivors/Build Initial Project"
unicli exec Compile
unicli exec Console.Clear
unicli exec PlayMode.Enter
Start-Sleep -Seconds 3
unicli exec Console.GetLog --logType Error --maxCount 30
unicli exec PlayMode.Exit
```

## 注意点

- 新しいランタイム型をBootstrapから追加するとき、Editor側のコンパイル順で直接参照が失敗する場合がある。
- その場合は `GetRuntimeType("AreaSurvivors.TypeName")` と `SerializedObject` を使って参照を設定する。
- UniCLIが `Server is busy executing 'Compile'` のまま解放されない場合は、Unityの状態を確認する。必要であればUnityエディタを再起動してから再実行する。
- 日本語文字列がPowerShell上で文字化けして見える場合は、ファイルを `Get-Content -Encoding utf8` で読む。
- 画像生成した透過Spriteは、フラットなクロマキー背景で生成し、透過処理後に `Assets/AreaSurvivors/Sprites/Generated` へ配置する。
- `LoadSprite` は `Sprites/Generated` を優先して読むため、生成済み画像を置けばプロシージャルなフォールバック画像より優先される。
- このPCのUniCLI CLIは2026-07-13時点で `v1.5.0`。AreaSurvivorsからは生の `unicli` ではなく、RTK経由の `Tools/TokenUsage/safe-unity.ps1` を入口にする。
- Unity Editorを再起動するとき、ユーザーが引き続き操作するEditorは通常表示で起動する。非表示起動したEditorが `Temp/UnityLockfile` を保持すると、ユーザーがUnity Editorを開けないように見える。

## 2026-06-17 Generated Sprite配置統合

- ゲーム用の生成Spriteは `Assets/AreaSurvivors/Sprites/Generated` に統一する。`Assets/AreaSurvivors/Resources/Generated` へは新規配置しない。
- ビルド時に必要な生成Spriteは `GeneratedSpriteCatalog.asset` に参照を持たせ、ランタイムは `GeneratedSpriteLoader` 経由で読む。
- `Resources.Load("Generated/... ")` を新規追加しない。UI/歩行アニメ/マップ外画像/地面バリアントも `GeneratedSpriteLoader` を使う。
- 画像差し替え時はPNGだけでなく、Prefab参照、Scene参照、TilePalette、Editor生成ツール、Catalogを必ず更新し、古いSprite/Source/Prefab/Tile/Metaを削除する。

## 2026-06-18 スキルツリーScene編集ルール

- スキルツリーのノード位置、ジャンルパネル、ラベル、アイコン、リンク線はScene上を正とする。
- `UpgradeScreen` はScene上の既存 `SkillNodeView` と `SkillLinkSegment` をバインドし、購入状態・表示色・ボタン接続だけを更新する。Runtimeでノード、ラベル、リンク線を生成しない。
- ユーザーがScene上でノードを配置変更した後に導線整理を依頼した場合は、一時Editor Runnerで `SkillNodeView.linkRoutes` と `SkillLinkSegment` を更新し、作業後Runnerと `.meta` を削除する。
- 恒久メニュー化を求められるまでは、配置整理のためのEditorメニューやスキル化は行わない。
- 旧カテゴリラベルやフォールバックUI生成を復活させない。必要なジャンルラベルはScene上に直接配置する。

## 2026-06-20 建造中Visual/Serialized field削除時の確認

- RuntimeクラスからSerialized fieldを削除しただけでは、Prefab YAMLに旧フィールド名が空参照として残る場合がある。
- 旧フィールドや旧子オブジェクトを削除した後は、対象Prefabを一時Editor Runnerで `PrefabUtility.LoadPrefabContents` -> `PrefabUtility.SaveAsPrefabAsset` して再保存し、不要なSerialized fieldを落とす。
- 一時Runnerは `Assets/AreaSurvivors/Editor/Temporary*.cs` として作成し、`Menu.Execute --menuItemPath ...` で実行する。実行後は `.cs` と `.meta` を削除し、`AssetDatabase.Import --forceUpdate true` とCompileでUnity側の参照を更新する。
- 最後に `rg` で旧子名、旧Serialized field名、旧Sprite名を `*.cs` / `*.prefab` / `*.unity` / `*.asset` へ横断検索する。
- Unity Prefab YAMLは空フィールド行で `git diff --check` のtrailing whitespaceが大量に出る場合があるため、基本はコード対象に絞って `git diff --check` し、Prefabは残存キーワード検索とUnity Compile/Consoleで確認する。

## 2026-06-25 HUD Scene配置の再徹底

- HUDの新規項目はScene上へ配置し、Runtimeで `CreatePanel`、`CreateText`、`Ensure*`、`new GameObject` を使って新規HUDを生成しない。
- `GameManager` / `GameHudController` はScene配置済みHUDの参照取得、値更新、ボタン接続、表示/非表示切替だけを担当する。
- 未取得武器など状態で空にしたいHUDは、パネル枠をSceneに残し、子要素の表示切替で空表示にする。Scene上の位置・サイズ・SpriteをRuntimeで補正しない。
- 既存HUDスロットへ背景、名前、種別アイコンなどを兄弟要素として追加する場合、既存スロットの `SetActive` だけでは追加要素は連動しない。通常、空、詳細、一時停止など全表示状態を先に列挙し、同じ表示ルート配下に置くか、Scene参照した追加ルートを同じBindingが明示的に表示切替する。
- HUDアイコンの見た目がずれる場合はRectTransformだけで補正せず、元Spriteの透明余白と縦横比を確認し、必要ならHUD専用Spriteを `Assets/AreaSurvivors/Sprites/Generated` に作る。

## 2026-07-02 Runtime/Editor再生成の制限

- ユーザーがScene上で調整したロビー、ゲーム終了画面、HUD、範囲Visualなどの配置・サイズ・Sorting・RotationはScene/Prefabを正とする。
- 一時的にEditor生成ツールでSceneを整える場合、確認後に不要なメニュー/Runner/Builderを削除または無効化する。残す場合は、既存レイアウトを初期化しないことを明示的に保証する。
- `LobbySceneBuilder` のように旧レイアウトへ戻す可能性があるツールは恒久メニューとして残さない。
- Runtimeコードでは、既存Scene/Prefabの位置、サイズ、Sprite、Collider、Scale、Rotation、Sortingを固定値に戻さない。必要な値はPrefab/Scene上のInspectorで編集可能にする。

## 2026-07-06 HUD/静的UIレイアウト保護

- HUD、ロビー、テスト画面、所持レリック画面など、ユーザーがScene上で調整する静的UIはScene/Prefabを唯一の正とする。
- Runtime、Editor Menu、Setup、Rebuild、Restore、Normalize、Validator、Importer、Migrationのどれであっても、既存UIのRectTransform/Transformレイアウト値を固定値へ戻さない。
- 既存HUD/静的UIに対して許可されるのは、数値更新、表示/非表示、色、透明化用コンポーネント、参照フィールドなど、レイアウトを変えない変更に限る。
- HUD系Editorコードを触ったら、`GameHudLayoutMutationGuard` の検出対象になる名前や処理を確認し、既存HUDの位置/サイズ/Scale/Rotation/Sprite変更入口を残さない。

## 2026-07-09 ビルドログと診断ログ

- ビルド配布時の調査をしやすくするため、アプリログとトークン獲得ログは実行ファイルと同階層の `logs` フォルダへ出す。AppData配下だけに頼るとユーザー共有が難しい。
- クラッシュ調査では `Player.log` と `application.log` の両方を見る。中心塔破壊などシーン遷移直前クラッシュでは、直前のRuntime object snapshot、Material/Memory診断、GameOver遷移ログが重要。
- UnityのMaterial数は環境やAPIによってRuntimeで直接取得できない場合があるため、`TotalUsedMemory`、Renderer数、material slot数、unique shared material数、対象コンポーネント数を補助ログとして残す。
- `renderer.material` / `renderer.materials` はMaterialインスタンスを複製しうる。色変更だけなら `MaterialPropertyBlock` と `sharedMaterials` を優先する。

## 2026-07-13 UniCLI失敗時の固定手順

- UniCLI `Compile` のHandlerは `CompilationPipeline.RequestScriptCompilation()` を呼ぶだけで、`AssetDatabase.Refresh/ImportAsset` は行わない。Unity外から新しいEditorスクリプトを追加した場合、Compileより先に明示Importする。
- 一時Editor Runnerは `Tools/TokenUsage/invoke-unity-editor-runner.ps1 -Phase RegisterAndRun -ScriptPath <Assets/...cs> -MenuPath <完全なMenuパス>` で実行する。Import→Compile→Menu完全一致確認→Executeの順序から外れない。
- Runnerの `.cs` / `.meta` をapply_patchで削除した後は、同Wrapperの `RefreshAfterRemoval` でRefresh→Compileする。登録失敗時に長いEvalへ切り替えない。
- 2026-07-13に一時ログ出力Runnerで、Import→Compile→Menu登録確認→Execute→削除→Refresh→Compile→Menu未登録確認まで実環境検証済み。前半・cleanupとも成功し、削除後は完全一致Validatorが `guard_code: 24` を返した。
- `PlayMode.Exit` は終了遷移完了を待たず成功を返すため、検証列の最後にする。直後20秒は `safe-unity.ps1` が後続UniCLIを拒否し、全UniCLI操作には強制timeoutを設定する。
- UniCLI captureの最終エラーが `Access to the path is denied` の場合は、Unity無応答やserver停止ではなくnamed pipeへのサンドボックス拒否。`guard_code: 26` を確認し、同じsafe-unityコマンドを外側の権限昇格付きで1回だけ再実行する。
- `safe-unity-search` は引用符付きEvalで検索語をEditorPrefsへ入れない。`Temp/AreaSurvivors/scene-prefab-search-query.txt`へ一時保存し、既存のScene/Prefab Search Reporter Menuが読み取る。Guard追加時はGuard自身だけでなく既存Wrapperとの契約も自己テストする。
- Play Mode中にEvalを使うと、`AssemblyBuilder`によるforced synchronous recompileとDomain ReloadでUniCLIの実行Taskが失われ、クライアントtimeout後もserverが `busy executing 'Eval'` のままになる場合がある。`safe-unity`はEval前にPlay状態を確認し、Play中を `guard_code: 27`、状態確認不能を `guard_code: 28` で拒否する。Play中のUI操作は事前コンパイル済みフックまたは通常入力を使う。
- 想定外の失敗、無応答、timeoutが出たら機能実装を止め、`Docs/AgentRules/command-failure-playbook.md` に沿って失敗境界を確定し、Validator/Wrapper/ルールへ反映してから再開する。

## 2026-07-15 物理移動とLateUpdateカメラの横揺れ

- 症状: Playerが左右移動するとカメラが細かくガクつく。Animator移行後に目立ったが、Animatorの子VisualはRoot Transformを動かしていなかった。
- 原因: `PlayerController.Update()`でRigidbody2Dのvelocityを更新し、物理ステップでPlayer Transformが進む一方、`CameraFollow.LateUpdate()`は毎描画フレームでPlayer Rootを追従していた。Rigidbody2DのInterpolationがNoneだと、描画フレーム間で物理位置が段階的に見える。
- 対応: Player PrefabのRigidbody2Dを`Interpolation = Interpolate`へ変更する。CameraのLateUpdate追従、Animator、歩行Spriteは変更しない。
- 切り分け: Animatorが子Objectのみを制御し、ClipにPosition/Rotation/ScaleカーブがなければカメラRoot振動の直接原因ではない。左右フレーム内の絵柄中心差は二次的な見た目の揺れとして別に評価する。
- 検証: Prefab Import成功、Console Error 0件、ユーザー実機確認で左右移動時のカメラ振動解消を確認した。
