# 入门指南

## 欢迎页面

当打开 Zed 而没有打开文件夹时，欢迎页面会显示在主编辑器区域。欢迎页面提供快速操作选项，如打开文件夹、克隆仓库或查看文档。

一旦打开文件夹或文件，欢迎页面就会消失。如果将编辑器拆分为多个窗格，欢迎页面只会在中间窗格为空时出现——其他窗格显示标准空状态。

要重新打开欢迎页面，关闭中间窗格中的所有项目或使用命令面板搜索"Welcome"。

## 1. 打开项目

从命令行打开文件夹：

```sh
zed ~/projects/my-app
```

或在 Zed 内部使用 `Cmd+O` (macOS) / `Ctrl+O` (Linux/Windows) 打开文件夹。

## 2. 学习基本命令

| 操作 | macOS | Linux/Windows |
|------|-------|---------------|
| 命令面板 | `Cmd+Shift+P` | `Ctrl+Shift+P` |
| 打开文件 | `Cmd+P` | `Ctrl+P` |
| 打开符号 | `Cmd+Shift+O` | `Ctrl+Shift+O` |
| 查找项目 | `Cmd+Shift+F` | `Ctrl+Shift+F` |
| 切换终端 | `Ctrl+\`` | `Ctrl+\`` |
| 打开设置 | `Cmd+,` | `Ctrl+,` |

命令面板 (`Cmd+Shift+P`) 是访问 Zed 中每个操作的门户。如果你忘记了快捷键，可以在那里搜索。

## 3. 配置编辑器

使用 `Cmd+,` (macOS) 或 `Ctrl+,` (Linux/Windows) 打开设置编辑器。直接搜索任何设置并更改它。

常见的首次更改：

- **主题**: 按 `Cmd+K Cmd+T` (macOS) 或 `Ctrl+K Ctrl+T` (Linux/Windows) 打开主题选择器
- **字体**: 在设置中搜索 `buffer_font_family`
- **保存时格式化**: 搜索 `format_on_save` 并设置为 `on`

## 4. 设置语言

Zed 包含对许多语言的内置支持。对于其他语言，安装扩展：

1. 使用 `Cmd+Shift+X` (macOS) 或 `Ctrl+Shift+X` (Linux/Windows) 打开扩展
2. 搜索你的语言
3. 点击安装

有关语言特定设置，请参阅 [语言支持](languages.html)。

## 5. 尝试 AI 功能

Zed 包含内置 AI 辅助。使用 `Cmd+Shift+A` (macOS) 或 `Ctrl+Shift+A` (Linux/Windows) 打开 Agent 面板开始对话，或使用 `Cmd+Enter` (macOS) / `Ctrl+Enter` (Linux/Windows) 进行内联助手。

有关配置提供商和了解可能性的信息，请参阅 [AI 概述](ai/overview.html)。

## 从其他编辑器迁移

我们有针对从其他编辑器切换的专门指南：

- [VS Code](migrate/vs-code.html) — 导入设置、映射键位、查找等效功能
- [IntelliJ IDEA](migrate/intellij.html) — 适应 Zed 的导航和重构方法
- [PyCharm](migrate/pycharm.html) — 在 Zed 中设置 Python 开发
- [WebStorm](migrate/webstorm.html) — 配置 JavaScript/TypeScript 工作流
- [RustRover](migrate/rustrover.html) — 在 Zed 中进行 Rust 开发

你也可以启用熟悉的键位绑定：

- **Vim**: 在设置中启用 `vim_mode`。详见 [Vim 模式](vim.html)。
- **Helix**: 在设置中启用 `helix_mode`。详见 [Helix 模式](helix.html)。

## 加入社区

Zed 是开源的。加入我们的 Discord 或 GitHub 社区，贡献代码、报告 bug 或建议功能。

- [Discord](https://discord.com/invite/zedindustries)
- [GitHub Discussions](https://github.com/zed-industries/zed/discussions)
- [Zed Reddit](https://www.reddit.com/r/ZedEditor)
