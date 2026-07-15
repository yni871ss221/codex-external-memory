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

2026-07-10: 軽微なUI修正へサブエージェントを多用して作業時間を肥大化させた
**NG Action**: レベルアップ画面へスキップ/リロールを追加する密結合な小規模修正で、調査・実装・レビューを複数サブエージェントへ分割し、通信・統合・再検証のオーバーヘッドで約1時間かけた。
**Correct Action**: AreaSurvivorsでは、ユーザーがその作業でサブエージェント利用を明示指定した場合にだけ使用する。指定がない場合は規模や並列化可能性にかかわらずLeadが単独で対応する。
**Trigger**: AreaSurvivorsで新しい実装・調査・レビューを開始し、サブエージェントへ委譲するか判断するとき。


2026-07-13: 通常作業で検証と再試行を広げ、軽微な変更を長時間化させた
**NG Action**: ユーザーが時間をかけてよいと指定していない変更で、Compile/Play ModeやUnity操作を必要以上に反復し、軽微な変更でも作業時間を肥大化させた。
**Correct Action**: 作業規模を問わず、明示許可がない場合はCompile最大2回、Play Mode開始最大2回を標準上限とする。失敗・再試行も回数へ含め、3回目が必要なら変更を止めて読み取り中心の原因調査へ移る。同種コマンド失敗が2回続いたら手打ちをやめ、Wrapper/Runner/Validatorへ部品化する。
**Trigger**: AreaSurvivorsでUnity Compile、Play Mode、UniCLI、Scene/Prefab検証を伴う作業を行うとき。

2026-07-13: 英語訳の文字列だけ確認し、Scene上の表示幅を確認しなかった
**NG Action**: タイトル英訳を `AREA SURVIVORS` と登録したが、日本語向けTitle Label幅、折り返し、縦切り捨ての組み合わせを確認せず、実表示が `AREA` だけになった。
**Correct Action**: ローカライズでは辞書値の正しさだけでなく、長い英語を代表画面で表示し、折り返し、Best Fit、Overflow、RectTransform幅を確認する。静的UIの修正はSceneを正として行う。
**Trigger**: タイトル、ボタン、HUD見出しなど、日本語より英語が長くなるTextを追加・翻訳・レイアウト調整するとき。

2026-07-13: Opening Storyを高精細に描きすぎ、既存ゲーム画風から外した
**NG Action**: Opening Story画像へ細かな質感・陰影を入れ、ゲーム本編より高品質で生成AIらしさが目立つ映像にした。
**Correct Action**: AreaSurvivorsの物語画像は01/05のような太い輪郭、大きな色面、2〜3段階の陰影、控えめなドット密度を基準にする。既存画像は差し替え前にArchiveへ保存する。
**Trigger**: Opening Story、漫画、背景など、連続して表示する生成画像を新規作成・差し替え・画風統一するとき。

2026-07-13: 想定外のコマンド失敗後に原因確定より別方式への切替を優先した
**NG Action**: 新規Editorメニューが見つからなかった時にAssetDatabase Importの有無を調べずCompileを再実行し、その後、同じScene変更を長いEvalへ切り替えて引用符破損を起こした。
**Correct Action**: コマンド失敗、timeout、無応答、想定外の戻り値が出たら元の機能実装を止める。実行コマンド、終了コード、capture、Handler実装、Unity状態から失敗境界を確定し、Validator/Wrapper/ルールへ反映して限定自己テストが通るまで別方式へ切り替えない。
**Trigger**: AreaSurvivorsでUniCLI、PowerShell、RTK、Unity Editor Runner、Evalを実行し、期待した応答・Menu登録・終了状態が得られなかったとき。

2026-07-14: 軽微なUI修正で検索Wrapperの引数ミスにより作業を長時間化させた
**NG Action**: 対象ファイルがほぼ判明している状態で追加検索を行い、`focused-search.ps1`へ未確認の`-First`を渡して実装前に停止した
**Correct Action**: 軽微修正は既知のScene/C#だけを限定読取し、検索が必要な場合は正式契約の`-TopFiles`または検証済みaliasだけを使う
**Trigger**: アイコンTint、文言、参照差し替えなど、対象が限定されたFast PathのUI修正

2026-07-14: 軽微修正中に禁止済みの入れ子PowerShellを使用した
**NG Action**: 削除対象確認と`Remove-Item`を二重引用の`-Command`へ埋め込み、外側Shellに`$relative`等を先行展開させてParserErrorを起こした
**Correct Action**: 変数・配列・検証を伴うPowerShellは最初から限定`.ps1`を`apply_patch`で作成し、`rtk powershell -File`だけで実行する
**Trigger**: PowerShellで複数ファイルの検証、移動、削除などを行う時

2026-07-14: 入れ子Scroll Viewで内側Contentを画面全体と誤認した
**NG Action**: テストメニュー全体をEditor表示する修正で、武器ボタンから親をたどって最初に見つかった`Content/Viewport`を外側Scroll Viewと判断し、内側の武器リストだけを拡張した。
**Correct Action**: 同名の`Viewport/Content`が入れ子になり得るUIでは、一意な画面Root名から直下階層を解決し、外側Root・外側Content・内側リストのfileID、親子関係、高さを専用Validatorで分離確認する。
**Trigger**: AreaSurvivorsのメニュー、HUD、図鑑、テスト画面でScroll View、Viewport、Contentを移行・拡張・検証するとき。

2026-07-14: 進化武器ボタン複製時にアイコンを差し替えなかった
**NG Action**: ソードラッシュのボタンを複製して名前とラベルだけを変更し、子`Icon`の`Image.sprite`を武器種別ごとに設定しなかった。Validatorもボタンの存在確認だけで成功扱いにした。
**Correct Action**: 種別付きのアイコンUIを複製するときは、種別と期待Spriteの対応表からScene参照を明示設定し、Validatorで全種別の期待Sprite一致まで検証する。
**Trigger**: AreaSurvivorsで武器、レリック、建造物など、アイコン付きボタンやパネルを複製追加するとき。

2026-07-14: 黄金の弓で基礎武器の一斉発射仕様を満たせなかった
**NG Action**: 進化固有の貫通処理は追加したが、共通弓処理がターゲット数まで矢を減らす挙動と、128px正方形Effectのワールド表示サイズを通常矢と比較せず採用した。
**Correct Action**: 進化で変更指定のない発射タイミング・同時発射・ターゲット配分は基礎武器と共通化し、矢本数分を同一フレームで生成する。生成Effectは画像寸法だけでなくPPU適用後のワールドサイズを基礎武器と比較する。
**Trigger**: AreaSurvivorsで既存武器から進化するProjectile武器を追加・調整するとき。

2026-07-14: 黄金の弓の再修正で通常弓の対象配分を変えてしまった
**NG Action**: 「矢本数分を同時発射」を満たすため、敵が少ない場合に同じ対象へ巡回配分し、別画像を160 PPUへ変更して通常矢サイズへ近似した。その結果、通常弓の`min(矢本数, 敵数)`契約と厳密な同一サイズ要件を満たさず、実機では4本が4回飛ぶように見える挙動と大きな矢が残った。
**Correct Action**: 通常弓と同じく1クールタイム1斉射、`min(矢本数, 射程内の敵数)`本を別対象へ同一フレームで発射する。重複要求はクールタイムガードで抑止する。同じサイズ指定では通常矢と同じSprite・Scale・Colliderを使い、金色はTintだけで表現する。
**Trigger**: AreaSurvivorsで既存武器の進化先について「元武器と同じ仕様」「同じサイズ」と指定された発射処理やProjectile Visualを修正するとき。

2026-07-14: 既知のRoot定数より推測したアセットパスを優先した
**NG Action**: `WeaponEvolutionBatchMigration`にPrefab/SpriteのRoot定数があるのに、確認用`safe-read`で`Prefabs/Projectiles/`と`Sprites/Generated/`を推測して存在しないパスを渡した。
**Correct Action**: Migration、Validator、Importerなど既知の管理スクリプトを先に読み、Root定数と対象名から実在パスを確定してから`safe-read`する。一般的なフォルダ分類を記憶で補わない。
**Trigger**: AreaSurvivorsで生成済みPrefab、進化武器Sprite、Scene移行対象の実在パスを確認するとき。

2026-07-14: 黄金の弓の実発射回数を検証せず修正完了とした
**NG Action**: `ResolveArrowVolleyProjectileCount`の戻り値と`nextArrowVolleyAt`フィールドの存在だけを専用Validatorで確認し、1クールタイム中に発射入口が何回通って何個のProjectileが生成されたかを検証せず、複数斉射が直ったと報告した。
**Correct Action**: 発射回数の不具合では、同時に複数本出る「1斉射」と、時間差で同じ斉射が繰り返される「複数回射撃」を分ける。実行可能な限定テストまたは実機traceで、controller instance、frame/time、volley sequence、生成Projectile数を確認してから原因箇所を修正する。
**Trigger**: AreaSurvivorsでクールタイム、バースト、連射数、Projectile本数に関する実機報告を修正・検証するとき。

### 2026-07-14 要約中のファイル名からGameManagerパスを推測

- 要約にあった `GameManager.cs` を `Assets/AreaSurvivors/Scripts/Game/GameManager.cs` と補完して読み取り、Path Guardに拒否された。
- 正確な相対パスがない場合は補完せず、対象ディレクトリを限定した `safe-search.ps1 -FilesOnly` で実在パスを確定してから読む。

### 2026-07-14 黄金の弓が1クールタイム内に複数斉射される再発経路

- Projectile/Prefabには追加発射経路がなく、05_GameはGameManager 1個・静的Player/WeaponController 0個、Player PrefabもPlayerController/WeaponController各1個だった。
- 問題の発射入口は、対象探索とProjectile生成が終わった後に次回時刻を記録していたため、同一時刻に入口が重複した場合の2回目を生成前に拒否できず、対象0体の時も予約が進まなかった。
- `TryConsumeArrowSchedule` で対象探索前に予約を確定し、同一時刻の2回目を拒否、対象0体でも予約を消費する形へ変更した。弓本来の `min(矢本数, 対象数)` 本を同一斉射で別対象へ出す仕様は維持した。
- `GameManager.Awake` では重複コンポーネントだけを停止・破棄し、GameObject上の他コンポーネントは壊さない。
- Golden Bow限定Validatorで同一時刻2回目の拒否、次クールダウンでの再許可、Scene/Prefab個数、参照整合性を実行検証する。Compile 1回、限定Validator、Console Error 0件を確認した。Play Mode確認はユーザーへ委ねる。

2026-07-14: 黄金の弓を実機再現せず防御的修正だけで完了扱いした
**NG Action**: 静的調査で複数射撃の根本原因が未確定と記録されていたのに、クールダウン予約とGameManager重複Guardを追加し、実際の発射入口回数・Projectile生成時刻をPlay Modeで確認せず修正完了と報告した。
**Correct Action**: ユーザー実機で継続する発射回数不具合は、許可されたPlay Modeでcontroller instance、volley sequence、frame/time、生成Projectile instanceを実測し、再現ログが示す発生源を修正した後、同じ経路で現象消失まで確認する。防御的Guardや静的Validatorの成功だけで完了扱いしない。
**Trigger**: 静的Validatorが通っているのに、ユーザーがPlay Mode上のクールタイム・連射・Projectile本数不具合の継続を報告したとき。

### 2026-07-14 黄金の弓の複数斉射に見える根本原因をテストプロファイルで修正

- Play Mode実測で、Golden Bowテスト開始は`logical/display Lv.10`に加えてGameConfig内部Lv.10をステータス参照にも使い、攻撃21・矢4本・クールダウン0.345秒・射程13.3になっていた。
- 通常ランの武器Lvは、基礎Lv.1へ選択した個別強化だけを加算し、表示Lvを別管理する。テスト開始だけが内部Lv.10の全ステータス自動曲線を読み、短時間に複数の4本斉射が画面へ残る状態を作っていた。
- 修正はGolden Bowテスト開始だけに限定した。論理Lv10・表示Lv10・進化済み・再レベルアップ不可を維持し、ステータス参照Lvだけ1へ分離する。複数矢テストのため最大Lv由来の矢本数4だけを明示bonusとしてReset後・Refresh前に適用する。
- 通常プレイの進化、獲得済み個別強化、レリック、特殊効果、共通ArrowLoopは変更しない。
- 診断用Play HookとProjectile詳細ログは削除した。Compile 2回目、実行型Golden Bow Validator、Console Error 0件を確認した。Play上限2回へ到達したため、修正後の見た目はユーザー実機確認へ委ねる。

2026-07-14: 表示Lv.10を特定の強化選択履歴と同一視した
**NG Action**: Golden Bowテストを表示Lv.10にする際、複数矢検証のため最大Lv定義由来の矢本数4を合成プロファイルへ入れたが、その4本が「Lv.10までに矢本数強化を3回選んだ場合」の値であり、基礎値ではないことを明確に区別しなかった。
**Correct Action**: 武器の表示Lvは強化回数だけを示し、どのパラメータを選んだかは確定しない。弓・黄金の弓の基礎矢本数は1本とし、4本は矢本数強化を3回選んだ明示的なテストプロファイルとしてのみ扱う。
**Trigger**: AreaSurvivorsで武器Lv.10のテスト開始値、進化前強化の引継ぎ、または個別パラメータ強化履歴を設定・説明するとき。

## 2026-07-14 アローシャワーの矢Spriteが円形へ歪んだ

- ユーザー訂正: 3フレーム画像は矢だけだったが、実機では旧水しぶきのような大きな青い円と交差模様が表示された。
- 根本原因: `GroundStrikeVisualAnimator.visual`が、コピー元Area Prefabから残った`useEllipseShape=1`・`shapeSpriteOverride`ありの`PaperMeshVisual`を参照していた。さらに範囲Visualコンテナにも不要な`PaperMeshVisual`が混入していた。
- 再発防止: 単体フレームアニメーション用Visualは通常Quadへ正規化し、範囲VisualはMesh FillとLine Outlineだけに限定する。専用ValidatorでPrefab内の`PaperMeshVisual`がAnimator参照先の1つだけであること、楕円設定と範囲側Sprite Visualがないことを検証する。
- 作業中の再発防止: 既存ルール文書へのpatchは記憶上の文言をアンカーにせず、`safe-read -Pattern`で実在する最小行を確認してから適用する。

## 2026-07-14 範囲Visual全体Copyが不要Spriteを復元した

- 症状: 矢用Visualの楕円設定を解除しても、専用ValidatorでPrefab内の`PaperMeshVisual`が2個残った。
- 根本原因: `EditorUtility.CopySerialized(sourceArea, targetArea)`がアローレインの色や幅だけでなく、元Prefabの`arrowVisual`・`frames`等の参照依存も移行し、Prefab保存時に不要なSprite Visualを復元した。
- 再発防止: 参照フィールドを持つVisual Componentは全体Copyせず、Fill/Outline色、幅、Sorting Order、縦横比だけを個別コピーする。移行先のSprite/Frame参照は空配列・nullへ明示し、Prefab内の`PaperMeshVisual`個数をValidatorで固定する。

## 2026-07-14 同名Prefab子ObjectのfileID再利用で旧Visualが残った

- 追加調査: `CopySerialized(sourceArea, targetArea)`を廃止して必要値だけをコピーしても、専用Validatorは`PaperMeshVisual`が2個ある状態を検出した。
- 証拠: 再保存後も余計な子Object名は`Ellipse Range Outline`、PaperMeshVisualのfileIDは`7749125301234567894`で変わらず、旧Sprite GUID参照も残った。Migrationは削除後にコピー元と同じ子Object名を再作成していた。
- 原因訂正: 全体Copyだけでなく、`SaveAsPrefabAsset`が同名・同階層Objectを既存fileIDへ対応付け、旧Component構成を保持したことが残存要因。
- 次回修正: 範囲Visualの子Objectへ移行先専用名を付け、保存後にPrefabを再ロードして`PaperMeshVisual`がAnimator参照先の1個だけであることを確認する。Compile上限2回到達のため、本ターンでは追加実装しない。

## 2026-07-14 アローシャワー旧Visual残存と矢サイズ過大

- ユーザー訂正: 実機で青い水しぶき状Visualが残り、落下矢も大きすぎた。
- 原因: 範囲Visualの子Objectをコピー元と同じ名前で再作成したため旧fileIDの`PaperMeshVisual`が保持された。矢3フレームは192px画像を96 PPUで読み込み、攻撃範囲Root Scale下で大きく表示されていた。
- 対応: 旧範囲コンテナを明示削除し、移行先専用名のMesh Fill／Line Outline Objectとして新規作成する。範囲側にSprite Visualを置かない。矢フレームは192 PPUへ変更して表示寸法を半分にし、専用Validatorで旧コンテナ不在・PaperMeshVisual 1個・PPU 192を固定する。

## 2026-07-14 旧Ellipse Visualは範囲コンテナ外のRoot直下に残っていた

- 追加調査: 専用名の新範囲コンテナへ置換後もValidatorは`PaperMeshVisual`を2個検出した。PPU 192のimport条件は通っており、失敗項目はVisual個数のみだった。
- 根本原因: 旧`Ellipse Range Outline`は後から追加した範囲コンテナの子ではなく、ArrowShowerStrikeのコピー元Area PrefabからRoot直下へ継承された既存Objectだった。コンテナ限定の削除では対象外だった。
- 再発防止: Prefab全体の`PaperMeshVisual`を列挙し、`GroundStrikeVisualAnimator`参照先以外はGameObjectごと削除する。ValidatorはRoot直下の旧Object名不在とPrefab全体のVisual個数1を確認する。

2026-07-15: アローシャワーの表示サイズと着弾pivotを画像中央のままにした
**NG Action**: 弓矢フレームを192 PPUへ縮小しただけで十分と判断し、全フレームのSprite Pivotを既定の画像中央に残したため、矢がまだ大きく、3フレーム目の接地点が攻撃エリア中心からずれた。
**Correct Action**: 指定された追加50%縮小はPPUを192から384へ倍増して反映する。最終フレームの矢軸中心X=90px、接地点Y=下端から22pxを全3フレーム共通Custom Pivot `(90/192, 22/192)`として設定し、ValidatorでPPUとpivotを固定する。
**Trigger**: 透明余白を持つ落下物・着弾アニメーションの表示サイズまたは着弾中心を調整する時。

2026-07-15: 攻撃範囲Root Scaleと非Billboard設定を落下矢へ継承した
**NG Action**: ArrowShowerStrikeの攻撃範囲Visualと落下矢Visualを同じPrefab Root配下に置いたまま、`AdvancedWeaponArea.Configure`でRoot全体を範囲半径・セル縦横比へScaleした。また矢Visualの`PaperBillboard.faceCamera`をfalseにしたため、画像は正しい縦横比でも画面上では横長に圧縮され、高さ違いの3フレームも地面上で潰れて見えた。
**Correct Action**: 動的ScaleはRange Visual専用Containerだけへ適用し、落下矢はそのContainer外でScale `(1,1,1)`を維持する。矢Visualだけ`PaperBillboard.faceCamera=true`にし、地面の範囲VisualはBillboard化しない。AnimatorはSprite差し替えだけに限定する。
**Trigger**: Area/Range Visualと落下物・着弾アニメーションを同一Prefabで構成する時。

2026-07-15: Animator戦闘VisualへPaperBillboardを付けてRotate X/Yを再導入した
**NG Action**: Area/Range VisualだけをRotate禁止対象と解釈し、落下矢Spriteを例外として`PaperBillboard.faceCamera=true`にしたため、Play Mode中にカメラ角度のRotate Xが毎フレーム設定された。
**Correct Action**: Area/Rangeだけでなく、AnimatorでSpriteを切り替える戦闘Visual、落下物、着弾演出もPrefabのRotation X/Yを0にし、`PaperBillboard.faceCamera`を使用しない。Animator、Clip、表示ScaleはPrefabへ保存し、Runtimeは再生開始だけを行う。変更後は`Combat Visual Rotation Guard`で全武器Prefabを検証する。
**Trigger**: 武器PrefabへAnimator、SpriteRenderer、落下物、着弾演出、Area/Range Visualを追加・変更する時。

2026-07-15: ArrowRainのPrefab Xだけを広げてClip再生時の上書きを見落とした
**NG Action**: 7個の子TransformをPrefab上で横分散し、Animator ClipはYだけを動かすためXは維持されると判断した。ValidatorもPrefab Xだけを確認したため、Animationウィンドウ上の未設定Position.x既定値0が再生中に全矢を中央へ戻す経路を検出できなかった。
**Correct Action**: 非0のX配置を持つTransformでYをAnimationClip制御する場合、各対象の`m_LocalPosition.x`を定数カーブとしてClipへ明示保存するか、非アニメーション親AnchorへX配置を分離する。ValidatorはPrefab XとClip Xのパス・値を両方照合する。
**Trigger**: 複数オブジェクトを横分散しつつ、同じTransformのPosition Yで落下・上下移動アニメーションを作成または調整するとき。

2026-07-15: ArrowRainをX方向だけ均等化し着弾分布が斜めに偏った
**NG Action**: 7本の落下矢についてPrefabとClipのPosition Xだけを等間隔へ修正し、Position Yの着弾基準と再生位相の空間的な相関を確認しなかった。その結果、中央収束は直っても着弾が左上と右下へ偏って見えた。
**Correct Action**: 範囲攻撃の落下物はX/Yを一組の二次元着弾点として設計し、中心1点と外周点などエリア全体を覆う不規則な均等配置をPrefabへ保存する。ClipのX定数カーブとY落下カーブも同じ着弾点へ同期し、ValidatorでPrefab X/YとClip X/Yの両方を照合する。
**Trigger**: 複数の落下物・範囲攻撃VisualをAnimatorの1 Clip内で分散配置するとき。

2026-07-15: マシンガン弾へ短いEffect Spriteを割り当てて圧縮表示にした
**NG Action**: 銃Prefabを複製したため見た目も同じ寸法になると判断し、マシンガンだけ96×96・PPU 96・可視領域84×26の`MachineGunEffect.png`へ差し替えた。同じPrefab Scaleでも銃弾128×40・PPU 64よりワールド寸法が約半分になり、短く圧縮された弾に見えた。
**Correct Action**: 基礎武器と同じ見た目寸法を要求された進化Projectileは、Canvas寸法、可視alpha bounds、PPU、Prefab Root/Visual Scale、Colliderを一組で一致させる。差別化は別色Spriteで行い、Runtime Scale補正を追加しない。専用Validatorで全項目を基礎Projectileと比較する。
**Trigger**: 基礎武器のProjectileを複製し、進化武器用Spriteへ差し替える時。

2026-07-15: ファイアミサイルの攻撃間隔2倍をCooldown値2倍として実装した
**NG Action**: 「攻撃間隔を2倍」を攻撃頻度ではなく待ち時間の秒数を2倍にする指定として扱い、ファイアボールの基礎Cooldownへ同値を加算した。
**Correct Action**: ファイアミサイルの基礎攻撃間隔はファイアボールLv.1基礎Cooldownの0.5倍とする。進化前強化を保持する計算は `currentCooldown + evolvedBaseCooldown - levelOneBaseCooldown` とし、その後にラン内強化・レリック等の倍率を適用する。
**Trigger**: 武器進化仕様で「攻撃間隔」「発射間隔」「Cooldown」の倍率変更を実装・説明するとき。

2026-07-15: Frost Stormの旧PaperMeshVisualをSpriteRenderer検査だけで見逃した
**NG Action**: 新しい氷トゲSpriteRendererと通常FrostのAnimator参照だけを確認し、コピー元Prefabの`Ellipse Range Outline`に残った`PaperMeshVisual.sourceSprite = FrostStormEffect`を検査しなかった。新旧Visualが二重表示され、画像が差し替わっていないように見えた。
**Correct Action**: Area Prefab派生武器ではPrefab全体の`PaperMeshVisual`と旧Object名を列挙して不要Objectを削除し、SpriteRendererだけでなく`PaperMeshVisual.sourceSprite`、AnimationClip、`AssetDatabase.GetDependencies`の全経路で旧Sprite依存0件をValidatorに固定する。
**Trigger**: 既存Area Prefabを複製し、進化武器のSprite・Animator・範囲Visualを差し替える時。
