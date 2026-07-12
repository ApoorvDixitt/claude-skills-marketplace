#!/usr/bin/env python3
"""Package a skill folder into a plugin inside this marketplace repo.

Usage: package_skill.py <path-to-skill-dir> <repo-root>

Rules:
- If the skill has ONLY SKILL.md -> print nothing to stdout (skip; use Customize > Skills).
- If it has more than SKILL.md   -> scaffold plugins/<name>-plugin/{.claude-plugin/plugin.json,
  skills/<name>/...}, copy the skill files, update .claude-plugin/marketplace.json, and print
  the plugin name to stdout (the shell wrapper uses that to git commit + push).
Progress/info goes to stderr so stdout stays a clean plugin-name value.
"""
import json
import re
import shutil
import sys
from pathlib import Path


def main() -> int:
    if len(sys.argv) != 3:
        sys.stderr.write("usage: package_skill.py <skill-dir> <repo-root>\n")
        return 2

    src = Path(sys.argv[1]).expanduser().resolve()
    repo = Path(sys.argv[2]).expanduser().resolve()
    skill_md = src / "SKILL.md"

    if not skill_md.exists():
        sys.stderr.write(f"ERROR: no SKILL.md found in {src}\n")
        return 1

    # Files beyond SKILL.md (ignore macOS junk).
    extra = [
        p for p in src.rglob("*")
        if p.is_file()
        and p.name not in ("SKILL.md", ".DS_Store")
        and "__MACOSX" not in p.parts
    ]
    if not extra:
        sys.stderr.write(
            f"'{src.name}' is SKILL.md-only -> no plugin needed. "
            "Add it directly via Customize > Skills.\n"
        )
        return 0  # stdout stays empty -> wrapper skips git push

    # Parse YAML frontmatter for name/description.
    text = skill_md.read_text(encoding="utf-8", errors="replace")
    fm = {}
    m = re.match(r"^---\s*\n(.*?)\n---", text, re.S)
    if m:
        for line in m.group(1).splitlines():
            if ":" in line:
                k, v = line.split(":", 1)
                fm[k.strip()] = v.strip()

    name = (fm.get("name") or src.name).strip().replace(" ", "-")
    desc = fm.get("description") or f"Skill: {name}"
    plugin = f"{name}-plugin"

    dest = repo / "plugins" / plugin
    if dest.exists():
        shutil.rmtree(dest)
    (dest / ".claude-plugin").mkdir(parents=True)

    def _ignore(_dir, names):
        return [n for n in names if n in (".DS_Store", "__MACOSX")]

    shutil.copytree(src, dest / "skills" / name, ignore=_ignore)

    (dest / ".claude-plugin" / "plugin.json").write_text(
        json.dumps({"name": plugin, "description": desc, "version": "1.0.0"}, indent=2) + "\n"
    )

    mp = repo / ".claude-plugin" / "marketplace.json"
    cat = json.loads(mp.read_text())
    cat.setdefault("plugins", [])
    cat["plugins"] = [p for p in cat["plugins"] if p.get("name") != plugin]
    cat["plugins"].append(
        {"name": plugin, "source": f"./plugins/{plugin}", "description": desc}
    )
    mp.write_text(json.dumps(cat, indent=2) + "\n")

    sys.stderr.write(
        f"Packaged '{name}' -> plugin '{plugin}' ({len(extra)} extra files). "
        f"Marketplace now lists {len(cat['plugins'])} plugin(s).\n"
    )
    print(plugin)  # stdout: plugin name for the shell wrapper
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
