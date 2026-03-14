# Volcengine Ark Web Search MCP Service

基于火山引擎方舟（Ark）豆包大模型的联网搜索功能实现的 MCP (Model Context Protocol) 服务，让大模型可以调用实时联网搜索能力。

## 功能特性

- ✅ 简单易用的Python实现，无需复杂配置
- ✅ 支持实时联网搜索，获取最新信息
- ✅ 可配置搜索结果数量和搜索深度
- ✅ 兼容MCP协议，可直接在Cursor、Claude等支持MCP的客户端中使用
- ✅ 自动处理API签名和请求

## 前置要求

1. Python >= 3.10
2. 火山引擎方舟API Key
3. 开通了豆包大模型的web_search功能权限

## 安装

1. 安装依赖：
```bash
pip install -r requirements.txt
```

2. 配置环境变量：
```bash
cp .env.example .env
```

编辑 `.env` 文件，填入你的方舟API Key：
```env
ARK_API_KEY=your_ark_api_key_here
ARK_BASE_URL=https://ark.cn-beijing.volces.com/api/v3
ARK_MODEL=doubao-seed-1-6-250615
```

## 获取API Key

1. 登录火山引擎控制台
2. 进入方舟大模型服务平台
3. 创建API Key，参考文档：https://www.volcengine.com/docs/82379/1399008

## MCP 配置

在你的MCP客户端配置文件中添加以下配置：

### macOS (Cursor)
配置文件路径：`~/Library/Application Support/Cursor/User/globalStorage/microsoft.ai.mcp.json`

```json
{
  "mcpServers": {
    "volc-web-search": {
      "command": "python3",
      "args": ["/path/to/volcsearch-mcp-python/main.py"],
      "env": {
        "ARK_API_KEY": "your_ark_api_key_here"
      }
    }
  }
}
```

### Windows
配置文件路径：`%APPDATA%\Cursor\User\globalStorage\microsoft.ai.mcp.json`

```json
{
  "mcpServers": {
    "volc-web-search": {
      "command": "python.exe",
      "args": ["C:\\path\\to\\volcsearch-mcp-python\\main.py"],
      "env": {
        "ARK_API_KEY": "your_ark_api_key_here"
      }
    }
  }
}
```

## 可用工具

### volc_web_search

火山引擎豆包AI联网搜索工具，可以搜索最新的新闻、信息、热点事件等。

**参数：**
- `query` (必填): 要搜索的查询关键词
- `max_keyword` (可选): 最多返回的搜索结果数量，默认2，范围1-10
- `search_depth` (可选): 搜索深度，可选值：
  - `basic`: 基础搜索（默认）
  - `advanced`: 深度搜索，获取更全面的结果

**使用示例：**

```
搜索最近的科技新闻，返回5条结果
```

模型会自动调用工具：
```json
{
  "name": "volc_web_search",
  "parameters": {
    "query": "最近的科技新闻",
    "max_keyword": 5,
    "search_depth": "basic"
  }
}
```

## 测试运行

你可以直接运行脚本测试是否正常工作：

```bash
python main.py
```

如果没有报错说明配置正确。

## 常见问题

### 1. 提示缺少权限
确保你的方舟API Key已经开通了对应模型的web_search功能权限。

### 2. API调用失败
检查API Key是否正确，网络是否可以访问火山引擎方舟服务。

### 3. 搜索结果不实时
豆包的web_search功能默认会返回最近的信息，对于实时性要求高的内容可以使用`search_depth: "advanced"`。

## 相关文档

- [火山引擎方舟文档](https://www.volcengine.com/docs/82379)
- [MCP协议文档](https://modelcontextprotocol.io/)

## License

MIT
