#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_common.sh"

require_cmd claude
clear_provider_env
clear_proxy_env
apply_default_proxy

env_file="$ROOT_DIR/profiles/anthropic.api.env"
if [[ ! -f "$env_file" ]]; then
  echo "Missing $env_file. Copy anthropic.api.env.example first."
  exit 1
fi

load_env_file "$env_file"
[[ -n "${ANTHROPIC_API_KEY:-}" ]] || { echo "ANTHROPIC_API_KEY missing"; exit 1; }

echo "Starting Claude Code in API mode."
exec claude
