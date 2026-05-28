<div align="center">

# Codex Cleaner

**一个安全优先的 Codex 工作区清理 Skill。**

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Skill](https://img.shields.io/badge/Codex-Skill-blue.svg)](codex-cleaner/SKILL.md)
[![Platform](https://img.shields.io/badge/Platform-Windows%20PowerShell-lightgrey.svg)](codex-cleaner/scripts/clean_codex.ps1)
[![Safety](https://img.shields.io/badge/Default-Safe%20Mode-brightgreen.svg)](#它会保护什么)

[English](README.md) | [中文](README.zh-CN.md)

能重建的就清理。让 Codex 正常工作的东西必须保留。

</div>

---

## 项目简介

Codex Cleaner 是一个轻量、实用、偏保守的维护型 skill，专门给感觉 Codex 工作区越来越重、越来越乱、越来越慢的用户使用。

它会找到明显的垃圾文件，清理低风险缓存，同时保留真正重要的内容：sessions、plugins、skills、项目代码、状态数据库和运行所需资源。

## 为什么需要它

AI 编程工具会带来效率，也会留下日志、临时文件、包管理器缓存、浏览器驱动缓存，以及各种一次性的工作区杂物。

Codex Cleaner 给你的 agent 一个清晰、可重复的清理流程，让维护不再靠猜，也不需要冒险手动删除文件。

## 一眼看懂

| 范围 | 默认行为 |
| --- | --- |
| 旧的系统临时文件 | 清理 |
| 过期的 Codex 临时文件 | 清理 |
| pip/npm/yarn/pnpm 下载缓存 | 清理 |
| 浏览器驱动缓存 | 清理 |
| Codex sessions | 保留 |
| Codex plugins 和 skills | 保留 |
| Codex state databases | 保留 |
| 项目源码和 `.git` 文件夹 | 保留 |
| Codex runtime caches | 默认保留，除非明确指定 |

## 它会清理什么

- 旧的系统临时文件
- 过期的 Codex 临时文件
- pip、npm、yarn、pnpm 下载缓存
- Selenium 和浏览器驱动缓存
- 零散遗留的 Codex 临时状态文件

## 它会保护什么

默认情况下，Codex Cleaner **不会** 删除：

- Codex sessions
- Codex plugins
- Codex skills
- Codex state databases
- 项目源码
- `.git` 文件夹
- 凭证或环境变量文件
- Codex runtime caches

运行时缓存可能很大，但删除后可能导致之后启动变慢或重新下载依赖。Codex Cleaner 默认保留它们，除非你明确选择清理。

## 安装

把 `codex-cleaner` 文件夹复制到你的 Codex skills 目录：

```text
~/.codex/skills/codex-cleaner
```

然后对 Codex 说：

```text
Use Codex Cleaner to safely clean my Codex cache and temp files.
```

## 使用

先预览将要清理的内容：

```powershell
powershell -ExecutionPolicy Bypass -File codex-cleaner/scripts/clean_codex.ps1 -DryRun
```

执行安全清理：

```powershell
powershell -ExecutionPolicy Bypass -File codex-cleaner/scripts/clean_codex.ps1 -Apply
```

只清理更久以前的临时文件：

```powershell
powershell -ExecutionPolicy Bypass -File codex-cleaner/scripts/clean_codex.ps1 -Apply -OlderThanDays 7
```

只有在你能接受之后启动变慢或重新下载时，才清理运行时缓存：

```powershell
powershell -ExecutionPolicy Bypass -File codex-cleaner/scripts/clean_codex.ps1 -Apply -IncludeRuntimeCaches
```

## Skill 特点

| 特点 | 价值 |
| --- | --- |
| 默认先预览 | 真正删除前，先看到将要清理什么。 |
| 保守默认策略 | 保留 Codex 工作文件和项目文件。 |
| 清晰安全边界 | 运行时缓存默认不碰，除非你明确选择。 |
| 适合 agent 调用 | 可以直接用自然语言让 Codex 执行。 |
| 聚焦实用清理 | 只处理临时文件和可再生成缓存。 |

Codex Cleaner 不是系统优化器。它是给每天使用 Codex 构建东西的人准备的实用维护 skill。

## 仓库结构

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

## License

MIT
