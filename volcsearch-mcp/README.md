# VolcSearch MCP Service

火山引擎云搜索服务的 MCP (Model Context Protocol) 服务实现，让大模型可以直接调用火山引擎搜索接口进行数据查询。

## 功能特性

- ✅ 完整的 Elasticsearch 查询 DSL 支持
- ✅ 简单搜索（query_string 语法）
- ✅ 字段匹配搜索
- ✅ 文档ID查询
- ✅ 文档计数
- ✅ 自动API签名认证
- ✅ 类型安全的参数校验
- ✅ 完整的错误处理

## 前置要求

1. Node.js >= 18
2. 火山引擎账号
3. 已创建的云搜索服务实例
4. 访问密钥（Access Key / Secret Key）

## 安装

```bash
npm install
```

## 配置

1. 复制环境变量示例文件：
```bash
cp .env.example .env
```

2. 编辑 `.env` 文件，填入你的配置信息：
```env
VOLC_ACCESS_KEY=你的火山引擎Access Key
VOLC_SECRET_KEY=你的火山引擎Secret Key
VOLC_REGION=cn-beijing  # 替换为你的区域
VOLC_SEARCH_DOMAIN=你的搜索实例域名  # 例如: es-cn-xxxx.volces.com
VOLC_SERVICE=es
VOLC_API_VERSION=2018-01-01
```

## 构建

```bash
npm run build
```

## 运行

### 开发模式
```bash
npm run dev
```

### 生产模式
```bash
npm start
```

## 可用工具

### 1. volcsearch_search
执行自定义 Elasticsearch 查询，支持完整的 Query DSL。

**参数：**
- `index` (必填): 要查询的索引名
- `query` (必填): Elasticsearch Query DSL 对象
- `from` (可选): 起始偏移量，默认 0
- `size` (可选): 返回结果数量，默认 10
- `sort` (可选): 排序配置
- `_source` (可选): 要返回的字段列表
- `highlight` (可选): 高亮配置

**示例：**
```json
{
  "name": "volcsearch_search",
  "arguments": {
    "index": "articles",
    "query": {
      "match": {
        "title": "人工智能"
      }
    },
    "size": 20,
    "_source": ["title", "content", "author"]
  }
}
```

### 2. volcsearch_simple_search
使用 query_string 语法进行简单搜索。

**参数：**
- `index` (必填): 要查询的索引名
- `q` (必填): 查询字符串
- `size` (可选): 返回结果数量，默认 10

**示例：**
```json
{
  "name": "volcsearch_simple_search",
  "arguments": {
    "index": "articles",
    "q": "title:人工智能 AND author:张三",
    "size": 10
  }
}
```

### 3. volcsearch_match_search
对指定字段进行全文搜索。

**参数：**
- `index` (必填): 要查询的索引名
- `field` (必填): 要搜索的字段名
- `query` (必填): 搜索文本
- `size` (可选): 返回结果数量，默认 10

**示例：**
```json
{
  "name": "volcsearch_match_search",
  "arguments": {
    "index": "articles",
    "field": "content",
    "query": "大模型应用开发",
    "size": 15
  }
}
```

### 4. volcsearch_get_document
根据文档ID获取文档详情。

**参数：**
- `index` (必填): 索引名
- `id` (必填): 文档ID

**示例：**
```json
{
  "name": "volcsearch_get_document",
  "arguments": {
    "index": "articles",
    "id": "12345"
  }
}
```

### 5. volcsearch_count
统计符合条件的文档数量。

**参数：**
- `index` (必填): 索引名
- `query` (可选): Query DSL 过滤条件

**示例：**
```json
{
  "name": "volcsearch_count",
  "arguments": {
    "index": "articles",
    "query": {
      "range": {
        "publish_date": {
          "gte": "2024-01-01"
        }
      }
    }
  }
}
```

## MCP 配置示例

在你的 MCP 客户端配置文件中添加：

```json
{
  "mcpServers": {
    "volcsearch": {
      "command": "node",
      "args": ["/path/to/volcsearch-mcp/dist/index.js"],
      "env": {
        "VOLC_ACCESS_KEY": "your_access_key",
        "VOLC_SECRET_KEY": "your_secret_key",
        "VOLC_REGION": "cn-beijing",
        "VOLC_SEARCH_DOMAIN": "your-es-domain.volces.com"
      }
    }
  }
}
```

## 权限说明

确保你的 Access Key 具有以下权限：
- `es:Search*`
- `es:Get*`
- `es:Count*`

## 常见问题

### 签名错误
检查以下配置是否正确：
- Access Key 和 Secret Key 是否正确
- 区域（region）是否与实例所在区域一致
- 服务域名是否正确

### 连接超时
- 检查搜索实例是否启用了公网访问
- 检查安全组是否允许你的IP访问
- 确认域名和端口是否正确

### 权限不足
检查 IAM 策略是否包含了必要的 ES 操作权限。

## License

MIT
