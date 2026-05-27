---
name: obsidian-memory
description: Use this skill when the user asks Codex to remember, recall, store, retrieve, summarize, update, or use durable external memory in Obsidian. It connects Codex behavior to the Obsidian Local REST API/MCP vault used as the user's long-term memory.
metadata:
  short-description: Use Obsidian as Codex long-term memory
---

# Obsidian Memory

Use the `obsidian` MCP server when the user asks to remember something, recall prior context, update durable notes, or consult external memory.

## Memory Policy

- Treat Obsidian as durable, user-owned memory. Do not store secrets, credentials, tokens, private keys, or sensitive personal data unless the user explicitly asks and the location is appropriate.
- Before writing a new durable memory, prefer a concise confirmation if the item is ambiguous, sensitive, or likely temporary.
- Preserve user intent and context. Store what matters, why it matters, and when it was learned.
- Prefer updating existing notes over creating duplicates.
- Keep memory entries short and searchable.

## Default Locations

- Durable Codex memory: `10_Codex/Memory.md`
- Quick capture: `00_Inbox/`
- Project notes: `20_Projects/`
- Archived material: `90_Archive/`

## Workflows

### Recall

1. Search the vault for relevant terms before answering from memory.
2. Read the most relevant notes.
3. Distinguish sourced vault facts from inference.

### Remember

1. Decide whether the information is durable enough to keep.
2. Append or patch the relevant section in `10_Codex/Memory.md` unless a project-specific note is a better fit.
3. Use dated bullets when adding facts or preferences.

### Maintenance

- When notes become stale, update in place and leave a brief date/context marker.
- If a memory conflicts with newer user instruction, prefer the latest explicit user instruction and update the note.
