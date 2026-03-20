# ainote

我的个人 Obsidian 知识笔记仓库，同时通过 GitHub Pages 在线展示。

## 在线阅读

https://[your-username].github.io/ainote/

## 内容导航

- [Claude Code 中的 skill-creator 完整指南](./02-Learning/claude/skill-creator.md) - 详细介绍 skill-creator 的使用方法、完整工作流程、实战案例

## 技术说明

本仓库使用 **Jekyll + GitHub Pages** 构建：

- `_config.yml` - Jekyll 配置
- `Gemfile` - Ruby 依赖
- `.github/workflows/jekyll-gh-pages.yml` - GitHub Actions 自动部署
- 支持 GitHub Flavored Markdown (GFM)，兼容 Obsidian 的 Markdown 语法

## 本地预览

```bash
# 安装 Ruby 和 Bundler 之后
bundle install
bundle exec jekyll serve --livereload
```

然后打开 http://localhost:4000/ainote/ 即可预览。
