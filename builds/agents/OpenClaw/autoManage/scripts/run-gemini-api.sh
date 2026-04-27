#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_common.sh"

require_cmd gemini
clear_provider_env
clear_proxy_env
apply_default_proxy

env_file="$ROOT_DIR/profiles/gemini.api.env"
if [[ ! -f "$env_file" ]]; then
  echo "Missing $env_file. Copy gemini.api.env.example first."
  exit 1
fi

load_env_file "$env_file"

if [[ -z "${GEMINI_API_KEY:-}" && -z "${GOOGLE_API_KEY:-}" ]]; then
  echo "GEMINI_API_KEY or GOOGLE_API_KEY missing"
  exit 1
fi

echo "Starting Gemini CLI in API mode."
exec gemini
