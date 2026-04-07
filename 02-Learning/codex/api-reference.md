---
layout: page
title: Codex API 参考
permalink: /codex/api-reference/
---

# Codex API 参考

> 注意：OpenAI Codex API 已逐渐被新的模型替代，建议使用 GPT-4 或 GPT-3.5-turbo 进行代码相关任务。

## 原始 API 端点

```
POST https://api.openai.com/v1/engines/davinci-codex/completions
POST https://api.openai.com/v1/engines/cushman-codex/completions
```

## 主要参数

| 参数 | 类型 | 描述 |
|------|------|------|
| `prompt` | string | 输入提示文本/代码 |
| `max_tokens` | integer | 生成的最大 token 数 |
| `temperature` | number | 采样温度，0-2 之间 |
| `top_p` | number | 核采样参数 |
| `stop` | string/array | 停止序列 |
| `presence_penalty` | number | 存在惩罚 |
| `frequency_penalty` | number | 频率惩罚 |

## 请求示例

```bash
curl https://api.openai.com/v1/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
    "model": "code-davinci-002",
    "prompt": "def fibonacci(n):",
    "max_tokens": 100,
    "temperature": 0
  }'
```

## 替代方案

当前推荐使用的模型：
- `gpt-4` - 最强大的代码生成和理解能力
- `gpt-3.5-turbo` - 性价比高的选择
- `gpt-4-turbo-preview` - 最新模型，性能更强
