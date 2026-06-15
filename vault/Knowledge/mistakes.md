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

2026-06-11: 外部メモリリポジトリをpullせず古いルールで作業した
**NG Action**: ユーザーが「最新の作業履歴や作業ルールを取得してほしい」と依頼していたのに、AreaSurvivors本体だけをpullし、外部メモリリポジトリ `codex-external-memory` の `git pull` を実行しないままローカルの古いメモリを読んで作業した。
**Correct Action**: AreaSurvivorsで作業開始時に最新履歴・ルール取得を求められた場合は、必ずAreaSurvivors本体と外部メモリリポジトリの両方で `git status --short --branch` と `git pull --ff-only` を確認してから、`Knowledge/mistakes`、`Projects/area-survivors-current`、`Knowledge/area-survivors-memory-rules`、必要なworkflow/preferenceノートを `-Encoding UTF8` で読む。
**Trigger**: ユーザーが「最新」「pull」「作業履歴」「作業ルール」「外部メモリ」「メモリ」を含む開始指示をしたとき。

2026-06-11: 画像をゲーム用に整形せずそのまま取り込んだ
**NG Action**: Google Driveから取得した大工小屋画像を、白背景の切り抜きや解像度調整をせず、そのまま `Generated` SpriteとしてゲームとHUDに使用した。
**Correct Action**: AreaSurvivorsの画像素材は、原本を `Assets/AreaSurvivors/Sprites/External/*Source.png` に残し、実際に参照する画像は背景透過、トリミング、解像度調整、既存資産とのサイズ比較、Unity Importer設定を行ったうえで `Generated` 側へ配置する。
**Trigger**: AreaSurvivorsでGoogle Drive画像、添付画像、生成画像をSprite・Prefab・HUDへ組み込むとき。

2026-06-11: HUD追加時に現在のScene配置を基準にしなかった
**NG Action**: 建造メニューへ大工小屋スロットを追加する際、初期実装時の固定座標を前提にし、ユーザーが調整済みの既存スロット高さとずれた位置へ配置した。
**Correct Action**: AreaSurvivorsのHUDへ項目を追加するときは、`05_Game.unity` の既存兄弟要素の `RectTransform` を確認し、既存スロット/パネルの位置・間隔・高さから新規要素の座標を導出する。ランタイムのfallback生成やEditorセットアップも同じ導出ロジックにする。
**Trigger**: AreaSurvivorsで建造メニュー、プレイヤーステータス、資源パネル、塔パネルなどHUD要素を追加・移動・拡張するとき。

2026-06-11: 建造ハンマー位置を建造対象ではなくプレイヤー/支援元へ寄せた
**NG Action**: 大工小屋の自動建造対応で建造進捗処理を共通化した際、ハンマー表示位置が `activeBuilder` やColliderの `ClosestPoint` に影響され、建造対象物上ではなくプレイヤー付近や支援元側へ出る挙動にした。
**Correct Action**: 建造中ハンマー画像は、バリスタ・柵・大工小屋など建造対象物のローカル固定位置に表示する。プレイヤー位置や大工小屋の自動建造元Transformをハンマー位置計算に使わない。
**Trigger**: AreaSurvivorsで建造進捗、建造支援、自動建造、ハンマー演出、建造中Visualを変更するとき。

2026-06-11: クレジット消費を増やす大きな出力を不用意に読んだ
**NG Action**: Unityの `Commands.List` をフィルタが効かない状態で実行して巨大なコマンド一覧を読み込んだり、`rg` / `Get-ChildItem` / 長いSkill本文 / 長い外部メモリを必要以上に広く読み、トークン・クレジット消費を増やした。
**Correct Action**: 調査時は対象ファイル、検索語、行数、出力件数を必ず絞る。巨大出力が予想されるUnityコマンド一覧や広範囲ファイル列挙は避け、必要なら `Select-Object -First`、具体パス指定、`rg -n` の限定パターン、該当セクションのみの読み取りを使う。Skillや外部メモリも必要箇所だけ読む。
**Trigger**: AreaSurvivorsやUnity作業で調査、コマンド探索、外部メモリ確認、スキル確認、ファイル一覧取得を行うとき。

2026-06-11: 大工小屋自身への自動建造が進まない減衰バグを入れた
**NG Action**: バリスタ/柵には外部建造作業中の進捗減衰抑制を入れていたが、大工小屋には同じ処理を入れず、自動建造速度 `0.1x` が建造ゲージ減衰に打ち消されて2軒目以降の大工小屋が自動建造されない状態にした。
**Correct Action**: `IBuildableConstruction.AddBuildWork` を受ける建造物には、外部建造作業直後に進捗減衰を一時停止する `assistedBuildTimer` 相当の処理を必ず揃える。新しい建造物を自動建造対象に含める場合は、バリスタ/柵/大工小屋など対象種別ごとに同じ挙動か確認する。
**Trigger**: AreaSurvivorsで自動建造、建造ゲージ減衰、`IBuildableConstruction` 実装、新規建造物を追加・変更するとき。

2026-06-12: ロビーUIをランタイム生成のまま扱い、Editorで調整しづらい構成にした
**NG Action**: ユーザーがEditor上で位置修正したいロビー画面について、HUDと同じScene配置方針をすぐ適用せず、`LobbyScreen` のランタイム生成でパネルやボタンを作る構成にした。
**Correct Action**: AreaSurvivorsでHUD/ロビー/メニューなど、ユーザーが位置調整するUIを追加・変更するときは、Scene上のUIオブジェクトとして配置し、ランタイム側は既存要素へバインドして値更新とボタン接続だけを行う。フォールバック生成はScene要素がない場合の保険に留める。
**Trigger**: AreaSurvivorsでロビー画面、HUD、建造メニュー、ステージパネル、ステータスパネルなどのUIを追加・移動・拡張するとき。

2026-06-13: HUDのStage表示をScene上に配置せず、実行時生成・固定座標上書きに寄せていた
**NG Action**: ユーザーがEditor上で位置調整したいHUD要素をSceneに置かず、実行時に作成したり、Scene上に存在してもコード側でRectTransformを固定値に戻した。
**Correct Action**: AreaSurvivorsのHUD/ロビー/メニューなど調整対象UIは原則Scene上に配置し、ランタイム側は既存UIへのバインドと値更新に徹する。Scene上にあるUIの位置・サイズはコードで上書きしない。
**Trigger**: AreaSurvivorsでHUD、ロビー、建造メニュー、ステージ表示、撃破数表示、リソース表示などのUIを追加・変更するとき。

2026-06-15: 中心塔だけ個別offsetで位置調整しようとした
**NG Action**: 中心塔やアップグレード後中心塔の位置ずれに対して、`position.y` や独自 `upgradedVisualOffset` を何度も調整し、根本原因であるRoot基準・中心セル・占有セル・Collider基準の不一致を先に解消しなかった。
**Correct Action**: AreaSurvivorsの建造物・自然物・アップグレード表示は、`GridObjectVisual` の中心セル + footprint からRootを占有セル下端中央へ配置し、画像、Collider、Grid登録、青エリア判定を同じ基準にそろえる。個別Y補正を追加する前に、共通規格から漏れていないか確認する。
**Trigger**: AreaSurvivorsで建造物、中心塔、監視塔、大型自然物、アップグレード後画像の位置ずれ、Colliderずれ、下端ずれを修正するとき。

2026-06-15: PlayerプレハブのColliderを実行時コードで上書きしていた
**NG Action**: ユーザーがPlayerプレハブ上でColliderを調整しているのに、`PlayerController.ConfigureFootCollider()` でランタイムに `GridObjectVisual.ConfigureCharacterCircle()` を呼び、Colliderを再設定していた。
**Correct Action**: Playerや敵など、PrefabでCollider調整する前提のものはPrefab設定を正とする。実行時にColliderを補正する場合は、ユーザーがInspectorで調整した値を上書きしないか先に確認する。
**Trigger**: AreaSurvivorsでプレイヤー、敵、キャラクターPrefabのCollider、当たり判定、足元判定を修正するとき。

2026-06-15: 締め作業を定型化していなかった
**NG Action**: 作業終了時のObsidian記録、スキル更新、AreaSurvivors本体と外部メモリrepoのcommit/pushを都度判断にしていた。
**Correct Action**: ユーザーが「締め作業」「作業終了」「今日の作業終了」と依頼したら `area-survivors-closeout` skill を使い、Obsidian記録、必要なミス/ルール/スキル更新、AreaSurvivorsと `codex-external-memory` のcommit/pushをまとめて実施する。
**Trigger**: AreaSurvivorsの作業終了、締め作業、Obsidian記録、コミット＆プッシュを依頼されたとき。
