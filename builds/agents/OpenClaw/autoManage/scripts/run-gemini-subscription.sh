#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_common.sh"

require_cmd gemini
clear_provider_env
clear_proxy_env
apply_default_proxy

unset GEMINI_API_KEY || true
unset GOOGLE_API_KEY || true

echo "Starting Gemini CLI in Google login / Gemini Code Assist mode."
echo "If needed, complete login in the browser when prompted."
exec gemini
