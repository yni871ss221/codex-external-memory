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

2026-06-17: Spriteの比率ずれをランタイムScale/Rotateで補正しようとした
**NG Action**: バリスタや城壁/城門の通常・アップグレード画像で、Sprite加工時の幅基準が揃っていない問題を、Prefab/実行時のScale YやRotate Xで補正しようとした。
**Correct Action**: 建造物画像は、背景除去→可視範囲トリミング→占有セル横幅 `セル数 * 64px` にアスペクト比維持でリサイズする。高さはセルに収めず、Prefabで下端と横幅を合わせる。ランタイムでScale/Rotationを変更しない。
**Trigger**: AreaSurvivorsで建造物、アップグレード建造物、建造予約ゴースト、建造中表示、完成表示の画像を追加・差し替えするとき。

2026-06-17: Resources/GeneratedとSprites/Generatedを二重管理した
**NG Action**: `Sprites/Generated/WoodenWall.png` を差し替えた一方で、PrefabやSceneが `Resources/Generated/WoodenWall.png` のGUIDを参照したままになり、見た目が変わらない・古い画像が残る状態を作った。
**Correct Action**: 生成済みゲーム用Spriteは `Sprites/Generated` に統一し、実行時は `GeneratedSpriteLoader` と `GeneratedSpriteCatalog.asset` で読む。画像差し替えでは、Prefab参照・Scene参照・Editorツール・Catalog・古いファイル削除まで一括で確認する。
**Trigger**: AreaSurvivorsで画像差し替え、Prefab化、Resources/Sprites配置整理、古いアセット削除を行うとき。

2026-06-18: スキルツリー/HUD系UIをRuntime生成で復活させた
**NG Action**: ユーザーがScene上でラベルやHUD項目を削除・調整した後に、`UpgradeScreen` などのRuntimeフォールバック生成で旧ラベルや線、UI項目を復活させた。
**Correct Action**: AreaSurvivorsのHUD、建造メニュー、スキルツリーなどEditor調整対象UIはSceneを正とする。Runtimeは既存Sceneオブジェクトのバインド、状態更新、ボタン接続だけを行う。Scene要素がない場合は勝手に生成せず、必要ならエラーや警告で不足を知らせる。
**Trigger**: HUD、ロビー、建造メニュー、スキルツリー、ステータス表示、ジャンルラベル、リンク線など、ユーザーがScene上で配置・削除・調整するUIを扱うとき。

2026-06-25: HUD武器ステータスをRuntime生成で追加した
**NG Action**: ユーザーが何度も「HUDはScene上に配置」と指示していたのに、武器ステータスHUDを `GameManager` / `GameHudController` の実行時生成で追加し、Editor上で調整できない構成にした。
**Correct Action**: AreaSurvivorsのHUD追加・修正では、必ず `05_Game.unity` のHUD配下にSceneオブジェクトを配置する。Runtime側は既存オブジェクトを検索/参照し、値更新、ボタン接続、表示/非表示切替だけを行う。Scene要素が足りない場合も勝手に生成せず、警告で不足を知らせる。
**Trigger**: AreaSurvivorsでプレイヤーステータス、武器ステータス、資源、ステージ、撃破数、塗り状況、トークンなどHUD項目を追加・変更するとき。

2026-06-26: 敵歩行アニメーションを元画像加工で作ろうとした
**NG Action**: ユーザーが「右/正面/上の3面歩行フレーム画像を生成してほしい」と依頼したのに、添付された立ち絵を変形・加工してシート化し、向きや歩行フレームが破綻した画像を作った。
**Correct Action**: AreaSurvivorsの敵歩行アニメーションでは、正面/右/上それぞれ3フレームの「その向きを向いたキャラクター画像」を生成または用意する。左は右向き反転で作る。難しい場合は早めにユーザーへ素材作成依頼を提案する。
**Trigger**: 敵・プレイヤーなどの歩行アニメーション用Spriteを新規作成・差し替えするとき。

2026-06-26: 見た目サイズをScale/Rotationで補正しようとした
**NG Action**: 建造物破壊画像、敵、プレイヤー、弓矢などの見た目サイズや向きをPrefab/実行時のScaleやRotation X/Yで補正しようとした。
**Correct Action**: AreaSurvivorsのSprite見た目サイズは、透過、トリミング、キャンバス余白、PNG解像度、PPU/import設定で合わせる。Prefab/子VisualのScaleは原則 `1`、Rotation X/Yは `0`。Projectileの進行方向だけRotation Zを許容する。
**Trigger**: Sprite、Prefab Visual、敵/プレイヤー表示、Projectile表示、建造物画像を追加・差し替え・サイズ調整するとき。

2026-06-26: Runtimeでアイコン/Sprite差し替えをしようとした
**NG Action**: スキルツリーアイコンや建造物表示など、Scene/Prefabで参照を持つべき静的Visualをゲーム内コードで差し替える方向へ実装した。
**Correct Action**: AreaSurvivorsの静的Visual、HUD、スキルツリー、建造メニューのアイコンやSource ImageはScene/Prefab上の参照を正とする。Runtimeは既存参照の状態更新・表示切替に留め、新規配置・生成・Sprite差し替えをしない。
**Trigger**: HUD、スキルツリー、建造メニュー、建造物表示、静的アイコン、Source Imageを追加・変更するとき。
2026-06-30: アローレインの横並び問題をコード側の位相調整だけで直そうとした
**NG Action**: アローレインの矢が横並びセットに見える原因が、フレームPNG自体に横一列の矢が描かれていることだったのに、先に各矢オブジェクトの落下位相や高さブレだけを調整した。
**Correct Action**: 攻撃アニメーションの見え方がおかしい場合は、Prefab上のオブジェクト配置だけでなく、各フレームPNGそのものを目視確認する。フレーム内で横並び・セット化している場合は、コードで散らすのではなくフレーム画像を散布配置へ再生成する。
**Trigger**: AreaSurvivorsでアローレイン、フロスト、斬撃、爆発など複数フレーム/複数要素の攻撃演出を修正するとき。
2026-07-02: Scene配置済みUIをEditor生成ツールで旧レイアウトへ戻すリスクを残した
**NG Action**: ユーザーが調整済みのロビー/ゲーム終了画面などに対し、`LobbySceneBuilder` や一時セットアップメニューが旧配置を再適用できる状態で残り、再実行時にレイアウトをデグレさせる可能性を残した。
**Correct Action**: Scene上で手調整するUIや静的VisualはScene/Prefabを正とする。Editor生成ツールは必要な一時作業後に削除または無効化し、残す場合も既存配置を固定値へ戻さない作りにする。
**Trigger**: ロビー、HUD、ゲーム終了画面、テスト画面、所持レリック画面などのScene/UIレイアウトを変更するとき。

2026-07-02: 楕円範囲Visualへ斜め視点用のRotation Xを入れた
**NG Action**: Circle/Ellipse Visualに `Rotation X = -40` のような斜め視点補正を入れ、見た目の楕円と当たり判定/塗り範囲が一致しない状態を作った。
**Correct Action**: 楕円範囲VisualのTransform Rotation X/Yは0を正とし、縦横比やセル範囲はMesh/Prefab/パラメータ側で表現する。見た目、当たり判定、塗り範囲を同じ楕円基準にする。
**Trigger**: 旗、フロスト、アローレイン、サンダーボール、監視塔などの円/楕円範囲攻撃・範囲表示を追加/修正するとき。

2026-07-02: 積み残しを回答に明示しないリスクがあった
**NG Action**: 「確認後に水平展開」「確認後に不要機能を削除」「後続検証」などの残作業があるのに、最終回答でTODOとして明記しないまま次作業へ進むリスクがあった。
**Correct Action**: 作業に積み残しがある場合は、最終回答に `TODO` として必ず明記する。積み残しがない場合は不要だが、曖昧なままにしない。
**Trigger**: ユーザー確認待ち、水平展開予定、後続検証、不要機能削除、派生修正が残る作業を終えるとき。

2026-07-06: HUDレイアウトをEditor/Runtime側で戻す処理を残した
**NG Action**: ユーザーがEditor上で調整した所持レリックHUDなどの位置を、EditorセットアップやRuntime側の固定値処理で元の配置へ戻してしまう入口を残した。
**Correct Action**: AreaSurvivorsのHUD/ロビー/テスト画面/所持レリック画面など静的UIはScene/Prefabを唯一の正とする。既存UIに対して、Runtime/Editor Menu/Setup/Rebuild/Restore/Normalize/Validator/Importer/MigrationのどれであってもRectTransform、Transform、Scale、Rotation、Spriteを固定値へ戻さない。
**Trigger**: HUD、ロビー、テスト画面、所持レリック画面、ゲーム終了画面など、ユーザーがSceneで位置や見た目を調整するUIを変更するとき。

2026-07-06: ボタン背景色をUiSelectionHighlightに戻された
**NG Action**: テスト画面のレリック取得状態ボタンで `Image.color` だけを変えたが、`UiSelectionHighlight` が保持している通常背景色を更新せず、毎フレーム元の色へ戻る状態にした。
**Correct Action**: `UiSelectionHighlight` 等、背景色を保持・再適用するコンポーネントが付いたUIでは、見た目の色を変えるときに対象コンポーネントの通常色も同期する。単純な `Image.color` 変更だけで完了扱いしない。
**Trigger**: 選択枠、ホバー、選択中表示、取得状態表示など、UIコンポーネントが背景色を管理するボタン/パネルの色を動的更新するとき。

2026-07-07: Projectile Prefab化後もRuntime Sprite補完を残した
**NG Action**: Fireball PrefabのSprite参照が壊れているのに、`Projectile.EnsureVisibleProjectile` の名前ベース `GeneratedSpriteLoader.Load("Fireball"/"Arrow")` フォールバックで実行時に見える状態を作り、Prefab上で画像が見えない問題を隠した。
**Correct Action**: 攻撃PrefabのSprite、Collider、Prefab内ScaleはPrefabを正とする。Prefab上で画像やColliderが確認できない場合はPrefab参照/GUIDを修正し、Runtimeの名前ベース補完で隠さない。
**Trigger**: AreaSurvivorsでProjectile、着弾演出、爆発Hitbox、攻撃Prefab、Sprite参照を追加・Prefab化・修正するとき。

2026-07-07: Prefab化した中心塔砲弾の参照をScene直置き中心塔へ反映し忘れた
**NG Action**: `CenterTower.prefab` には `TowerCannonController.projectilePrefab` を設定したが、`05_Game.unity` の直置きCenterTowerには同コンポーネント/参照がなく、Runtimeの `AddComponent` で空のControllerが追加されてProjectile Prefab missingになった。
**Correct Action**: Scene直置きオブジェクトとPrefabが混在する対象では、Prefabだけでなく実際にGameManager等が参照するSceneインスタンスにも必要コンポーネント/Prefab参照が入っているか確認する。Runtimeで空コンポーネントを足して不足参照を隠さない。
**Trigger**: AreaSurvivorsで中心塔、Player、Scene直置き建造物、Prefab参照を追加・移行・Prefab化するとき。

2026-07-09: UIフォーカス移動を個別画面の場当たり指定で歪ませた
**NG Action**: シールド追加ノードなど特定パネルへ移動できない問題を、画面全体の移動ルールではなく個別の移動先指定で補正し、ロビーやオプションで右/下入力時に直感と違うボタンへ飛ぶ状態を作った。
**Correct Action**: AreaSurvivorsのSelectable移動は、アクティブ画面内の可視Selectableだけを対象に、見た目上近い方向へ共通ロジックで選ぶ。個別補正は最後の手段にし、入れる場合も対象画面/対象グループへ閉じる。
**Trigger**: パッド対応、キーボードナビゲーション、フォーカスが画面外へ消える問題、特定ボタンへ移動できない問題を修正するとき。

2026-07-09: フォーカス追従を毎フレーム判定にしてマウススクロールを阻害した
**NG Action**: フォーカスが画面外に出ないようにする処理をフレーム更新で走らせ、マウスホイールでスクロールしても少し後にフォーカス位置へ画面が戻る状態にした。
**Correct Action**: スクロール/パン追従は、パッドやキーボードのフォーカス移動が発生した瞬間だけ行う。マウスホイール、ドラッグ、ポインタホバー中はマウス操作を優先し、自動追従で戻さない。
**Trigger**: オプション、武器図鑑、レリック図鑑、強化画面など、スクロール/パンとSelectableフォーカスが共存する画面を修正するとき。

2026-07-09: 色変更で `renderer.materials` を使いMaterialを大量複製した
**NG Action**: バリスタ/壁の完成時色変更などで `renderer.materials` を取得・変更し、RendererごとにMaterialインスタンスが増殖して長時間プレイ時のクラッシュ要因を作った。
**Correct Action**: Renderer単位の色変更は `MaterialPropertyBlock` と `sharedMaterials` を優先する。Materialインスタンス数やメモリ使用量はビルドログへ補助診断として残す。
**Trigger**: 建造物完成色、ヒットハイライト、アウトライン、シルエット、状態異常色など、Rendererの色やMaterialプロパティを動的に変えるとき。

2026-07-09: 日本語フォント修正をRuntimeだけに入れてEditor表示を残した
**NG Action**: ゲーム実行中だけ日本語フォントを差し替え、Editor Scene上では簡体字風の漢字表示やサイズ/位置ずれが残る状態にした。
**Correct Action**: UIフォント表示を補正する場合はRuntimeとEditorプレビューの両方を用意し、既存TextのfontSizeやRectTransformを変えずFontだけ差し替える。Editor上の見た目も確認対象にする。
**Trigger**: 日本語フォント、文字化け、漢字の字形、Text/TextMesh表示、Editorプレビュー表示を修正するとき。