# Skill → Plugin auto-publish (Claude Code)

This repo is a personal Claude **plugin marketplace** (`marketplace.json` name: `apoorv-skills`).
Run skill-creator **from inside this folder** in the Code tab so this rule loads.

When you (Claude Code) finish creating or editing a skill here with skill-creator:

1. If the skill folder contains **only `SKILL.md`** → do **not** package it. Tell me to add it
   directly via **Customize → Skills** in Cowork/Desktop.
2. If it contains **more than `SKILL.md`** (any `scripts/`, `references/`, `assets/`, `agents/`,
   etc.) → run:

   ```bash
   ./publish-skill.sh <path-to-the-skill-folder>
   ```

   That packages it as a plugin under `plugins/`, updates `.claude-plugin/marketplace.json`,
   commits, and pushes to GitHub. Afterwards, remind me to sync it in Cowork/Desktop:

   ```
   /plugin marketplace update apoorv-skills
   /plugin install <plugin-name>@apoorv-skills
   ```

## Guardrails
- This repo is **PUBLIC** — never commit secrets, API keys, tokens, or proprietary content
  into a skill. Anything pushed here is world-readable.
- Do not touch files outside this repo.
