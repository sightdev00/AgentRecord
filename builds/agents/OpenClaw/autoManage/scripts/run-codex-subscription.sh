#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_common.sh"

require_cmd codex
clear_provider_env
clear_proxy_env
apply_default_proxy

echo "Starting Codex CLI in subscription/login mode."
echo "If you have not logged in yet, run: codex --login"
exec codex
