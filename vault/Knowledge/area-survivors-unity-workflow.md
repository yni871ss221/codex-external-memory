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
