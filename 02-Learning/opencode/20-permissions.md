# OpenCode 权限管理

控制 OpenCode 工具的访问权限。

## 概述

OpenCode 允许您精细控制每个工具的访问权限，确保安全使用。

## 权限级别

OpenCode 支持三种权限级别：

### allow（允许）

工具可以自动执行，无需用户确认。

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "read": "allow",
    "glob": "allow"
  }
}
```

### ask（询问）

工具执行前需要用户确认。

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "bash": "ask",
    "edit": "ask"
  }
}
```

### deny（拒绝）

工具被禁用，无法使用。

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "webfetch": "deny",
    "websearch": "deny"
  }
}
```

## 默认权限

默认情况下，所有工具都是 `allow` 级别，无需权限即可运行。

## 工具权限配置

### 按工具配置

您可以为每个工具单独配置权限：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "read": "allow",
    "write": "ask",
    "edit": "ask",
    "bash": "ask",
    "webfetch": "deny"
  }
}
```

### 使用通配符

您可以使用通配符同时配置多个工具：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "mcp_*": "ask",
    "custom_*": "deny"
  }
}
```

### 混合配置

您可以混合使用具体工具名和通配符：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "read": "allow",
    "write": "ask",
    "edit": "ask",
    "bash": "ask",
    "mcp_*": "ask",
    "web*": "deny"
  }
}
```

## 可用工具

以下是 OpenCode 的内置工具：

### 文件操作
- `read` - 读取文件
- `write` - 写入文件
- `edit` - 编辑文件
- `glob` - 文件模式匹配
- `list` - 列出目录内容
- `grep` - 搜索文件内容

### 系统操作
- `bash` - 执行 shell 命令
- `patch` - 应用补丁
- `lsp` - LSP 操作（实验性）

### 网络操作
- `webfetch` - 获取网页内容
- `websearch` - 网页搜索

### 其他
- `skill` - 执行技能
- `todowrite` - 管理待办事项
- `question` - 询问用户

## 权限配置示例

### 示例 1：严格模式

所有修改操作都需要确认：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "read": "allow",
    "glob": "allow",
    "list": "allow",
    "grep": "allow",
    "write": "ask",
    "edit": "ask",
    "bash": "ask",
    "patch": "ask",
    "webfetch": "deny",
    "websearch": "deny"
  }
}
```

### 示例 2：只读模式

完全禁止修改：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "read": "allow",
    "glob": "allow",
    "list": "allow",
    "grep": "allow",
    "write": "deny",
    "edit": "deny",
    "bash": "deny",
    "patch": "deny"
  }
}
```

### 示例 3：宽松模式

所有操作都允许（默认）：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "*": "allow"
  }
}
```

### 示例 4：MCP 服务器权限

为 MCP 服务器工具设置权限：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "read": "allow",
    "write": "ask",
    "edit": "ask",
    "bash": "ask",
    "mcp_filesystem_*": "ask",
    "mcp_database_*": "deny"
  }
}
```

## 权限优先级

权限配置按以下优先级应用：

1. **具体工具名** - 最高优先级
2. **通配符模式** - 中等优先级
3. **默认值** - 最低优先级

示例：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "*": "allow",
    "web*": "deny",
    "webfetch": "ask"
  }
}
```

在这个例子中：
- `webfetch` 将是 `ask`（具体工具名）
- `websearch` 将是 `deny`（通配符模式）
- 其他所有工具将是 `allow`（默认）

## 运行时权限

在 TUI 中，当工具需要确认时，您会看到：
- 工具将要执行的操作
- 选择：允许、拒绝或始终允许

您可以选择：
- **允许** - 仅允许这一次
- **拒绝** - 拒绝这次操作
- **始终允许** - 允许并更新配置为 `allow`

## 安全最佳实践

1. **新项目** - 从 `ask` 级别开始，逐步信任
2. **生产环境** - 考虑使用更严格的权限设置
3. **敏感操作** - `bash`、`edit`、`write` 应该是 `ask` 或 `deny`
4. **网络操作** - `webfetch`、`websearch` 应该谨慎使用
5. **团队共享** - 在团队中共享权限配置

## 更多信息

有关权限的更多信息，请访问：
- OpenCode 官方文档：https://opencode.ai/docs/zh-cn/permissions/
