# ainote 项目全面概览报告

## 1. 项目整体结构和主要目录

这是一个组织良好的个人知识管理系统，结合了 Obsidian 本地编辑和 Jekyll GitHub Pages 在线展示功能。

### 项目根目录结构
```
/Users/yutao/ainote/
├── 00-System/              # 系统模板和 Obsidian 配置
├── 01-Journals/            # 日常日志
├── 02-Learning/            # 主题学习笔记（核心内容区）
├── 03-Code-Analysis/       # 代码分析笔记
├── 04-Projects/            # 项目相关笔记
├── 05-Permanent/           # 永久参考笔记
├── 06-Archive/             # 归档内容
├── _config.yml             # Jekyll 主配置文件
├── _includes/              # HTML 包含文件
├── _layouts/               # Jekyll 布局模板
├── assets/                 # 静态资源
├── .github/workflows/      # GitHub Actions 自动部署
├── skills/                 # 自定义 Agent Skills 仓库（Git 子模块）
├── plugin/                 # 插件相关
├── Gemfile                 # Ruby 依赖声明
├── README.md               # 项目说明
├── CLAUDE.md               # Claude Code 项目指南
└── index.md                # 网站首页
```

### 主要内容目录详解
- **00-System/**: 包含系统模板（如 Skill 开发模板）和附件目录
- **01-Journals/**: 按年/月/日组织的日常日志和 inbox
- **02-Learning/**: 主题学习笔记，包含以下子目录：
  - `claude/` - Claude Code 和 skill-creator 相关笔记（核心）
  - `codex/` - AI 编程相关
  - `opencode/` - OpenCode 相关
  - `zed/` - Zed 编辑器相关
  - `obsidian/` - Obsidian 使用相关
- **skills/**: 自定义 Agent Skills 仓库，遵循 Agent Skills 开放标准
- **03-Code-Analysis/**: 架构、设计模式和项目代码分析

---

## 2. 项目目的和功能

### 核心目的
这是一个**个人 Obsidian 知识笔记仓库**，通过 Jekyll + GitHub Pages 实现在线展示，主要聚焦于 **Claude Code 和 AI 工具开发的学习笔记**。

### 核心功能
1. **Obsidian 本地知识管理** - 使用 Obsidian 进行日常笔记编辑和知识链接
2. **GitHub Pages 在线展示** - 自动将 Markdown 笔记转换为静态网站
3. **Claude Code Skill 开发指南** - 提供完整的 skill-creator 使用教程和自定义 Skill 开发
4. **PlantUML 图表支持** - 支持在 Markdown 中嵌入 PlantUML 图表并自动渲染
5. **任务管理** - 集成 Obsidian Tasks 插件进行任务追踪（Tasks.md）

### 在线访问
- 网站地址: https://syllr.github.io/ainote/

---

## 3. 技术栈和依赖

### 核心技术栈
| 技术 | 版本/说明 | 用途 |
|------|----------|------|
| **Jekyll** | Ruby 静态网站生成器 | 将 Markdown 转换为 HTML |
| **GitHub Pages** | 官方托管服务 | 在线网站托管 |
| **GitHub Actions** | 自动 CI/CD | 推送到 main 分支时自动部署 |
| **Obsidian** | 个人知识管理工具 | 本地笔记编辑 |
| **PlantUML** | 图表绘制语言 | 技术图表渲染 |

### Ruby 依赖（Gemfile）
```ruby
gem "minima"                    # GitHub Pages 默认主题
gem "github-pages"              # GitHub Pages 官方依赖包
gem "jekyll-include-cache"      # 性能优化
gem "jekyll-spaceship"          # PlantUML 支持插件
```

### Jekyll 插件
- `jekyll-feed` - RSS 订阅
- `jekyll-seo-tag` - SEO 优化
- `jekyll-sitemap` - 站点地图生成
- `jekyll-spaceship` - PlantUML 图表渲染（核心功能）

### 其他工具
- **Agent Skills** - 开放技能生态标准（https://agentskills.io）
- **npx skills** - Skills 命令行管理工具

---

## 4. 主要配置文件

### 1. _config.yml - Jekyll 主配置
**位置**: `/Users/yutao/ainote/_config.yml`

关键配置项：
```yaml
# 基本信息
title: Claude 学习笔记
description: Claude Code skill-creator 完整指南和自定义 Skill 开发笔记
baseurl: "/ainote"
url: "https://syllr.github.io"

# 主题
theme: minima

# Markdown 处理
markdown: kramdown
kramdown:
  input: GFM                          # GitHub Flavored Markdown
  syntax_highlighter: rouge

# PlantUML 配置（jekyll-spaceship）
jekyll-spaceship:
  processors:
    - plantuml-processor              # 只启用 PlantUML 处理器
  plantuml-processor:
    mode: pre-fetch                   # 构建时预渲染缓存
    src: https://www.plantuml.com/plantuml/svg/

# 目录处理规则
exclude:
  - .obsidian/                        # 忽略 Obsidian 系统目录
  - .git/
  - .idea/
  # ... 更多忽略项
include:
  - 02-Learning/                      # 确保学习笔记被处理
```

### 2. Gemfile - Ruby 依赖
**位置**: `/Users/yutao/ainote/Gemfile`

声明了所有 Ruby gem 依赖，包括 Jekyll、主题和插件。

### 3. .github/workflows/jekyll-gh-pages.yml - 自动部署
**位置**: `/Users/yutao/ainote/.github/workflows/jekyll-gh-pages.yml`

**功能**:
- 监听 main 分支的推送
- 使用 Ruby 3.2 构建 Jekyll 网站
- 自动部署到 GitHub Pages
- 支持手动触发（workflow_dispatch）

### 4. CLAUDE.md - Claude Code 项目指南
**位置**: `/Users/yutao/ainote/CLAUDE.md`

为 Claude Code 提供项目特定的指令，包括：
- 项目概述和架构
- 常用 Jekyll 命令
- 关键配置要点
- Markdown 和 PlantUML 约定

### 5. .gitignore - Git 忽略规则
忽略 Obsidian 配置、IDE 配置、Python 虚拟环境、Jekyll 构建产物等。

---

## 5. 内容组织方式

### 数字前缀命名规则
所有内容目录使用**两位数字前缀**，确保按照逻辑顺序排列：
- `00-` 系统级
- `01-` 时间序列（日志）
- `02-` 学习内容
- `03-` 代码分析
- `04-` 项目
- `05-` 永久笔记
- `06-` 归档

### 核心内容结构

#### 02-Learning/ - 主题学习（核心）
每个子主题都有完整的结构化笔记：
```
02-Learning/
├── claude/
│   ├── skill-creator.md                    # skill-creator 完整指南（715 行）
│   ├── skill/
│   │   └── skill-prompt-create.md          # Skill 创建流程
│   ├── background-task.md
│   ├── markdown/
│   └── crawl/
├── zed/                                     # Zed 编辑器教程
│   ├── index.md
│   ├── installation.md
│   ├── getting-started.md
│   ├── ai-overview.md
│   └── ...
├── opencode/                                # OpenCode 系列教程（19+ 文件）
└── codex/                                   # Codex 相关
```

#### 01-Journals/ - 日志组织
按时间层级组织：
```
01-Journals/
├── 2026/
│   └── 03/
│       ├── 2026-03-18.md
│       ├── 2026-03-18-inbox.md
│       ├── 2026-03-19.md
│       └── ...
├── Daily/
├── Monthly/
└── Weekly/
```

#### skills/ - Agent Skills 仓库
作为 Git 子模块存在，遵循 Agent Skills 开放标准：
```
skills/
├── skills/              # 实际技能目录
├── improve/             # 技能改进相关笔记
├── test/                # 测试相关
├── README.md            # 用户说明
└── CLAUDE.md            # 开发指南
```

### Markdown 格式约定
- **GitHub Flavored Markdown (GFM)** - 兼容 Obsidian 和 Jekyll
- **表格对齐** - 所有竖线 | 对齐，便于阅读
- **PlantUML 代码块** - 使用 ` ```plantuml ` 语法，构建时自动渲染
- **YAML Frontmatter** - 可选的页面元数据

### 关键内容亮点
1. **skill-creator 完整指南** (`02-Learning/claude/skill-creator.md`) - 715 行详细文档
2. **Zed 编辑器教程** - 完整的安装、使用和 AI 功能指南
3. **OpenCode 系列** - 19+ 份详细文档
4. **任务管理面板** (`Tasks.md`) - 集成 Obsidian Tasks 的全局任务仪表盘

---

## 6. 常用开发命令

### 本地预览
```bash
bundle install                          # 安装依赖
bundle exec jekyll serve --livereload  # 启动本地服务器（支持实时刷新）
```

### 其他命令
```bash
bundle exec jekyll build                # 完整构建
bundle exec jekyll doctor               # 检查配置问题
bundle exec jekyll clean                # 清理构建缓存
bundle exec jekyll build --incremental  # 增量构建（开发时更快）
```

---

## 总结

这是一个**精心设计的个人知识管理系统**，完美结合了：
- **Obsidian** 的本地编辑和链接功能
- **Jekyll** 的静态网站生成能力
- **GitHub Pages** 的免费托管
- **GitHub Actions** 的自动部署
- **PlantUML** 的图表支持
- **Agent Skills** 的开放生态

项目主要聚焦于 **Claude Code 和 AI 工具开发**的学习笔记，特别是 `skill-creator` 的完整指南，同时也是一个通用的个人知识管理平台。
