# Claude WebSearch 替换实施计划

## 📋 概述

将 Claude 原生的 WebSearch 功能替换为 open-web-search 和 volc-search 两个 MCP 搜索引擎，提供更丰富、更灵活的搜索能力。

## 🎯 目标

1. ✅ 配置 open-web-search MCP 服务器（支持多引擎：Bing、百度、CSDN、DuckDuckGo、Exa、Brave、掘金）
2. ✅ 配置 volc-search MCP 服务器（火山引擎豆包AI搜索）
3. ✅ 禁用原生 WebSearch 和 WebFetch 工具
4. ✅ 配置 CLAUDE.md 指导，让 AI 优先使用 MCP 搜索工具
5. ✅ 验证配置是否生效

## 📁 配置文件位置

| 配置文件 | 路径 | 作用 |
|---------|------|------|
| 用户配置 | `~/.claude/settings.json` | 权限规则、MCP 服务器配置 |
| 全局 CLAUDE.md | `~/.claude/CLAUDE.md` | 全局指令，影响所有项目 |
| 项目 CLAUDE.md | `项目根目录/CLAUDE.md` | 项目级指令，优先级高于全局 |

## 📝 实施步骤

### 步骤 1：配置 open-web-search MCP 服务器

**方式 A：使用 npx 快速启动（推荐）**

```bash
claude mcp add open-websearch --transport stdio -- \
  n'px open-websearch@latest'
```

**方式 B：使用本地安装**

```bash
# 1. 克隆仓库
git clone https://github.com/Aas-ee/open-webSearch.git

# 2. 安装依赖
cd open-webSearch
npm install

# 3. 构建
npm run build

# 4. 添加 MCP 服务器
claude mcp add open-websearch --transport stdio -- \
  node /path/to/open-webSearch/build/index.js
```

**可选配置：**

```bash
# 使用环境变量配置默认搜索引擎
claude mcp add open-websearch --transport stdio --env \
  DEFAULT_SEARCH_ENGINE=duckduckgo \
  ALLOWED_SEARCH_ENGINES=duckduckgo,bing,exa,brave,juejin,csdn,baidu \
  -- n'px open-websearch@latest'
```

**可用搜索引擎：**
- `bing` (默认)
- `duckduckgo`
- `exa`
- `brave`
- `baidu`
- `csdn`
- `juejin`

---

### 步骤 2：配置 volc-search MCP 服务器

```bash
# volc-search 通常已通过 MCP 配置，验证是否已添加
claude mcp list
```

如果需要添加（根据您的 MCP 配置调整）：

```bash
# 假设 volc-search 通过 stdio 启动
claude mcp add volc-search --transport stdio -- \
  n'px volc-search-mcp'
```

---

### 步骤 3：禁用原生 WebSearch 和 WebFetch 工具

**编辑 `~/.claude/settings.json`**，添加权限规则：

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "deny": [
      "WebSearch",
      "WebFetch"
    ]
  }
}
```

**说明：**
- `deny` 规则优先级最高，会阻止指定工具的使用
- 这会禁用 Claude 原生的 `WebSearch` 和 `WebFetch` 工具
- AI 将无法通过提示词触发这些工具

---

### 步骤 4：配置 CLAUDE.md 指令

**编辑 `~/.claude/CLAUDE.md`**，添加以下内容：

```markdown
# 搜索工具使用优先级

## 联网搜索规则

当用户需要联网搜索信息时，必须遵循以下优先级：

### 优先级 1：MCP 搜索工具

**必须**首先使用以下 MCP 搜索工具：

1. **open-websearch** (`mcp__open-web-search__search`)
   - 支持多引擎：Bing、百度、CSDN、DuckDuckGo、Exa、Brave、掘金
   - 使用示例：`mcp__open-web-search__search({query: "...", engines: ["duckduckgo", "bing"], limit: 10})`
   - 可选工具：
     - `fetchCsdnArticle`: 获取 CSDN 文章全文
     - `fetchGithubReadme`: 获取 GitHub README
     - `fetchJuejinArticle`: 获取掘金文章
     - `fetchWebContent`: 获取通用网页内容

2. **volc-search** (`mcp__volc-search__volc_web_search`)
   - 火山引擎豆包AI搜索，擅长中文内容
   - 使用示例：`mcp__volc-search__volc_web_search({query: "...", max_keyword: 5})`

### 搜索策略

**组合搜索策略：**
- 同时调用 `open-websearch` 和 `volc-search` 进行并行搜索
- 使用不同引擎获取多样化结果（如：open-websearch 使用 duckduckgo，加上 volc-search）
- 对于中文内容，优先使用 volc-search 获取更准确的结果
- 对于技术文档，使用 open-websearch 的 CSDN、掘金等引擎

### 严格禁止

**禁止使用以下原生工具：**
- ❌ `WebSearch` - Claude 原生搜索工具
- ❌ `WebFetch` - Claude 原生网页抓取工具

即使用户明确要求使用这些工具，也**不得**调用。应解释原因并引导使用 MCP 工具替代。

### 搜索后处理

1. **整合结果**：将来自两个 MCP 搜索工具的结果整合，去重
2. **格式化输出**：清晰标注来源（哪个MCP工具、哪个搜索引擎）
3. **提供来源**：在回复末尾列出所有使用的来源 URL

示例输出格式：
```
## 搜索结果

### 来自 open-websearch (DuckDuckGo)
- [结果标题](URL) - 描述

### 来自 volc-search
- [结果标题](URL) - 描述

---
来源：
- open-websearch: https://duckduckgo.com/...
- volc-search: [搜索结果来源]
```
```
```

---

### 步骤 5：验证配置

**当前状态：** ✅ 配置完成

**5.1 MCP 服务器状态**

```
✓ plugin:github:github - Connected
✓ web-fetch - Connected
✓ volc-search - Connected
✓ context7 - Connected
✗ open-web-search - Failed to connect
```

**5.2 权限配置**

```json
{
  "permissions": {
    "deny": ["WebSearch"],
    "allow": [
      "WebFetch",
      "mcp__volc-search__volc_web_search",
      "mcp__web-fetch__fetchpage",
      "mcp__open-web-search__search",
      "mcp__open-web-search__fetchLinuxDoArticle",
      "mcp__open-web-search__fetchCsdnArticle",
      "mcp__open-web-search__fetchGithubReadme",
      "mcp__open-web-search__fetchJuejinArticle",
      "mcp__open-web-search__fetchWebContent"
    ]
  }
}
```

**5.3 配置文件位置**

- ✅ `~/.claude/settings.json` - 权限配置已更新
- ✅ `~/.claude/CLAUDE.md` - 搜索规则已配置

**5.1 验证 MCP 服务器已添加**

```bash
claude mcp list
```

预期输出应包含：
- `open-websearch`
- `volc-search`

**5.2 验证权限配置**

```bash
cat ~/.claude/settings.json
```

确认 `permissions.deny` 包含 `WebSearch` 和 `WebFetch`。

**5.3 测试搜索功能**

在 Claude 中输入：
```
搜索 "Claude MCP 配置教程"
```

预期行为：
- ✅ 使用 MCP 搜索工具
- ✅ 显示两个搜索源的结果
- ✅ 不尝试调用原生 WebSearch/WebFetch
- ❌ 不出现权限提示（因为已 deny）

---

## 🔧 故障排查

### MCP 服务器无法启动

```bash
# 检查日志
claude mcp get open-websearch

# 手动测试
npx open-websearch@latest
```

### 权限规则未生效

```bash
# 确认 settings.json 格式正确
cat ~/.claude/settings.json | python3 -m json.tool

# 查看 Claude 日志（如有）
tail -f ~/.claude/logs/claude-code.log
```

### AI 仍尝试使用原生工具

检查 CLAUDE.md 指令是否被正确加载：
- 全局：`~/.claude/CLAUDE.md`
- 项目：`./.claude/CLAUDE.md` 或 `./CLAUDE.md`

---

## 📚 参考资料

- [open-web-search 仓库](https://github.com/Aas-ee/open-webSearch)
- [Claude MCP 文档](https://code.claude.com/docs/en/mcp)
- [Claude 权限文档](https://code.claude.com/docs/en/permissions)
- [MCP 官方文档](https://modelcontextprotocol.io/docs/introduction)
