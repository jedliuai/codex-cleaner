<div align="center">

# Codex Cleaner

**A safety-first cleanup skill for Codex workspaces.**

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Skill](https://img.shields.io/badge/Codex-Skill-blue.svg)](codex-cleaner/SKILL.md)
[![Platform](https://img.shields.io/badge/Platform-Windows%20PowerShell-lightgrey.svg)](codex-cleaner/scripts/clean_codex.ps1)
[![Safety](https://img.shields.io/badge/Default-Safe%20Mode-brightgreen.svg)](#what-it-protects)

[English](README.md) | [中文](README.zh-CN.md)

Clean what can be rebuilt. Keep what makes Codex work.

</div>

---

## Overview

Codex Cleaner is a small, practical maintenance skill for Codex users who feel their agent workspace is getting heavy, messy, or slow.

It finds obvious junk, clears low-risk caches, and preserves the files that matter: sessions, plugins, skills, project code, state databases, and runtime assets.

## Why It Exists

AI coding tools move fast. Over time, they also leave behind logs, temporary files, package-manager caches, browser-driver caches, and one-off workspace clutter.

Codex Cleaner gives your agent a simple, repeatable cleanup workflow without turning maintenance into a risky guessing game.

## At A Glance

| Area | Default Behavior |
| --- | --- |
| Old system temp files | Clean |
| Stale Codex temp files | Clean |
| pip/npm/yarn/pnpm download caches | Clean |
| Browser-driver caches | Clean |
| Codex sessions | Preserve |
| Codex plugins and skills | Preserve |
| Codex state databases | Preserve |
| Project source code and `.git` folders | Preserve |
| Codex runtime caches | Preserve unless explicitly requested |

## What It Cleans

- Old system temp files
- Stale Codex temp files
- pip, npm, yarn, and pnpm download caches
- Selenium and browser-driver caches
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

Preview before cleaning:

```powershell
powershell -ExecutionPolicy Bypass -File codex-cleaner/scripts/clean_codex.ps1 -DryRun
```

Run the safe cleanup:

```powershell
powershell -ExecutionPolicy Bypass -File codex-cleaner/scripts/clean_codex.ps1 -Apply
```

Clean only older temporary files:

```powershell
powershell -ExecutionPolicy Bypass -File codex-cleaner/scripts/clean_codex.ps1 -Apply -OlderThanDays 7
```

Clean runtime caches only when you accept slower future startup or re-downloads:

```powershell
powershell -ExecutionPolicy Bypass -File codex-cleaner/scripts/clean_codex.ps1 -Apply -IncludeRuntimeCaches
```

## Skill Features

| Feature | Why It Matters |
| --- | --- |
| Dry-run first | See what would be cleaned before anything changes. |
| Conservative defaults | Keeps Codex working files and project files safe. |
| Clear safety boundary | Runtime caches are preserved unless you opt in. |
| Agent-friendly workflow | Designed to be called naturally from Codex. |
| Practical cleanup scope | Focuses on temporary files and reusable caches. |

Codex Cleaner is not a system optimizer. It is a focused maintenance skill for people building with Codex every day.

## Repository Structure

```text
codex-cleaner/
├── codex-cleaner/
│   ├── SKILL.md
│   ├── agents/
│   │   └── openai.yaml
│   └── scripts/
│       └── clean_codex.ps1
├── README.md
├── README.zh-CN.md
└── LICENSE
```

## Contact

- Homepage: [jedliuai.com](https://jedliuai.com)
- Email: [ryjedliu@gmail.com](mailto:ryjedliu@gmail.com)

## License

MIT
