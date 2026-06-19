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
- このPCではUniCLI CLI `v1.3.3` を `C:\Users\yni87\.local\bin\unicli\unicli.exe` に配置し、ユーザーPATHにも追加済み。Codex Desktop再起動前のシェルでは直接フルパスで呼び出せる。
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
