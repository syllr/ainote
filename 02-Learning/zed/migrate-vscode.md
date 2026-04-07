# 从 VS Code 迁移

本指南解释如何从 VS Code 迁移到 Zed 而无需重建工作流程。

它涵盖了哪些设置自动导入、哪些快捷键干净地映射，以及哪些行为不同，以便你可以快速调整。

## 安装 Zed

Zed 可在 macOS、Windows 和 Linux 上使用。

对于 macOS，你可以从 zed.dev/download 下载，或通过 Homebrew 安装：`brew install zed-editor/zed/zed`

对于大多数 Linux 用户，最简单的安装方式是通过我们的安装脚本：`curl -f https://zed.dev/install.sh | sh`

安装后，你可以从应用程序文件夹（macOS）或直接从终端（Linux）使用：`zed .` 这会在 Zed 中打开当前目录。

## 从 VS Code 导入设置

在设置期间，你有选项从 VS Code 导入关键设置。Zed 导入以下设置：

### 从 VS Code 导入的设置

以下 VS Code 设置在**从 VS Code 导入设置**时自动导入：

**编辑器**

VS Code 设置 | Zed 设置
--- | ---
`editor.fontFamily` | `buffer_font_family`
`editor.fontSize` | `buffer_font_size`
`editor.fontWeight` | `buffer_font_weight`
`editor.tabSize` | `tab_size`
`editor.insertSpaces` | `hard_tabs`（反转）
`editor.wordWrap` | `soft_wrap`
`editor.wordWrapColumn` | `preferred_line_length`
`editor.cursorStyle` | `cursor_shape`
`editor.cursorBlinking` | `cursor_blink`
`editor.renderLineHighlight` | `current_line_highlight`
`editor.lineNumbers` | `gutter.line_numbers`, `relative_line_numbers`
`editor.showFoldingControls` | `gutter.folds`
`editor.minimap.enabled` | `minimap.show`
`editor.minimap.autohide` | `minimap.show`
`editor.minimap.showSlider` | `minimap.thumb`
`editor.minimap.maxColumn` | `minimap.max_width_columns`
`editor.stickyScroll.enabled` | `sticky_scroll.enabled`
`editor.scrollbar.horizontal` | `scrollbar.axes.horizontal`
`editor.scrollbar.vertical` | `scrollbar.axes.vertical`
`editor.mouseWheelScrollSensitivity` | `scroll_sensitivity`
`editor.fastScrollSensitivity` | `fast_scroll_sensitivity`
`editor.cursorSurroundingLines` | `vertical_scroll_margin`
`editor.hover.enabled` | `hover_popover_enabled`
`editor.hover.delay` | `hover_popover_delay`
`editor.parameterHints.enabled` | `auto_signature_help`
`editor.multiCursorModifier` | `multi_cursor_modifier`
`editor.selectionHighlight` | `selection_highlight`
`editor.roundedSelection` | `rounded_selection`
`editor.find.seedSearchStringFromSelection` | `seed_search_query_from_cursor`
`editor.rulers` | `wrap_guides`
`editor.renderWhitespace` | `show_whitespaces`
`editor.guides.indentation` | `indent_guides.enabled`
`editor.linkedEditing` | `linked_edits`
`editor.autoSurround` | `use_auto_surround`
`editor.formatOnSave` | `format_on_save`
`editor.formatOnPaste` | `auto_indent_on_paste`
`editor.formatOnType` | `use_on_type_format`
`editor.trimAutoWhitespace` | `remove_trailing_whitespace_on_save`
`editor.suggestOnTriggerCharacters` | `show_completions_on_input`
`editor.suggest.showWords` | `completions.words`
`editor.inlineSuggest.enabled` | `show_edit_predictions`

**文件和工作区**

VS Code 设置 | Zed 设置
--- | ---
`files.autoSave` | `autosave`
`files.autoSaveDelay` | `autosave.milliseconds`
`files.insertFinalNewline` | `ensure_final_newline_on_save`
`files.associations` | `file_types`
`files.watcherExclude` | `file_scan_exclusions`
`files.watcherInclude` | `file_scan_inclusions`
`files.simpleDialog.enable` | `use_system_path_prompts`
`search.smartCase` | `use_smartcase_search`
`search.useIgnoreFiles` | `search.include_ignored`

**终端**

VS Code 设置 | Zed 设置
--- | ---
`terminal.integrated.fontFamily` | `terminal.font_family`
`terminal.integrated.fontSize` | `terminal.font_size`
`terminal.integrated.lineHeight` | `terminal.line_height`
`terminal.integrated.cursorStyle` | `terminal.cursor_shape`
`terminal.integrated.cursorBlinking` | `terminal.blinking`
`terminal.integrated.copyOnSelection` | `terminal.copy_on_select`
`terminal.integrated.scrollback` | `terminal.max_scroll_history_lines`
`terminal.integrated.macOptionIsMeta` | `terminal.option_as_meta`
`terminal.integrated.{platform}Exec` | `terminal.shell`
`terminal.integrated.env.{platform}` | `terminal.env`

**选项卡和面板**

VS Code 设置 | Zed 设置
--- | ---
`workbench.editor.showTabs` | `tab_bar.show`
`workbench.editor.showIcons` | `tabs.file_icons`
`workbench.editor.tabActionLocation` | `tabs.close_position`
`workbench.editor.tabActionCloseVisibility` | `tabs.show_close_button`
`workbench.editor.focusRecentEditorAfterClose` | `tabs.activate_on_close`
`workbench.editor.enablePreview` | `preview_tabs.enabled`
`workbench.editor.enablePreviewFromQuickOpen` | `preview_tabs.enable_preview_from_file_finder`
`workbench.editor.enablePreviewFromCodeNavigation` | `preview_tabs.enable_preview_from_code_navigation`
`workbench.editor.editorActionsLocation` | `tab_bar.show_tab_bar_buttons`
`workbench.editor.limit.enabled` / `value` | `max_tabs`
`workbench.editor.restoreViewState` | `restore_on_file_reopen`
`workbench.statusBar.visible` | `status_bar.show`

**项目面板（文件资源管理器）**

VS Code 设置 | Zed 设置
--- | ---
`explorer.compactFolders` | `project_panel.auto_fold_dirs`
`explorer.autoReveal` | `project_panel.auto_reveal_entries`
`explorer.excludeGitIgnore` | `project_panel.hide_gitignore`
`problems.decorations.enabled` | `project_panel.show_diagnostics`
`explorer.decorations.badges` | `project_panel.git_status`

**Git**

VS Code 设置 | Zed 设置
--- | ---
`git.enabled` | `git_panel.button`
`git.defaultBranchName` | `git_panel.fallback_branch_name`
`git.decorations.enabled` | `git.inline_blame`, `project_panel.git_status`
`git.blame.editorDecoration.enabled` | `git.inline_blame.enabled`

**窗口和行为**

VS Code 设置 | Zed 设置
--- | ---
`window.confirmBeforeClose` | `confirm_quit`
`window.nativeTabs` | `use_system_window_tabs`
`window.closeWhenEmpty` | `when_closing_with_no_tabs`
`accessibility.dimUnfocused.enabled` / `opacity` | `active_pane_modifiers.inactive_opacity`

**其他**

VS Code 设置 | Zed 设置
--- | ---
`http.proxy` | `proxy`
`npm.packageManager` | `node.npm_path`
`telemetry.telemetryLevel` | `telemetry.metrics`, `telemetry.diagnostics`
`outline.icons` | `outline_panel.file_icons`, `outline_panel.folder_icons`
`chat.agent.enabled` | `agent.enabled`
`mcp` | `context_servers`

Zed 不导入扩展或键位绑定，但此导入使核心编辑器行为接近你的 VS Code 设置。如果你在设置期间跳过此步骤，稍后也可以通过命令面板手动导入设置：

`Cmd+Shift+P → Zed: Import VS Code Settings`

## 设置编辑器首选项

你可以在设置编辑器（`cmd-,`/`ctrl-,`）中配置大多数设置。对于高级设置，从命令面板运行 `zed: open settings file` 直接编辑你的设置文件。

以下是常见的 VS Code 设置如何转换：

VS Code | Zed
--- | ---
`editor.fontFamily` | `buffer_font_family`
`editor.fontSize` | `buffer_font_size`
`editor.tabSize` | `tab_size`
`editor.insertSpaces` | `insert_spaces`
`editor.formatOnSave` | `format_on_save`
`editor.wordWrap` | `soft_wrap`
`editor.minimap.enabled` | `minimap.show`

Zed 还支持项目级设置。你可以在设置编辑器中找到这些设置。

## 打开或创建项目

设置后，按 `Cmd+O`（Linux 上为 `Ctrl+O`）打开文件夹。这将成为你在 Zed 中的工作区。Zed 不支持多根工作区或 `.code-workspace` 文件，就像在 VS Code 中一样。Zed 保持简单：一个文件夹，一个工作区。

要开始新项目，使用终端或文件管理器创建一个目录，然后在 Zed 中打开它。编辑器将把该文件夹视为项目的根目录。

你也可以在终端内任何文件夹中使用：`zed .` 启动 Zed。

进入项目后，使用 `Cmd+P` 快速在文件之间跳转。`Cmd+Shift+P`（Linux 上为 `Ctrl+Shift+P`）打开命令面板，用于运行操作/任务、切换设置或启动协作会话。

打开的缓冲区显示为顶部的选项卡。项目面板显示你的文件树和 Git 状态。使用 `Cmd+B` 折叠它以获得无干扰的视图。

## 键位绑定的差异

如果你在入门时选择了 VS Code 键位方案，大多数快捷键应该已经感觉很熟悉。以下是键位绑定匹配和不同的地方。

### 共享键位绑定（Zed <> VS Code）

| 操作 | 快捷键 |
|------|--------|
| 查找文件 | `Cmd + P` |
| 运行命令 | `Cmd + Shift + P` |
| 搜索文本（项目范围） | `Cmd + Shift + F` |
| 查找符号（项目范围） | `Cmd + T` |
| 查找符号（文件范围） | `Cmd + Shift + O` |
| 切换左侧停靠栏 | `Cmd + B` |
| 切换底部停靠栏 | `Cmd + J` |
| 打开终端 | `Ctrl + ~` |
| 打开文件树资源管理器 | `Cmd + Shift + E` |
| 关闭当前缓冲区 | `Cmd + W` |
| 关闭整个项目 | `Cmd + Shift + W` |
| 重构：重命名符号 | `F2` |
| 更改主题 | `Cmd + K, Cmd + T` |
| 换行 | `Opt + Z` |
| 导航打开的选项卡 | `Cmd + Opt + Arrow` |
| 语法折叠/展开 | `Cmd + Opt + {` 或 `}` |

### 不同的键位绑定（Zed <> VS Code）

| 操作 | VS Code | Zed |
|------|---------|-----|
| 打开最近的项目 | `Ctrl + R` | `Cmd + Opt + O` |
| 向上/向下移动行 | `Opt + Up/Down` | `Cmd + Ctrl + Up/Down` |
| 拆分窗格 | `Cmd + \` | `Cmd + K, Arrow Keys` |
| 扩展选择 | `Shift + Alt + Right` | `Opt + Up` |

### Zed 独有

| 操作 | 快捷键 |
|------|--------|
| 切换右侧停靠栏 | `Cmd + R` 或 `Cmd + Alt + B` |
| 语法选择 | `Opt + Up/Down` |

### 如何自定义键位绑定

要编辑你的键位绑定：

1. 打开命令面板（`Cmd+Shift+P`）
2. 运行 `Zed: Open Keymap Editor`

这会打开所有可用绑定的列表。你可以覆盖单个快捷键、删除冲突或构建更适合你设置的布局。

Zed 也支持和弦（多键序列），如 `Cmd+K Cmd+C`，就像 VS Code 一样。

## 用户界面的差异

### 无工作区

VS Code 使用专门的工作区概念，包括多根文件夹、`.code-workspace` 文件和"窗口"与"工作区"之间的清晰区分。Zed 简化了此模型。

在 Zed 中：

- 没有工作区文件格式。打开文件夹就是你的项目上下文。
- Zed 不支持多根工作区。你只能在窗口中一次打开一个文件夹。
- 大多数项目级行为都作用在你打开的目录上。搜索、Git 集成、任务和环境检测都将打开的目录视为项目根目录。
- 项目级设置是可选的。你可以在项目内添加 `.zed/settings.json` 文件来覆盖全局设置，但 Zed 不使用 `.code-workspace` 文件，也不会导入它们。
- 你可以从单个文件或空窗口开始。Zed 不需要你打开文件夹即可开始编辑。

结果是更简单的模型：打开文件夹 → 在该文件夹中工作 → 没有额外的工作区层。

### 在项目中导航

在 VS Code 中，标准入口点是打开文件夹。然后，左侧面板是导航的核心。Zed 采用了不同的方法：

- 你仍然可以打开文件夹，但你不需要。打开单个文件甚至从空工作区开始都是有效的。
- 命令面板（`Cmd+Shift+P`）和文件查找器（`Cmd+P`）是主要导航工具。文件查找器在工作区中搜索文件、符号和命令。
- Zed 鼓励你：
  - 按名称模糊查找文件（`Cmd+P`）
  - 直接跳转到符号（`Cmd+Shift+O`）
  - 使用拆分窗格和选项卡进行上下文，而不是保持大型文件树打开（尽管如果你更喜欢，可以使用项目面板这样做）。

UI 将辅助面板放在一边，使导航保持在代码周围。

### 扩展与市场

Zed 不像 VS Code 那样提供许多扩展。可用的扩展专注于语言支持、主题、语法高亮和其他核心编辑增强。

在 VS Code 中通常需要扩展的几个功能在 Zed 中是内置的：

- 实时协作，具有语音和光标共享（无需 Live Share）
- AI 编码辅助（无需 Copilot 扩展）
- 内置终端面板
- 项目范围模糊搜索
- 使用 JSON 配置的任务运行器
- 通过 LSP 的内联诊断和代码操作

你不会找到与每个 VS Code 扩展的一一对应替换，特别是如果你依赖 DevOps、容器或测试运行器的工具。Zed 的扩展目录仍在增长，仍然较小。

### Zed 与 VS Code 中的协作

与 VS Code 不同，Zed 不需要扩展即可协作。它内置在核心体验中。

- 在左侧停靠栏中打开 Collab 面板
- 创建频道并[邀请你的协作者](https://zed.dev/docs/collaboration#inviting-a-collaborator)加入
- [直接共享你的屏幕或代码库](https://zed.dev/docs/collaboration#share-a-project)

连接后，你将实时看到彼此的光标、选择和编辑。语音聊天是包含的，所以你可以边工作边交谈。无需单独的工具或第三方登录。

了解 Zed 如何使用 [Zed](https://zed.dev/blog/zed-is-our-office) 来规划工作和协作。

## 在 Zed 中使用 AI

如果你习惯在 VS Code 中使用 GitHub Copilot，你也可以在 Zed 中这样做。你还可以通过 Zed Pro 探索其他代理，或携带你自己的密钥并无需认证即可连接。如果你更喜欢，可以完全禁用 AI 功能。

### 配置 GitHub Copilot

1. 使用 `Cmd+,`（macOS）或 `Ctrl+,`（Linux/Windows）打开设置
2. 导航到 **AI → 编辑预测**
3. 点击"配置提供商"旁边的"配置"
4. 在 **GitHub Copilot** 下，点击"登录 GitHub"

登录后，只需开始输入。Zed 会提供供你接受的内联建议。

### 其他 AI 选项

要在 Zed 中使用其他 AI 模型，你有几个选项：

- 使用 Zed 的托管模型，具有更高的速率限制。需要 [身份验证](https://zed.dev/docs/authentication) 和 [Zed Pro](https://zed.dev/docs/ai/subscription.html) 订阅。
- 带来你自己的 [API 密钥](https://zed.dev/docs/ai/llm-providers.html)，无需身份验证
- 使用 [外部代理](https://zed.dev/docs/ai/external-agents.html)，如 Claude Agent

## 高级配置和生产力调整

Zed 为想要微调环境的超级用户暴露高级设置。

这里有一些有用的调整：

**保存时格式化：**

```json
"format_on_save": "on"
```

**启用 direnv 支持：**

```json
"load_direnv": "shell_hook"
```

**自定义任务**: 在你的 `tasks.json` 中定义构建或运行命令（通过命令面板访问：`zed: 打开任务`）：

```json
[
  {
    "label": "build",
    "command": "cargo build"
  }
]
```

**带入自定义代码片段** 复制你的 VS Code 代码片段 JSON 直接到 Zed 的代码片段文件夹（`zed: 配置代码片段`）。

[MCP 服务器扩展](../extensions/mcp-extensions.html) [IntelliJ IDEA](../migrate/intellij.html)
