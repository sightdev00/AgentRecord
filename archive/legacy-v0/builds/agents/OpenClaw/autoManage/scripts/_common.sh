#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNTIME_DIR="$ROOT_DIR/runtime"
LOG_DIR="$ROOT_DIR/logs"

mkdir -p "$RUNTIME_DIR" "$LOG_DIR"

now_ts() {
  date +"%Y-%m-%d %H:%M:%S"
}

log() {
  echo "[$(now_ts)] $*"
}

load_env_file() {
  local env_file="$1"
  if [[ ! -f "$env_file" ]]; then
    echo "Env file not found: $env_file" >&2
    exit 1
  fi
  set -a
  # shellcheck disable=SC1090
  source "$env_file"
  set +a
}

clear_provider_env() {
  unset OPENAI_API_KEY || true
  unset ANTHROPIC_API_KEY || true
  unset GEMINI_API_KEY || true
  unset GOOGLE_API_KEY || true
  unset OPENCLAW_PROVIDER || true
  unset OPENCLAW_MODEL || true
}

clear_proxy_env() {
  unset ALL_PROXY all_proxy || true
}

apply_default_proxy() {
  export HTTP_PROXY="${HTTP_PROXY:-http://127.0.0.1:7890}"
  export HTTPS_PROXY="${HTTPS_PROXY:-http://127.0.0.1:7890}"
  export http_proxy="${http_proxy:-$HTTP_PROXY}"
  export https_proxy="${https_proxy:-$HTTPS_PROXY}"
  export NO_PROXY="${NO_PROXY:-localhost,127.0.0.1,.feishu.cn,open.feishu.cn}"
  export no_proxy="${no_proxy:-$NO_PROXY}"
  export NODE_USE_ENV_PROXY=1
}

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing command: $cmd" >&2
    exit 1
  fi
}

write_runtime_pointer() {
  local key="$1"
  local value="$2"
  mkdir -p "$RUNTIME_DIR"
  printf "%s\n" "$value" > "$RUNTIME_DIR/$key"
}

read_runtime_pointer() {
  local key="$1"
  if [[ -f "$RUNTIME_DIR/$key" ]]; then
    cat "$RUNTIME_DIR/$key"
  fi
}
