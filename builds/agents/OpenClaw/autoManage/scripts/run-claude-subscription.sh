#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_common.sh"

require_cmd claude
clear_provider_env
clear_proxy_env
apply_default_proxy

# Claude Code 会优先使用 ANTHROPIC_API_KEY。
# 订阅模式必须确保该变量未设置。
unset ANTHROPIC_API_KEY || true

echo "Starting Claude Code in Claude.ai subscription mode."
echo "If needed, run /login inside Claude Code."
exec claude
