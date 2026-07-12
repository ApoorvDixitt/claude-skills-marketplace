# apoorv-skills — personal Claude plugin marketplace

A GitHub-hosted **plugin marketplace** for skills created with skill-creator. Skills that
have more than a `SKILL.md` (scripts, references, assets, agents) are packaged as plugins
here and installed into Claude Cowork/Desktop by syncing this repo as a marketplace.

## Workflow

1. **Create a skill** with skill-creator in the **Claude Code / Code tab**, working inside this
   folder (`cd ~/claude-skills-marketplace`) so `CLAUDE.md` auto-applies.
2. **Publish it** (Claude Code does this automatically per `CLAUDE.md`, or run it yourself):
   ```bash
   ./publish-skill.sh <path-to-skill-folder>
   ```
   - Only `SKILL.md` → skipped (add via **Customize → Skills** instead).
   - More than `SKILL.md` → packaged as `plugins/<name>-plugin/` and pushed.
3. **Use it in Cowork/Desktop:**
   - One-time: Add marketplace → *Add from a repository* → `ApoorvDixitt/claude-skills-marketplace`
   - Sync + install:
     ```
     /plugin marketplace update apoorv-skills
     /plugin install <plugin-name>@apoorv-skills
     ```

## Layout
```
.claude-plugin/marketplace.json     catalog of all plugins
plugins/<name>-plugin/
  .claude-plugin/plugin.json        plugin manifest
  skills/<name>/                    the skill (SKILL.md + scripts/references/…)
publish-skill.sh                    package + push helper
tools/package_skill.py              packaging logic
```

⚠️ **Public repo — never commit secrets.**
