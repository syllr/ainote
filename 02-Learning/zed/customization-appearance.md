# 外观定制

## 主题

Zed 使用内置主题。要更改主题：

1. 打开命令面板：`Cmd+Shift+P`
2. 运行 `Zed: Open Theme Editor`
3. 选择一个主题

### 内置主题

Zed 提供几个内置主题：

- **Default** - 默认主题，平衡的颜色方案
- **One Dark** - 深色主题，类似 VS Code 的 One Dark
- **Nord** - 深色主题，基于 Nord 调色板
- **GitHub Light** - 浅色主题，与 GitHub 一致
- **GitHub Dark** - 深色主题，与 GitHub 一致

### 主题文件位置

主题文件位于：`~/.config/zed/themes/`

你可以手动编辑主题文件，或创建自定义主题。

## 图标主题

Zed 支持多种图标主题来显示文件类型图标：

### 内置图标主题

- **Default** - 默认图标主题
- **Feather** - 羽毛风格图标
- **Material** - Material Design 风格图标
- **Octicons** - GitHub Octicons 风格图标

### 图标主题文件位置

图标主题文件位于：`~/.config/zed/icon_themes/`

## 字体和视觉调整

### 字体设置

在设置编辑器中搜索以下设置：

```json
{
  "buffer_font_family": "JetBrains Mono",
  "buffer_font_size": 16,
  "buffer_font_weight": 400,
  "buffer_line_height": "comfortable"
}
```

### 行高选项

```json
{
  "buffer_line_height": "standard"    // 标准
  "buffer_line_height": "comfortable" // 舒适
  "buffer_line_height": {             // 自定义
    "custom": 1.5
  }
}
```

### 光标设置

```json
{
  "cursor_shape": "bar",           // 垂直条
  "cursor_shape": "block",         // 块
  "cursor_shape": "underline",     // 下划线
  "cursor_shape": "hollow"         // 空心框
}
```

### 光标闪烁

```json
{
  "cursor_blink": true  // 或 false
}
```

### 当前行高亮

```json
{
  "current_line_highlight": "none"    // 不高亮
  "current_line_highlight": "gutter"  // 只高亮边距
  "current_line_highlight": "line"    // 只高亮行
  "current_line_highlight": "all"     // 高亮整行
}
```

### 选中文本高亮

```json
{
  "selection_highlight": true  // 或 false
}
```

### 圆角选区

```json
{
  "rounded_selection": true  // 或 false
}
```

## 编辑器设置

### 折叠

```json
{
  "gutter": {
    "folds": true  // 显示折叠按钮
  }
}
```

### 最小化地图

```json
{
  "minimap": {
    "show": "auto",           // 自动显示
    "show": "always",         // 总是显示
    "show": "never",          // 总是不显示
    "thumb": "always",        // 总是显示缩略图
    "thumb": "hover"          // 悬停时显示
  }
}
```

### 状态栏

```json
{
  "status_bar": {
    "active_language_button": true,
    "cursor_position_button": true,
    "line_endings_button": false
  }
}
```

### 选项卡栏

```json
{
  "tab_bar": {
    "show": true,
    "show_nav_history_buttons": true,
    "show_tab_bar_buttons": true
  }
}
```

### 选项卡设置

```json
{
  "tabs": {
    "close_position": "right",      // 关闭按钮在右侧
    "close_position": "left",       // 关闭按钮在左侧
    "file_icons": false,            // 显示文件图标
    "git_status": false,            // 显示 Git 状态
    "show_close_button": "hover"    // 悬停时显示关闭按钮
  }
}
```

### 滚动条

```json
{
  "scrollbar": {
    "show": "auto",
    "cursors": true,                // 显示光标指示器
    "git_diff": true,               // 显示 Git 差异
    "search_results": true,         // 显示搜索结果
    "selected_text": true,          // 显示选中文本
    "selected_symbol": true,        // 显示选中的符号
    "diagnostics": "all"            // 显示所有诊断
  }
}
```

## 窗口和外观

### 窗口布局

```json
{
  "centered_layout": {
    "left_padding": 0.2,
    "right_padding": 0.2
  }
}
```

### 底部停靠栏布局

```json
{
  "bottom_dock_layout": "contained"  // 容器模式
  "bottom_dock_layout": "full"       // 全宽模式
  "bottom_dock_layout": "left_aligned"  // 左对齐
  "bottom_dock_layout": "right_aligned"  // 右对齐
}
```

### 激活窗格修饰

```json
{
  "active_pane_modifiers": {
    "border_size": 0.0,
    "inactive_opacity": 1.0
  }
}
```

## 自动保存

```json
{
  "autosave": "off"                     // 关闭
  "autosave": "on_focus_change"        // 焦点变化时
  "autosave": "on_window_change"        // 窗口变化时
  "autosave": {
    "after_delay": {
      "milliseconds": 1000              // 延迟 1 秒
    }
  }
}
```

## 显示选项

### 显示鼠标

```json
{
  "hide_mouse": "never"              // 从不隐藏
  "hide_mouse": "on_typing"          // 打字时隐藏
  "hide_mouse": "on_typing_and_movement"  // 打字和移动时隐藏
}
```

### 显示空格

```json
{
  "render_whitespace": "none"        // 不显示
  "render_whitespace": "selection"   // 选择时显示
  "render_whitespace": "all"         // 总是显示
}
```

## 响应式设计

Zed 支持响应式布局，适应不同屏幕尺寸。

### 拆分窗格

- **水平分割**: `Cmd+K Cmd+ArrowRight`
- **垂直分割**: `Cmd+K Cmd+ArrowDown`

### 多缓冲区

使用多缓冲区同时编辑多个文件：
- 创建多光标：`Cmd+D` 或 `Ctrl+D`
- 选择所有匹配：`Cmd+L` 或 `Ctrl+L`
