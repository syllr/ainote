# OpenCode CLI 使用指南

OpenCode 命令行接口参考。

## 概述

OpenCode 提供了强大的命令行接口（CLI），用于从终端快速执行各种操作。

## 基本用法

### 启动 OpenCode

```bash
# 在当前目录启动 OpenCode
opencode

# 在指定目录启动 OpenCode
opencode /path/to/project
```

### 全局选项

```bash
# 显示帮助信息
opencode --help
opencode -h

# 显示版本信息
opencode --version
opencode -v

# 启用调试模式
opencode --debug

# 指定配置文件
opencode --config /path/to/config.json
```

## 命令列表

### init

初始化项目，创建 `AGENTS.md` 文件。

```bash
opencode init
```

### connect

连接 LLM 提供商。

```bash
opencode connect
```

### new

创建新会话。

```bash
opencode new
```

### sessions

列出所有会话。

```bash
opencode sessions
```

### models

列出可用模型。

```bash
opencode models
```

### themes

列出可用主题。

```bash
opencode themes
```

### help

显示帮助信息。

```bash
opencode help
```

## 一次性命令

您可以使用 `--execute` 或 `-e` 选项执行一次性命令：

```bash
# 执行单个提示
opencode --execute "给我这个代码库的快速总结"

# 使用短选项
opencode -e "重构这个函数"
```

## 管道输入

OpenCode 支持从标准输入读取内容：

```bash
# 将文件内容传递给 OpenCode
cat file.txt | opencode -e "总结这个文件的内容"

# 将命令输出传递给 OpenCode
git diff | opencode -e "代码审查这个 diff"
```

## 配置文件

OpenCode 支持 JSON 和 JSONC 格式的配置文件。

### 配置文件位置

1. **项目级**：`./opencode.json`
2. **全局**：`~/.config/opencode/opencode.json`
3. **自定义**：通过 `--config` 选项指定

### 配置文件示例

```json
{
  "$schema": "https://opencode.ai/config.json",
  "models": {
    "default": "openai:gpt-4-turbo"
  },
  "themes": {
    "default": "opencode"
  }
}
```

## 环境变量

OpenCode 支持以下环境变量：

```bash
# API 密钥
export OPENAI_API_KEY="your-key"
export ANTHROPIC_API_KEY="your-key"
export OPENCODE_API_KEY="your-key"

# 配置
export OPENCODE_CONFIG="/path/to/config.json"
export OPENCODE_HOME="/path/to/home"

# 调试
export OPENCODE_DEBUG="true"
```

## 退出码

- `0` - 成功
- `1` - 一般错误
- `2` - 配置错误
- `3` - 认证错误

## 使用示例

### 示例 1：快速代码审查

```bash
git diff HEAD~1 HEAD | opencode -e "代码审查这个变更，提供改进建议"
```

### 示例 2：文件总结

```bash
cat README.md | opencode -e "为这个 README 创建一个简短的 TL;DR"
```

### 示例 3：批量处理

```bash
# 处理多个文件
for file in *.py; do
  echo "Processing $file..."
  cat "$file" | opencode -e "检查这个 Python 文件的语法错误"
done
```

## TUI 命令

在 TUI 中，您可以使用斜杠命令：

- `/connect` - 连接提供商
- `/init` - 初始化项目
- `/new` - 新会话
- `/sessions` - 列出会话
- `/models` - 列出模型
- `/themes` - 列出主题
- `/share` - 分享对话
- `/undo` - 撤销修改
- `/redo` - 重做修改
- `/help` - 显示帮助
- `/exit` - 退出

## 更多信息

有关 CLI 的更多信息，请访问：
- OpenCode 官方文档：https://opencode.ai/docs/zh-cn/cli/
