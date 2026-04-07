# OpenCode 自定义工具开发

创建自定义工具来扩展 OpenCode 的功能。

## 概述

OpenCode 允许您创建自定义工具，让 LLM 能够执行特定的操作和集成。

## 什么是自定义工具

自定义工具是：
- LLM 可以调用的函数
- 用于执行特定操作
- 可以集成外部服务
- 可以自动化工作流程

## 工具结构

### 基本结构

```javascript
{
  "name": "tool_name",
  "description": "工具描述",
  "parameters": {
    "type": "object",
    "properties": {
      "param1": {
        "type": "string",
        "description": "参数描述"
      }
    },
    "required": ["param1"]
  }
}
```

## 工具定义位置

自定义工具可以保存在：

1. **项目级**：`.opencode/tools/`
2. **全局**：`~/.config/opencode/tools/`

## 创建简单工具

### 示例 1：天气查询工具

创建 `.opencode/tools/weather.json`：

```json
{
  "name": "get_weather",
  "description": "获取指定城市的当前天气信息",
  "parameters": {
    "type": "object",
    "properties": {
      "city": {
        "type": "string",
        "description": "城市名称，例如：北京、上海、New York"
      },
      "unit": {
        "type": "string",
        "enum": ["celsius", "fahrenheit"],
        "default": "celsius",
        "description": "温度单位"
      }
    },
    "required": ["city"]
  }
}
```

然后创建 `.opencode/tools/weather.js`：

```javascript
import fetch from 'node-fetch';

export async function execute({ city, unit }) {
  const apiKey = process.env.WEATHER_API_KEY;
  const url = `https://api.weatherapi.com/v1/current.json?key=${apiKey}&q=${encodeURIComponent(city)}`;
  
  const response = await fetch(url);
  const data = await response.json();
  
  const temp = unit === 'fahrenheit' 
    ? data.current.temp_f 
    : data.current.temp_c;
  
  return {
    city: data.location.name,
    country: data.location.country,
    temperature: temp,
    unit: unit,
    condition: data.current.condition.text,
    humidity: data.current.humidity,
    windSpeed: data.current.wind_kph
  };
}
```

### 示例 2：数据库查询工具

创建 `.opencode/tools/db-query.json`：

```json
{
  "name": "db_query",
  "description": "执行数据库查询（只读）",
  "parameters": {
    "type": "object",
    "properties": {
      "query": {
        "type": "string",
        "description": "SQL 查询语句"
      },
      "limit": {
        "type": "integer",
        "default": 100,
        "minimum": 1,
        "maximum": 1000,
        "description": "结果限制数量"
      }
    },
    "required": ["query"]
  }
}
```

创建 `.opencode/tools/db-query.js`：

```javascript
import { Database } from 'sqlite3';
import { open } from 'sqlite';

export async function execute({ query, limit }) {
  // 只允许 SELECT 查询
  if (!query.trim().toUpperCase().startsWith('SELECT')) {
    throw new Error('只允许 SELECT 查询');
  }
  
  // 添加 LIMIT 子句
  const limitedQuery = `${query} LIMIT ${limit}`;
  
  const db = await open({
    filename: process.env.DATABASE_PATH,
    driver: Database
  });
  
  try {
    const results = await db.all(limitedQuery);
    return {
      count: results.length,
      results: results
    };
  } finally {
    await db.close();
  }
}
```

### 示例 3：Git 操作工具

创建 `.opencode/tools/git-operations.json`：

```json
{
  "name": "git_operations",
  "description": "执行 Git 操作",
  "parameters": {
    "type": "object",
    "properties": {
      "operation": {
        "type": "string",
        "enum": ["status", "log", "diff", "branch", "tag"],
        "description": "Git 操作类型"
      },
      "options": {
        "type": "object",
        "description": "操作选项"
      }
    },
    "required": ["operation"]
  }
}
```

创建 `.opencode/tools/git-operations.js`：

```javascript
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

export async function execute({ operation, options = {} }) {
  let command = 'git ';
  
  switch (operation) {
    case 'status':
      command += 'status';
      break;
    case 'log':
      command += 'log';
      if (options.limit) {
        command += ` -n ${options.limit}`;
      }
      if (options.oneline) {
        command += ' --oneline';
      }
      break;
    case 'diff':
      command += 'diff';
      if (options.file) {
        command += ` ${options.file}`;
      }
      break;
    case 'branch':
      command += 'branch';
      if (options.list) {
        command += ' -a';
      }
      break;
    case 'tag':
      command += 'tag';
      if (options.list) {
        command += ' -l';
      }
      break;
    default:
      throw new Error(`未知操作: ${operation}`);
  }
  
  try {
    const { stdout, stderr } = await execAsync(command);
    return {
      success: true,
      output: stdout,
      error: stderr || null
    };
  } catch (error) {
    return {
      success: false,
      output: null,
      error: error.message
    };
  }
}
```

## Python 工具

也可以使用 Python 创建工具：

创建 `.opencode/tools/image-processor.json`：

```json
{
  "name": "image_processor",
  "description": "处理图像文件",
  "parameters": {
    "type": "object",
    "properties": {
      "input_path": {
        "type": "string",
        "description": "输入图像路径"
      },
      "operation": {
        "type": "string",
        "enum": ["resize", "grayscale", "rotate", "thumbnail"],
        "description": "图像处理操作"
      },
      "options": {
        "type": "object",
        "description": "操作选项"
      }
    },
    "required": ["input_path", "operation"]
  }
}
```

创建 `.opencode/tools/image-processor.py`：

```python
from PIL import Image
import os

def execute(input_path, operation, options=None):
    options = options or {}
    
    if not os.path.exists(input_path):
        return {"error": f"文件不存在: {input_path}"}
    
    img = Image.open(input_path)
    
    result = {}
    
    if operation == "resize":
        width = options.get("width", 800)
        height = options.get("height", 600)
        img = img.resize((width, height))
        result["size"] = (width, height)
    
    elif operation == "grayscale":
        img = img.convert("L")
        result["mode"] = "grayscale"
    
    elif operation == "rotate":
        degrees = options.get("degrees", 90)
        img = img.rotate(degrees)
        result["rotated"] = degrees
    
    elif operation == "thumbnail":
        size = options.get("size", (200, 200))
        img.thumbnail(size)
        result["thumbnail_size"] = img.size
    
    # 保存结果
    output_path = f"processed_{os.path.basename(input_path)}"
    img.save(output_path)
    
    result["output_path"] = output_path
    result["success"] = True
    
    return result
```

## 工具配置

在 `opencode.json` 中配置工具：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "tools": {
    "weather": {
      "enabled": true,
      "permission": "ask"
    },
    "db_query": {
      "enabled": true,
      "permission": "ask"
    },
    "git_operations": {
      "enabled": true,
      "permission": "allow"
    }
  }
}
```

## 工具权限

控制工具的访问权限：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "weather": "allow",
    "db_query": "ask",
    "git_operations": "ask",
    "image_processor": "deny"
  }
}
```

## 最佳实践

1. **明确描述** - 提供清晰的工具描述
2. **详细参数** - 详细说明每个参数的用途
3. **输入验证** - 验证所有输入参数
4. **错误处理** - 正确处理和报告错误
5. **安全性** - 注意安全问题，防止滥用
6. **权限控制** - 为工具设置适当的权限级别
7. **文档完善** - 包含使用示例

## 更多信息

有关自定义工具的更多信息，请访问：
- OpenCode 官方文档：https://opencode.ai/docs/zh-cn/custom-tools/
