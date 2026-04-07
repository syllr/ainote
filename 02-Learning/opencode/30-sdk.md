# OpenCode SDK 使用指南

使用 OpenCode SDK 开发自定义集成和扩展。

## 概述

OpenCode SDK 允许您以编程方式与 OpenCode 交互，创建自定义集成、工具和应用程序。

## 安装 SDK

### Node.js

```bash
npm install @opencode/sdk
# 或
yarn add @opencode/sdk
# 或
pnpm add @opencode/sdk
```

### Go

```bash
go get github.com/anomalyco/opencode/sdk
```

## 快速开始

### Node.js 示例

```javascript
import { OpenCode } from '@opencode/sdk';

// 初始化客户端
const opencode = new OpenCode({
  apiKey: 'your-api-key',
  // 或使用环境变量
  // apiKey: process.env.OPENCODE_API_KEY
});

// 发送消息
async function main() {
  const response = await opencode.chat({
    messages: [
      {
        role: 'user',
        content: '给我一个简单的 JavaScript 函数示例'
      }
    ]
  });
  
  console.log(response.message);
}

main();
```

### Go 示例

```go
package main

import (
	"context"
	"fmt"
	"log"

	"github.com/anomalyco/opencode/sdk"
)

func main() {
	// 初始化客户端
	client, err := sdk.NewClient(
		sdk.WithAPIKey("your-api-key"),
	)
	if err != nil {
		log.Fatal(err)
	}

	// 发送消息
	ctx := context.Background()
	response, err := client.Chat(ctx, &sdk.ChatRequest{
		Messages: []*sdk.Message{
			{
				Role:    "user",
				Content: "给我一个简单的 Go 函数示例",
			},
		},
	})
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(response.Message.Content)
}
```

## 核心概念

### 客户端

SDK 的主要入口点，用于所有 API 交互。

### 消息

表示对话中的单个消息，包含角色和内容。

### 工具

LLM 可以调用的函数，用于执行操作。

### 会话

表示与 OpenCode 的连续对话。

## API 参考

### 聊天

```javascript
// 简单聊天
const response = await opencode.chat({
  messages: [
    { role: 'user', content: '你好' }
  ]
});

// 带模型的聊天
const response = await opencode.chat({
  model: 'openai:gpt-4-turbo',
  messages: [
    { role: 'user', content: '你好' }
  ]
});

// 带系统提示的聊天
const response = await opencode.chat({
  system: '你是一个专业的代码助手',
  messages: [
    { role: 'user', content: '帮我写一个函数' }
  ]
});
```

### 流式聊天

```javascript
// 流式响应
const stream = await opencode.chatStream({
  messages: [
    { role: 'user', content: '写一个长篇故事' }
  ]
});

for await (const chunk of stream) {
  process.stdout.write(chunk.content);
}
```

### 工具调用

```javascript
// 定义工具
const tools = [
  {
    name: 'get_weather',
    description: '获取指定城市的天气',
    parameters: {
      type: 'object',
      properties: {
        city: {
          type: 'string',
          description: '城市名称'
        }
      },
      required: ['city']
    }
  }
];

// 使用工具
const response = await opencode.chat({
  messages: [
    { role: 'user', content: '北京今天天气怎么样？' }
  ],
  tools,
  onToolCall: async (toolCall) => {
    if (toolCall.name === 'get_weather') {
      const { city } = toolCall.arguments;
      // 调用天气 API
      const weather = await fetchWeather(city);
      return weather;
    }
  }
});
```

### 会话管理

```javascript
// 创建会话
const session = await opencode.createSession({
  name: '我的项目会话'
});

// 继续会话
const response = await opencode.chat({
  sessionId: session.id,
  messages: [
    { role: 'user', content: '继续我们的讨论' }
  ]
});

// 列出会话
const sessions = await opencode.listSessions();

// 获取会话历史
const history = await opencode.getSessionHistory(session.id);
```

## 文件操作

```javascript
// 读取文件
const content = await opencode.readFile('path/to/file.txt');

// 写入文件
await opencode.writeFile('path/to/file.txt', '文件内容');

// 编辑文件
await opencode.editFile('path/to/file.txt', {
  oldString: '旧内容',
  newString: '新内容'
});

// 搜索文件
const files = await opencode.glob('**/*.js');

// 列出目录
const entries = await opencode.listDir('path/to/dir');
```

## 命令执行

```javascript
// 执行命令
const result = await opencode.exec('ls -la');
console.log(result.stdout);
console.log(result.stderr);
console.log(result.exitCode);

// 带工作目录执行
const result = await opencode.exec('npm install', {
  cwd: '/path/to/project'
});

// 带超时执行
const result = await opencode.exec('long-running-command', {
  timeout: 30000 // 30秒
});
```

## 自定义工具

### 创建工具

```javascript
import { Tool } from '@opencode/sdk';

const weatherTool = new Tool({
  name: 'get_weather',
  description: '获取城市天气',
  parameters: {
    type: 'object',
    properties: {
      city: {
        type: 'string',
        description: '城市名称'
      },
      unit: {
        type: 'string',
        enum: ['celsius', 'fahrenheit'],
        default: 'celsius'
      }
    },
    required: ['city']
  },
  async execute({ city, unit }) {
    const response = await fetch(
      `https://api.weatherapi.com/v1/current.json?key=${API_KEY}&q=${city}`
    );
    const data = await response.json();
    return {
      temperature: data.current.temp_c,
      condition: data.current.condition.text,
      unit
    };
  }
});

// 注册工具
opencode.registerTool(weatherTool);
```

## 错误处理

```javascript
try {
  const response = await opencode.chat({
    messages: [...]
  });
} catch (error) {
  if (error.code === 'AUTHENTICATION_ERROR') {
    console.error('API 密钥无效');
  } else if (error.code === 'RATE_LIMIT_ERROR') {
    console.error('请求过于频繁，请稍后再试');
  } else if (error.code === 'MODEL_ERROR') {
    console.error('模型错误，请尝试其他模型');
  } else {
    console.error('未知错误:', error);
  }
}
```

## 配置选项

```javascript
const opencode = new OpenCode({
  apiKey: 'your-api-key',
  baseURL: 'https://api.opencode.ai',
  timeout: 60000, // 60秒超时
  maxRetries: 3, // 失败重试3次
  defaultModel: 'openai:gpt-4-turbo',
  debug: false // 启用调试日志
});
```

## 类型定义

### TypeScript

```typescript
import { OpenCode, Message, ChatRequest } from '@opencode/sdk';

const opencode: OpenCode = new OpenCode({
  apiKey: process.env.OPENCODE_API_KEY!
});

const messages: Message[] = [
  {
    role: 'user',
    content: '你好'
  }
];

const request: ChatRequest = {
  messages,
  model: 'openai:gpt-4-turbo'
};

const response = await opencode.chat(request);
```

## 最佳实践

1. **错误处理** - 始终处理可能的错误
2. **超时设置** - 为长时间运行的操作设置超时
3. **资源清理** - 使用后清理资源
4. **日志记录** - 在开发时启用调试日志
5. **API 密钥安全** - 不要在代码中硬编码 API 密钥

## 更多信息

有关 SDK 的更多信息，请访问：
- OpenCode 官方文档：https://opencode.ai/docs/zh-cn/sdk/
- GitHub 仓库：https://github.com/anomalyco/opencode
