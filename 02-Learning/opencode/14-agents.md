# OpenCode 代理系统

OpenCode 代理配置和使用详解。

## 概述

OpenCode 的代理系统允许您为不同的任务配置专门的 AI 助手。

## 什么是代理

代理是具有特定指令和配置的 AI 助手，可以：
- 理解项目的代码规范
- 遵循特定的编码风格
- 专注于特定类型的任务
- 使用预设的工具和权限

## AGENTS.md 文件

OpenCode 使用 `AGENTS.md` 文件来定义项目的代理配置。

### 初始化项目

运行 `/init` 命令来创建初始的 `AGENTS.md` 文件：

```
/init
```

### AGENTS.md 结构

```markdown
# 项目代理配置

## 默认代理

这是项目的默认代理，用于一般任务。

### 指令

- 遵循项目的代码规范
- 编写清晰、可维护的代码
- 添加适当的注释和文档
- 遵循测试驱动开发

### 代码规范

- 使用 2 空格缩进
- 函数名使用驼峰命名法
- 类名使用大驼峰命名法
- 常量使用全大写下划线分隔

## 专用代理

### 前端代理

专注于前端开发任务。

#### 指令

- 使用 React 和 TypeScript
- 遵循组件最佳实践
- 使用 Tailwind CSS 进行样式
- 确保响应式设计

### 后端代理

专注于后端开发任务。

#### 指令

- 使用 Node.js 和 Express
- 遵循 RESTful API 设计
- 使用 Prisma 进行数据库操作
- 添加适当的错误处理

### 数据库代理

专注于数据库相关任务。

#### 指令

- 编写高效的 SQL 查询
- 遵循数据库设计规范
- 考虑性能优化
- 添加适当的索引
```

## 配置代理

### 在 opencode.json 中配置

您可以在 `opencode.json` 配置文件中定义代理：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agents": {
    "default": {
      "name": "默认代理",
      "description": "用于一般任务的默认代理",
      "instructions": [
        "遵循项目的代码规范",
        "编写清晰、可维护的代码"
      ],
      "model": "openai:gpt-4-turbo"
    },
    "frontend": {
      "name": "前端代理",
      "description": "专注于前端开发",
      "instructions": [
        "使用 React 和 TypeScript",
        "遵循组件最佳实践"
      ],
      "model": "openai:gpt-4-turbo"
    },
    "backend": {
      "name": "后端代理",
      "description": "专注于后端开发",
      "instructions": [
        "使用 Node.js 和 Express",
        "遵循 RESTful API 设计"
      ],
      "model": "anthropic:claude-3-sonnet"
    }
  }
}
```

## 默认代理

您可以配置默认使用的代理：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agents": {
    "default": {
      "name": "默认代理",
      "instructions": ["你的指令"]
    }
  },
  "defaultAgent": "default"
}
```

## 代理指令

代理指令是代理行为的核心。

### 指令类型

1. **代码规范** - 编码风格、命名约定等
2. **技术栈** - 使用的框架、库、工具等
3. **工作流程** - 开发流程、测试要求等
4. **项目特定** - 项目特有的约定和知识

### 编写好的指令

```markdown
### 指令

#### 代码风格
- 使用 4 空格缩进，不要使用 tabs
- 行长度限制在 100 字符以内
- 使用单引号而不是双引号
- 总是添加分号

#### 架构原则
- 遵循 MVC 模式
- 保持函数简洁，每个函数只做一件事
- 优先使用组合而不是继承
- 依赖注入而非硬编码依赖

#### 测试要求
- 新功能必须包含单元测试
- 测试覆盖率至少 80%
- 使用 Jest 作为测试框架
- 测试应该独立且可重复

#### 文档标准
- 公共 API 必须有 JSDoc 注释
- 复杂算法需要解释其工作原理
- README 更新以反映重大变更
- 添加使用示例

#### 性能考虑
- 避免在循环中进行数据库查询
- 使用缓存来提高响应速度
- 优化 N+1 查询问题
- 使用适当的数据结构
```

## 切换代理

在 TUI 中，您可以随时切换代理：

```
/agent frontend
```

或者使用代理选择器来查看和选择可用代理。

## 代理特定配置

每个代理可以有自己的：

- **模型** - 使用特定的 LLM 模型
- **工具** - 启用/禁用特定工具
- **权限** - 自定义权限设置
- **主题** - 不同的视觉主题

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agents": {
    "cautious": {
      "name": "谨慎代理",
      "instructions": ["谨慎行事，确认每个步骤"],
      "model": "openai:gpt-4-turbo",
      "permission": {
        "edit": "ask",
        "bash": "ask",
        "write": "ask"
      }
    },
    "fast": {
      "name": "快速代理",
      "instructions": ["快速完成任务，使用简洁的方法"],
      "model": "openai:gpt-3.5-turbo",
      "permission": {
        "*": "allow"
      }
    }
  }
}
```

## 项目特定知识

在 AGENTS.md 中包含项目特定的知识：

```markdown
## 项目特定知识

### 目录结构
- `src/` - 源代码
  - `components/` - React 组件
  - `hooks/` - 自定义 hooks
  - `utils/` - 工具函数
- `tests/` - 测试文件
- `docs/` - 文档

### 重要文件
- `src/config.ts` - 应用配置
- `src/routes.ts` - 路由定义
- `prisma/schema.prisma` - 数据库 schema

### 常用命令
- `npm run dev` - 启动开发服务器
- `npm run test` - 运行测试
- `npm run build` - 构建生产版本
- `npx prisma studio` - 打开 Prisma Studio

### 环境变量
- `DATABASE_URL` - 数据库连接字符串
- `API_KEY` - 外部 API 密钥
- `DEBUG_MODE` - 启用调试日志
```

## 团队协作

将 AGENTS.md 提交到版本控制，这样整个团队可以：
- 共享相同的代理配置
- 保持一致的代码规范
- 减少沟通成本
- 加快新成员上手速度

## 最佳实践

1. **定期更新** - 随着项目发展更新代理指令
2. **保持简洁** - 指令应该清晰、具体、可操作
3. **分类组织** - 使用标题和部分组织相关指令
4. **示例驱动** - 包含代码示例来说明预期
5. **迭代改进** - 根据使用反馈调整代理配置

## 更多信息

有关代理系统的更多信息，请访问：
- OpenCode 官方文档：https://opencode.ai/docs/zh-cn/agents/
