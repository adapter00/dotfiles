import importlib.util
import json
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).resolve().parents[1] / "sync-agent-permissions.py"


def load_module():
    spec = importlib.util.spec_from_file_location("sync_agent_permissions", SCRIPT)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class SyncAgentPermissionsTests(unittest.TestCase):
    def test_claude_merge_preserves_existing_allow_and_deny(self):
        module = load_module()
        settings = {
            "permissions": {
                "allow": ["Bash(custom *)"],
                "deny": ["Bash(rm *)", "Read(**/.env)"],
            },
            "editorMode": "vim",
        }
        updated, changed = module.merge_claude_settings(
            settings,
            ["Bash(git *)", "Bash(custom *)"],
        )

        self.assertTrue(changed)
        self.assertEqual(updated["permissions"]["deny"], ["Bash(rm *)", "Read(**/.env)"])
        self.assertEqual(updated["permissions"]["allow"], ["Bash(custom *)", "Bash(git *)"])
        self.assertEqual(updated["editorMode"], "vim")

    def test_codex_replaces_only_managed_block(self):
        module = load_module()
        original = "\n".join(
            [
                'prefix_rule(pattern=["hand", "made"], decision="allow")',
                module.CODEX_BEGIN,
                'prefix_rule(pattern=["old"], decision="allow")',
                module.CODEX_END,
                'prefix_rule(pattern=["keep"], decision="allow")',
                "",
            ]
        )
        updated, changed = module.merge_codex_rules(
            original,
            [["git"], ["gh"]],
        )

        self.assertTrue(changed)
        self.assertIn('prefix_rule(pattern=["hand", "made"], decision="allow")', updated)
        self.assertIn('prefix_rule(pattern=["keep"], decision="allow")', updated)
        self.assertNotIn('prefix_rule(pattern=["old"], decision="allow")', updated)
        self.assertIn('prefix_rule(pattern=["git"], decision="allow")', updated)
        self.assertIn('prefix_rule(pattern=["gh"], decision="allow")', updated)

    def test_codex_merge_is_idempotent(self):
        module = load_module()
        original = "\n".join(
            [
                'prefix_rule(pattern=["hand", "made"], decision="allow")',
                "",
                module.CODEX_BEGIN,
                'prefix_rule(pattern=["git"], decision="allow")',
                module.CODEX_END,
                "",
            ]
        )
        updated, changed = module.merge_codex_rules(original, [["git"]])

        self.assertFalse(changed)
        self.assertEqual(updated, original)

    def test_apply_false_does_not_write_files(self):
        module = load_module()
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            allowlist = root / "common.json"
            codex = root / "default.rules"
            claude = root / "settings.json"
            allowlist.write_text(
                json.dumps(
                    {
                        "codex_prefix_rules": [["git"]],
                        "claude_allow": ["Bash(git *)"],
                    }
                ),
                encoding="utf-8",
            )
            codex.write_text("", encoding="utf-8")
            claude.write_text('{"permissions":{"allow":[],"deny":["Bash(rm *)"]}}', encoding="utf-8")

            result = module.sync(
                allowlist_path=allowlist,
                codex_rules_path=codex,
                claude_settings_path=claude,
                apply=False,
            )

            self.assertTrue(result["codex"]["changed"])
            self.assertTrue(result["claude"]["changed"])
            self.assertEqual(codex.read_text(encoding="utf-8"), "")
            self.assertEqual(
                json.loads(claude.read_text(encoding="utf-8")),
                {"permissions": {"allow": [], "deny": ["Bash(rm *)"]}},
            )


if __name__ == "__main__":
    unittest.main()
