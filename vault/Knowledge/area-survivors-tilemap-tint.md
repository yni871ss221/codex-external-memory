---
date: 2026-06-02
tags: [knowledge, unity, tilemap, area-survivors]
project: area-survivors
related: [[Projects/area-survivors-2-5d-paper-model]]
---

# Unity TilemapのセルTintが白く表示される場合

## 症状

- `Tilemap.SetColor()`で青や赤を指定しても、配置した領地Tileが白いまま表示される。

## 原因

- TileのColor変更がロックされていると、セルごとのTintが反映されない。

## 対処

- `SetTile()`の後、対象セルへ`TileFlags.None`を設定してから`SetColor()`を呼ぶ。

```csharp
tilemap.SetTile(cell, tile);
tilemap.SetTileFlags(cell, TileFlags.None);
tilemap.SetColor(cell, color);
```
