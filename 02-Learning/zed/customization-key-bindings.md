# 键位绑定

## 自定义键位绑定

### 打开键位编辑器

1. 打开命令面板：`Cmd+Shift+P`
2. 运行 `Zed: Open Keymap Editor`

这会打开所有可用绑定的列表。你可以覆盖单个快捷键、删除冲突或构建更适合你设置的布局。

### 键位绑定格式

键位绑定使用 JSON 格式：

```json
[
  {
    "context": "Editor && mode == full",
    "bindings": {
      "ctrl-shift-s": "file:save_all"
    }
  }
]
```

### 上下文条件

`context` 字段定义绑定适用的条件：

- `Editor` - 编辑器上下文
- `Terminal` - 终端上下文
- `ProjectPanel` - 项目面板上下文
- `Mode` - 编辑模式
  - `full` - 完整模式
  - `vim` - Vim 模式
  - `helix` - Helix 模式

### 基本键位

```json
{
  "cmd+p": "file_finder:toggle",
  "cmd+shift+p": "command_palette:toggle",
  "cmd+shift+o": "symbol_finder:toggle",
  "cmd+shift+f": "project_finder:toggle"
}
```

## 预设键位方案

### VS Code

默认预设，最常用的快捷键：

| 操作 | 快捷键 |
|------|--------|
| 打开文件 | `Cmd+P` |
| 命令面板 | `Cmd+Shift+P` |
| 搜索文件 | `Cmd+Shift+F` |
| 搜索符号 | `Cmd+Shift+O` |
| 打开终端 | `Ctrl+`` |
| 打开设置 | `Cmd+,` |
| 关闭选项卡 | `Cmd+W` |

### Atom

Atom 风格的键位绑定。

### JetBrains

JetBrains IDE 风格的键位绑定。

### Sublime Text

Sublime Text 风格的键位绑定。

### TextMate

TextMate 风格的键位绑定。

### None

无预设键位绑定。

## 创建自定义键位绑定

### 示例 1: 添加自定义快捷键

```json
[
  {
    "context": "Editor && mode == full",
    "bindings": {
      "ctrl-shift-s": "file:save_all",
      "ctrl-shift-w": "tabs:close_other"
    }
  }
]
```

### 示例 2: 多键组合

```json
[
  {
    "context": "Editor && mode == full",
    "bindings": {
      "cmd+k cmd+c": "editor:comment_line",
      "cmd+k cmd+u": "editor:uncomment_line"
    }
  }
]
```

### 示例 3: 基于上下文的绑定

```json
[
  {
    "context": "Terminal && mode == full",
    "bindings": {
      "ctrl+shift+enter": "terminal:insert_new_line"
    }
  }
]
```

## 常用键位绑定

### 文件操作

| 操作 | 快捷键 |
|------|--------|
| 打开文件 | `Cmd+P` |
| 打开最近 | `Cmd+Opt+O` |
| 保存 | `Cmd+S` |
| 保存所有 | `Cmd+Shift+S` |
| 关闭选项卡 | `Cmd+W` |
| 关闭所有 | `Cmd+Shift+W` |

### 编辑操作

| 操作 | 快捷键 |
|------|--------|
| 复制 | `Cmd+C` |
| 剪切 | `Cmd+X` |
| 粘贴 | `Cmd+V` |
| 撤销 | `Cmd+Z` |
| 重做 | `Cmd+Shift+Z` |
| 查找 | `Cmd+F` |
| 替换 | `Cmd+H` |

### 导航操作

| 操作 | 快捷键 |
|------|--------|
| 前一个文件 | `Ctrl+Tab` |
| 后一个文件 | `Ctrl+Shift+Tab` |
| 前一个选项卡 | `Cmd+Shift+Tab` |
| 后一个选项卡 | `Cmd+Tab` |
| 向上滚动 | `Cmd+Up` |
| 向下滚动 | `Cmd+Down` |
| 向左滚动 | `Cmd+Left` |
| 向右滚动 | `Cmd+Right` |

### 视图操作

| 操作 | 快捷键 |
|------|--------|
| 切换左侧面板 | `Cmd+B` |
| 切换底部面板 | `Cmd+J` |
| 切换右侧面板 | `Cmd+R` 或 `Cmd+Alt+B` |
| 切换全屏 | `Cmd+Shift+F` |
| 切换最小化地图 | `Cmd+K Cmd+M` |
| 放大 | `Cmd++` |
| 缩小 | `Cmd+-` |

### AI 功能

| 操作 | 快捷键 |
|------|--------|
| 打开 Agent 面板 | `Cmd+Shift+A` |
| 打开内联助手 | `Cmd+Enter` |
| 生成代码 | `Tab` |

## Vim 模式

启用 Vim 模式：

```json
{
  "vim_mode": true
}
```

### Vim 快捷键

| 模式 | 操作 | 快捷键 |
|------|------|--------|
| 普通 | 移动光标 | `h/j/k/l` |
| 普通 | 跳到行首 | `0` |
| 普通 | 跳到行尾 | `$` |
| 普通 | 向上翻页 | `Ctrl+F` |
| 普通 | 向下翻页 | `Ctrl+B` |
| 插入 | 退出插入 | `Esc` |
| 插入 | 保存并退出 | `Esc :wq` |

### Vim 设置

```json
{
  "vim_mode": true,
  "vim": {
    "use_system_clipboard": true,
    "use_smartcase_search": true,
    "insert_mode_at_cursor": false
  }
}
```

## Helix 模式

启用 Helix 模式：

```json
{
  "helix_mode": true
}
```

### Helix 快捷键

Helix 模式使用类似 Vim 的键位绑定。

## 键位冲突解决

当两个命令使用相同的键位绑定时，会发生冲突。解决方法：

1. **覆盖绑定**: 在自定义键位绑定中定义相同的键位绑定
2. **更改上下文**: 使用不同的上下文条件
3. **删除冲突**: 删除其中一个绑定

## 键位绑定调试

### 查看所有可用绑定

1. 打开命令面板：`Cmd+Shift+P`
2. 运行 `Zed: Show All Actions`

这会显示所有可用的命令和它们的默认键位绑定。

### 测试键位绑定

1. 打开键位编辑器：`Cmd+Shift+P` → `Zed: Open Keymap Editor`
2. 在搜索框中输入命令名称
3. 查看默认键位绑定

## 导入键位绑定

### 从 VS Code 导入

```json
{
  "base_keymap": "VSCode"
}
```

### 从其他编辑器导入

```json
{
  "base_keymap": "Atom"  // 或 "JetBrains", "SublimeText", "TextMate"
}
```

### 自定义键位绑定文件

你可以创建自定义键位绑定文件：

1. 创建文件 `~/.config/zed/keymap.json`
2. 添加你的键位绑定
3. 重启 Zed

## 最佳实践

1. **保持一致性**: 使用与你习惯的编辑器相同的键位方案
2. **避免冲突**: 检查是否有冲突的键位绑定
3. **简化快捷键**: 使用多键组合（`Cmd+K Cmd+X`）而不是单键快捷键
4. **文档化**: 为自定义键位绑定添加注释
5. **测试**: 测试所有自定义快捷键确保正常工作
