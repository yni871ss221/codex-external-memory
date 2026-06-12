---
date: 2026-06-11
tags: [preference, assets, google-drive, area-survivors]
project: area-survivors
---

# Asset Sources

- AreaSurvivors向けの新規画像素材は、今後Google Drive上に配置される前提で扱う。
- ユーザーがGoogle DriveフォルダURL、フォルダ名、ファイル名を示した場合は、Drive上の該当ファイルを検索・取得し、Unityプロジェクト内の適切な `Assets/AreaSurvivors/...` 配下へ配置する。
- 取得した画像をそのままゲーム内参照に使わない。原本は `Assets/AreaSurvivors/Sprites/External/*Source.png` に保存し、背景切り抜き、透明化、トリミング、解像度調整、既存資産とのサイズ比較を行った処理済みPNGを `Sprites/Generated/` や `Resources/Generated/` に配置する。
- HUD画像や建造メニューへ追加する場合は、現在の `05_Game.unity` 上の既存パネル/スロットの `RectTransform` を基準に位置を導出する。初期実装時の固定座標を前提にしない。
- 1セル建造物の見た目は、現在の1セル幅 `0.7` world units を超えないようにする。上方向にははみ出してよいが、横幅はセル内に収め、見た目の下端は既存バリスタのようにセルラインへ厳密に揃える。
- ローカルCodexスキル `area-survivors-asset-import` を追加済み。AreaSurvivorsで画像素材を取り込むときはこの手順を使う。
- 2026-06-11時点の例: フォルダ `1ojjR0F9Bfz82J9yRNw87Qfq-yOQFk8Wx`、ファイル `ChatGPT Image 2026年6月10日 22_14_28.png` は大工小屋画像として指定された。
- 2026-06-11 大工小屋差し替え: フォルダ `1aayEswXWTJUzwZLwJ1uzD529LlQ-X7x1`、ファイル `ChatGPT Image 2026年6月11日 21_06_09.png` を新しい大工小屋画像として取り込んだ。
- 敵アニメーション素材は、敵名フォルダ配下の立ち絵と歩行用9枚を取得し、原本を `Sprites/External/Enemies/<EnemyName>/` に残す。ゲーム用は `Resources/Generated/Walk/<EnemyName>/` へ、既存敵と同じ `Up/Right/Down/Left_0..2` 命名で配置する。
- 敵アニメーション取り込みでは `area-survivors-enemy-animation-import` スキルを使う。
- 画像の配置調整では、下端アンカーを基本にする。上方向にははみ出してよいが、横幅と見た目下端はセル/既存資産に厳密に合わせる。
