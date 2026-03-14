#!/usr/bin/env python3
"""
Volcengine Ark Web Search MCP Service
"""
import os
import json
import sys
import asyncio
from typing import Any, Dict, List
from dotenv import load_dotenv
from openai import OpenAI

# Load environment variables
try:
    load_dotenv()
except:
    pass

# Initialize OpenAI client for Volcengine Ark
api_key = os.getenv("ARK_API_KEY")
base_url = os.getenv("ARK_BASE_URL", "https://ark.cn-beijing.volces.com/api/v3")
model = os.getenv("ARK_MODEL", "doubao-seed-2-0-lite-260215")

if not api_key:
    raise ValueError("ARK_API_KEY environment variable is required")

client = OpenAI(
    base_url=base_url,
    api_key=api_key
)

# Define tools
TOOLS = [
    {
        "name": "volc_web_search",
        "description": "火山引擎豆包AI联网搜索工具，可以搜索最新的新闻、信息、热点事件等。支持获取实时信息、热点新闻、知识查询、价格查询等。",
        "inputSchema": {
            "type": "object",
            "properties": {
                "query": {
                    "type": "string",
                    "description": "要搜索的查询关键词",
                },
                "max_keyword": {
                    "type": "integer",
                    "description": "最多返回的搜索结果数量，默认2",
                    "default": 2,
                    "minimum": 1,
                    "maximum": 10,
                }
            },
            "required": ["query"],
        },
    }
]

async def handle_message(message: Dict[str, Any]) -> Dict[str, Any]:
    """Handle incoming MCP messages"""
    if message.get("method") == "initialize":
        return {
            "jsonrpc": "2.0",
            "id": message.get("id"),
            "result": {
                "protocolVersion": "2024-11-05",
                "serverInfo": {
                    "name": "volcsearch-mcp",
                    "version": "1.0.0"
                },
                "capabilities": {
                    "tools": {}
                }
            }
        }
    
    elif message.get("method") == "tools/list":
        return {
            "jsonrpc": "2.0",
            "id": message.get("id"),
            "result": {
                "tools": TOOLS
            }
        }
    
    elif message.get("method") == "tools/call":
        params = message.get("params", {})
        tool_name = params.get("name")
        arguments = params.get("arguments", {})
        
        if tool_name != "volc_web_search":
            return {
                "jsonrpc": "2.0",
                "id": message.get("id"),
                "error": {
                    "code": -32601,
                    "message": f"Unknown tool: {tool_name}"
                }
            }
        
        try:
            query = arguments.get("query")
            max_keyword = arguments.get("max_keyword", 2)
            # Ignore search_depth parameter if present (for backward compatibility)
            search_depth = arguments.get("search_depth", None)

            if not query:
                return {
                    "jsonrpc": "2.0",
                    "id": message.get("id"),
                    "error": {
                        "code": -32602,
                        "message": "query parameter is required"
                    }
                }

            # Call Ark web search using OpenAI compatible API
            tools = [{
                "type": "web_search",
                "max_keyword": int(max_keyword),
            }]

            response = client.responses.create(
                model=model,
                input=[{"role": "user", "content": query}],
                tools=tools,
            )
            
            # Extract results
            result_text = ""
            if hasattr(response, 'output'):
                if isinstance(response.output, list):
                    for item in response.output:
                        if hasattr(item, 'content') and item.content:
                            if isinstance(item.content, list):
                                for content_item in item.content:
                                    if hasattr(content_item, 'text'):
                                        result_text += content_item.text + "\n\n"
                            elif isinstance(item.content, str):
                                result_text += item.content + "\n\n"
                elif isinstance(response.output, str):
                    result_text = response.output

            if not result_text:
                result_text = json.dumps(response.model_dump(), ensure_ascii=False, indent=2)
            
            return {
                "jsonrpc": "2.0",
                "id": message.get("id"),
                "result": {
                    "content": [
                        {
                            "type": "text",
                            "text": result_text.strip()
                        }
                    ],
                    "isError": False
                }
            }
            
        except Exception as e:
            return {
                "jsonrpc": "2.0",
                "id": message.get("id"),
                "result": {
                    "content": [
                        {
                            "type": "text",
                            "text": f"Search error: {str(e)}"
                        }
                    ],
                    "isError": True
                }
            }
    
    # Handle notifications
    elif message.get("method") in ["notifications/initialized", "notifications/exit"]:
        return None
    
    # Unknown method
    return {
        "jsonrpc": "2.0",
        "id": message.get("id"),
        "error": {
            "code": -32601,
            "message": f"Unknown method: {message.get('method')}"
        }
    }

async def main():
    """Main server loop"""
    while True:
        try:
            # Read line from stdin
            line = await asyncio.get_event_loop().run_in_executor(None, sys.stdin.readline)
            if not line:
                break
            
            # Parse JSON message
            message = json.loads(line.strip())
            
            # Handle message
            response = await handle_message(message)
            
            # Send response if needed
            if response is not None:
                print(json.dumps(response, ensure_ascii=False))
                sys.stdout.flush()
                
        except Exception as e:
            # Send error response
            error_response = {
                "jsonrpc": "2.0",
                "id": None,
                "error": {
                    "code": -32603,
                    "message": f"Internal error: {str(e)}"
                }
            }
            print(json.dumps(error_response, ensure_ascii=False))
            sys.stdout.flush()

if __name__ == "__main__":
    asyncio.run(main())
