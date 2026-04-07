# Zed 编辑器学习笔记

本文档库整理自 Zed 官方文档 (https://zed.dev/docs/)，作为个人知识库的参考。

## 目录结构

```
zed/
├── index.md                    # 总览
├── getting-started.md          # 入门指南
├── installation.md             # 安装指南
├── ai-overview.md              # AI 功能概述
├── ai-agent-panel.md           # Agent 面板详细说明
├── ai-inline-assistant.md      # 内联助手说明
├── editing-code.md             # 编辑代码功能
├── customization-appearance.md # 外观定制
├── customization-key-bindings.md # 键位绑定
├── migrate-vscode.md           # 从 VS Code 迁移
└── all-settings.md             # 所有设置参考
```

## 快速导航

### 新手入门

1. [入门指南](getting-started.md) - 了解基本操作和快捷键
2. [安装指南](installation.md) - 在你的系统上安装 Zed
3. [从 VS Code 迁移](migrate-vscode.md) - 从其他编辑器平滑过渡

### AI 功能

1. [AI 功能概述](ai-overview.md) - 了解 Zed 的 AI 能力
2. [Agent 面板](ai-agent-panel.md) - 与 AI 代理对话、执行复杂任务
3. [内联助手](ai-inline-assistant.md) - 选择代码进行智能转换

### 编辑功能

1. [编辑代码](editing-code.md) - 代码编辑、补全、格式化

### 自定义配置

1. [外观定制](customization-appearance.md) - 主题、字体、布局
2. [键位绑定](customization-key-bindings.md) - 自定义快捷键
3. [所有设置参考](all-settings.md) - 完整的设置文档

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

## 常用快捷键

| 操作 | macOS | Linux/Windows |
|------|-------|---------------|
| 打开项目 | `Cmd+O` | `Ctrl+O` |
| 命令面板 | `Cmd+Shift+P` | `Ctrl+Shift+P` |
| 打开文件 | `Cmd+P` | `Ctrl+P` |
| 打开符号 | `Cmd+Shift+O` | `Ctrl+Shift+O` |
| 查找项目 | `Cmd+Shift+F` | `Ctrl+Shift+F` |
| 切换终端 | `Ctrl+\`` | `Ctrl+\`` |
| 打开设置 | `Cmd+,` | `Ctrl+,` |
| Agent 面板 | `Cmd+Shift+A` | `Ctrl+Shift+A` |
| 内联助手 | `Cmd+Enter` | `Ctrl+Enter` |

## 核心特性

- **开源**: 编辑器和所有 AI 功能都是开源的
- **多模型支持**: 支持多种 LLM 提供商（Anthropic、OpenAI、Google、Ollama 等）
- **内置协作**: 无需扩展即可进行实时协作
- **AI 集成**: 内置 AI 编码助手、代码补全和智能编辑
- **隐私优先**: AI 数据共享可选，使用自己的 API 密钥时零数据保留

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

## 更新日志

- 2026-04-07 - 初始创建，整理 Zed 官方文档
