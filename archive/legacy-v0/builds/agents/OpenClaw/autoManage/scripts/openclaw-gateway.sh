#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_common.sh"

require_cmd openclaw
require_cmd node

profile_path="$(read_runtime_pointer current_gateway_profile || true)"
if [[ -z "${profile_path:-}" ]]; then
  echo "No gateway profile selected. Run: ./scripts/use-gateway-profile.sh <xxx.api.env>"
  exit 1
fi

clear_provider_env
clear_proxy_env
apply_default_proxy
load_env_file "$profile_path"

if [[ -z "${OPENCLAW_PROVIDER:-}" || -z "${OPENCLAW_MODEL:-}" ]]; then
  echo "Profile must define OPENCLAW_PROVIDER and OPENCLAW_MODEL"
  exit 1
fi

case "$OPENCLAW_PROVIDER" in
  openai)
    [[ -n "${OPENAI_API_KEY:-}" ]] || { echo "OPENAI_API_KEY missing"; exit 1; }
    ;;
  anthropic)
    [[ -n "${ANTHROPIC_API_KEY:-}" ]] || { echo "ANTHROPIC_API_KEY missing"; exit 1; }
    ;;
  google)
    if [[ -z "${GEMINI_API_KEY:-}" && -z "${GOOGLE_API_KEY:-}" ]]; then
      echo "GEMINI_API_KEY or GOOGLE_API_KEY missing"
      exit 1
    fi
    ;;
  *)
    echo "Unsupported OPENCLAW_PROVIDER: $OPENCLAW_PROVIDER"
    exit 1
    ;;
esac

log_file="$LOG_DIR/openclaw-gateway-$(date +%Y%m%d-%H%M%S).log"
log "Starting OpenClaw gateway"
log "profile=$profile_path"
log "provider=$OPENCLAW_PROVIDER model=$OPENCLAW_MODEL"
log "log_file=$log_file"

# 说明：
# 1) 这里直接按你的实际入口启动：openclaw gateway
# 2) 如果你后续发现 OpenClaw 需要额外的 provider/model 变量名，可在这里映射
# 3) 当前会把 OPENCLAW_PROVIDER/OPENCLAW_MODEL 暴露给子进程，便于你在 OpenClaw 配置中引用

exec bash -lc "openclaw gateway 2>&1 | tee '$log_file'"
