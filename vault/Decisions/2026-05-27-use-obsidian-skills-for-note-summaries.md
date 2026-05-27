---
date: 2026-05-27
tags: [decision, codex, obsidian, skills, summaries]
project: codex-external-memory
related: [[Projects/codex-external-memory]], [[Knowledge/obsidian-skills-note-summarization]]
---

# Use obsidian-skills for Note Summaries

## Decision

Use `kepano/obsidian-skills` as the Obsidian-specific skill layer for note summarization and organization.

## Rationale

`obsidian-markdown` provides conventions for Obsidian Flavored Markdown, including wikilinks, properties, embeds, and callouts. `obsidian-bases` supports structured index and summary views across groups of notes.

## Implementation

- Vendored the upstream skills under `skills/`.
- Updated `obsidian-memory` to route summarization and organization tasks through `obsidian-markdown` and `obsidian-bases`.
- Updated setup so all repo-managed skills are installed into Codex on each PC.
