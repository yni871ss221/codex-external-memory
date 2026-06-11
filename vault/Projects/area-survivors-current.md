---
date: 2026-06-10
tags: [project, current, unity, game, area-survivors]
project: area-survivors
related: [[area-survivors]], [[area-survivors-history]], [[area-survivors-unity-workflow]], [[game-art-style]], [[area-survivors-2-5d-style]], [[area-survivors-stencil-occlusion-silhouette]]
---

# AreaSurvivors Current

## 現在の開始地点

- ローカル作業パス: `D:\develop\unity_workspace\AreaSurvivors`
- ブランチ: `feature/01_GameSystemInit`
- 最新Push済みコミット: `19fba1e Improve map presentation and occlusion rendering`
- 2026-06-10終了時点でAreaSurvivors作業ツリーはclean。

## 現在有効なゲーム方針

- 2Dの移動、Collider、領地塗りロジックを維持し、見た目は斜め見下ろしの2.5D風にする。
- フィールド上の主要オブジェクトは遠目で判別しやすい、太い黒アウトライン付きのアイコン調ドット絵を使う。
- 背景は大きな草原チャンク画像を敷き、セルグリッドと領地色を上に重ねる。
- 木、石、森、山などの大きなランドマークはランダム配置だが、中心塔からの距離帯ごとの配置数をInspectorで調整できるようにする。
- 8セル森、8セル山は採取不可。障害物として残す。

## 現在有効な建造仕様

- 建造物は固定数ではなく、木・石資源を消費して建造予約する。
- 予約配置時に資源を即消費する。
- 建造キャンセルは今後実装予定。実装時は全額返却予定。
- 建造予約中の建造物は破壊されない前提。
- バリスタ、柵、塔などの画像を割り当てる場合は、ゲーム内アウトラインを適用する。
- 必要な画像が出た場合、ポリゴンの組み合わせで無理に作らず、寸法付きで画像生成を依頼する。

## 現在有効な採取仕様

- 木、石オブジェクトはプレイヤーが触れている間、伐採・採掘できる。
- 採取できるのは、青いエリアに接している木、石のみ。
- 採取中は対象上に採取ゲージを表示する。
- 伐採中は斧、採掘中はつるはしを表示する。
- 1秒ごとに資源を獲得し、初期値は `2`。
- 取得時は対象上に「取得数 + 丸太/石アイコン」のポップアップを出す。
- 採取しきった1/2/4セルの木・石は消滅する。
- 最大採取量:
  - 1セル木・石: `100`
  - 2セル木・石: `200`
  - 4セル木・石: `400`
  - 8セル森・山: 採取不可
- 採取量、初期所持資源、建造コストは将来的にスキルツリーで強化する可能性があるため設定パラメータ化する。

## 現在有効なHUD仕様

- HUD項目は可能な限りScene上に配置し、Editorで位置調整できるようにする。
- 左上にプレイヤー枠、武器枠、HP/XPゲージ、ステータス枠を置く。
- 上部中央に経過時間と撃破数をパネル表示する。
- 撃破数の右に木・石所持数パネルを置き、丸太/石アイコン + 所持数で表示する。
- 右側に中心塔ステータスを置き、塔画像、塔HPゲージ、HP数値を表示する。
- 旧XPバーなど不要になったHUDは削除済み。
- パネル外枠は四辺の子オブジェクトではなく、`UiBoxOutline` のようなコンポーネントで自動的に縁取りする。

## 直近の実装済み

- カメラをプレイヤー中心追従にし、マップ端では設定範囲内へクランプするようにした。
- マップを縦方向へ拡張し、外周描画と進行不可境界を調整した。
- HUDは通常時に背景を半透明とし、プレイヤーと重なった場合は内容を含む全体を薄くする。レベルアップ画面は透明化対象外。
- キャラクターが塔、建造物、自然物へ隠れた部分だけシルエット表示するステンシル方式を追加した。
- シルエットの広域重なり判定は、斜めカメラでのずれを避けるためスクリーン空間で行う。
- ダメージ、回復、資源取得ポップアップは遮蔽物より前面へ固定表示する。
- 詳細は [[area-survivors-stencil-occlusion-silhouette]] を参照。
- プレイヤー/武器ステータスの基礎値、永続強化量、ラン中強化量、武器固有範囲を `GameConfig` から調整できるようにした。
- HUD左側ステータス欄に、既存の攻撃/間隔/速度/塗りに加えて、復活時間、弾速、射程/範囲を表示するようにした。
- HUD項目はPlay中に生成せず、`05_Game.unity` のScene上へ配置し、ランタイム側は既存要素にバインドする方針を再確認した。
- 資源タイプ `ResourceType` を追加。
- `GameConfig` に初期資源、建造コスト、採取量などの設定を追加。
- `HarvestableResource` と `HarvestResourcePopup` を追加。
- 木・石ランドマークへ採取情報を付与。
- 斧、つるはし、ハンマー、丸太、石、経験値オーブ、岩ランドマーク画像を追加。
- 採取ツールと採取ゲージをランドマークより手前に表示するようSortingを調整。
- 木・石取得表示は最前面に近いSortingへ調整。
- 武器は敵より前面に出るよう `WeaponSortingOrders` を追加。
- `StatBlock` と `PlayerStats` を追加し、基礎値、永続強化、ラン中強化を合成した現在値として扱うようにした。
- 新規ステータスとして、ノックバック、防御力、経験値獲得量、体力自動回復、作業速度、資源獲得量を追加。
- ノックバックは敵のみを対象にし、`knockback * knockbackForceUnit` を `KnockbackReceiver` へ渡す。
- 防御力は受けるダメージから差し引き、0ダメージでも命中確認用にダメージ表記を出す。
- 経験値獲得量は `1.0x` 表記で、小数経験値を `GameManager` 内に蓄積して切り捨てロスを防ぐ。
- 体力自動回復は `AutoRegeneration` を `Health` に組み合わせる共通方式にし、現状はプレイヤーのみ値を持つ。
- 最大HP増加時は全回復せず、増えた最大HP分だけ `Health.Heal` で回復する。
- 作業速度は建造進捗、伐採、採掘に適用する。建造ゲージ減少には適用しない。
- 資源獲得量は採取1tickごとの木・石獲得量へ加算する。
- HUD左側ステータス欄に、ノックバック、防御力、経験値倍率、自動回復、作業速度、資源獲得量をScene上の項目として追加した。
- スキルツリーに上記6ステータスの永続強化ノードを追加した。

## 検証

- 2026-06-10: 中心塔と山への部分重なりで、画像と重なった部分だけシルエット表示されることを確認。
- 2026-06-10: 塔上のダメージ数値が塔画像より前面へ表示されることを確認。
- 2026-06-10: UniCLI Compile `0 errors / 0 warnings`、共通ナビゲーションGameplayTest成功、Console Error `0件`。
- 2026-06-08: ステータス設定化とHUD追加後、UniCLI Compile `0 errors / 0 warnings`、PlayMode Errorログ `0件`。
- 2026-06-08: 左HUD追加項目をScene上へ配置し直し、ランタイム動的生成を停止。UniCLI Compile `0 errors / 0 warnings`、PlayMode Errorログ `0件`。
- 2026-06-08: 新規ステータス6種、ノックバック、防御、自動回復、経験値小数蓄積、作業速度/資源獲得反映後、UniCLI Compile `0 errors / 0 warnings`、PlayMode Errorログ `0件`。
- 直近の変更後、UniCLI Compile は `0 errors / 0 warnings` を確認済み。
- PlayMode確認は変更内容に応じて実施する。

## 次の作業候補

- シルエット方式を追加される新規建造物・自然物にも `OcclusionMaskSource` で適用する。
- カメラ端、外周描画、HUD重複透明化を複数解像度で確認する。
- 採取表示、採取ゲージ、斧/つるはしのサイズと前後関係をGame Viewで再確認する。
- 資源消費型建造のUI表記をさらに分かりやすくする。
- 建造キャンセルと資源全額返却を実装する。
- スキルツリーで資源・採取・建造関連パラメータを強化可能にする。

## 2026-06-11 引継ぎ: 軽量化と検証効率化

- `90_GameplayTest.unity` は `05_Game.unity` のコピーではなく、Bootstrap Sceneとして維持する。
- GameplayTest実行時はBootstrapが `05_Game` をAdditiveロードし、`GameplayTestRunner` を実行時に注入する。
- Scenario選択は `EditorPrefs` の `AreaSurvivors.GameplayTestScenarioPath` に保持し、Scenario切り替えでScene差分を出さない。
- `05_Game.unity` の `Ground Tilemap` 保存済みタイルは削除済み。地面は `TileGrid.Build()` が実行時に再生成する。
- 追加Editorメニュー: `Area Survivors/Map/Clear Saved Ground Tiles In 05_Game`、`Area Survivors/Map/Rebuild Ground Preview In Active Scene`。
- 検証済み: UniCLI Compile `0 errors / 0 warnings`、`Gameplay_Prefab_Smoke` PASS、`Gameplay_Navigation_Default` PASS、`Gameplay_Map_Perimeter` PASS。
- 次回以降は、大きな作業前に軽量化済みSceneをベースとして扱い、巨大Scene差分本文の読み込みは避ける。
