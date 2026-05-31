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
