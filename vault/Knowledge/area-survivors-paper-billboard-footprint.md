---
date: 2026-06-02
tags: [unity, area-survivors, 2-5d, billboard, grid]
project: area-survivors
related: [[Projects/area-survivors-2-5d-paper-model]]
---

# PaperBillboardと床面占有範囲の不一致

## 原因

- `PaperMeshVisual`はSpriteのBoundsからQuadを生成する。
- `MeshChild()`はQuadへ`PaperBillboard`を追加し、常にカメラ正面へ向ける。
- 床面Y方向は斜めカメラで画面上の長さが短縮されるが、カメラ正面を向くQuadの高さは短縮されない。
- 床面の縦方向に長い柵へBillboard Quadを使うと、Collider内へ収まるTexture寸法でも画面上では上下へ突き抜けて見える。

## 実測

- 縦20セル柵:
  - Collider高さ: `7.6846`
  - Sprite Quad高さ: `8.0`
  - 画面上のCollider高さ: 約`388px`
  - 画面上のQuad高さ: 約`527px`
- 横20セル柵:
  - Collider幅: `13.972`
  - Sprite Quad幅: `14.0`
  - 画面上のCollider幅: 約`920px`
  - 画面上のQuad幅: 約`922px`

## 対応方針

- 床面Y方向へ長いオブジェクトには、常時カメラ正面を向くBillboard表示をそのまま使わない。
- 縦柵専用に床面へ沿うQuadを使うか、カメラ傾斜を考慮して画面上の占有範囲を補正する。
- Collider寸法だけで完了扱いせず、床面上の範囲と画面上のTexture範囲を比較する。

## 実施した修正

- `MeshChild()`へ`faceCamera`引数を追加した。
- 柵の`Ghost`、`Build Fill`、`Complete`は`faceCamera = false`とし、床面XYへ沿うQuadとして表示する。
- Sprite Boundsから作るQuadへCollider寸法に合わせたScaleを適用した。
- `DefensiveFence`は基準Scaleを保持し、建造中のFill伸縮と完成時のパルスでも床面QuadのScaleを壊さないようにした。

## 修正後の実測

- 縦20セル柵:
  - Collider高さ: `7.6846`
  - 床面Quad高さ: `7.6846`
  - 画面上のCollider高さ: 約`387.66px`
  - 画面上のQuad高さ: 約`387.66px`
- Scene再オープン後、建造完了後、横移動後にも一致を確認した。

## 2026-07-15 Animator戦闘Visualへの水平展開

- `PaperBillboard.LateUpdate()`は`transform.rotation = Camera.main.transform.rotation`を毎フレーム実行するため、PrefabのRotationが0でもPlay Mode中はカメラ角度のRotate X/Yが表示される。
- Arrow Shower Animator VisualでRotate X `-38.6`が発生した原因はAnimatorではなく、Migrationが追加した`PaperBillboard.faceCamera=true`だった。
- 以前のルールがArea/Range Visualだけを禁止し、落下矢Spriteを例外としていたため再導入を防げなかった。
- 全武器PrefabのArea/Range/Outline配下、Animator+SpriteRenderer、`GroundStrikeAnimatorPlayback`を走査する`Combat Visual Rotation Guard`を追加した。
- 初回Reporterでは武器Prefab29個、対象Visual31個、違反9件を検出した。内訳はArrowRainAreaの落下矢7件とArrowShowerStrikeの現行・旧Visual各1件。
- 対象VisualではRotation X/Yと`PaperBillboard.faceCamera`を禁止し、方向表現はZ回転だけを許容する。

## 2026-07-15 水平Migration結果

- `Remove Forbidden Combat Visual Rotation` MigrationでArrowRainArea 7件、ArrowShowerStrike 2件の`PaperBillboard.faceCamera`をPrefabから除去した。
- Arrow Shower Animator VisualはPrefabへRotation `0/0/0`、Scale `2/2/2`、`ArrowShower.controller`参照を直接保存した。RuntimeはAnimator再生開始だけを行う。
- Migration後のReporterは武器Prefab29個、対象Visual31個、違反0件。
- Ground Strike ValidatorとCombat Visual Rotation Guardの完了マーカー更新、Unity Console Error 0件を確認した。

## 2026-07-15 Arrow Shower旧Runtime削除と6キー落下

- `GroundStrikeVisualAnimator.cs`とmeta、`AdvancedWeaponRuntime`の旧フォールバック分岐を削除した。
- ArrowShowerStrike Prefabから旧Component、Missing Script、旧PaperMeshVisual子ObjectをMigrationで除去した。
- `ArrowShowerFall.anim`を上空・高・中・低・着弾・着弾保持の6キーへ変更した。
- 落下Yは`1.60 → 1.25 → 0.90 → 0.45 → 0 → 0`、時刻は`0 → 0.08 → 0.16 → 0.24 → 0.32 → 0.40秒`。着弾時刻はPrefabへ`0.32秒`として保存した。
- 高さはRuntime処理ではなくAnimationClipの`Transform.m_LocalPosition.y`として保存し、Animationウィンドウから調整できる。
- Ground Strike Validator、Combat Visual Rotation Guard（違反0件）、Console Error 0件を確認した。
