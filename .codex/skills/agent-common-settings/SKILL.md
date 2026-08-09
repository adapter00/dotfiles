---
name: agent-common-settings
description: Use when agent 共通設定、Codex や Claude の command approval、allowlist、permission prompt、sandbox rule を設定・監査・共有するとき。
---

# Agent 共通設定

Codex や Claude の承認設定を直接編集する前に、dotfiles の共通設定を使う。

## 手順

1. `~/.config/agent-common/permissions/common-allowlist.json` を読む。
2. コマンド allowlist を変えるときは、まずそのファイルを更新する。
3. dry-run を実行する。

   ```bash
   python3 ~/.config/agent-common/permissions/sync-agent-permissions.py
   ```

4. 結果が意図どおりなら適用する。

   ```bash
   python3 ~/.config/agent-common/permissions/sync-agent-permissions.py --apply
   ```

## ルール

- 各環境で追加された設定は消さない。Claude は merge-only、Codex は marker で囲まれた管理ブロックだけを置き換える。
- 既存の deny ルールは、ユーザーが明示しない限り変更しない。
- shell wrapper の全許可より、コマンド単位の広めの許可を優先する。ユーザーが危険性を明示的に受け入れない限り、`Bash(*)`、`bash -lc` 全許可、`zsh -lc` 全許可は避ける。
- スクリプトを変更したら、次を実行する。

  ```bash
  python3 -B -m unittest discover -s ~/.config/agent-common/permissions/tests -p 'test_*.py'
  ```
