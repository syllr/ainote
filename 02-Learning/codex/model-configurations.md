---
layout: page
title: Codex 模型配置
permalink: /codex/model-configurations/
---

# Codex 模型配置

本文档记录了 opencode 配置中的各种模型配置信息。

## 配置文件位置

```
~/.config/opencode/opencode.json
```

## 提供商配置

### Volcengine (火山引擎)

**基础配置**:
- `npm`: `@ai-sdk/openai-compatible`
- `baseURL`: `https://ark.cn-beijing.volces.com/api/coding/v3`

**可用模型**:

| 模型名称 | 模型ID | 上下文限制 | 输入/输出 | 推理能力 | 附件支持 |
|---------|--------|-----------|----------|---------|---------|
| ark-code-latest | doubao-seed-2-0-code-preview-260215 | 262k | 262k / 131k | ✓ | ✓ |
| doubao-seed-2-0-code | doubao-seed-2-0-code-preview-260215 | 262k | 262k / 131k | ✓ | ✓ |
| doubao-seed-2-0-pro | doubao-seed-2-0-pro-260215 | 262k | 262k / 131k | ✓ | ✓ |
| kimi-k2.5 | kimi-k2-thinking-251104 | 262k | 229k / 32k | ✓ | ✗ |
| glm-4.7 | glm-4-7-251222 | 200k | 200k / 131k | ✓ | ✗ |

**模态支持**:
- 豆包系列: 文本、图像、视频输入，文本输出
- Kimi/GLM: 仅文本输入输出

### Ailot

**基础配置**:
- `npm`: `@ai-sdk/openai-compatible`
- `baseURL`: `http://openai.ailot.vip/v1`

**可用模型**:

#### GLM 系列
| 模型名称 | 上下文限制 | 输入/输出 | 推理能力 |
|---------|-----------|----------|---------|
| glm-4-flash | 131k | 131k / 32k | ✗ |
| glm-4.5-air | 131k | 131k / 32k | ✓ |
| glm-4.7 | 200k | 200k / 32k | ✓ |
| glm-4.7-flash | 131k | 131k / 32k | ✗ |
| glm-5 | 200k | 200k / 32k | ✓ |
| Pro-GLM-4.7 | 200k | 200k / 32k | ✓ |
| Pro-GLM-5 | 200k | 200k / 32k | ✓ |

#### 其他模型
| 模型名称 | 上下文限制 | 输入/输出 | 推理能力 | 附件支持 |
|---------|-----------|----------|---------|---------|
| DeepSeek-V3.2 | 160k | 160k / 32k | ✓ | ✗ |
| MiniMax-M2.5 | 192k | 192k / 32k | ✓ | ✗ |
| Kimi-K2.5 | 262k | 262k / 32k | ✓ | ✓ (图像) |
| Qwen3.5-397B-A17B | 262k | 262k / 32k | ✓ | ✓ (图像) |
| qwen3-coder-next | 262k | 262k / 32k | ✓ | ✗ |
| qwen3-coder-plus | 262k | 262k / 32k | ✓ | ✗ |
| qwen3-max | 262k | 262k / 32k | ✓ | ✓ (图像) |
| qwen3.5-plus | 262k | 262k / 32k | ✓ | ✓ (图像) |

## 插件配置

已启用的插件:
- `@opencode/plugin-git`
- `@opencode/plugin-test`
- `@opencode/plugin-docs`
- `opencode-plugin-sql`

## 思考模式配置

大部分模型都启用了思考模式 (`thinking.type: enabled`)，支持深度推理。

## 注意事项

⚠️ 配置文件中包含 API 密钥，请勿提交到公开仓库。
