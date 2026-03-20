# Claude Code 中的 skill-creator 完整指南

> 本文基于 Anthropic 官方文档和社区实践整理，详细介绍 skill-creator 的定位、使用方法和实现原理。

---

## 一、skill-creator 的定位与作用

### 什么是 skill-creator

**skill-creator** 是 Claude Code 官方提供的**用于创建、测试、优化自定义 Skill 的内置工具/技能**，它是 Claude Code
插件生态系统的一部分，遵循 [Agent Skills](https://agentskills.io) 开放标准。

你可以把它理解为 Claude Code 的**"Skill 开发 IDE"**——从零创建到测试优化，一站式搞定自定义 Skill。

### 核心定位

| 维度       | 说明                                         |
|----------|--------------------------------------------|
| **定位**   | Claude Code 官方预置的 Skill 开发工具               |
| **目标用户** | 需要自定义工作流的开发者、团队                            |
| **设计哲学** | 将软件工程方法引入 Skill 开发，让自定义 Skill 从"玩具"变成生产级可用 |

### 核心作用

1. **创建**：引导式问答从零构建新 Skill，自动生成符合规范的目录结构和 `SKILL.md` 模板
2. **测试**：为已有的 Skill 编写测试用例（evals）并运行自动化测试，生成 HTML 报告
3. **优化**：基于测试失败结果迭代优化 Skill 指令，直到满足预期
4. **基准测试**：多次运行 evals 并进行方差分析，对比有/无 Skill 的表现，**量化证明** Skill 的价值
5. **触发优化**：优化 Skill 的 description，提高 Claude 自动触发的准确率

### 它解决什么问题

| 问题                    | skill-creator 解决方案      |
|-----------------------|-------------------------|
| 手动创建 Skill 格式不规范      | 自动生成符合官方规范的模板           |
| Skill 测试全凭感觉，无法保证质量   | 系统化编写 evals 自动化测试       |
| Claude 更新后 Skill 悄悄失效 | 基准测试可快速验证有效性            |
| Skill 写好了但触发不了        | 优化 description 匹配用户实际输入 |
| 重复给 Claude 发相同指令，记不住  | Skill 持久化存储，一次创建随处可用    |

一句话总结：**skill-creator 把你重复的工作流 → 变成 Claude 可稳定调用的结构化能力**，让 Claude 从聊天机器人升级为可编程开发助理。

---

## 二、普通用户使用方式

### 1. 安装 skill-creator

**方式一：通过 Plugin Marketplace 安装（推荐）**

```
/plugin marketplace add anthropic/skills
```

安装后选择 `skill-creator`，选择 User Scope 使其跨项目可用。重启 Claude Code 后，输入 `/skill` 就能看到了。

**方式二：手动本地安装**

```bash
git clone https://github.com/anthropics/skills.git
mkdir -p ~/.claude/skills/
cp -r skills/skills/skill-creator ~/.claude/skills/
```

### 2. 四种工作模式

skill-creator 有四种核心工作模式，满足不同阶段需求：

| 模式            | 功能                                    | 调用示例                                                           |
|---------------|---------------------------------------|----------------------------------------------------------------|
| **Create**    | 引导式问答从零构建新 Skill，生成草稿和初始测试用例          | `/skill-creator "create a new skill for reviewing PRs"`        |
| **Eval**      | 对现有 Skill 运行测试 prompts，生成 HTML 报告展示结果 | `/skill-creator "run evals on my PDF skill"`                   |
| **Improve**   | 基于失败的 evals 迭代优化 Skill 指令             | `/skill-creator "improve my PRD skill based on failing evals"` |
| **Benchmark** | 多次运行 evals 进行方差分析，对比有/无 Skill 表现      | `/skill-creator "benchmark my skill across 10 runs"`           |

### 3. 创建第一个 Skill：完整实战

这里以创建一个"SQL 关键字大写转换"Skill 为例：

#### Step 1：启动创建流程

在 Claude Code 中输入：

```
/skill-creator "我想创建一个把 SQL 关键字转换成大写的 skill"
```

#### Step 2：回答澄清问题

skill-creator 会问你几个问题：

- Skill 叫什么名字？（示例：`sql-uppercase`）
- 功能描述是什么？什么时候触发？（示例：'Convert all SQL keywords to uppercase. Use when user wants to format SQL queries.'）
- 需要什么输入？（示例：`SQL text or file path`）
- 期望输出是什么？（示例：`Formatted SQL with keywords in uppercase`）
- 有哪些特殊规则需要遵守？（示例：
  `Don't change string literals, preserve original formatting, only keywords should be uppercased`）
- Claude 绝对不应该做什么？（示例：`Don't rewrite the query logic, don't add semicolons where none existed`）

#### Step 3：获取生成结果

问答完成后，skill-creator 会自动：

1. 创建目录结构：`~/.claude/skills/sql-uppercase/`
2. 生成 `SKILL.md` 初稿，包含正确的 YAML frontmatter
3. 生成 `evals.json` 测试用例模板

#### Step 4：完善测试用例

编辑 `evals.json`，添加可验证的测试用例：

```json
{
  "evals": [
    {
      "prompt": "Convert this SQL: select * from users where id = 1",
      "expectations": [
        "Output contains SELECT * FROM users WHERE id = 1",
        "select is converted to SELECT",
        "from is converted to FROM",
        "where is converted to WHERE",
        "The string '1' remains lowercase"
      ]
    }
  ]
}
```

> ⚠️ 关键原则：expectations **必须可验证**。'Output is high quality' 无效，'Output includes a Problem Statement section'
> 才有效。

#### Step 5：运行测试

```
/skill-creator "run evals on sql-uppercase"
```

skill-creator 会：

- 为每个 eval 启动独立的隔离子代理
- 运行 Skill 得到输出
- Grader 逐条件检查是否通过
- 生成 HTML 报告让你浏览结果

#### Step 6：迭代优化（如果有失败）

```
/skill-creator "improve sql-uppercase based on failing evals"
```

skill-creator 会：

- 按 60/40 分割训练集和保留测试集
- 分析失败原因，提出 `SKILL.md` 修改建议
- 迭代改进，最多 5 轮避免过拟合
- 选择测试集分数最高的版本

#### Step 7：量化效果验证（可选）

```
/skill-creator "benchmark sql-uppercase across 10 runs and compare with/without"
```

你会得到类似这样的数据：

| 模式            | Pass Rate | Avg Tokens | Avg Time |
|---------------|-----------|------------|----------|
| With skill    | 94%       | 4,210      | 18s      |
| Without skill | 61%       | 3,890      | 15s      |

结论：Skill 只增加了少量 token 开销，但通过率提升了 33 个百分点，确有价值。

### 4. 日常使用命令速查

```bash
# 从 marketplace 安装
/plugin marketplace add anthropic/skills

# 查看所有已安装 skills
/skill

# 启动 skill-creator 交互式创建
/skill-creator

# 直接指定任务创建
/skill-creator "create a new skill for [your task]"

# 运行测试
/skill-creator "run evals on my [skill-name]"

# 基于失败改进
/skill-creator "improve my [skill-name] based on failing evals"

# 基准测试
/skill-creator "benchmark my [skill-name] across 10 runs"

# 优化描述提高触发率
/skill-creator "optimize the description for my [skill-name]"
```

---

## 三、实现原理与源码结构

### 1. Skill 基础架构

在理解 skill-creator 之前，先了解 Claude Code 中 Skill 的基本结构：

#### 目录结构

每个 Skill 都是一个独立目录，入口是 `SKILL.md`：

```
my-skill/
├── SKILL.md          # 核心指令 + YAML frontmatter（必需）
├── evals.json        # 测试用例（skill-creator 使用）
├── agents/           # 可选：自定义 subagent
├── scripts/          # 可选：可执行脚本（Python/Node/Shell）
├── templates/        # 可选：输出模板
├── examples/         # 可选：使用示例
└── assets/           # 可选：其他支持文件
```

#### SKILL.md 文件格式

`SKILL.md` 使用 **YAML frontmatter + Markdown 正文** 格式：

```yaml
---
name: my-skill-name
description: What this skill does and when to trigger it.
disable-model-invocation: false
user-invocable: true
argument-hint: "[filename] [format]"
allowed-tools: Read, Grep, Bash
model: claude-sonnet-4-6
context: fork
agent: Explore
---
```

# Skill 名称

这里是详细的指令说明，告诉 Claude 具体该怎么做。

## 工作流程

1. Step 1：...
2. Step 2：...
3. Step 3：...

## 规则

- 规则 1
- 规则 2
- 规则 3

## 使用示例

`/my-skill-name input`

#### Frontmatter 字段说明

| 字段                         | 类型      | 必填 | 说明                                                                  |
|----------------------------|---------|----|---------------------------------------------------------------------|
| `name`                     | string  | 否  | Skill 显示名称，省略则使用目录名                                                 |
| `description`              | string  | 推荐 | 功能描述和触发时机，Claude 用它决定何时自动加载                                         |
| `disable-model-invocation` | boolean | 否  | `true` = 禁止 Claude 自动触发，只能手动调用。默认 `false`                           |
| `user-invocable`           | boolean | 否  | `false` = 从 `/` 菜单隐藏，仅供 Claude 自动调用。默认 `true`                       |
| `argument-hint`            | string  | 否  | 自动补全提示，示例：`[issue-number]`                                          |
| `allowed-tools`            | string  | 否  | 此 Skill 激活时，Claude 可以无需批准直接使用的工具                                    |
| `model`                    | string  | 否  | 指定此 Skill 使用的模型                                                     |
| `context`                  | string  | 否  | `fork` = 在分叉 subagent 中运行                                           |
| `agent`                    | string  | 否  | `context: fork` 时指定 subagent 类型（`Explore`/`Plan`/`general-purpose`） |

#### 动态参数替换

Skill 支持变量替换：

| 变量                     | 说明                          |
|------------------------|-----------------------------|
| `$ARGUMENTS`           | 所有参数                        |
| `$ARGUMENTS[N]`        | 第 N 个参数（0 索引）               |
| `$N`                   | `$ARGUMENTS[N]` 简写          |
| `${CLAUDE_SESSION_ID}` | 当前会话 ID                     |
| `${CLAUDE_SKILL_DIR}`  | Skill 目录的绝对路径（用于引用 scripts） |

示例：

```yaml
---
name: fix-issue
description: Fix a GitHub issue by number
disable-model-invocation: true
---

Fix GitHub issue number $0:

...
```

调用 `/fix-issue 123` 后，`$0` 会被替换为 `123`。

#### 动态上下文注入

支持 `!`command`` 语法在 Skill 内容发送前运行 shell 命令，输出替换占位符：

```yaml
---
name: pr-summary
description: Summarize changes in a pull request
context: fork
agent: Explore
allowed-tools: Bash(gh *)
---

## PR 数据
- Diff: !`gh pr diff`
- Comments: !`gh pr view --comments`
```

Summarize this pull request...

运行时，所有 `!`command`` 会先执行，输出插入到内容中再发给 Claude。

### 2. skill-creator 自身源码结构

skill-creator 本身就是一个 Skill，它的目录结构如下（来自官方 [anthropics/skills](https://github.com/anthropics/skills)
仓库）：

```
skill-creator/
├── SKILL.md                  # 主指令入口，定义整体工作流
├── agents/                   # 四个专用子代理
│   ├── Executor/             # 执行器：在干净上下文运行每个测试
│   │   └── SKILL.md
│   ├── Grader/               # 评分器：检查输出是否满足预期
│   │   └── SKILL.md
│   ├── Comparator/           # 比较器：A/B 测试对比两个版本
│   │   └── SKILL.md
│   └── Analyzer/             # 分析器：分析失败原因提出改进
│       └── SKILL.md
├── assets/                   # 静态资源
│   └── eval-template.html    # Eval 报告 HTML 模板
├── eval-viewer/              # HTML 报告生成脚本
│   └── generate_review.py
├── references/               # Schema 参考文档
│   └── skill-schema.json
└── scripts/                  # 核心逻辑脚本
    └── ...
```

### 3. 核心工作流程

#### Create 模式流程

```
用户输入需求
    ↓
skill-creator 交互式澄清提问（5-10个问题）
    ↓
收集完整需求后，按照官方规范
    ↓
自动创建目录 → 生成 SKILL.md 初稿 → 生成 evals.json 模板
    ↓
交付用户编辑完善
```

#### Eval 模式流程

```
读取 evals.json 中的所有测试用例
    ↓
对每个测试用例：
    ↓
    创建干净的隔离上下文（避免污染）
    ↓
    调用目标 Skill 运行
    ↓
    记录输出、token 消耗、耗时
    ↓
Grader 子代理逐条检查 expectations 是否满足
    ↓
统计通过率，生成 HTML 报告
    ↓
用户可以在浏览器中逐项查看结果
```

#### Improve 模式流程

```
读取当前 SKILL.md 和所有 evals
    ↓
60/40 随机分割 → 训练集 + 保留测试集
    ↓
在训练集上运行评估
    ↓
Analyzer 分析失败案例，找出问题根源
    ↓
提出 SKILL.md 修改建议
    ↓
应用修改 → 在完整集合重新评估
    ↓
最多重复 5 次迭代（防止过拟合）
    ↓
选择保留测试集分数最高的版本
```

#### Benchmark 模式流程

```
配置 N 次重复运行（通常 10 次）
    ↓
循环 N 次：
    ↓
    运行带 Skill 的评估 → 记录结果
    ↓
    运行不带 Skill 的评估 → 记录结果
    ↓
统计对比：通过率、token 分布、耗时分布
    ↓
输出对比表格，量化 Skill 带来的提升
```

### 4. 常见问题：临时目录与自动安装机制

很多用户会好奇：skill-creator 创建 Skill 时，临时目录到底是做什么用的？我需要手动把 Skill 从 temp 移到正式目录吗？

**答：你不需要任何手动操作，整个过程全自动。**

| 模式            | temp 目录使用吗？ | 最终输出位置                                   | 说明                                       |
|---------------|-------------|------------------------------------------|------------------------------------------|
| **Create**    | ❌ 不用        | `~/.claude/skills/<skill-name>/`         | 问答完成后**直接**创建到正式目录，全程不碰 temp             |
| **Eval**      | ✅ 运行时用      | 不修改正式文件                                  | 只是在隔离上下文运行测试，正式目录的 Skill 文件保持不变          |
| **Improve**   | ✅ 迭代用       | `~/.claude/skills/<skill-name>/SKILL.md` | 在 temp 测试多个候选版本 → 选出分数最高的 → **自动替换**正式文件 |
| **Benchmark** | ✅ 测试用       | 不修改正式文件                                  | 在 temp 多次运行对比测试，测试完自动清理，不影响正式文件          |

**关键结论：**

- **Create 一开始就写入正式目录**，不是先在 temp 再等你确认
- **只有 Improve 迭代优化会用到 temp**，测试完自动把最优版本放到正式目录
- **全程不需要你手动复制/移动文件**，skill-creator 全帮你做好了
- temp 目录只是内部测试隔离用，结束后会自动清理

### 5. 两类 Skill 与测试策略

skill-creator 区分两种不同类型的 Skill，采用不同测试策略：

| 类型                            | 说明                                                       | 测试重点                                             |
|-------------------------------|----------------------------------------------------------|--------------------------------------------------|
| **Capability Uplift Skills**  | 赋予 Claude 原本无法可靠完成的能力（比如生成特定格式的 PDF/docx 文件）             | 验证模型更新后 Skill 是否仍然有效；检查是否还存在价值（如果基础模型已经学会了，可以退役） |
| **Encoded Preference Skills** | 为 Claude 已能完成的任务编码团队/个人偏好（比如特定的 PRD 格式、code review 检查清单） | 验证小修改不会意外跳过某个步骤，保持保真度                            |

### 6. 常见最佳实践与陷阱

#### ✅ 最佳实践

- **Expectations 要具体可验证**："输出包含问题陈述章节" ✓，"输出高质量" ✗
- **包含边缘情况测试**：不只测试 happy path，也要测试不完整输入、模糊请求
- **使用保留测试集**：从不拿训练集评估，避免过拟合
- **迭代不超过 5 次**：超过 5 次容易过拟合到训练样本
- **description 包含关键词**：把用户会说的自然语言关键词放进去，提高触发率

#### ❌ 常见陷阱

- `description` 太笼统：'Helps with writing' → 优化为 "Helps writing product requirement documents (PRDs). Use when user
  mentions 'PRD', 'requirement doc', 'user stories'"
- Expectations 模糊：无法被 Grader 准确判断，结果不可靠
- 只测试正确输入不测试边缘情况：真正使用时遇到异常就会失败

---

## 四、总结

### 一句话概括

**skill-creator 是 Claude Code 官方提供的 Skill 开发工具，它让你可以把重复的工作流持久化、标准化，并通过测试方法保证质量，最终得到可复用、可自动化的自定义能力。
**

### 适用场景

当你满足以下任意一条，就应该考虑使用 skill-creator 创建自定义 Skill：

- ✅ 你重复给 Claude 下达相同的指令
- ✅ 你的项目有固定的编码风格/文档规范
- ✅ 你在开发插件、代码生成器
- ✅ 你希望 Claude 严格遵循团队工作流

### 参考文档

1. **Anthropic 官方 Skills 文档（中文）**：https://code.claude.com/docs/zh-CN/skills
2. **Anthropic 官方斜杠命令文档（英文）**：https://code.claude.com/docs/en/slash-commands
3. **掘金社区 - 如何用 skill-creator 创建测试优化 skill**：https://juejin.cn/post/7615613426630656034
4. **掘金社区 - Claude Code Skill 从入门到自定义**：https://juejin.cn/post/7617682877929127987
5. **CSDN - Claude Code 插件 Skill-Creator 使用说明**：https://blog.csdn.net/u014333212/article/details/157023838
6. **Agent Skills 开放标准**：https://agentskills.io
