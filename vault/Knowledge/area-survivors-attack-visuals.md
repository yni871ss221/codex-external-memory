---
date: 2026-06-30
tags: [knowledge, unity, area-survivors, weapons, animation, sprites]
project: area-survivors
related: [[Projects/area-survivors-current]], [[area-survivors-unity-workflow]], [[mistakes]]
---

# AreaSurvivors 攻撃演出・武器Visualメモ

## 基本方針

- 武器アイコン、HUDアイコン、図鑑アイコン、静的UI画像はScene/Prefab上の参照を正とする。RuntimeでSpriteを差し替えない。
- 動的なProjectile/Area/EffectはPrefab化し、`WeaponController` / `AdvancedWeaponRuntime` からPrefab参照で生成する。
- 見た目サイズはScaleではなく、生成PNG、透明余白、Importer、Prefab内Transformで調整する。Projectileの進行方向だけRotation Zを使う。

## アローレインの教訓

- アニメーションが「横並びセット」に見える場合、コード側の落下位相だけで直そうとせず、まずフレームPNG自体を `view_image` などで確認する。
- 2026-06-30時点では `ArrowRainFrame_0..7.png` が1枚内に横一列の矢を含んでいたため、矢オブジェクトをばらしても横列が増幅された。
- 修正では、各フレーム画像自体を高い矢/低い矢が混在する散布配置へ再生成し、Prefab上の矢オブジェクト配置もリング状から不規則配置へ変更した。
- `AdvancedWeaponsSetup.BuildArrowRainOffsets()` も散布配置にして、`ApplyArrowRainArea` 再実行で横列配置へ戻らないようにする。

## エリア攻撃の表示と当たり判定

- 旗、アローレイン、フロストのような床/エリア攻撃は斜め視点に合わせて楕円表示にする。
- 見た目を楕円にした場合、当たり判定や塗りも円のままだとズレる。`AdvancedWeaponArea` の `verticalRadiusMultiplier` と `TileGrid.PaintEllipse` のように、表示・ダメージ・塗りを同じパラメータに寄せる。
- 塗り範囲を追加するときは既存の `TileGrid.Paint(...)` と同じ所有権更新経路を使い、Tilemap色を直接触らない。

## 追加武器の確認導線

- 武器追加後の動作確認は `08_GameTestLauncher.unity` を使う。ロビーにボタンを増やしすぎず、テスト用Sceneに武器別Stage 1開始ボタンを置く。
- 新武器を増やしたら `WeaponCatalog.TestableWeapons`、HUD、レベルアップ候補、武器図鑑、スキルツリーアンロック、GameConfig、Prefab参照、GeneratedSpriteCatalog を合わせて確認する。
## 2026-07-02 楕円エリアVisualの基準

- 旗、フロスト、アローレイン、サンダーボールなどの楕円範囲攻撃は、VisualのRotation X/Yを0にする。斜め視点らしく見せる目的で `Rotation X = -40` のような固定回転を入れると、表示範囲と当たり判定/塗り範囲がずれる。
- 当たり判定、塗り、表示は同じ楕円パラメータを使う。セル塗りは「楕円に少しでも重なるセルを塗る」を基準にする。
- アウトライン幅、透明度、Sorting Orderなどユーザーが調整したい見た目値はPrefab/SceneのInspectorを正とし、Runtimeで固定値へ戻さない。
- 監視塔の範囲表示も同じ考え方にする。範囲Spriteは地面側に表示し、キャラクター、建造物、武器本体より手前に出さない。

## 2026-07-07 Projectile Prefab化メモ

- Slash、TowerCannonball、ProjectileImpact、ProjectileExplosionHitboxはPrefab化済み。動的攻撃はPrefab参照からInstantiateし、RuntimeでGameObjectやColliderを一から組み立てない。
- 弾本体のSprite、Collider、Prefab内ScaleはPrefabを正とする。`Projectile.EnsureVisibleProjectile` では不足時に名前からSpriteをロードして補完しない。
- Arrow/PlayerArrowはBoxCollider2Dで矢全体を覆う。円Colliderへ戻すと矢先や軸の当たり判定が狭くなりやすい。
- Fireballの表示SpriteはPrefabの `PaperMeshVisual.sourceSprite` と `Projectile.fallbackSprite` に正しいGenerated Sprite GUIDを持たせる。Runtimeで `GeneratedSpriteLoader.Load("Fireball")` に依存しない。
- TowerCannonballはユーザーがPrefab上でColliderを弾サイズに合わせて調整する。RuntimeはCollider半径、Offset、Prefab Scaleを上書きしない。進行方向に合わせるRotation Zのみ許容する。
- 爆発Hitboxは攻撃ステータス依存のため `ProjectileExplosionHitbox` がPrefabをInstantiate後にCircleCollider2D.radiusだけ設定する。これは範囲仕様そのものなので例外的にRuntime設定可。

## 2026-07-09 Slash / Projectile / Boss攻撃メモ

- スラッシュは `slashRange` だけを伸ばすと前方距離だけ強調され、横幅が狭く見える。見た目と当たり判定はPrefab/SlashView側の縦横バランスを確認し、横幅と距離をセットで調整する。
- スラッシュのレベルアップ伸び幅は見た目に分かる量が必要。微増だとユーザー確認で変化が見えないため、現在はレベルごとに0.2増える設計へ寄せた。
- Fireballの軌道塗りはProjectileの移動経路で床塗り処理が呼ばれるかを確認する。Prefab化やProjectile共通化で塗り呼び出しが外れると、見た目は飛んでも床が青くならない。
- ボス攻撃のダメージは接触攻撃力から倍率で出す方針を維持する。固定値フィールドを安易に追加すると調整軸が増えるため、必要がなければ倍率で表現する。
- 多段Hitする攻撃（ゴブリンロード闇玉など）は1Hit値だけでなく、滞在時間中の累計Hitを基準に調整する。