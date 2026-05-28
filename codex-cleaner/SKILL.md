---
name: codex-cleaner
description: Safely inspect and clean Codex, developer, and system temporary files when the user says Codex feels slow, asks to slim down the agent, clean caches, remove temp files, recover disk space, or tidy a Codex workspace without breaking normal use.
metadata:
  short-description: Safely clean Codex and dev caches
---

# Codex Cleaner

Use this skill when the user wants a conservative cleanup for Codex or a developer workstation. The goal is to recover space and reduce obvious clutter while preserving configuration, sessions, plugins, skills, runtimes, project files, and anything that may be needed for normal operation.

## Safety Rules

- Start with inspection unless the user explicitly asks for immediate cleanup.
- Prefer the bundled script: `scripts/clean_codex.ps1`.
- Never delete source code, `.git`, lockfiles, environment files, credentials, installed plugins, installed skills, Codex sessions, Codex state databases, or runtime caches by default.
- Treat `~/.cache/codex-runtimes`, `~/.codex/plugins`, `~/.codex/skills`, `~/.codex/sessions`, and `~/.codex/state_*.sqlite` as keep-by-default.
- Clean only files that are normally regenerated: old system temp files, pip/npm/yarn/pnpm download caches, browser-driver caches, and stale Codex temp files.
- If a path is outside the current user's profile, ask before cleaning it.
- If a file is locked or in use, skip it and report that it was skipped.

## Workflow

1. Inspect:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/clean_codex.ps1 -DryRun
```

2. Explain the planned cleanup in plain language. Mention what will be preserved.

3. Clean conservatively:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/clean_codex.ps1 -Apply
```

4. Re-run inspection and summarize reclaimed space:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/clean_codex.ps1 -DryRun
```

## Optional Flags

- `-OlderThanDays 2`: default age threshold for temp files.
- `-IncludePackageCaches`: include package-manager download caches. Enabled by default when `-Apply` is used through the standard workflow.
- `-IncludeRuntimeCaches`: include large runtime caches. Do not use unless the user explicitly accepts slower future startup or re-downloads.

## Response Style

Keep the summary short and user-facing:

- space reclaimed
- what was cleaned
- what was intentionally preserved
- whether anything was skipped because it was in use

If the user says Codex still feels slow after cleanup, explain that long conversation context can be a bigger cause than disk cache and suggest starting a fresh thread for the next task.
