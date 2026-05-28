---
name: obsidian-memory
description: Use this skill at the start of sessions and whenever the user asks Codex to remember, recall, store, retrieve, update, or use durable external memory in Obsidian. It defines the user's Codex x Obsidian external brain rules, including mandatory startup reads, transparent reads/writes, note locations, frontmatter, naming, and mistakes.md behavior.
metadata:
  short-description: Use Obsidian as Codex external brain
---

# Obsidian Memory

Treat the Obsidian vault as the user's external brain. Use the `obsidian` MCP server when available; if the MCP tool is unavailable but the configured vault is local, use the repo files directly and say so.

Always be transparent: whenever you read or write Obsidian memory, tell the user exactly what was read or written. Report in the user's language when possible, e.g. `Obsidian: Knowledge/foo.md read` or `Obsidian: Knowledge/foo.md written`.

## Language

- Write Obsidian memory notes in Japanese by default.
- Use another language only when the user explicitly asks for it or when preserving an exact source title, API name, command, library name, or quote.
- File names, tags, and project identifiers may stay in ASCII/kebab-case for searchability and cross-platform compatibility.
- If an existing durable note is in English, update it in Japanese when editing it.

## Startup Recall

At the first user message of a new conversation:

1. Read `Knowledge/mistakes.md`.
2. Read relevant notes under `Preferences/`, especially `Preferences/profile.md` and `Preferences/language.md` if present.
3. Search the vault with keywords from the user's request.
4. Read relevant matching notes.
5. Answer using the retrieved memory, distinguishing vault facts from inference when useful.

You may skip this only for clearly unrelated one-off questions such as the current time or simple arithmetic.

## Vault Structure

Use these root folders:

- `Knowledge/`: technical findings, solved bugs, API/library/tool discoveries, environment setup lessons, and anything that would have helped next time.
- `Decisions/`: decisions between options, design choices, policies, and why that option won.
- `Projects/`: current project state, versions, summaries, and changes in project status.
- `Preferences/`: user preferences, profile, and working style.

If the user asks for initial setup, create the folder structure above plus `Knowledge/mistakes.md` and `.gitkeep` files as needed. Then explain which folders were created, what each folder stores, and suggest writing a short self-introduction in `Preferences/profile.md`.

## Write Immediately

Do not defer durable memory writes. Write during the conversation when any of these happen:

- `Knowledge/`: a bug or problem is solved; a cause and solution pair is learned; a library/API/tool discovery is made; environment setup friction is resolved; something would have helped in the next similar task.
- `Decisions/`: a choice is made among alternatives, including the rationale.
- `Projects/`: a project's status, version, or summary changes.
- `Preferences/`: a new user preference or work style is discovered.

Do not store secrets, credentials, private keys, tokens, or sensitive personal data unless the user explicitly asks and the location is appropriate.

## Summarize and Organize Notes

When the user asks to summarize, consolidate, organize, or turn scattered notes into a cleaner note:

1. Use the `obsidian-markdown` skill's conventions for Obsidian Flavored Markdown: frontmatter, wikilinks, embeds, callouts, and properties.
2. Use `obsidian-bases` when the output should be an index, table, card/list view, filtered collection, or summary view across many notes.
3. Read the source notes first, then write the summary immediately. Do not create a summary from memory alone if the source note exists.
4. Put the summary in the most relevant existing root folder:
   - technical or reusable synthesis: `Knowledge/topic-summary.md`
   - project rollup: `Projects/project-name.md`
   - decision summary: `Decisions/YYYY-MM-DD-topic.md`
   - user preference synthesis: `Preferences/category.md`
5. Include `summary_of` or `related` links in frontmatter when useful, and link source notes with `[[wikilinks]]` in the body.
6. Prefer replacing/updating an existing summary note over creating duplicates.

Summary notes should be concise and scannable:

```markdown
---
date: YYYY-MM-DD
tags: [summary, relevant]
project: project-name
summary_of: [[Source Note]]
related: [[Other Note]]
---

# Title

## Summary

- Key point

## Details

- Supporting detail with [[wikilinks]]

## Open Questions

- Follow-up if any
```

## Note Format

Every durable note must include YAML frontmatter:

```markdown
---
date: YYYY-MM-DD
tags: [relevant, tags]
project: project-name
related: [[Other Note]]
---

# Title

Body text. Link related notes with [[wiki links]].
```

Use today's date in the user's locale. Keep notes simple and readable.
Write the body and headings in Japanese unless the user requests otherwise.

## File Naming

- `Knowledge/`: `topic-subtopic.md`, e.g. `nextjs-auth-cookie.md`
- `Decisions/`: `YYYY-MM-DD-topic.md`, e.g. `2026-05-16-database-choice.md`
- `Preferences/`: `category.md`, e.g. `coding-style.md`
- `Projects/`: `project-name.md`

Match existing naming patterns when present.

## mistakes.md Rules

Append to `Knowledge/mistakes.md` only when all three conditions are true:

1. The user explicitly corrected you; it was not merely your own realization.
2. The pattern can recur; it is not a one-off accident.
3. The correction can be written as a concrete do/don't rule.

Use this format:

```markdown
YYYY-MM-DD: [short mistake summary]
**NG Action**: What was actually done wrong
**Correct Action**: What to do next time
**Trigger**: When this rule applies
```

## Reporting

Never silently read or write memory. Report Obsidian operations in plain language:

- `Obsidian: Knowledge/xxx.md read`
- `Obsidian: Knowledge/xxx.md written`

## Style

- Prefer simple, readable notes.
- Avoid unnecessary decoration and verbose explanations.
- Follow existing patterns and naming.
- Complete deployment and verification yourself when feasible.
