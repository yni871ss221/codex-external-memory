---
date: 2026-06-12
tags: [knowledge, assets, animation, google-drive, unity, area-survivors]
project: area-survivors
related: [[area-survivors-current]], [[asset-sources]]
---

# AreaSurvivors 敵アニメーション取り込み

## 手順

- Google Drive上に敵名フォルダがある場合、敵名フォルダから立ち絵1枚と歩行用9枚を取得する。
- 原本は `Assets/AreaSurvivors/Sprites/External/Enemies/<EnemyName>/Source_XX.png` に保存する。
- ゲーム内で使う画像は `Assets/AreaSurvivors/Resources/Generated/Walk/<EnemyName>/` に生成する。
- 既存の敵と同じ命名規則で `Up_0..2`、`Right_0..2`、`Down_0..2`、`Left_0..2` を作る。
- 背景は境界接続の背景色から透過し、キャラクター本体をトリミングして下端揃えにする。
- 左向きが提供されない場合は、右向きを反転して生成する。
- 生成後はコンタクトシートで向き、足運び、下端、サイズ感を確認する。

## ステージ2での実績

- 対象: ゴブリン、オーガ、ゴブリンロード。
- Driveフォルダ: `1ojjR0F9Bfz82J9yRNw87Qfq-yOQFk8Wx` 配下の敵名フォルダ。
- `Source_00..02` は上向き、`Source_03..05` は下向き、`Source_06..08` は右向き、`Source_09` は立ち絵/予備として扱った。
- アニメーションのばたつきを抑えるため、ステージ2敵の再生速度は遅めに設定した。

## ローカルスキル

- `C:\Users\yni87\.codex\skills\area-survivors-enemy-animation-import\SKILL.md` を作成済み。
- 今後、AreaSurvivorsの敵アニメーション素材をDriveから取り込む時はこのスキルを使う。
- ユーザーがDrive共有権限を変更した後、公開リンクから直接ダウンロードできることを確認済み。
