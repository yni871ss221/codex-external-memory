---
date: 2026-05-28
tags: [codex, mistakes, behavior]
project: codex-external-memory
related: [[Preferences/language]]
---

# AIのミス記録

ユーザーから明示的に訂正され、再発し得る行動だけを記録する。

2026-05-28: Obsidianノートを英語で記録していた
**NG Action**: ユーザーが日本語で運用している外部記憶ノートを、既定で英語の本文・見出しで作成した。
**Correct Action**: Obsidianの外部記憶ノートは、ユーザーが別言語を指定しない限り日本語で作成・更新する。
**Trigger**: `Knowledge/`、`Decisions/`、`Projects/`、`Preferences/` に永続ノートを書き込むとき。

2026-05-31: プロジェクト固有名にCodexを含めた
**NG Action**: 継続的に利用するブランチ名やプロジェクト固有の識別子に、実装ツールである `Codex` を含めた。
**Correct Action**: AreaSurvivorsのプロジェクト名、クラス名、ブランチ名には `Codex` を含めず、実装内容を表す中立的な名前を使う。
**Trigger**: AreaSurvivorsでクラス、プロジェクト、ブランチ、永続的な識別子を新規作成・改名するとき。

2026-05-31: 参考画像をそのまま流用した
**NG Action**: ユーザーが参考として示したアニメーション素材を、生成画像へ置き換えずにコピーして使用した。
**Correct Action**: 参考素材は構図や動きの理解に使い、ゲームへ組み込む画像自体は新規生成したものを使用する。
**Trigger**: AreaSurvivorsでユーザーが参考画像や参考アニメーションを示し、ゲーム用Spriteの作成を依頼したとき。
