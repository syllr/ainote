# AI 功能概述

Zed 是一个开源 AI 代码编辑器。AI 功能在编辑体验中运行：读取和写入代码的代理、内联转换、每次按键的代码补全，以及在任意缓冲区与模型的对话。

## Zed 如何处理 AI

Zed 的 AI 功能在用 Rust 构建的原生、GPU 加速应用程序中运行。你和模型输出之间没有 Electron 层。

- **开源**。编辑器和所有 AI 功能都是 [开源的](https://github.com/zed-industries/zed)。你可以阅读 AI 是如何实现的、数据如何流向提供商、工具调用如何执行。
- **多模型**。使用 Zed 的托管模型或从 Anthropic、OpenAI、Google、Ollama 等 8+ 个提供商 [自带 API 密钥](./llm-providers.html)。运行本地模型、连接到云端 API 或两者混合。每个任务切换模型。
- **外部代理**。直接在 Zed 中通过 [Agent 客户端协议](https://zed.dev/acp) 运行 Claude Agent、Gemini CLI、Codex 和其他基于 CLI 的代理。详见 [外部代理](./external-agents.html)。
- **隐私优先**。默认情况下 AI 数据共享是可选的。当你使用自己的 API 密钥时，Zed 与提供商保持零数据保留协议。详见 [隐私和安全](./privacy-and-security.html)。

## 代理式编辑

[Agent 面板](./agent-panel.html) 是你与 AI 代理交互的地方。代理可以读取文件、编辑代码、运行终端命令、搜索网络，并通过 [内置工具](./tools.html) 访问诊断信息。

你可以通过 [MCP 服务器](./mcp.html) 扩展代理的额外工具，通过 [工具权限](./tool-permissions.html) 控制它们可以访问的内容，并通过 [规则](./rules.html) 影响它们的行为。

[内联助手](./inline-assistant.html) 的工作方式不同：选择代码或终端命令，描述你想要的，模型在原处重写选择。它支持多光标。

## 代码补全

[编辑预测](./edit-prediction.html) 提供每次按键的 AI 代码补全。每次按键都会向预测提供商发送请求，该提供商返回你可以用 `tab` 接受的单行或多行建议。

默认提供商是 Zeta，Zed 的在开放数据上训练的开源模型。你也可以使用 GitHub Copilot 或 Codestral。

## 入门

- [配置](./configuration.html): 连接到 Anthropic、OpenAI、Ollama、Google AI 或其他 LLM 提供商。
- [外部代理](./external-agents.html): 在 Zed 中直接运行 Claude Agent、Codex、Aider 或其他外部代理。
- [订阅](./subscription.html): Zed 的托管模型和计费。
- [隐私和安全](./privacy-and-security.html): Zed 在使用 AI 功能时如何处理数据。

新到 Zed？从 [入门指南](../getting-started.html) 开始，然后回来设置 AI。对于更高层次的概述，请参阅 [zed.dev/ai](https://zed.dev/ai)。

## AI 功能对比

| 功能 | 描述 | 快捷键 |
|------|------|--------|
| **Agent 面板** | 与 AI 代理对话，执行复杂任务 | `Cmd+Shift+A` |
| **内联助手** | 选择代码进行智能转换 | `Cmd+Enter` |
| **编辑预测** | 自动建议代码编辑 | 每次按键 |
| **代码补全** | 基于上下文的智能补全 | 每次按键 |
