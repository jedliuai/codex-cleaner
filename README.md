# Codex Cleaner

Codex Cleaner is a tiny safety-first cleanup skill for Codex users who feel their agent workspace is getting heavy, messy, or slow.

It finds the obvious junk, clears the low-risk caches, and leaves the important stuff alone.

## Why People Want This

AI coding tools generate momentum. They also generate logs, temp files, package caches, driver caches, and one-off workspace clutter.

Codex Cleaner gives your agent a simple rule:

> Clean what can be rebuilt. Keep what makes Codex work.

That means less manual digging through folders, less fear of deleting the wrong thing, and a faster path back to work.

## What It Cleans

- Old system temp files
- Stale Codex temp files
- pip, npm, yarn, and pnpm download caches
- Selenium/browser-driver caches
- Tiny leftover Codex state temp files

## What It Protects

By default, Codex Cleaner does **not** delete:

- Codex sessions
- Codex plugins
- Codex skills
- Codex state databases
- project source code
- `.git` folders
- credentials or environment files
- Codex runtime caches

Runtime caches can be large, but deleting them may make future runs slower. Codex Cleaner keeps them unless you explicitly opt in.

## Install

Copy the `codex-cleaner` folder into your Codex skills directory:

```text
~/.codex/skills/codex-cleaner
```

Then ask Codex:

```text
Use Codex Cleaner to safely clean my Codex cache and temp files.
```

## Usage

Preview first:

```powershell
powershell -ExecutionPolicy Bypass -File codex-cleaner/scripts/clean_codex.ps1 -DryRun
```

Clean safely:

```powershell
powershell -ExecutionPolicy Bypass -File codex-cleaner/scripts/clean_codex.ps1 -Apply
```

Clean older temp files only after a longer delay:

```powershell
powershell -ExecutionPolicy Bypass -File codex-cleaner/scripts/clean_codex.ps1 -Apply -OlderThanDays 7
```

Only if you accept slower future startup or re-downloads:

```powershell
powershell -ExecutionPolicy Bypass -File codex-cleaner/scripts/clean_codex.ps1 -Apply -IncludeRuntimeCaches
```

## The Pitch

Most cleanup scripts are reckless. Most cache advice is vague. Codex Cleaner is built for the actual AI-agent workflow: keep the memory, keep the tools, keep the skills, and sweep the disposable mess.

It is not a system optimizer. It is a practical maintenance skill for people building with Codex every day.

## License

MIT
