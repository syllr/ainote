# 内联助手

## 使用概述

使用 `ctrl-enter`/`ctrl-enter` 在编辑器、规则库、频道笔记和终端面板中打开内联助手。内联助手将你当前的选择（或行）发送给语言模型并替换为响应。

## 入门

如果首次使用内联助手，需要配置至少一个 LLM 提供商或外部代理。你可以通过以下方式配置：

1. [订阅我们的 Pro 计划](https://zed.dev/pricing)，这样你就可以使用我们的托管模型
2. [使用你自己的 API 密钥](./llm-providers.html#use-your-own-keys)，来自 Anthropic 等模型提供商或 OpenRouter 等模型网关

如果你已经设置了与 [Agent 面板](./agent-panel.html#getting-started) 交互的 LLM 提供商，那么这也适用于内联助手。

> 与 Agent 面板不同，目前 [外部代理](./external-agents.html) 不支持用于生成更改。

## 添加上下文

你可以像在 [Agent 面板](./agent-panel.html#adding-context) 中一样在内联助手中添加上下文：

- @-提及文件、目录、过去的线程、规则和符号
- 粘贴从剪贴板复制的图像

你还可以在 Agent 面板中创建一个线程，然后在内联助手中使用 `@thread` 引用它。这允许你在不重新解释上下文的情况下，从更大的线程中细化特定的更改。

## 并行生成

内联助手可以同时生成多个更改：

### 多光标

使用多光标时，按 `ctrl-enter`/`ctrl-enter` 将相同的提示发送到每个光标位置，同时在所有位置生成更改。

这在使用 [多缓冲区](../multibuffers.html) 中的摘录时效果很好。

### 多模型

你可以使用内联助手将相同的提示发送到多个模型。

以下是如何在设置文件中自定义配置（[如何编辑](../configuring-zed.html#settings-files)）以添加此功能：

```json
{
  "agent": {
    "default_model": {
      "provider": "zed.dev",
      "model": "claude-sonnet-4-5"
    },
    "inline_alternatives": [
      {
        "provider": "zed.dev",
        "model": "gpt-4-mini"
      }
    ]
  }
}
```

当配置多个模型时，你会看到内联助手 UI 中的按钮，允许你循环浏览由每个模型生成的输出。

在此处指定的模型总是用于 [默认模型](#default-model)。

例如，以下配置将为每次助手生成三个输出。一个使用 Claude Sonnet 4.5（默认模型），另一个使用 GPT-5-mini，另一个使用 Gemini 3 Flash。

```json
{
  "agent": {
    "default_model": {
      "provider": "zed.dev",
      "model": "claude-sonnet-4-5"
    },
    "inline_alternatives": [
      {
        "provider": "zed.dev",
        "model": "gpt-4-mini"
      },
      {
        "provider": "zed.dev",
        "model": "gemini-3-flash"
      }
    ]
  }
}
```

## 内联助手与编辑预测

这两个功能都生成内联代码，但它们的工作方式不同：

- **内联助手**: 你编写提示并选择要转换的内容。你控制上下文。
- [编辑预测](./edit-prediction.html): Zed 根据你最近的更改、访问过的文件和光标位置自动建议编辑。无需提示。

关键区别：内联助手是明确的、基于提示的；编辑预测是自动的、基于上下文推断的。

## 预填充提示

要创建自定义键位绑定来预填充提示，你可以在你的键映射中添加以下格式：

```json
[
  {
    "context": "Editor && mode == full",
    "bindings": {
      "ctrl-shift-enter": [
        "assistant::InlineAssist",
        { "prompt": "Build a snake game" }
      ]
    }
  }
]
```
