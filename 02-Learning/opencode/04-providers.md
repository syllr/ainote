# OpenCode 提供商配置

在 OpenCode 中使用任意 LLM 提供商。

## 概述

OpenCode 支持多种 LLM 提供商，您可以根据自己的需求选择合适的提供商。

## 推荐：OpenCode Zen

如果您刚开始接触 LLM 提供商，我们推荐使用 **OpenCode Zen**。这是一组经过 OpenCode 团队测试和验证的精选模型。

### 连接 OpenCode Zen

1. 在 TUI 中运行 `/connect` 命令
2. 选择 `opencode`
3. 前往 [opencode.ai/auth](https://opencode.ai/auth)
4. 登录并添加账单信息
5. 复制您的 API 密钥
6. 粘贴 API 密钥到 OpenCode 中

```bash
/connect
```

## 支持的提供商

OpenCode 支持多种 LLM 提供商，包括但不限于：

### OpenAI
- 模型：GPT-4、GPT-4 Turbo、GPT-3.5 Turbo 等
- 配置：需要 OpenAI API 密钥

### Anthropic
- 模型：Claude 3 Opus、Claude 3 Sonnet、Claude 3 Haiku 等
- 配置：需要 Anthropic API 密钥

### OpenAI 兼容
- 任何兼容 OpenAI API 的提供商
- 包括：LiteLLM、Ollama、vLLM 等

### 其他提供商
- Google (Gemini)
- Mistral
- Together.ai
- 等等...

## 配置提供商

### 使用环境变量

您可以通过环境变量配置提供商：

```bash
# OpenAI
export OPENAI_API_KEY="your-api-key"

# Anthropic
export ANTHROPIC_API_KEY="your-api-key"

# OpenCode
export OPENCODE_API_KEY="your-api-key"
```

### 使用配置文件

您也可以在 `opencode.json` 配置文件中配置提供商：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "providers": {
    "openai": {
      "apiKey": "your-api-key"
    },
    "anthropic": {
      "apiKey": "your-api-key"
    }
  }
}
```

## 模型配置

您可以配置默认使用的模型：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "models": {
    "default": "openai:gpt-4-turbo",
    "fast": "openai:gpt-3.5-turbo",
    "thinking": "anthropic:claude-3-opus"
  }
}
```

## 目录结构

OpenCode 会在以下位置查找提供商配置：

1. **环境变量** - 最高优先级
2. **项目级配置** - `./opencode.json`
3. **全局配置** - `~/.config/opencode/opencode.json`

## 切换提供商

在 TUI 中，您可以随时切换提供商：

1. 运行 `/connect` 命令
2. 选择想要使用的提供商
3. 按照提示配置 API 密钥

## 本地模型

OpenCode 支持使用本地模型，如 Ollama：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "providers": {
    "ollama": {
      "baseURL": "http://localhost:11434/v1",
      "apiKey": "ollama"
    }
  },
  "models": {
    "default": "ollama:llama2"
  }
}
```

## 多个提供商

您可以同时配置多个提供商，并根据需要切换：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "providers": {
    "openai": {
      "apiKey": "your-openai-key"
    },
    "anthropic": {
      "apiKey": "your-anthropic-key"
    },
    "opencode": {
      "apiKey": "your-opencode-key"
    }
  }
}
```

## 安全注意事项

- 不要将包含 API 密钥的配置文件提交到版本控制
- 使用环境变量或全局配置来存储敏感信息
- 考虑使用密钥管理工具来管理 API 密钥

## 更多信息

有关支持的提供商和配置选项的完整列表，请访问：
- OpenCode 官方文档：https://opencode.ai/docs/zh-cn/providers/
