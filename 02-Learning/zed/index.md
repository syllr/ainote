# Zed 编辑器学习笔记

本文档整理自 Zed 官方文档 (https://zed.dev/docs/)，作为个人知识库的参考。

## 目录

- [入门指南](getting-started.md)
- [安装指南](installation.md)
- [AI 功能概述](ai-overview.md)
- [Agent 面板](ai-agent-panel.md)
- [内联助手](ai-inline-assistant.md)
- [编辑代码](editing-code.md)
- [外观定制](customization-appearance.md)
- [键位绑定](customization-key-bindings.md)
- [从 VS Code 迁移](migrate-vscode.md)
- [所有设置参考](all-settings.md)

## Zed 简介

Zed 是一个开源代码编辑器，内置协作和 AI 工具。它使用 Rust 构建，具有原生性能和 GPU 加速的 AI 功能。

### 核心特性

- **开源**: 编辑器和所有 AI 功能都是开源的
- **多模型支持**: 支持多种 LLM 提供商（Anthropic、OpenAI、Google、Ollama 等）
- **内置协作**: 无需扩展即可进行实时协作
- **AI 集成**: 内置 AI 编码助手、代码补全和智能编辑
- **隐私优先**: AI 数据共享可选，使用自己的 API 密钥时零数据保留

## 快速开始

### 常用快捷键

| 操作 | macOS | Linux/Windows |
|------|-------|---------------|
| 打开项目 | `Cmd+O` | `Ctrl+O` |
| 命令面板 | `Cmd+Shift+P` | `Ctrl+Shift+P` |
| 打开文件 | `Cmd+P` | `Ctrl+P` |
| 打开符号 | `Cmd+Shift+O` | `Ctrl+Shift+O` |
| 查找项目 | `Cmd+Shift+F` | `Ctrl+Shift+F` |
| 切换终端 | `Ctrl+`` | `Ctrl+`` |
| 打开设置 | `Cmd+,` | `Ctrl+,` |
| Agent 面板 | `Cmd+Shift+A` | `Ctrl+Shift+A` |
| 内联助手 | `Cmd+Enter` | `Ctrl+Enter` |

### 配置编辑器

打开设置编辑器：`Cmd+,` (macOS) 或 `Ctrl+,` (Linux/Windows)

常用设置：
- **主题**: `Cmd+K Cmd+T` 打开主题选择器
- **字体**: 搜索 `buffer_font_family`
- **保存时格式化**: 搜索 `format_on_save` 并设置为 `on`

## 配置文件位置

### macOS

- **主配置**: `~/.config/zed/settings.json`
- **键位映射**: `~/.config/zed/keymap.json`
- **代码片段**: `~/.config/zed/snippets/`

### Linux

- **主配置**: `~/.config/zed/settings.json`
- **键位映射**: `~/.config/zed/keymap.json`
- **代码片段**: `~/.config/zed/snippets/`

### Windows

- **主配置**: `%APPDATA%\Zed\settings.json`
- **键位映射**: `%APPDATA%\Zed\keymap.json`
- **代码片段**: `%APPDATA%\Zed\snippets\`

## 技术栈

- **语言**: Rust
- **AI**: 原生 GPU 加速，无 Electron 层
- **协议**: LSP（语言服务器协议）、MCP（模型上下文协议）、ACP（Agent 客户端协议）
- **协作**: LiveKit SDK

## 资源链接

- [官方文档](https://zed.dev/docs/)
- [GitHub 仓库](https://github.com/zed-industries/zed)
- [Discord 社区](https://discord.com/invite/zedindustries)
- [Reddit 社区](https://www.reddit.com/r/ZedEditor)
