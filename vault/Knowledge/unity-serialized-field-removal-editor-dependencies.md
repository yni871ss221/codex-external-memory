---
date: 2026-07-15
tags: [unity, compile, editor, migration, prevention]
project: AreaSurvivors
---

# Unity serialized field削除時のEditor依存確認

## 事象

Playerの方向別アニメーションをAnimatorへ移行し、`PlayerController`から旧`directionalAnimator`と12個のSprite配列を削除した。Runtime側と新Migratorは更新したが、`AreaSurvivorsBootstrap.cs`が旧フィールドを直接設定しており、Unity Compileで13件の`CS1061`になった。

## 根本原因

旧フィールド削除前の水平検索をRuntimeコード中心に行い、Prefab生成・Setupを担う`Assets/AreaSurvivors/Editor`を削除契約の対象へ含めなかった。

## 再発防止

- serialized field、Component型、旧アニメーション経路を削除する前に、RuntimeとEditorの両方を限定検索する。
- `AreaSurvivorsBootstrap`、Setup、Migrator、Validatorの生成・設定処理を同じCompileバッチで更新する。
- Compile前Validatorで削除予定member名のEditorコード残存を0件にする。

## 今回の証拠

- Compile 2回目: 13 errors / 0 warnings
- 全エラー: `Assets/AreaSurvivors/Editor/AreaSurvivorsBootstrap.cs` 343〜358行の旧Player field参照
- Unity Scene/PrefabへのMigration MenuはCompile失敗により未実行

## 追加事象: Animator移行前の旧Script削除

戦闘VisualのAnimator移行で旧`PaperMeshSpriteAnimator.cs`と`.meta`をPrefab更新より先に削除したため、Frost系Prefab内のComponentがMissing Script化した。型名検索では欠損Componentを見つけられず、単一GameObjectだけの除去ではPrefab保存が拒否された。`PrefabUtility.SaveAsPrefabAsset`のnull戻り値を検査せず、`Menu.Execute`もMenu受付だけを終了コード0として返したため、移行成功に見えた。

### 再発防止

- 原則はPrefab移行とValidator成功後に旧Script/`.meta`を削除する。
- 既にMissing Script化した場合は、Prefab全Transformで`RemoveMonoBehavioursWithMissingScript`を実行し、各Objectの欠損数0をassertする。
- `SaveAsPrefabAsset`の戻り値がnullなら即時失敗にする。
- `Menu.Execute`の終了コード0を成功判定に使わず、Validatorが処理末尾で作る成功markerをWrapper側で必須確認する。
- Validator自身もPrefab rootだけでなく全TransformのMissing Scriptを検査する。

### 証拠

- Console: `FrostArea.prefab`と`FrostStormSpike.prefab`がMissing Scriptを理由に保存拒否。
- Menuコマンド終了コード: 0。
- Combat Animator Validator: Frost系とArrowRainの未移行、および成功marker未生成を検出。

## 追加事象: Mesh VisualからSpriteRendererへのComponent追加順

Missing Script除去後もFrost移行が停止した。Editor.logで`Can't add component 'SpriteRenderer' ... conflicts with the existing 'MeshFilter'`を確認した。旧`PaperMeshVisual`の見た目情報を読んだ後、`MeshFilter/MeshRenderer`を除去する前に同じGameObjectへ`SpriteRenderer`を追加していたことが原因で、Frost例外後のFrostStorm/ArrowRainへ到達しなかった。

### 再発防止

- 同一GameObjectのRenderer方式を移行する順序は、旧見た目値の読取→旧Visual/Renderer/Mesh除去→新Renderer追加→Animator設定→保存とする。
- `RemoveLegacyVisualComponents`は旧Component型が既に無くても、移行指定時はMeshFilter/MeshRendererを必ず除去する。
- Editor.logの最初の例外を根拠にし、後続Validatorの派生エラーを個別修正しない。

## 追加事象: Animator初期SpriteとClip先頭フレームの不一致

Renderer移行後の専用Validatorで残ったエラーはFrostStormの1件だけだった。旧`PaperMeshVisual.sourceSprite`を新`SpriteRenderer.sprite`へ引き継いだ一方、生成AnimationClipは`FrostAreaTexture.png`を先頭フレームとしており、Prefab初期状態とAnimator再生開始状態が不一致だった。

### 再発防止

- Animator管理SpriteのPrefab初期SpriteはClip先頭フレームへ固定する。
- 旧Visualから引き継ぐのは色、Material、Sorting Orderなどに限定する。
- ValidatorでSpriteRenderer初期Sprite、Clip先頭PPtr、Controller参照を同時に検査する。
