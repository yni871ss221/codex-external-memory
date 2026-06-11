---
date: 2026-05-28
tags: [codex, mistakes, behavior]
project: codex-external-memory
related: [[Preferences/language]]
---

# AIのミス記録

ユーザーから明示的に訂正され、再発し得る行動だけを記録する。

2026-05-28: Obsidianノートを英語で記録していた
**NG Action**: ユーザーが日本語で運用している外部記憶ノートを、既定で英語の本文・見出しで作成した。
**Correct Action**: Obsidianの外部記憶ノートは、ユーザーが別言語を指定しない限り日本語で作成・更新する。
**Trigger**: `Knowledge/`、`Decisions/`、`Projects/`、`Preferences/` に永続ノートを書き込むとき。

2026-05-31: プロジェクト固有名にCodexを含めた
**NG Action**: 継続的に利用するブランチ名やプロジェクト固有の識別子に、実装ツールである `Codex` を含めた。
**Correct Action**: AreaSurvivorsのプロジェクト名、クラス名、ブランチ名には `Codex` を含めず、実装内容を表す中立的な名前を使う。
**Trigger**: AreaSurvivorsでクラス、プロジェクト、ブランチ、永続的な識別子を新規作成・改名するとき。

2026-05-31: 参考画像をそのまま流用した
**NG Action**: ユーザーが参考として示したアニメーション素材を、生成画像へ置き換えずにコピーして使用した。
**Correct Action**: 参考素材は構図や動きの理解に使い、ゲームへ組み込む画像自体は新規生成したものを使用する。
**Trigger**: AreaSurvivorsでユーザーが参考画像や参考アニメーションを示し、ゲーム用Spriteの作成を依頼したとき。

2026-05-31: 操作用のUnity Editorを非表示で再起動した
**NG Action**: 検証後もユーザーが操作するUnity Editorを非表示で起動し、プロジェクトロックを保持したままにした。
**Correct Action**: ユーザーが操作するUnity Editorは通常表示で起動する。バックグラウンド起動は、終了まで管理する一時的な検証プロセスに限る。
**Trigger**: Unity Editorを再起動、またはバックグラウンド起動するとき。

2026-06-02: 配置間隔だけを見て2セル柵の見た目を完了扱いした
**NG Action**: 縦柵Prefabを2セル間隔で配置したが、Textureの表示高さが間隔に対して大きすぎる状態を見落とし、1セル柵の連続に見える表示を完了扱いした。
**Correct Action**: グリッド部品を複数セル単位へ変更するときは、配置座標だけでなく縦横それぞれのTexture寸法、ワールド表示寸法、重なり量をGame Viewで確認する。
**Trigger**: AreaSurvivorsでグリッド上の柵や連結オブジェクトを複数セル単位へ変更するとき。

2026-06-08: HUD項目をPlay中に動的生成した
**NG Action**: ユーザーがEditor上で位置調整したいHUD項目について、Scene上に配置せず、`GameManager` の実行時処理で不足項目を生成した。
**Correct Action**: AreaSurvivorsのHUD項目を追加・変更するときは、まず `05_Game.unity` のHUD Canvas配下にSceneオブジェクトとして配置し、ランタイム側は既存要素を検索して値を流し込むだけにする。
**Trigger**: AreaSurvivorsでHUDパネル、HUDテキスト、HUDアイコン、ステータス表示、資源表示などを追加・変更するとき。

2026-06-09: 大型の通常オークをオークキングと誤認した
**NG Action**: スクリーンショット上で大きく表示された敵を、敵種別の確認をせずオークキングとして原因調査を進めた。
**Correct Action**: 敵AIや衝突問題を調査するときは、見た目だけで敵種別を判断せず、通常・エリート・ボスのどの定義かをユーザー確認または実行時データで確認する。
**Trigger**: AreaSurvivorsで敵のサイズ、アウトライン、衝突、移動挙動から敵種別を推定するとき。

2026-06-11: UniCLI呼び出しで不要なサンドボックス指定を付けて作業が止まる
**NG Action**: 現在のCodex環境が `danger-full-access` かつ承認ポリシー `never` のときに、`sandbox_permissions` を付けてUniCLIやPowerShellを実行しようとする。
**Correct Action**: このPC/このスレッド環境では、ツール呼び出しに `sandbox_permissions` を付けない。UniCLIが止まったように見えたら、権限指定・プロセス待ち・Unityログ・UniCLI出力を先に確認し、同じ失敗呼び出しを繰り返さない。
**Trigger**: AreaSurvivorsでUniCLI、Unity検証、PowerShellコマンドを実行するとき。
