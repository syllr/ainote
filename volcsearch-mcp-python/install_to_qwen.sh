#!/bin/bash
set -e

# VolcSearch MCP Service Installer for Qwen Code

echo "====================================="
echo "VolcSearch MCP Service Installer"
echo "====================================="
echo ""

# Check if .qwen directory exists
if [ ! -d ~/.qwen ]; then
    echo "Error: ~/.qwen directory not found. Is Qwen Code installed?"
    exit 1
fi

# Configuration
MCP_CONFIG_FILE=~/.qwen/mcp.json
SERVICE_NAME="volc-web-search"
PYTHON_PATH="/Users/yutao/ainote/.venv/bin/python"
SCRIPT_PATH="/Users/yutao/ainote/volcsearch-mcp-python/main.py"

# Check if Python and script exist
if [ ! -f "$PYTHON_PATH" ]; then
    echo "Error: Python interpreter not found at $PYTHON_PATH"
    exit 1
fi

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Error: MCP script not found at $SCRIPT_PATH"
    exit 1
fi

# Get API Key from user
read -p "Enter your ARK_API_KEY: " ARK_API_KEY
if [ -z "$ARK_API_KEY" ]; then
    echo "Error: ARK_API_KEY is required"
    exit 1
fi

# Create config structure
if [ -f "$MCP_CONFIG_FILE" ]; then
    echo "Existing MCP config found, updating..."
    # Backup existing config
    cp "$MCP_CONFIG_FILE" "$MCP_CONFIG_FILE.backup.$(date +%Y%m%d%H%M%S)"
    # Read existing config
    CONFIG=$(cat "$MCP_CONFIG_FILE")
else
    echo "Creating new MCP config..."
    CONFIG='{"mcpServers": {}}'
fi

# Add or update service configuration
UPDATED_CONFIG=$(echo "$CONFIG" | jq --arg name "$SERVICE_NAME" --arg py "$PYTHON_PATH" --arg script "$SCRIPT_PATH" --arg key "$ARK_API_KEY" '
  .mcpServers[$name] = {
    "command": $py,
    "args": [$script],
    "env": {
      "ARK_API_KEY": $key,
      "ARK_BASE_URL": "https://ark.cn-beijing.volces.com/api/v3",
      "ARK_MODEL": "doubao-seed-1-6-250615"
    }
  }
')

# Write updated config
echo "$UPDATED_CONFIG" > "$MCP_CONFIG_FILE"

echo ""
echo "✅ Installation completed successfully!"
echo ""
echo "Configuration saved to: $MCP_CONFIG_FILE"
echo ""
echo "To use the service:"
echo "1. Restart Qwen Code"
echo "2. You can now use the 'volc_web_search' tool in your conversations"
echo ""
echo "Tool capabilities:"
echo " - Search latest news and information"
echo " - Real-time web search"
echo " - Support configurable search depth and result count"
echo ""
echo "Example usage:"
echo "\"搜索今天的热点新闻，返回5条结果\""
