---
title: AreaSurvivors ローカライズとOpening Story
date: 2026-07-13
tags:
  - project/area-survivors
  - knowledge/localization
  - knowledge/opening-story
project: area-survivors
related:
  - "[[area-survivors-current]]"
  - "[[area-survivors-unity-workflow]]"
---

# AreaSurvivors ローカライズとOpening Story

## ローカライズ

- 日本語Scene文言を正として `LocalizationTextCatalog` から英語へ変換する。
- `LocalizationService` はSceneロード、言語変更、武器獲得、特殊効果、レリック更新など状態変化時に更新する。毎フレーム全Textを翻訳しない。
- 武器名、HUDステータス、レリック、スキルツールチップ、レベルアップ、オプション、ゲーム終了画面を対象にする。
- `Area Survivors/Validate/Localization Coverage` でProduction Scene、UI Prefab、スキル説明、武器説明の日本語残存を確認する。
- 辞書が正しくてもRectTransform幅が不足すると英語だけ折り返される。Title Labelでは `AREA SURVIVORS` の2行目が縦切り捨てされ、`AREA`だけ表示された。翻訳確認には代表画面の実表示を含める。

## Opening Story

- Title Scene上の `OpeningStorySequence` と保守用 `OpeningStoryOverlay.prefab` に6枚のCanvasGroupを持つ。
- 各画像はフェードイン/アウトしながら、中央で停止せず一定方向へスライドし続ける。
- 任意キー、クリック、パッド入力でスキップし、再生完了/スキップ時にBGMを停止してタイトルへ進む。
- BGMは `Resources/Audio/BGM/opening_story.wav`。36秒、フェードアウト加工なし。
- 6シーンの論理時間は合計36秒で、固定タイムラインから各6秒を算出し、フレーム誤差を累積させない。
- 起動順はスタジオロゴの後にStoryを再生する設計だが、現在は `RuntimeFeatureFlags.PlayOpeningStoryOnApplicationLaunch = false` で通常起動だけ無効化している。
- テスト起動メニューの「Opening Story Test Button」は残し、Scene/画像/BGMを削除せず保留する。

## 画像運用

- 01/05を画風基準とし、太い輪郭、大きな色面、少ない陰影段階、コミカルなドット絵へ統一する。
- 原本は `Sprites/External/UI/OpeningStory/*Source.png`、ゲーム用は `Sprites/Generated/UI/OpeningStory/*.png` に置く。
- ゲーム用画像は中央16:9クロップ、640x360縮小、1280x720ニアレスト拡大を基準とする。
- 変更前の02/03/04/06は `External/UI/OpeningStory/Archive/BeforeStyleUnification_20260712` に保存済み。
- 下部の文章枠は使わず、画像端の違和感はScene上のEdge Vignetteで隠す。

## 起動セッション

- `ApplicationLaunchSession` が最初のTitle Sceneだけ起動イントロをclaimする。
- EditorでLobby等から開始した場合や、ゲーム終了後にTitleへ戻った場合はStudio Logoを再表示しない。
- 通常起動でStoryを再開する場合はFeature Flagだけをtrueにし、テスト再生経路やSceneを再構築しない。

## 検証

- 2026-07-13: Unity Compile成功、HUD Layout Mutation Guard合格、Localization Coverage合格、Console Error 0件。