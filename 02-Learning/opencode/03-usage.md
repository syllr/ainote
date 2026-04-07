# 使用 OpenCode

## 初始化项目

配置好提供商后，导航到你想要处理的项目目录。

```bash
cd /path/to/project
```

然后运行 OpenCode。

```bash
opencode
```

接下来，运行以下命令为项目初始化 OpenCode。

```
/init
```

OpenCode 会分析你的项目并在项目根目录创建一个 `AGENTS.md` 文件。

> 你应该将项目的 `AGENTS.md` 文件提交到 Git。这有助于 OpenCode 理解项目结构和编码规范。

## 基本使用

### 提问

你可以让 OpenCode 为你讲解代码库。

> 使用 `@` 键可以模糊搜索项目中的文件。

```
How is authentication handled in @packages/functions/src/api/index.ts
```

当你遇到不熟悉的代码时，这个功能非常有用。

### 添加功能

你可以让 OpenCode 为项目添加新功能。不过我们建议先让它制定一个计划。

#### 1. 制定计划

OpenCode 有一个*计划模式*，该模式下它不会进行任何修改，而是建议*如何*实现该功能。

使用 **Tab** 键切换到计划模式。你会在右下角看到模式指示器。

```
<TAB>
```

接下来描述你希望它做什么。

```
When a user deletes a note, we'd like to flag it as deleted in the database.Then create a screen that shows all the recently deleted notes.From this screen, the user can undelete a note or permanently delete it.
```

你需要提供足够的细节，让 OpenCode 理解你的需求。可以把它当作团队中的一名初级开发者来沟通。

> 为 OpenCode 提供充足的上下文和示例，帮助它理解你的需求。

#### 2. 迭代计划

当它给出计划后，你可以提供反馈或补充更多细节。

```
We'd like to design this new screen using a design I've used before.[Image #1] Take a look at this image and use it as a reference.
```

> 将图片拖放到终端中即可将其添加到提示词中。OpenCode 可以扫描你提供的图片并将其添加到提示词中。只需将图片拖放到终端窗口即可。

#### 3. 构建功能

当你对计划满意后，再次按 **Tab** 键切换回*构建模式*。

```
<TAB>
```

然后让它开始实施。

```
Sounds good! Go ahead and make the changes.
```

### 直接修改

对于比较简单的修改，你可以直接让 OpenCode 实施，无需先审查计划。

```
We need to add authentication to the /settings route. Take a look at how this ishandled in the /notes route in @packages/functions/src/notes.ts and implementthe same logic in @packages/functions/src/settings.ts
```

请确保提供足够的细节，以便 OpenCode 做出正确的修改。

### 撤销修改

假设你让 OpenCode 做了一些修改。

```
Can you refactor the function in @packages/functions/src/api/index.ts?
```

但你发现结果不是你想要的。你**可以使用** `/undo` 命令来撤销修改。

```
/undo
```

OpenCode 会还原所做的修改，并重新显示你之前的消息。

```
Can you refactor the function in @packages/functions/src/api/index.ts?
```

你可以调整提示词，让 OpenCode 重新尝试。

> 你可以多次运行 `/undo` 来撤销多次修改。你也**可以使用** `/redo` 命令来重做修改。

## 分享

你与 OpenCode 的对话可以[与团队分享](/docs/share)。

```
/share
```

这会生成当前对话的链接并复制到剪贴板。

> 对话默认不会被分享。这是一个与 OpenCode 的[示例对话](https://opencode.ai/s/4XP1fce5)。

## 个性化

以上就是全部内容！你现在已经是 OpenCode 的使用高手了。

要让它更符合你的习惯，我们推荐[选择一个主题](/docs/themes)、[自定义快捷键](/docs/keybinds)、[配置代码格式化工具](/docs/formatters)、[创建自定义命令](/docs/commands)，或者探索 [OpenCode 配置](/docs/config)。
