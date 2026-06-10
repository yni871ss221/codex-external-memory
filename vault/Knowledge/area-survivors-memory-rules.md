---
date: 2026-06-08
tags: [knowledge, memory, workflow, area-survivors]
project: area-survivors
related: [[area-survivors]], [[area-survivors-current]], [[area-survivors-history]], [[area-survivors-unity-workflow]]
---

# AreaSurvivors外部記憶ルール

## 次回開始時の読み取り順

1. [[Knowledge/mistakes]]
2. [[area-survivors-current]]
3. [[area-survivors-memory-rules]]
4. 作業内容がUnity検証に触れる場合は [[area-survivors-unity-workflow]]
5. 表示・アート調整なら [[game-art-style]] と [[area-survivors-2-5d-style]]

## 書き分け

- [[area-survivors-current]]: 現在有効な仕様、最新コミット、未解決タスクだけを書く。
- [[area-survivors-history]]: 日付ごとの作業履歴を書く。古い仕様や経緯はここへ逃がす。
- [[area-survivors-unity-workflow]]: UniCLI、Unity Editor、再生成、検証、環境トラブルを書く。
- [[Knowledge/mistakes]]: ユーザーに明示的に訂正された再発防止ルールだけを書く。
- [[game-art-style]] / [[area-survivors-2-5d-style]]: 長く効く好みや表現方針を書く。

## 更新ルール

- その日の作業終了時、または大きな仕様変更が入った時点で [[area-survivors-current]] を更新する。
- まとまった機能単位が完了したら [[area-survivors-history]] に日付付きで追記する。
- `area-survivors-current` は長くしすぎない。目安は、次回開始時に1分で読める分量。
- 古くなった仕様はcurrentから消し、必要ならhistoryへ移す。

## 注意

- PowerShellで日本語ノートを読む場合は `-Encoding UTF8` を付ける。
- workspace外アクセス制限があるセッションでは、Obsidian vault 読み取りに承認や権限変更が必要になることがある。
