# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this repository.

## Overview

这是一个个人知识笔记仓库，使用 **Obsidian** 本地编辑，通过 **Jekyll** 发布到 **GitHub Pages** 在线展示。核心内容是关于 Claude Code 和 AI 工具开发的学习笔记，特别是 `skill-creator` 技能开发的完整指南。

在线阅读：https://syllr.github.io/ainote/

## 内容组织

内容按数字前缀顺序组织（遵循仓库目录命名的排序规则）：
- `00-System/` - 系统模板和 Obsidian 配置
- `01-Journals/` - 日常日志
- `02-Learning/` - 主题学习笔记，主要是 Claude Code 及相关 AI 工具开发内容
  - `02-Learning/claude/skill-creator.md` - Claude Code skill-creator 完整指南（核心文档）
- `03-Code-Analysis/` - 代码分析笔记
- `04-Projects/` - 项目相关笔记
- `05-Permanent/` - 永久参考笔记
- `06-Archive/` - 归档内容

## 技术栈

- **格式**: Markdown (GFM)，同时兼容 Obsidian 和 Jekyll
- **构建**: Jekyll (Ruby)
- **部署**: GitHub Pages via GitHub Actions（自动部署）
- **图表支持**: PlantUML 图表（通过 jekyll-spaceship 远程渲染，无需本地安装）
- **主题**: 使用 GitHub Pages 默认 minima 主题

## 常用命令

### 本地预览
```bash
# 安装依赖（首次使用或更新 Gemfile 后）
bundle install

# 启动本地开发服务器，支持 LiveReload 实时刷新
bundle exec jekyll serve --livereload
```
启动后访问 http://localhost:4000/ainote/ 预览。

### 完整构建
```bash
# 生成完整静态网站到 _site 目录
bundle exec jekyll build
```

### 检查配置问题
```bash
# 诊断 Jekyll 配置问题
bundle exec jekyll doctor
```

### 清理构建缓存
```bash
# 清理 _site 和 .jekyll-cache 目录
bundle exec jekyll clean
```

### 增量构建（开发时更快）
```bash
# 增量构建，只重新生成修改过的文件
bundle exec jekyll build --incremental
```

## 架构

### 仓库结构

```
ainote/
├── _config.yml             # Jekyll 主配置（包含 PlantUML 设置）
├── _includes/              # HTML 包含文件
├── _layouts/               # Jekyll 布局模板
├── assets/                 # 静态资源（图片、CSS、JS）
├── .github/workflows/      # GitHub Actions 自动部署工作流
├── 00-System/              # 系统模板
├── 01-Journals/            # 日常日志
├── 02-Learning/            # 主题学习笔记
│   └── claude/             # Claude Code 专门笔记
├── 03-Code-Analysis/       # 代码分析笔记
├── 04-Projects/           # 项目相关笔记
├── 05-Permanent/           # 永久参考笔记
├── 06-Archive/            # 归档内容
├── Gemfile                 # Ruby 依赖声明
└── README.md               # 项目说明
```

### 关键配置要点

- `_config.yml` 中 `exclude` 列表排除了 Obsidian 系统目录和私有文件
- `include` 允许处理笔记目录，确保内容能被 Jekyll 处理
- `jekyll-spaceship` 只启用 `plantuml-processor`，禁用其他不需要的处理器（表格/Mermaid等）
- PlantUML 使用官方远程服务器 `https://www.plantuml.com/plantuml/svg/` 渲染 SVG，无需本地 Java

## 关键约定

- 所有笔记使用 **Markdown** 编写
- Markdown 表格采用对齐格式，所有竖线 `|` 在源代码中对齐，便于编辑和阅读
- PlantUML 图表使用 ````plantuml ` 代码块格式，构建时自动渲染
- 仓库是公开的，**绝对不能提交任何敏感信息**（API 密钥、凭证、个人隐私）
- 新增笔记时，需要确保文件名使用小写字母和连字符，避免空格和特殊字符
