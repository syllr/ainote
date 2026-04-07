# OpenCode 命令参考

OpenCode 自定义命令配置和使用。

## 概述

OpenCode 允许您创建自定义命令来自动化常见任务。

## 内置命令

### /connect

连接到 LLM 提供商。

```
/connect
```

### /init

初始化项目，创建 `AGENTS.md` 文件。

```
/init
```

### /new

创建新会话。

```
/new
```

### /sessions

列出所有会话。

```
/sessions
```

### /models

列出可用的模型。

```
/models
```

### /themes

列出并切换主题。

```
/themes
```

### /compact

切换紧凑模式。

```
/compact
```

### /details

切换详细模式。

```
/details
```

### /editor

打开编辑器设置。

```
/editor
```

### /thinking

切换思考模式。

```
/thinking
```

### /undo

撤销上一次修改。

```
/undo
```

### /redo

重做上一次撤销的修改。

```
/redo
```

### /export

导出当前对话。

```
/export
```

### /share

分享当前对话。

```
/share
```

### /unshare

取消分享对话。

```
/unshare
```

### /help

显示帮助信息。

```
/help
```

### /exit

退出 OpenCode。

```
/exit
```

## 自定义命令

您可以在 `opencode.json` 配置文件中定义自定义命令。

### 基本结构

```json
{
  "$schema": "https://opencode.ai/config.json",
  "commands": {
    "mycommand": {
      "description": "我的自定义命令",
      "prompt": "执行这个命令时要发送的提示词"
    }
  }
}
```

### 示例 1：代码审查命令

```json
{
  "$schema": "https://opencode.ai/config.json",
  "commands": {
    "review": {
      "description": "代码审查当前变更",
      "prompt": "请进行代码审查，检查：\n1. 代码质量\n2. 潜在bug\n3. 性能问题\n4. 最佳实践\n5. 安全问题\n\n提供具体的改进建议。"
    }
  }
}
```

### 示例 2：测试生成命令

```json
{
  "$schema": "https://opencode.ai/config.json",
  "commands": {
    "test": {
      "description": "为当前文件生成测试",
      "prompt": "为 @ 的代码生成全面的单元测试。\n\n要求：\n- 覆盖正常情况\n- 覆盖边界情况\n- 覆盖错误处理\n- 使用适当的断言\n- 添加清晰的测试描述"
    }
  }
}
```

### 示例 3：文档生成命令

```json
{
  "$schema": "https://opencode.ai/config.json",
  "commands": {
    "document": {
      "description": "为当前文件生成文档",
      "prompt": "为 @ 的代码生成清晰的文档。\n\n包括：\n- 功能概述\n- 参数说明\n- 返回值说明\n- 使用示例\n- 注意事项"
    }
  }
}
```

### 示例 4：重构命令

```json
{
  "$schema": "https://opencode.ai/config.json",
  "commands": {
    "refactor": {
      "description": "重构当前代码",
      "prompt": "重构 @ 的代码以提高：\n\n- 可读性\n- 可维护性\n- 性能\n- 可测试性\n\n保持功能不变，只改进代码结构和质量。"
    }
  }
}
```

### 示例 5：多步骤命令

```json
{
  "$schema": "https://opencode.ai/config.json",
  "commands": {
    "feature": {
      "description": "完整功能开发流程",
      "prompt": "让我们按照以下步骤开发新功能：\n\n1. 首先理解需求\n2. 制定实现计划\n3. 实现代码\n4. 添加测试\n5. 更新文档\n\n准备好了吗？开始第一步：理解需求。"
    }
  }
}
```

## 命令变量

自定义命令支持变量替换。

### 可用变量

- `{{file}}` - 当前选中的文件
- `{{selection}}` - 当前选中文本
- `{{cwd}}` - 当前工作目录
- `{{project}}` - 项目名称

### 变量使用示例

```json
{
  "$schema": "https://opencode.ai/config.json",
  "commands": {
    "explain": {
      "description": "解释选中的代码",
      "prompt": "请详细解释这段代码的作用：\n\n```\n{{selection}}\n```\n\n包括：\n- 整体功能\n- 关键逻辑\n- 输入输出\n- 注意事项"
    },
    "optimize": {
      "description": "优化当前文件",
      "prompt": "分析 {{file}} 并提供优化建议：\n\n1. 性能优化\n2. 内存优化\n3. 代码简化\n4. 算法改进"
    }
  }
}
```

## 使用自定义命令

在 TUI 中，只需输入斜杠后跟命令名称：

```
/review
/test
/document
/refactor
/feature
/explain
/optimize
```

## 命令组合

您可以创建相互调用的命令组合：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "commands": {
    "complete": {
      "description": "完成的代码审查流程",
      "prompt": "让我们执行完整的代码审查流程：\n\n1. 首先运行 /review 进行代码审查\n2. 然后运行 /test 确保测试覆盖\n3. 最后运行 /document 更新文档\n\n开始第一步！"
    }
  }
}
```

## 项目级 vs 全局命令

- **项目级命令**：在 `./opencode.json` 中定义，仅对当前项目有效
- **全局命令**：在 `~/.config/opencode/opencode.json` 中定义，对所有项目有效

## 最佳实践

1. **清晰的描述** - 为每个命令添加清晰的描述
2. **具体的提示** - 提示词应该具体、明确
3. **合理命名** - 使用简短、易记的命令名
4. **分组管理** - 相关命令使用相似的前缀
5. **文档说明** - 在团队中共享命令定义

## 更多信息

有关自定义命令的更多信息，请访问：
- OpenCode 官方文档：https://opencode.ai/docs/zh-cn/commands/
