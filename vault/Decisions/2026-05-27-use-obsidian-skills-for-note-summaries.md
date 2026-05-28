---
date: 2026-05-27
tags: [decision, codex, obsidian, skills, summaries]
project: codex-external-memory
related: [[Projects/codex-external-memory]], [[Knowledge/obsidian-skills-note-summarization]]
---

# ノート要約にobsidian-skillsを使う

## 決定

ノートの要約や整理には、`kepano/obsidian-skills` をObsidian向けのスキル層として使う。

## 理由

`obsidian-markdown` は、wikilink、properties、embeds、calloutsなど、Obsidian Flavored Markdownの作法を扱える。`obsidian-bases` は、複数ノートを横断する構造化ビューや要約ビューを作るときに使える。

## 実装

- 上流スキルを `skills/` に取り込んだ。
- `obsidian-memory` を更新し、要約・整理タスクでは `obsidian-markdown` と `obsidian-bases` を使うようにした。
- 他PCのセットアップでもrepo管理スキル一式がCodexへ入るようにした。
