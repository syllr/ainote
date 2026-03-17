# Qwen Code MCP 安装指南

## 快速安装

### 方法一：使用自动安装脚本（推荐）

1. 运行安装脚本：
```bash
./install_to_qwen.sh
```

2. 按照提示输入你的 `ARK_API_KEY`

3. 重启 Qwen Code 即可使用

### 方法二：手动配置

1. 编辑或创建 `~/.qwen/mcp.json` 文件：
```json
{
  "mcpServers": {
    "volc-web-search": {
      "command": "/Users/yutao/ainote/.venv/bin/python",
      "args": [
        "/Users/yutao/ainote/volcsearch-mcp-python/main.py"
      ],
      "env": {
        "ARK_API_KEY": "你的ARK_API_KEY",
        "ARK_BASE_URL": "https://ark.cn-beijing.volces.com/api/v3",
        "ARK_MODEL": "doubao-seed-1-6-250615"
      }
    }
  }
}
```

2. 重启 Qwen Code

## 验证安装

重启 Qwen Code 后，你可以在对话中尝试使用：

```
搜索今天的科技热点新闻
```

如果 Qwen 能够返回最新的新闻信息，说明安装成功。

## 可用命令

### 查看已安装的MCP服务
```bash
qwen mcp list
```

### 重启MCP服务
```bash
qwen mcp restart volc-web-search
```

### 查看MCP服务日志
```bash
qwen mcp logs volc-web-search
```

## 常见问题

### 1. 服务无法启动
- 检查 `ARK_API_KEY` 是否正确
- 确认虚拟环境路径是否正确：`/Users/yutao/ainote/.venv/bin/python`
- 检查脚本路径是否正确：`/Users/yutao/ainote/volcsearch-mcp-python/main.py`

### 2. 搜索没有结果
- 确认你的API Key有web_search权限
- 检查网络是否可以访问火山引擎方舟服务
- 尝试使用 `search_depth: "advanced"` 获取更全面的结果

### 3. Qwen不调用搜索工具
- 重启 Qwen Code
- 明确在提问中说明需要搜索，例如："请搜索最新的Python 3.13新特性"

## 卸载服务

1. 删除 `~/.qwen/mcp.json` 中的 `volc-web-search` 配置项
2. 重启 Qwen Code

## 更新服务

```bash
cd /Users/yutao/ainote/volcsearch-mcp-python
git pull  # 如果使用git管理
# 或者手动更新main.py文件
qwen mcp restart volc-web-search
```