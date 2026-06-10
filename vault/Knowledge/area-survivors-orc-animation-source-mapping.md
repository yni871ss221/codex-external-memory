---
date: 2026-06-09
tags: [area-survivors, enemy, sprite, animation]
project: area-survivors
related: [[Preferences/game-art-style]], [[Knowledge/area-survivors-unity-workflow]]
---

# オーク歩行アニメーション素材の対応表

## 取り込み方針

- 方向ごとに `静止 / 右足 / 左足` の3フレームとして扱う。
- 左向きは右向き画像を水平反転して生成する。
- 元画像は白背景付きRGB画像なので、背景透過、足元基準の整列、同一キャンバス化を行ってから使用する。
- 立ち絵として配置された各フォルダ先頭画像は使用しない。

## オーク

- Right: `11_03_45`, `11_03_52`, `11_04_00`
- Down: `11_09_06`, `11_11_38`, `11_38_51`
- Up: `11_41_08`, `11_42_51`, `11_46_07`

## オークキング

- Right: `11_58_40`, `12_09_39`, `12_13_42`
- Down: `12_16_58`, `12_20_23`, `12_26_23`
- Up: `12_37_15`, `12_39_06`, `12_40_02`

## ゲーム側で必要な変更

- `EnemyDefinition.spriteKey` を `EnemyController` のアニメーションフレーム選択へ反映済み。
- Orc / EliteOrc は `EnemyOrc`、OrcKing は `EnemyOrcKing` を使用する。
- `DirectionalSpriteAnimator.SetFramesFromResources` で実行時に4方向3フレームを読み込む。
- 敵種ごとの `animationSpeedMultiplier` を持ち、オーク・エリートオーク・オークキングは `0.5` で通常の半速にする。
- 歩行画像は `384 x 384`、PPU `256`、足元を下端から14pxの位置に統一した。
- `WalkSpriteImporter` によりWalkフォルダへ追加した画像を自動的にSprite設定する。

## 検証

- `Gameplay_Enemy_Visuals` シナリオでオークとオークキングを同時表示して確認した。
- オークは `EnemyOrc/Down_2.png`、オークキングは `EnemyOrcKing/Down_2.png` が実行時に読み込まれた。
- Unityコンパイルエラー、Console Errorともになし。
- `Gameplay_Enemy_Visuals` でオークとオークキングの `framesPerSecond = 4` を確認した。
