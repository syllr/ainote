# Claude Code .claude/ 目录结构与使用指南

Claude Code 提供了一套完整的项目配置机制，让 AI 能够真正理解你的项目并按照规范工作。很多初学者分不清 `CLAUDE.md`、`rules`、
`skills`、`hooks` 各自该什么时候用，本文给你讲清楚。

-----

## 一、整体目录结构

### 层级关系：用户全局 vs 项目级

Claude Code 有两个层级的配置：

| 层级       | 位置               | 作用范围                |
|----------|------------------|---------------------|
| **用户全局** | `~/.claude/`     | 你的所有项目都生效，是你个人的配置偏好 |
| **项目级**  | `项目根目录/.claude/` | 只对当前项目生效，团队共享       |

> **重要结论**（[官方文档](https://code.claude.com/docs/en/best-practices#write-an-effective-claude-md)）：
>
>   - `~/.claude/CLAUDE.md` - 全局 CLAUDE.md 放在用户目录的 `.claude/` 下
>   - **`项目/CLAUDE.md`** - 项目级 CLAUDE.md 放在**项目根目录**，**不是**放在 `项目/.claude/CLAUDE.md`
>   - `项目/.claude/` - 只放 `rules/`、`skills/`、`hooks.json` 等项目级配置

一个典型的项目配置长这样：

``` 
你的项目/
├── CLAUDE.md                      # 项目级全局说明（在项目根目录，不在 .claude 里）
└── .claude/                       # 项目级配置目录
    ├── rules/                     # 编码规范规则目录
    │   ├── controller.md          # 某类文件/目录的规则
    │   ├── react-components.md    # 另一规则
    │   └── sql.md                 # ...
    ├── skills/                    # 技能（任务流程）目录
    │   └── create-api/            # 每个 skill 一个目录
    │       └── SKILL.md           # skill 定义文件（必需）
    ├── hooks.json                 # Hooks 配置文件
    ├── keybindings.json           # 自定义键盘快捷键
    └── agents/                    # 自定义 subagent 配置（可选）
```

-----

## 二、.claude/ 目录下各个文件/目录的作用

### 1\. `.claude/rules/` - 编码规范规则

**作用**：存放**局部场景**的编码规范。

| 特点                                | 说明                  |
|-----------------------------------|---------------------|
| **何时用**                           | 只有某个目录/某类文件才需要遵守的规则 |
| **作用范围**                          | 只在相关场景加载，不浪费上下文     |
| **类比**：就像「地方法规」，CLAUDE.md 是「国家法律」 |

**示例**：

`rules/react-components.md`：

``` markdown
# 规则：src/components/ 目录下的 React 组件

- 必须使用函数组件，不推荐使用 class 组件
- 优先使用 React hooks，不推荐 HOC 或 render props
- 保持组件提纯，数据获取逻辑尽量放在上层或自定义 hook
- 组件文件名使用 PascalCase
```

`rules/sql.md`：

``` markdown
# 规则：*.sql 文件

- 禁止使用 SELECT *，必须明确列出需要的字段
- 每个关键字独占一行
- 给复杂查询添加注释说明目的
- 禁止在生产环境使用 DELETE 不带 WHERE 条件
```

### 2\. `.claude/skills/` - 技能（任务流程）

**作用**：定义某类任务的**标准操作流程**，相当于给 Claude 一份「任务说明书」。

**结构**：每个 skill 是一个独立目录，必须包含 `SKILL.md`：

``` 
.claude/skills/create-api/
└── SKILL.md           # 必需：skill 定义
├── template.hbs        # 可选：模板文件
└── examples/          # 可选：示例
```

**何时用**：当某类任务有固定的步骤，不希望 AI 临场自由发挥时。比如：

- 创建新 API 接口的流程
- 调试问题的排查步骤
- 代码审查的检查清单
- 发布部署的 checklist

**示例**：

``` markdown
---
name: create-api
description: 创建新的 REST API 接口，遵循项目规范
---

## 目标
按照项目规范创建一个完整的 API 接口。

## 步骤

1. 创建 Controller 层文件
2. 创建 Service 层文件
3. 创建 Repository 层文件
4. 添加路由注册
5. 添加错误处理
6. 添加单元测试

## 输出

- 列出所有修改/创建的文件
- 说明 API 路径和方法
- 给出测试示例
```

skill 支持 YAML frontmatter 配置：

| 字段                               | 作用                                |
|----------------------------------|-----------------------------------|
| `name`                           | skill 名称，对应 `/name` 斜杠命令          |
| `description`                    | 描述，Claude 用它判断何时自动加载              |
| `disable-model-invocation: true` | 禁止 Claude 自动触发，只允许用户手动调用 `/skill` |
| `user-invocable: false`          | 从用户的 `/` 菜单隐藏，只允许 Claude 调用       |
| `context: fork`                  | 在独立的 subagent 中运行，不污染主会话上下文       |
| `allowed-tools`                  | 限制该 skill 可以使用哪些工具                |

> **官方文档**：<https://code.claude.com/docs/zh-CN/skills>

### 3\. `.claude/hooks.json` - 钩子（自动执行）

**作用**：在特定事件发生时**自动执行**命令或检查，类似 Git 的 pre-commit hook。

**类比**：就像 Husky，只不过绑的是 Claude Code 的事件生命周期，不是 Git 事件。

**何时用**：凡是「不应该靠 AI 自觉记住，应该系统自动检查」的事情，都适合用 hook。

**示例**：

``` json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "pattern": "*.rs",
        "hooks": [
          {
            "type": "command",
            "command": "cargo check 2>&1 | head -30",
            "statusMessage": "Running cargo check..."
          }
        ]
      },
      {
        "matcher": "Edit",
        "pattern": "*.{ts,tsx}",
        "hooks": [
          {
            "type": "command",
            "command": "pnpm eslint --fix {file}",
            "statusMessage": "Running ESLint..."
          }
        ]
      }
    ]
  }
}
```

**触发时机**：

| 时机             | 说明    |
|----------------|-------|
| `SessionStart` | 会话启动时 |
| `PreToolUse`   | 工具执行前 |
| `PostToolUse`  | 工具执行后 |

最常见的用法：

- 修改代码后自动跑 lint / typecheck
- 禁止修改敏感目录（拦住 AI 的修改）
- 会话开始时自动收集环境信息

### 4\. `.claude/keybindings.json` - 自定义键盘快捷键

**作用**：自定义快捷键绑定，用于终端模式下的快捷操作。

### 5\. `.claude/agents/` - 自定义 Subagent

**作用**：定义自定义的 subagent 配置，可以让特定任务在隔离的代理上下文中运行。

-----

## 三、根目录的 `CLAUDE.md`

虽然 `CLAUDE.md` 不在 `.claude/` 目录里，但它是 Claude Code 最重要的配置文件，这里一起说明。

**作用**：项目级的**全局合作协议**，放**长期成立、全局适用**的原则。

**适合放**：

- 项目是什么，技术栈是什么
- 默认构建/测试命令是什么
- 哪些目录是禁区，不要碰
- 完成任务前必须做什么检查
- 全局的编码偏好
- 合作方式（比如先给计划再动手）

**不适合放**：

- 某个目录专属的细粒度规则（那是 rules 的活）
- 一整页的项目百科（那是 README 的活）
- 某类任务的操作步骤（那是 skills 的活）

**示例**：

``` markdown
# CLAUDE.md - 项目合作约定

## 技术栈
- Node.js 20 + TypeScript 5
- React 18 + Vite
- PostgreSQL + Prisma
- pnpm（不要用 npm/yarn）

## 常用命令
- 开发：`pnpm dev`
- 构建：`pnpm build`
- 测试：`pnpm test`
- lint：`pnpm lint`

## 工作流
- 改动较大时，先说明计划，得到确认再开始编码
- 每次提交之前，确保 lint 和测试通过
- 不要修改 `src/generated/` 下的自动生成代码
- 涉及支付/用户信息改动，必须 double check 逻辑

## 代码风格
- 优先小函数、小文件，避免上千行的超大文件
- 不修改无关文件，每次聚焦一个问题
- 类型优先，给所有公共接口添加类型注解
```

-----

## 四、全局配置（用户级别） vs 项目配置

除了项目级的 `.claude/`，Claude Code 还有**用户全局配置**，放在你的用户目录下：

``` 
~/.claude/
├── CLAUDE.md                 # 全局规则，对所有项目生效
├── rules/                    # 全局规则
├── skills/                   # 全局 skills，所有项目都能用
├── settings.json            # 用户设置
├── keybindings.json         # 全局快捷键
└── projects/                # 每个项目的 AI 自动记忆
    └── project-path/
        └── memory/
```

**优先级**：`企业级 > 用户全局 > 项目级`，同名 skill 优先级高的覆盖优先级低的。

-----

## 五、什么时候该把信息固化到哪里？判断口诀

| 你的需求                         | 该放到哪里                           |
|------------------------------|---------------------------------|
| "这个原则**整个项目所有任务**都要遵守"       | → `CLAUDE.md`（根目录）              |
| "只有**这个目录/这类文件**才需要遵守这条规则"   | → `.claude/rules/xxx.md`        |
| "**这类任务**有一套固定做法，不能让 AI 乱发挥" | → `.claude/skills/xxx/SKILL.md` |
| "改完代码要**自动检查**，不能靠 AI 记住"    | → `.claude/hooks.json`          |
| "这个信息**我所有项目**都要用"           | → `~/.claude/` 下对应位置            |
| "只有**这个项目**才需要"              | → `.claude/` 下对应位置              |

### 判断流程图

``` 
是否全局长期成立？
  ├─ 是 → 放 CLAUDE.md
  └─ 否 → 是否只有局部场景才成立？
        ├─ 是 → 放 .claude/rules/
        └─ 否 → 是否是某类任务的固定流程？
              ├─ 是 → 放 .claude/skills/
              └─ 否 → 是否需要自动执行/拦截？
                    ├─ 是 → 放 .claude/hooks.json
                    └─ 否 → 再想想...
```

-----

## 六、完整示例：一个中等项目的配置

``` 
my-project/
├── CLAUDEmd
│   └── 项目全局约定：技术栈、命令、禁区
└── .claude/
    ├── rules/
    │   ├── frontend-components.md    # 前端组件规范
    │   ├── backend-go.md             # Go 后端规范
    │   └── sql-migrations.md         # 数据库迁移规范
    ├── skills/
    │   ├── create-api/SKILL.md       # 创建 API 流程
    │   └── debug-issue/SKILL.md       # 调试问题流程
    └── hooks.json
        └── 改完 TS 自动 lint，改完 Go 自动 go fmt
```

-----

## 七、常见误区

### 误区 1：把所有东西都塞进 CLAUDE.md

❌ 错误做法：

``` 
CLAUDE.md 写了几千字，包含所有目录的所有规则...
```

✅ 正确做法：

- CLAUDE.md 只放全局原则，保持精简
- 局部规则分到 `rules/` 下按文件拆分，只在相关场景加载

### 误区 2：把 skill 写成大段 prompt

❌ 错误做法：

``` 
---
name: myskill
description: xxx
---
帮我做一个什么什么功能...
（这里写了 500 字需求，其实这该你直接告诉 Claude，不该存在 skill 里）
```

✅ 正确做法： skill 是**流程说明书**，告诉 Claude "做这件事该按什么步骤来"，不是放具体某次任务的需求。

### 误区 3：用 skill 代替规则

❌ 错误：把 "React 组件必须用函数组件" 写进 skill 里

✅ 正确：这条是编码规则，放 `rules/react.md` 里，每次写组件都会生效。

### 误区 4：用规则代替 skill

❌ 错误：把 "创建 API 的步骤" 写进 `rules/api.md` 里

✅ 正确：这是任务流程，放 `skills/create-api/SKILL.md`。

-----

## 八、总结

| 配置项                    | 位置                   | 作用          | 类比           |
|------------------------|----------------------|-------------|--------------|
| **CLAUDE.md**          | 项目根目录                | 全局合作协议，长期原则 | 公司总章程        |
| **.claude/rules/**     | `.claude/rules/`     | 局部场景编码规范    | 地方法规         |
| **.claude/skills/**    | `.claude/skills/`    | 某类任务的标准操作流程 | SOP 操作手册     |
| **.claude/hooks.json** | `.claude/hooks.json` | 事件触发自动执行    | Husky Git 钩子 |
| **~/.claude/**         | 用户目录                 | 全局配置，所有项目共享 | 用户个人偏好       |

记住这个口诀：

> **全局原则 CLAUDE，局部规则 rules 放，任务流程 skills 装，自动检查 hooks 上**

这样配置之后，Claude 就能真正理解你的项目习惯，不再像个刚入职的实习生，而是一个熟悉你项目规范的 AI 同事。
