---
date: 2026-06-08
tags: [project, history, unity, enemy, spawn, boss, token]
project: area-survivors
related: [[area-survivors-current]], [[area-survivors-history]], [[2026-06-08-enemy-spawn-and-boss-system]]
---

# AreaSurvivors 敵スポーン・ボス実装 2026-06-08

## 実装内容

- `EnemyDefinition`、`SpawnPhase`、`TimedEnemySpawn` を `GameConfig` に追加し、敵ステータスと出現情報をInspectorで調整できるようにした。
- 通常スポーンを、完全ランダム方向ではなく、30秒ごとに変わる襲撃方角±30度の範囲から出現する方式へ変更した。
- 30秒ごとに出現数が増える構造を追加し、出現数・間隔・上限は設定値化した。
- 2:00エリートイノシシ、2:30通常敵オーク切替、4:30エリートオーク、5:00オークキングの時間イベントを追加した。
- 全敵は画像生成待ちのため一旦イノシシ画像を使い、サイズ・HP・攻撃力・XP・アウトライン色で区別する。
- エリートは黄色アウトライン、ボスは赤アウトライン。ボスは画面上部にScene配置のボス名・HPバーを表示する。
- ボス出現後はHUD表示時間を `05:00` で固定して赤文字にするが、内部スポーン時間は進行させる。
- エリート/ボスは経験値に加えてトークンをフィールドにドロップする。トークンは経験値オーブ同様に吸引・回収される。
- トークンHUDを石所持数の右側にScene配置で追加し、ラン中取得トークン数を表示する。
- ボス撃破時は `GAME CLEAR` アナウンス後、残敵を消去して `06_GameEnd` へ遷移する。
- `06_GameOver` Sceneを `06_GameEnd` にリネームし、ゲームオーバー/ゲームクリア両対応の終了画面として扱うようにした。

## 検証

- UniCLI Compile: `0 errors / 0 warnings`
- PlayMode通常起動: Errorログ `0件`
- PlayMode短縮時刻テスト: エリート/ボス出現、ボス撃破、`06_GameEnd` 遷移を確認。Errorログ `0件`

