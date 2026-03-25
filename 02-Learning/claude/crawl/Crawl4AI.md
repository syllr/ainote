# 🚀 Crawl4AI 部署和使用指南

> 开源 LLM 友好型网络爬虫与抓取工具，Firecrawl 的优秀开源替代

## 方式一：**本地直接安装（推荐开发测试）**

### 步骤 1：安装包

```bash
# 基础安装（仅核心功能，不包含大模型依赖）
pip install crawl4ai

# 如果需要文本聚类、语义分块（需要 PyTorch）
pip install crawl4ai[torch]

# 如果需要 Hugging Face 摘要/生成策略
pip install crawl4ai[transformer]

# 如果需要全部功能
pip install crawl4ai[all]
```

### 步骤 2：初始化设置（必须）

```bash
crawl4ai-setup
```

这个命令会：

- 安装浏览器依赖（Playwright）
- 检查操作系统缺失的库
- 确认环境准备就绪

### 步骤 3：验证安装（可选）

```bash
# 运行诊断检查
crawl4ai-doctor

# 预下载模型（仅使用高级LLM功能需要）
crawl4ai-download-models
```

### 步骤 4：第一个测试

```python
import asyncio
from crawl4ai import AsyncWebCrawler, BrowserConfig, CrawlerRunConfig


async def main():
    async with AsyncWebCrawler() as crawler:
        result = await crawler.arun(
            url="https://www.example.com",
        )
        print(result.markdown[:300])  # 显示前300个字符


if __name__ == "__main__":
    asyncio.run(main())
```

---

## 方式二：**Docker 部署（推荐服务端/生产使用）**

> ⚠️ 注意：v0.7.x 后 Docker 已经稳定，支持 MCP（模型上下文协议）可直接集成到 Claude Code。

### 选项 1：使用预构建镜像（最简单，推荐）

```bash
# 1. 拉取镜像
docker pull unclecode/crawl4ai:latest

# 2. 如果需要LLM功能，创建 .llm.env 文件添加API密钥
cat > .llm.env << EOL
OPENAI_API_KEY=sk-your-key
ANTHROPIC_API_KEY=your-anthropic-key
# DEEPSEEK_API_KEY=your-deepseek-key  # 国产模型也支持！
# GROQ_API_KEY=your-groq-key
EOL

# 3. 运行容器（不需要LLM可去掉 --env-file）
docker run -d \
    -p 11235:11235 \
    --name crawl4ai \
    --shm-size=1g \
    --env-file .llm.env \
    unclecode/crawl4ai:latest
```

服务启动后访问：

- `http://localhost:11235/playground` - 交互式测试界面
- `http://localhost:11235/health` - 健康检查
- `http://localhost:11235/crawl` - API 端点

### 选项 2：Docker Compose（适合开发）

```bash
# 1. 克隆仓库
git clone https://github.com/unclecode/crawl4ai.git
cd crawl4ai

# 2. 配置API密钥
cp deploy/docker/.llm.env.example .llm.env
# 编辑 .llm.env 添加你的API密钥

# 3. 运行（使用预构建镜像）
IMAGE=unclecode/crawl4ai:latest docker compose up -d

# 或本地构建
docker compose up --build -d

# 停止服务
docker compose down
```

### 选项 3：本地手动构建

```bash
git clone https://github.com/unclecode/crawl4ai.git
cd crawl4ai

# 创建 .llm.env （同上）

# 构建镜像
docker buildx build -t crawl4ai-local:latest --load .

# 运行容器
docker run -d \
    -p 11235:11235 \
    --name crawl4ai-local \
    --shm-size=1g \
    --env-file .llm.env \
    crawl4ai-local:latest
```

### 停止容器

```bash
docker stop crawl4ai && docker rm crawl4ai
```

---

## 🔌 集成 Claude Code via MCP

当你用 Docker 部署 Crawl4AI 后，可以直接添加为 Claude Code 的 MCP 工具：

```bash
# 添加 Crawl4AI MCP 服务
claude mcp add --transport sse c4ai-sse http://localhost:11235/mcp/sse

# 验证
claude mcp list
```

添加后 Claude Code 可以直接使用这些工具：

| 工具           | 功能             |
|--------------|----------------|
| `md`         | 从网页生成 Markdown |
| `html`       | 提取预处理 HTML     |
| `screenshot` | 捕获网页截图         |
| `pdf`        | 生成 PDF 文档      |
| `execute_js` | 执行 JavaScript  |
| `crawl`      | 多 URL 爬取       |

---

## 基础使用示例

### 简单爬取

```python
import asyncio
from crawl4ai import AsyncWebCrawler


async def main():
    async with AsyncWebCrawler(verbose=True) as crawler:
        result = await crawler.arun(url="https://en.wikipedia.org/wiki/Machine_learning")
        print("markdown length:", len(result.markdown))
        print(result.markdown[:500])


if __name__ == "__main__":
    asyncio.run(main())
```

### 带配置爬取

```python
import asyncio
from crawl4ai import (
    AsyncWebCrawler,
    BrowserConfig,
    CrawlerRunConfig,
    CacheMode
)


async def main():
    browser_config = BrowserConfig(
        headless=True,
        verbose=True
    )

    crawler_config = CrawlerRunConfig(
        cache_mode=CacheMode.BYPASS,
        verbose=True
    )

    async with AsyncWebCrawler(config=browser_config) as crawler:
        result = await crawler.arun(
            url="https://github.com/unclecode/crawl4ai",
            config=crawler_config
        )
        print(result.markdown)


if __name__ == "__main__":
    asyncio.run(main())
```

### 使用 Docker API 调用（Python SDK）

```python
import asyncio
from crawl4ai.docker_client import Crawl4aiDockerClient
from crawl4ai import BrowserConfig, CrawlerRunConfig, CacheMode


async def main():
    async with Crawl4aiDockerClient(base_url="http://localhost:11235") as client:
        results = await client.crawl(
            ["https://example.com"],
            browser_config=BrowserConfig(headless=True),
            crawler_config=CrawlerRunConfig(cache_mode=CacheMode.BYPASS)
        )
        for result in results:
            print(f"URL: {result.url}, 成功: {result.success}")
            print(result.markdown[:300])


if __name__ == "__main__":
    asyncio.run(main())
```

---

## 📊 关键信息总结

| 项目         | 说明                                                 |
|------------|----------------------------------------------------|
| **默认端口**   | `11235`                                            |
| **最低要求**   | Docker ≥ 20.10.0，内存 ≥ 4GB                          |
| **架构支持**   | `linux/amd64` 和 `linux/arm64`（Apple Silicon 原生支持）✓ |
| **GPU 支持** | 可通过 `ENABLE_GPU=true` 启用                           |
| **国产 LLM** | 支持 DeepSeek、字节豆包等，只需配置对应的 API 密钥                   |
| **监控**     | Prometheus 端点 `/metrics`                           |

---

## 有用的链接

- [GitHub 仓库](https://github.com/unclecode/crawl4ai)
- [官方文档](https://crawl4ai.docslib.dev/)
- [Playground](http://localhost:11235/playground)（本地部署后）
