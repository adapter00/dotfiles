#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DOTFILES_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)

link_if_missing() {
  src=$1
  dst=$2
  parent=$(dirname -- "$dst")
  mkdir -p "$parent"

  if [ -L "$dst" ]; then
    current=$(readlink "$dst")
    if [ "$current" = "$src" ]; then
      printf 'ok: %s already points to %s\n' "$dst" "$src"
      return
    fi
    printf 'skip: %s is a symlink to %s\n' "$dst" "$current"
    return
  fi

  if [ -e "$dst" ]; then
    printf 'skip: %s already exists; leaving environment-local files untouched\n' "$dst"
    return
  fi

  ln -s "$src" "$dst"
  printf 'linked: %s -> %s\n' "$dst" "$src"
}

link_if_missing "$SCRIPT_DIR" "$HOME/.config/agent-permissions"
link_if_missing "$DOTFILES_DIR/.codex/skills/agent-permissions-sync" "$HOME/.codex/skills/agent-permissions-sync"
link_if_missing "$DOTFILES_DIR/.claude/skills/agent-permissions-sync" "$HOME/.claude/skills/agent-permissions-sync"

printf '\nDry run:\n'
python3 "$SCRIPT_DIR/sync-agent-permissions.py"
