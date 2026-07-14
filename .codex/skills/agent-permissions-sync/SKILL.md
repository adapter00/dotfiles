---
name: agent-permissions-sync
description: Use when configuring, reducing, auditing, or sharing Codex and Claude command approvals, allowlists, permission prompts, or agent sandbox permission rules across machines.
---

# Agent Permissions Sync

Use the shared dotfiles permission source before editing Codex or Claude approval settings by hand.

## Workflow

1. Read `~/.config/agent-permissions/common-allowlist.json`.
2. For command allowlist changes, update that file first.
3. Run a dry run:

   ```bash
   python3 ~/.config/agent-permissions/sync-agent-permissions.py
   ```

4. If the result is expected, apply:

   ```bash
   python3 ~/.config/agent-permissions/sync-agent-permissions.py --apply
   ```

## Rules

- Preserve environment-local additions. The sync script is merge-only for Claude and only replaces its marked Codex managed block.
- Keep existing deny rules unless the user explicitly asks to change them.
- Prefer broad command families over shell-wrapper all-access. Avoid `Bash(*)`, `bash -lc` blanket allows, and `zsh -lc` blanket allows unless the user explicitly accepts that risk.
- After changing the script, run:

  ```bash
  python3 -m unittest discover -s ~/.config/agent-permissions/tests -p 'test_*.py'
  ```
