---
date: 2026-06-10
tags: [preferences, area-survivors, workflow, credit-saving, testing]
project: area-survivors
related: [[Preferences/testing-workflow]], [[Knowledge/area-survivors-unity-workflow]]
---

# AreaSurvivors の効率・クレジット節約ルール

## 標準作業

- 関連する小規模修正はまとめて実装し、修正ごとにUnityコンパイルやPlayMode検証を行わない。
- 通常は「コード確認 + コンパイル1回 + 関連GameplayTest 1件」を標準検証とする。
- 中間報告は重要な判断、問題発生、長時間化した場合だけ簡潔に行う。

## 検証レベル

- 簡易: コード確認とコンパイルのみ。
- 標準: コンパイル + 関連GameplayTest 1件。通常はこちらを使う。
- 完全: 複数GameplayTest + `05_Game` 統合確認 + 必要なスクリーンショット確認。
- 完全検証は大規模変更、再発バグ、見た目確認が必要な変更、ユーザー指定時だけ行う。

## 避ける処理

- Scene全体やHUD全体の再生成は原則行わず、必要なオブジェクトだけ変更する。
- Gameplay Test Sceneは毎回再構築せず、既存SceneとScenarioを再利用する。
- 成功時のスクリーンショットは原則撮影しない。
- 通常ゲームでランダムな事象発生を待つ検証は避ける。

## 調査

- 原因調査が約10分以上長引く、または複数の大規模な修正案がある場合は、推測実装を進めず状況と選択肢を報告する。
- 仕様判断が必要な新機能は実装前に認識を合わせる。

## Obsidian

- 軽微な修正は記録しない。
- 再発し得る原因と解決策、長期的な設計判断、作業ルール、作業終了時の重要な進捗だけ記録する。
## 2026-06-11 GameplayTest軽量化

- `90_GameplayTest.unity` は `05_Game.unity` のコピーにしない。空に近いBootstrap Sceneとして維持する。
- GameplayTest実行時はBootstrapが `05_Game` をAdditiveロードし、`GameplayTestRunner` を実行時に注入する。
- Scenario選択はScene保存ではなく `EditorPrefs` に保持し、選択操作でGit差分を出さない。
- 通常検証は `Area Survivors/Test Scenarios/Run Samples/...` の1コマンド実行を使う。
- `05_Game.unity` の巨大差分本文は読まず、必要なときだけ対象ファイル・`git diff --stat`・固定Scenarioの結果を確認する。

## 常時ルール

- どの対応でも、実装前後に「作業量・検証時間・Scene差分・クレジット使用が肥大化しないか」を確認する。
- 大きなSceneやPrefabを直接増やす変更では、実行時生成・Bootstrap・Scenario化・Editorツール化で差分を小さくできないか先に検討する。
- 検証は原則、通常プレイで事象発生を待たず、GameplayTest Scenarioや専用Editorメニューで再現する。
- UniCLIやUnity検証が長時間止まって見える場合は、同じ呼び出しを繰り返す前にコマンド、権限、待ち状態、ログ出力先を確認する。

## 2026-06-11 Ground Tilemap軽量化

- `05_Game.unity` の `Ground Tilemap` はSceneに全セルを保存せず、`TileGrid.Build()` の実行時生成を正とする。
- Scene上の保存済み地面タイルを整理したい場合は `Area Survivors/Map/Clear Saved Ground Tiles In 05_Game` を使う。
- 見た目確認用にEditor上で地面を再構築したい場合は `Area Survivors/Map/Rebuild Ground Preview In Active Scene` を使う。

## 2026-06-13 UI配置の基本方針

- AreaSurvivorsでHUD、ロビー、メニュー、ステージ表示、撃破数表示などユーザーがEditor上で位置調整したいUIを追加・変更する場合は、特別な理由がない限りScene上にUIオブジェクトとして配置する。
- ランタイム側は既存Sceneオブジェクトを検索して値更新・ボタン接続・表示切替だけを行う。Sceneオブジェクトが存在しない場合のみフォールバック生成を許容する。
- 既にScene上に存在するUIのRectTransformは、実行時コードで固定座標・固定サイズへ上書きしない。初期座標の設定は新規生成時またはEditor用正規化ツール内に限定する。
- クレジット/作業量削減のため、HUD全体再生成ではなく必要なパネルや子要素だけを追加・更新する。

## 2026-06-15 締め作業の定型化

- ユーザーが「締め作業」「作業終了」「今日の作業終了」「Obsidianへ記録」「コミット＆プッシュ」を依頼した場合は、`area-survivors-closeout` skill を使う。
- 締め作業では、AreaSurvivors本体だけでなく `C:\Develop\unity_workspace\codex-external-memory` も必ず対象にする。
- Obsidianへ、作業履歴、現在状態、再発防止のミス、設計判断、スキル/ルール更新を記録する。
- その後、AreaSurvivors repo と外部メモリ repo の両方で `git status`、必要な差分確認、commit、pushを行う。
- 外部メモリrepoのcommit/pushを省略しない。省略せざるを得ない場合は理由を明示する。

## 2026-06-18 トークン節約ルール追加

- UniCLI `Eval` に複雑な引用符つきC#を直接渡さず、Scene操作やValidator実行は一時Editor Runnerを作成して短いEvalで呼ぶ。
- 作業後、一時Runnerと `.meta` は必ず削除する。
- `git status` / `git diff` は対象パス、`--stat`、`--name-only`、行数制限を優先し、巨大Scene差分や広い履歴を不用意に読まない。
- スキルツリーやHUDの見た目調整は、スクリーンショット反復よりValidatorとScene上の座標・親子関係確認を優先する。
- 長いスレッドでトークン消費が大きい場合は、新規チャットへ移る提案を行い、`AGENTS.md` とObsidian要点だけを読み込んで続行する。

## 2026-06-20 トークン対策の運用フェーズ

- 通常の調査・検証では `guarded-command`、`safe-*`、`safe-unity`、Reporter、`token-health` を優先する。
- 作業開始は `start-token-check.ps1`、作業終了は `end-token-check.ps1` を使う。
- 日常用の消費比較は `token-health.ps1` と `TokenReports/token-daily-baseline.json` を使う。
- Heavyベンチ `token-benchmark-heavy.ps1` は巨大出力退行を明示確認したい場合だけ実行する。
- TokenReportsは `token-report-summary.ps1 -Kind ... -Since ...` で必要範囲を絞り、古いJSONLは `archive-token-reports.ps1` で削除せずアーカイブする。

## 2026-06-21 低トークン入口固定化

- 作業開始時にObsidianを常読しない。恒久ルールは AGENTS.md、詳細は必要時だけ Docs/AgentRules/*.md を読む。
- Asset整理や未参照候補調査は全文読込ではなく Reporter と filter ツールを先に使う。
- プロジェクト容量の大きさそのものより、巨大Scene、Prefab、長いコード、広域検索の直接読込を避ける方がクレジット節約に効く。