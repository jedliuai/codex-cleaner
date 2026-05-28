# Codex Cleaner

[English](README.md) | [中文](README.zh-CN.md)

Codex Cleaner 是一个安全优先的轻量级清理 skill，专门给感觉 Codex 工作区越来越重、越来越乱、越来越慢的用户使用。

它会找到明显的垃圾文件，清理低风险缓存，同时把真正重要的东西留下。

## 为什么需要它

AI 编程工具会带来效率，也会留下日志、临时文件、包管理器缓存、浏览器驱动缓存，以及各种一次性的工作区杂物。

Codex Cleaner 给你的 agent 一条简单规则：

> 能重建的就清理。让 Codex 正常工作的东西必须保留。

这意味着你不用手动翻文件夹，也不用担心删错关键内容，可以更快回到真正的工作里。

## 它会清理什么

- 旧的系统临时文件
- 过期的 Codex 临时文件
- pip、npm、yarn、pnpm 下载缓存
- Selenium / 浏览器驱动缓存
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

先预览：

```powershell
powershell -ExecutionPolicy Bypass -File codex-cleaner/scripts/clean_codex.ps1 -DryRun
```

安全清理：

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

## 一句话卖点

大多数清理脚本太激进，大多数缓存建议又太模糊。Codex Cleaner 是为真实 AI agent 工作流设计的：保留记忆，保留工具，保留技能，只扫掉可以再生成的杂物。

它不是系统优化器。它是给每天使用 Codex 构建东西的人准备的实用维护 skill。

## License

MIT
