#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path


CODEX_BEGIN = "# BEGIN managed by agent-permissions-sync"
CODEX_END = "# END managed by agent-permissions-sync"


def default_allowlist_path():
    return Path.home() / ".config" / "agent-permissions" / "common-allowlist.json"


def default_codex_rules_path():
    return Path.home() / ".codex" / "rules" / "default.rules"


def default_claude_settings_path():
    return Path.home() / ".claude" / "settings.json"


def load_allowlist(path):
    data = json.loads(path.read_text(encoding="utf-8"))
    codex = data.get("codex_prefix_rules", [])
    claude = data.get("claude_allow", [])
    if not isinstance(codex, list) or not all(isinstance(rule, list) for rule in codex):
        raise ValueError("codex_prefix_rules must be a list of argument lists")
    if not isinstance(claude, list) or not all(isinstance(rule, str) for rule in claude):
        raise ValueError("claude_allow must be a list of strings")
    return data


def dedupe_keep_order(values):
    seen = set()
    result = []
    for value in values:
        key = json.dumps(value, sort_keys=True) if not isinstance(value, str) else value
        if key in seen:
            continue
        seen.add(key)
        result.append(value)
    return result


def format_codex_rule(pattern):
    encoded = json.dumps(pattern, ensure_ascii=False)
    return f"prefix_rule(pattern={encoded}, decision=\"allow\")"


def build_codex_block(prefix_rules):
    lines = [CODEX_BEGIN]
    for pattern in dedupe_keep_order(prefix_rules):
        lines.append(format_codex_rule(pattern))
    lines.append(CODEX_END)
    return "\n".join(lines)


def merge_codex_rules(existing_text, prefix_rules):
    block = build_codex_block(prefix_rules)
    if CODEX_BEGIN in existing_text and CODEX_END in existing_text:
        before, rest = existing_text.split(CODEX_BEGIN, 1)
        _, after = rest.split(CODEX_END, 1)
        updated = before + block + after
    else:
        updated = existing_text.rstrip()
        if updated:
            updated += "\n\n"
        updated += block + "\n"
    if updated and not updated.endswith("\n"):
        updated += "\n"
    return updated, updated != existing_text


def merge_claude_settings(settings, allow_rules):
    updated = dict(settings)
    permissions = dict(updated.get("permissions", {}))
    existing_allow = permissions.get("allow", [])
    if not isinstance(existing_allow, list):
        existing_allow = []
    permissions["allow"] = dedupe_keep_order(existing_allow + allow_rules)
    updated["permissions"] = permissions
    return updated, updated != settings


def read_json_file(path):
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8"))


def write_text(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def write_json(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def sync(allowlist_path, codex_rules_path, claude_settings_path, apply):
    allowlist = load_allowlist(allowlist_path)
    codex_existing = codex_rules_path.read_text(encoding="utf-8") if codex_rules_path.exists() else ""
    codex_updated, codex_changed = merge_codex_rules(
        codex_existing,
        allowlist.get("codex_prefix_rules", []),
    )

    claude_existing = read_json_file(claude_settings_path)
    claude_updated, claude_changed = merge_claude_settings(
        claude_existing,
        allowlist.get("claude_allow", []),
    )

    if apply:
        if codex_changed:
            write_text(codex_rules_path, codex_updated)
        if claude_changed:
            write_json(claude_settings_path, claude_updated)

    return {
        "codex": {
            "path": str(codex_rules_path),
            "changed": codex_changed,
            "managed_rules": len(allowlist.get("codex_prefix_rules", [])),
        },
        "claude": {
            "path": str(claude_settings_path),
            "changed": claude_changed,
            "managed_rules": len(allowlist.get("claude_allow", [])),
        },
        "applied": apply,
    }


def parse_args(argv):
    parser = argparse.ArgumentParser(
        description="Merge shared agent command permissions into Codex and Claude settings."
    )
    parser.add_argument("--allowlist", type=Path, default=default_allowlist_path())
    parser.add_argument("--codex-rules", type=Path, default=default_codex_rules_path())
    parser.add_argument("--claude-settings", type=Path, default=default_claude_settings_path())
    parser.add_argument("--apply", action="store_true", help="write changes; default is dry-run")
    return parser.parse_args(argv)


def main(argv):
    args = parse_args(argv)
    result = sync(
        allowlist_path=args.allowlist.expanduser(),
        codex_rules_path=args.codex_rules.expanduser(),
        claude_settings_path=args.claude_settings.expanduser(),
        apply=args.apply,
    )
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
