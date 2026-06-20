---
date: 2026-06-20
tags: [knowledge, tokens, workflow, git, unity]
project: area-survivors
related: [[rtk-codex-windows]], [[area-survivors-unity-workflow]]
---

# AreaSurvivors トークン急増の原因メモ

## 2026-06-20 調査結果

- 直近の大きな消費は、コード変更量よりもコマンド出力の膨張が主因。
- `git merge feature/01_GameSystemInit` のraw出力で、fast-forward時の巨大diffstatが出て約3万token級の出力になった。
- `Select-String` を `Library/ScriptAssemblies` のDLL/PDBへ当てたことで、バイナリ内容が大量に展開され約数千tokenを消費した。
- 一時Editor Runner削除後のUnity/Beeキャッシュ詰まりで、Compile/Import/ログ確認を何度も繰り返したことも追加消費になった。

## 再発防止

- マージやpullは、可能なら `--no-stat`、`--ff-only`、または事前の `rtk git diff --stat` / `git diff --name-only` で規模確認してから実行する。
- `Library/`、`Temp/`、`.git/`、DLL/PDB/画像に対する広い本文検索を避ける。Unity生成キャッシュは対象ファイル名や小さいテキストファイルに限定する。
- 一時Editor Runnerは、削除前にUnityのAssetDatabase経由で削除できる形にするか、最初から恒久Validator/Reporterとして作るかを検討する。