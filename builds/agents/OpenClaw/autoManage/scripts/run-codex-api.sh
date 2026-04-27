#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_common.sh"

require_cmd codex
clear_provider_env
clear_proxy_env
apply_default_proxy

env_file="$ROOT_DIR/profiles/openai.api.env"
if [[ ! -f "$env_file" ]]; then
  echo "Missing $env_file. Copy openai.api.env.example first."
  exit 1
fi

load_env_file "$env_file"
[[ -n "${OPENAI_API_KEY:-}" ]] || { echo "OPENAI_API_KEY missing"; exit 1; }

echo "Starting Codex CLI in API mode."
exec codex
