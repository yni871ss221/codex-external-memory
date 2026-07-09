---
date: 2026-06-10
tags: [knowledge, area-survivors, unity, rendering, silhouette, stencil]
project: area-survivors
related: [[area-survivors-current]], [[area-survivors-2-5d-paper-model]]
---

# AreaSurvivors のステンシル式遮蔽シルエット

## 採用方式

- キャラクターが塔、建造物、木、石、森、山などの画像に隠れた部分だけ、シルエットを前面表示する。
- 遮蔽物の実画像アルファをステンシルマスクへ書き込み、キャラクターのシルエット描画をそのマスク部分だけに制限する。
- 遮蔽物として扱うRendererには `OcclusionMaskSource` を付与する。
- キャラクター側は `CharacterOcclusionReveal` が対象Rendererを収集して描画する。

## 重なり判定

- 斜め見下ろしカメラでは、ワールドXYの `Renderer.bounds` と画面上の見た目が一致しない。
- 広域判定はRenderer boundsの8頂点を画面座標へ投影し、スクリーン空間の矩形同士で重なりを確認する。
- 実際にシルエットが表示される形状は、`OcclusionStencilMask.shader` のアルファクリップで画像の不透明部分だけに限定する。
- これにより、自然物やバリスタの端へ少し重なった場合にも反応し、四角いbounds全体がシルエットになることを防げる。

## 描画優先度

- ダメージ、回復、資源取得などのワールドポップアップは、遮蔽物より前面に表示する。
- `DamagePopup` は固定の高いSorting Orderを使い、`PreserveSortingOrder` で `YSort` による上書きを防ぐ。

## 検証

- 中心塔と山への部分重なりで、重なった画像部分だけシルエット表示されることを確認。
- 塔中央へ固定表示したダメージ数値が、塔画像より前面に表示されることを確認。
- UniCLI Compile `0 errors / 0 warnings`。
- 共通ナビゲーションGameplayTest成功、Console Error `0件`。

## 2026-07-09 塗りつぶしアウトライン/ハイライト/シルエット

- Spriteの透明余白や半透明エッジがあると、線状アウトラインと本体画像の間に隙間が見える。対策として、本体画像の裏に黒い塗りつぶし領域を置く方式へ寄せると、輪郭線と画像の境界が目立ちにくい。
- ヒット時白ハイライトは本体RendererのSortingやMaterialを一時的に変えると、YSortや建造物との前後関係が揺れることがある。塗りつぶし領域側を白くする方が、見た目の領域を保ったまま優先度変化を避けやすい。
- 建物裏シルエットも同じ塗りつぶし領域を使うと、アウトライン/ヒット/遮蔽の表示形状を揃えやすい。ただし更新頻度LODを落としすぎると、建物裏に入った時のシルエットがカクついて見えるため、近接/遮蔽中は十分な更新頻度を保つ。