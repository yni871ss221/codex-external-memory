---
name: area-survivors-closeout
description: Close out AreaSurvivors work sessions. Use when the user asks for 締め作業, 作業終了, 今日の作業終了, Obsidian記録, 履歴/ルール/ミス/スキルの記録, or commit and push both the AreaSurvivors repository and the external memory repository after a work session.
---

# AreaSurvivors Closeout

Use this skill to finish an AreaSurvivors work session consistently.

## Workflow

1. Read current status.
   - In `C:\Develop\unity_workspace\AreaSurvivors`, run `git status --short --branch`.
   - In `C:\Develop\unity_workspace\codex-external-memory`, run `git status --short --branch`.
   - Inspect only focused diffs and stats; avoid loading huge Unity scene diffs unless needed.

2. Update Obsidian memory in `C:\Develop\unity_workspace\codex-external-memory\vault`.
   - Read existing relevant notes before writing:
     - `Projects/area-survivors-current.md`
     - `Projects/area-survivors-history.md`
     - relevant `Knowledge/area-survivors-*.md`
     - `Knowledge/mistakes.md` when the user corrected a repeatable mistake
     - `Preferences/efficient-development-workflow.md` when workflow rules changed
   - Write in Japanese with YAML frontmatter for new notes.
   - Append concise session history to `Projects/area-survivors-history.md`.
   - Update `Projects/area-survivors-current.md` with current implemented state and validation status.
   - Add or update `Knowledge/` notes for reusable technical lessons.
   - Append to `Knowledge/mistakes.md` only when the correction is repeatable and concrete.
   - Report every Obsidian file read or written.

3. Update skills when requested or when the user says the closeout workflow itself should become a rule.
   - Keep skills concise.
   - Validate changed skills with `quick_validate.py`.
   - Do not add auxiliary README or changelog files.

4. Verify repository state before commit.
   - Prefer `git diff --stat` and targeted `git diff --check`.
   - If Unity is open and batchmode compile cannot run, state that verification was not run because the project is locked.
   - Do not revert unrelated user changes.

5. Commit and push both repositories.
   - Commit AreaSurvivors first with a concise message summarizing game changes.
   - Commit `codex-external-memory` second with a concise memory/update message.
   - Push both current branches to their configured remotes.
   - Report commit hashes and push results.

## Important Rules

- Always include the external memory repository in closeout if the user asks for Obsidian/memory/history/rules recording.
- Never commit secrets.
- Do not stage unrelated generated junk, temp files, Unity lock files, or local Obsidian plugin runtime data unless already intentionally tracked.
- Do not silently skip `codex-external-memory`; if it cannot be committed or pushed, explain the blocker.
