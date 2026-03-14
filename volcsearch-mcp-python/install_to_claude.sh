#!/bin/bash

set -e


# VolcSearch MCP Service Installer for Claude Desktop


echo "====================================="
echo "VolcSearch MCP Service Installer for Claude"
echo "====================================="
echo ""


# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# Configuration
MCP_CONFIG_FILE=~/.claude.json
SERVICE_NAME="volc-search"
SCRIPT_PATH="$SCRIPT_DIR/main.py"
REQUIREMENTS_PATH="$SCRIPT_DIR/requirements.txt"
DEFAULT_ARK_BASE_URL="https://ark.cn-beijing.volces.com/api/v3"
DEFAULT_ARK_MODEL="doubao-seed-2-0-lite-260215"


# 检测系统中可用的Python版本
echo "🔍 正在检测系统中的Python版本..."
echo ""

PYTHON_CANDIDATES=("python3" "python3.8" "python3.9" "python3.10" "python3.11" "python3.12" "python3.13")
AVAILABLE_PYTHONS=()

for py in "${PYTHON_CANDIDATES[@]}"; do
    if command -v "$py" &> /dev/null; then
        py_path="$(command -v "$py")"
        py_version="$("$py" --version 2>&1 | awk '{print $2}')"
        AVAILABLE_PYTHONS+=("$py_version|$py_path")
        echo "* Python $py_version - $py_path"
    fi
done

if [ ${#AVAILABLE_PYTHONS[@]} -eq 0 ]; then
    echo "Error: 未找到可用的Python 3版本，请先安装Python"
    exit 1
fi

echo ""
echo "📋 可用的Python版本列表:"
echo "================================"
for i in "${!AVAILABLE_PYTHONS[@]}"; do
    IFS="|" read -r version path <<< "${AVAILABLE_PYTHONS[$i]}"
    echo "$((i+1)). Python $version"
    echo "   路径: $path"
    echo ""
done

# 让用户选择Python版本
while true; do
    read -p "请选择要使用的Python版本 (1-${#AVAILABLE_PYTHONS[@]}): " selection
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le ${#AVAILABLE_PYTHONS[@]} ]; then
        index=$((selection-1))
        IFS="|" read -r PYTHON_VERSION PYTHON_PATH <<< "${AVAILABLE_PYTHONS[$index]}"
        break
    else
        echo "请输入1到${#AVAILABLE_PYTHONS[@]}之间的有效数字"
    fi
done

echo ""
echo "✅ 已选择 Python $PYTHON_VERSION"
echo "   路径: $PYTHON_PATH"
echo ""


# 检查必要文件
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Error: MCP脚本不存在: $SCRIPT_PATH"
    exit 1
fi

if [ ! -f "$REQUIREMENTS_PATH" ]; then
    echo "Error: 依赖文件不存在: $REQUIREMENTS_PATH"
    exit 1
fi


# 安装依赖
echo "🔧 正在安装依赖..."
"$PYTHON_PATH" -m pip install --upgrade pip
"$PYTHON_PATH" -m pip install -r "$REQUIREMENTS_PATH"

if [ $? -ne 0 ]; then
    echo "Error: 依赖安装失败"
    exit 1
fi

echo "✅ 依赖安装成功"
echo ""


# 尝试从现有配置中获取API_KEY和MODEL
EXISTING_API_KEY=""
EXISTING_MODEL=""

if [ -f "$MCP_CONFIG_FILE" ]; then
    EXISTING_API_KEY=$(jq -r '.mcpServers["volc-search"].env.ARK_API_KEY // empty' "$MCP_CONFIG_FILE" 2>/dev/null || echo "")
    EXISTING_MODEL=$(jq -r '.mcpServers["volc-search"].env.ARK_MODEL // empty' "$MCP_CONFIG_FILE" 2>/dev/null || echo "")
fi

# 获取API Key
if [ -n "$EXISTING_API_KEY" ]; then
    echo "🔑 在配置中找到已存在的VOLCENGINE_API_KEY"
    read -p "是否使用现有API Key? (Y/n): " use_existing
    if [[ "$use_existing" =~ ^[Nn]$ ]]; then
        read -p "请输入你的ARK_API_KEY: " ARK_API_KEY
    else
        ARK_API_KEY="$EXISTING_API_KEY"
        echo "✅ 使用现有API Key"
    fi
else
    read -p "请输入你的ARK_API_KEY: " ARK_API_KEY
fi

if [ -z "$ARK_API_KEY" ]; then
    echo "Error: ARK_API_KEY是必需的"
    exit 1
fi

echo ""

# 获取ARK_MODEL
if [ -n "$EXISTING_MODEL" ]; then
    echo "🤖 在配置中找到已存在的ARK_MODEL: $EXISTING_MODEL"
    read -p "是否使用现有模型? (Y/n): " use_existing_model
    if [[ "$use_existing_model" =~ ^[Nn]$ ]]; then
        read -p "请输入ARK_MODEL名称 (默认: $DEFAULT_ARK_MODEL): " ARK_MODEL
        ARK_MODEL=${ARK_MODEL:-$DEFAULT_ARK_MODEL}
    else
        ARK_MODEL="$EXISTING_MODEL"
        echo "✅ 使用现有模型: $ARK_MODEL"
    fi
else
    read -p "请输入ARK_MODEL名称 (默认: $DEFAULT_ARK_MODEL): " ARK_MODEL
    ARK_MODEL=${ARK_MODEL:-$DEFAULT_ARK_MODEL}
fi

echo ""
echo "✅ 配置信息确认:"
echo "   ARK_API_KEY: ${ARK_API_KEY:0:8}..."
echo "   ARK_MODEL: $ARK_MODEL"
echo "   ARK_BASE_URL: $DEFAULT_ARK_BASE_URL"
echo ""

read -p "确认配置信息正确? (Y/n): " confirm
if [[ "$confirm" =~ ^[Nn]$ ]]; then
    echo "安装已取消"
    exit 0
fi

echo ""
echo "⚙️  正在更新Claude配置文件..."

# 备份现有配置
if [ -f "$MCP_CONFIG_FILE" ]; then
    BACKUP_FILE="$MCP_CONFIG_FILE.backup.$(date +%Y%m%d%H%M%S)"
    cp "$MCP_CONFIG_FILE" "$BACKUP_FILE"
    echo "📋 已备份原有配置到: $BACKUP_FILE"

    # 读取现有配置
    CONFIG=$(cat "$MCP_CONFIG_FILE")
else
    echo "📝 创建新的配置文件"
    CONFIG='{}'
fi

# 确保mcpServers节点存在
UPDATED_CONFIG=$(echo "$CONFIG" | jq '
  .mcpServers = (.mcpServers // {})
')

# 添加或更新服务配置
UPDATED_CONFIG=$(echo "$UPDATED_CONFIG" | jq \
  --arg name "$SERVICE_NAME" \
  --arg py "$PYTHON_PATH" \
  --arg script "$SCRIPT_PATH" \
  --arg api_key "$ARK_API_KEY" \
  --arg model "$ARK_MODEL" \
  --arg base_url "$DEFAULT_ARK_BASE_URL" '
  .mcpServers[$name] = {
    "command": $py,
    "args": [$script],
    "env": {
      "ARK_API_KEY": $api_key,
      "ARK_BASE_URL": $base_url,
      "ARK_MODEL": $model
    },
    "type": "stdio"
  }
')

# 写入更新后的配置
echo "$UPDATED_CONFIG" > "$MCP_CONFIG_FILE"

echo ""
echo "🎉 安装完成!"
echo "================================"
echo ""
echo "✅ 配置已保存到: $MCP_CONFIG_FILE"
echo "📝 服务名称: $SERVICE_NAME"
echo "🐍 Python解释器: $PYTHON_PATH"
echo "📄 主脚本路径: $SCRIPT_PATH"
echo "🤖 使用模型: $ARK_MODEL"
echo ""
echo "⚠️  注意: 如果~/.claude.json不生效，请尝试将配置复制到Claude官方配置路径:"
echo "   macOS: ~/Library/Application Support/Claude/claude_desktop_config.json"
echo "   Windows: %APPDATA%\Claude\claude_desktop_config.json"
echo ""
echo "📖 使用说明:"
echo "1. 重启Claude Desktop使配置生效"
echo "2. 重启后可以使用/mcp命令查看已连接的MCP服务器"
echo "3. 现在你可以在对话中使用volc-search工具进行联网搜索"
echo ""
echo "💡 使用示例:"
echo "\"搜索今天的热点新闻，返回5条结果\""
echo "\"查询Python 3.13的新特性\""
