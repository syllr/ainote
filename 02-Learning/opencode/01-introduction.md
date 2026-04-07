# OpenCode 简介

OpenCode 是一个开源的 AI 编码代理，它提供终端界面、桌面应用和 IDE 扩展等多种使用方式。

## 核心特性

OpenCode 是一个开源代理，帮助您在终端、IDE 或桌面端编写代码。

- **支持 LSP** - 为 LLM 自动加载合适的 LSP
- **多会话** - 在同一个项目中并行启动多个代理
- **分享链接** - 分享任意会话链接以供参考或调试
- **GitHub Copilot** - 使用 GitHub 登录以使用您的 Copilot 账户
- **ChatGPT Plus/Pro** - 使用 OpenAI 登录以使用您的 ChatGPT Plus 或 Pro 账户
- **任意模型** - 通过 Models.dev 支持 75+ LLM 提供商，包括本地模型
- **任意编辑器** - 提供终端界面、桌面应用及 IDE 扩展

## 生态统计

OpenCode 拥有超过 **120,000** 颗 GitHub Star，**800** 位贡献者，以及超过 **10,000** 次提交，每月被超过 **5M** 名开发者使用并信赖。

## 隐私优先的设计

OpenCode 不存储您的任何代码或上下文数据，确保可以在对隐私敏感的环境中运行。

## 前提条件

要在终端中使用 OpenCode，你需要：

1.  一款现代终端模拟器，例如：
    -   WezTerm（跨平台）
    -   Alacritty（跨平台）
    -   Ghostty（Linux 和 macOS）
    -   Kitty（Linux 和 macOS）
2.  你想使用的 LLM 提供商的 API 密钥

## 快速开始

```bash
# 安装
curl -fsSL https://opencode.ai/install | bash

# 运行 OpenCode
opencode

# 初始化项目
/init
```

## 下一步

- [安装](/docs/zh-cn/installation) - 了解详细的安装方法
- [配置](/docs/zh-cn/config) - 配置 API 密钥和提供商
- [使用指南](/docs/zh-cn/usage) - 学习如何使用 OpenCode
- [OpenCode Zen](/docs/zh-cn/zen) - 推荐的精选模型列表
