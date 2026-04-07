# OpenCode 官方文档

本目录包含 OpenCode 官方文档的完整整理版本，所有内容均来自 https://opencode.ai/docs/zh-cn/

## 关于 OpenCode

**OpenCode** 是一个开源的 AI 编码代理。它提供终端界面、桌面应用和 IDE 扩展等多种使用方式。

- **官方网站**: https://opencode.ai/
- **GitHub**: https://github.com/anomalyco/opencode
- **Discord**: https://opencode.ai/discord

## 文档结构

### 入门指南
- [01-introduction.md](01-introduction.md) - OpenCode 简介和快速开始
- [02-configuration.md](02-configuration.md) - OpenCode 配置详解
- [04-providers.md](04-providers.md) - LLM 提供商配置

### 使用指南
- [03-tui.md](03-tui.md) - 终端用户界面使用指南
- [05-cli.md](05-cli.md) - 命令行接口参考
- [06-web.md](06-web.md) - Web 界面使用说明
- [07-ide.md](07-ide.md) - IDE 集成指南
- [08-zen.md](08-zen.md) - Zen 模式使用指南
- [09-share.md](09-share.md) - 分享功能说明
- [10-github.md](10-github.md) - GitHub 集成
- [11-gitlab.md](11-gitlab.md) - GitLab 集成

### 配置详解
- [12-tools.md](12-tools.md) - 工具配置和使用
- [13-rules.md](13-rules.md) - 规则系统详解
- [14-agents.md](14-agents.md) - 代理系统详解
- [15-models.md](15-models.md) - 模型配置
- [16-themes.md](16-themes.md) - 主题系统
- [17-keybinds.md](17-keybinds.md) - 快捷键配置
- [18-commands.md](18-commands.md) - 自定义命令
- [19-formatters.md](19-formatters.md) - 格式化工具配置
- [20-permissions.md](20-permissions.md) - 权限管理
- [21-lsp.md](21-lsp.md) - LSP 服务器集成
- [22-mcp-servers.md](22-mcp-servers.md) - MCP 服务器集成
- [23-acp.md](23-acp.md) - ACP 支持
- [24-skills.md](24-skills.md) - 代理技能
- [25-custom-tools.md](25-custom-tools.md) - 自定义工具开发

### 高级功能
- [26-network.md](26-network.md) - 网络配置
- [27-enterprise.md](27-enterprise.md) - 企业版功能
- [28-troubleshooting.md](28-troubleshooting.md) - 故障排除指南
- [29-windows-wsl.md](29-windows-wsl.md) - Windows/WSL 使用指南

### 开发相关
- [30-sdk.md](30-sdk.md) - SDK 使用指南
- [31-server.md](31-server.md) - 服务器 API 文档
- [32-plugins.md](32-plugins.md) - 插件开发
- [33-ecosystem.md](33-ecosystem.md) - 生态系统项目

## 快速开始

### 安装

安装 OpenCode 最简单的方法是通过安装脚本：

```bash
curl -fsSL https://opencode.ai/install | bash
```

其他安装方式：
- **Node.js**: `npm install -g opencode-ai`
- **Homebrew**: `brew install anomalyco/tap/opencode`
- **Arch Linux**: `sudo pacman -S opencode`

### 配置

1. 运行 `/connect` 命令连接 LLM 提供商
2. 推荐使用 OpenCode Zen（经过测试和验证的精选模型）
3. 导航到项目目录并运行 `opencode`
4. 运行 `/init` 初始化项目

### 使用

- 输入消息进行提问
- 使用 `@` 键模糊搜索项目文件
- 使用 **Tab** 键切换计划/构建模式
- 使用 `/undo` 撤销修改
- 使用 `/share` 分享对话

## 核心特性

- **多种界面**: TUI（终端）、Web、IDE 扩展
- **多提供商支持**: 支持 OpenAI、Anthropic、OpenCode Zen 等多种 LLM 提供商
- **强大的工具集**: 文件操作、代码编辑、终端执行等
- **可扩展**: 支持自定义工具、MCP 服务器、插件等
- **协作**: 对话分享功能
- **个性化**: 主题、快捷键、命令等自定义

## 文档更新

所有文档最后更新时间：2026年4月7日（来自官方网站）

## 贡献

如果您发现文档有错误或需要补充，请访问：
- OpenCode 官方文档: https://opencode.ai/docs/zh-cn/
- GitHub 仓库: https://github.com/anomalyco/opencode
