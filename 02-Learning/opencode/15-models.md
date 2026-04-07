# OpenCode 模型配置

OpenCode 模型配置和选择指南。

## 概述

OpenCode 支持多种 LLM 模型，您可以根据任务需求选择合适的模型。

## 模型类型

### 通用模型

适用于大多数编码任务的平衡模型。

- **GPT-4 Turbo** - 强大的通用模型，良好的编码能力
- **Claude 3 Sonnet** - 平衡的性能和速度
- **Gemini Pro** - 谷歌的通用模型

### 快速模型

适合简单任务和快速迭代的模型。

- **GPT-3.5 Turbo** - 快速且经济实惠
- **Claude 3 Haiku** - 极快的响应速度
- **Llama 2 (70B)** - 开源快速模型

### 高级模型

适合复杂任务和深度思考的模型。

- **GPT-4** - 最强大的模型之一
- **Claude 3 Opus** - 高级推理能力
- **Gemini Ultra** - 谷歌最强大的模型

## 模型选择

### 按任务选择

| 任务类型 | 推荐模型 | 原因 |
|---------|---------|------|
| 代码生成 | GPT-4 Turbo, Claude 3 Sonnet | 良好的代码理解和生成 |
| 快速原型 | GPT-3.5 Turbo, Claude 3 Haiku | 速度快，成本低 |
| 复杂推理 | GPT-4, Claude 3 Opus | 深度思考和问题解决 |
| 代码审查 | GPT-4 Turbo, Claude 3 Sonnet | 细致的代码分析 |
| 文档生成 | 任何通用模型 | 内容生成能力 |
| 重构 | GPT-4, Claude 3 Opus | 理解代码上下文和关系 |

### 按提供商选择

#### OpenCode Zen

推荐！经过测试和验证的精选模型。

```json
{
  "$schema": "https://opencode.ai/config.json",
  "models": {
    "default": "opencode:gpt-4-turbo",
    "fast": "opencode:gpt-3.5-turbo",
    "thinking": "opencode:claude-3-opus"
  }
}
```

#### OpenAI

```json
{
  "$schema": "https://opencode.ai/config.json",
  "models": {
    "default": "openai:gpt-4-turbo",
    "fast": "openai:gpt-3.5-turbo",
    "thinking": "openai:gpt-4"
  }
}
```

#### Anthropic

```json
{
  "$schema": "https://opencode.ai/config.json",
  "models": {
    "default": "anthropic:claude-3-sonnet",
    "fast": "anthropic:claude-3-haiku",
    "thinking": "anthropic:claude-3-opus"
  }
}
```

## 配置模型

### 默认模型

设置默认使用的模型：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "models": {
    "default": "openai:gpt-4-turbo"
  }
}
```

### 专用模型

为不同类型的任务配置专用模型：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "models": {
    "default": "openai:gpt-4-turbo",
    "fast": "openai:gpt-3.5-turbo",
    "thinking": "anthropic:claude-3-opus",
    "creative": "openai:gpt-4"
  }
}
```

### 代理特定模型

每个代理可以使用不同的模型：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agents": {
    "default": {
      "name": "默认代理",
      "model": "openai:gpt-4-turbo"
    },
    "fast": {
      "name": "快速代理",
      "model": "openai:gpt-3.5-turbo"
    },
    "careful": {
      "name": "谨慎代理",
      "model": "anthropic:claude-3-opus"
    }
  }
}
```

## 模型参数

您可以为模型配置参数：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "modelConfig": {
    "openai:gpt-4-turbo": {
      "temperature": 0.7,
      "maxTokens": 4096,
      "topP": 0.9
    },
    "anthropic:claude-3-sonnet": {
      "temperature": 0.7,
      "maxTokens": 4096
    }
  }
}
```

### 常用参数

| 参数 | 说明 | 推荐值 |
|-----|------|-------|
| temperature | 控制随机性，越高越随机 | 0.7 (编码), 0.3 (精确) |
| maxTokens | 最大生成 token 数 | 2048-4096 |
| topP | 核采样参数 | 0.9 |
| topK | Top-k 采样参数 | 50 |
| stopSequences | 停止序列 | 根据需要 |

## 切换模型

在 TUI 中，您可以随时切换模型：

```
/models
```

这会显示可用模型列表，您可以选择要使用的模型。

## 本地模型

OpenCode 支持使用本地模型：

### Ollama

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
    "default": "ollama:llama2",
    "fast": "ollama:mistral"
  }
}
```

### Llama.cpp

```json
{
  "$schema": "https://opencode.ai/config.json",
  "providers": {
    "llamacpp": {
      "baseURL": "http://localhost:8080/v1",
      "apiKey": "not-needed"
    }
  },
  "models": {
    "default": "llamacpp:your-model-name"
  }
}
```

## 成本考虑

不同模型的成本差异很大：

### 成本层级

| 层级 | 模型 | 相对成本 |
|-----|------|---------|
| 经济 | GPT-3.5 Turbo, Claude 3 Haiku | 1x |
| 标准 | GPT-4 Turbo, Claude 3 Sonnet | 10x |
| 高级 | GPT-4, Claude 3 Opus | 30x |

### 成本优化策略

1. **任务分层** - 简单任务用快速模型，复杂任务用高级模型
2. **使用 fast 模型** - 为快速任务配置专门的 fast 模型
3. **代理优化** - 不同代理使用不同成本的模型
4. **监控使用** - 关注 API 使用量和成本

## 模型比较

### GPT-4 vs Claude 3

| 特性 | GPT-4 | Claude 3 Opus |
|-----|-------|---------------|
| 编码能力 | 优秀 | 优秀 |
| 长上下文 | 8K/32K | 200K |
| 速度 | 快 | 中等 |
| 成本 | 高 | 高 |
| 代码理解 | 优秀 | 优秀 |

### GPT-3.5 Turbo vs Claude 3 Haiku

| 特性 | GPT-3.5 Turbo | Claude 3 Haiku |
|-----|---------------|-----------------|
| 编码能力 | 良好 | 良好 |
| 速度 | 快 | 极快 |
| 成本 | 低 | 很低 |
| 简单任务 | 优秀 | 优秀 |

## 最佳实践

1. **从推荐开始** - 初次使用推荐 OpenCode Zen
2. **测试比较** - 尝试不同模型，找到最适合你的
3. **成本意识** - 根据任务选择合适的成本层级
4. **代理配置** - 不同代理使用不同模型
5. **定期评估** - 随着模型更新重新评估选择

## 更多信息

有关模型配置的更多信息，请访问：
- OpenCode 官方文档：https://opencode.ai/docs/zh-cn/models/
