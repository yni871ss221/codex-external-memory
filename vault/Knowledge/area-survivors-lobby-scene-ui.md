---
date: 2026-06-12
tags: [knowledge, ui, unity, scene, area-survivors]
project: area-survivors
related: [[area-survivors-current]], [[area-survivors-memory-rules]]
---

# AreaSurvivors ロビーScene配置UI

## 方針

- ロビー画面は `03_Lobby.unity` のScene上にUI実体を配置する。
- `LobbyScreen` はScene上の `Lobby UI` を探し、既存オブジェクトへバインドして状態更新とボタン接続だけを行う。
- ユーザーがEditor上で位置調整する前提なので、通常作業でロビーUIをランタイム生成だけで済ませない。
- `AreaSurvivors/Lobby/Rebuild Lobby Scene UI` は再生成用の保険であり、実行すると手動調整した配置を上書きする。普段は使わない。

## 参照名

`LobbyScreen` は再帰検索で以下の名前を参照する。親子関係は変更してよいが、名前は維持する。

- `Lobby UI`
- `TokenInfo`
- `Stage 1 Panel` から `Stage 4 Panel`
- 各ステージ配下の `Boss Image`、`Boss Name`、`Unknown Boss`、`Clear`、`Fast Mode Toggle`
- `Character Knight`、`Character Archer`、`Character Mage`
- `Start Stage 2 Test Button`
- `Start Game Button`
- `Upgrade Button`
- `Title Button`

## 注意

- HUDと同じく、初期実装時の固定座標を前提にしない。
- ユーザーがScene内で親子関係を整理することがあるため、実装側は親直下前提ではなく再帰検索やSerialized参照で耐える。
- Scene配置済みUIが見つからない場合のみ、一時的なフォールバック生成を許容する。
