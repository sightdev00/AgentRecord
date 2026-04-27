#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_common.sh"

echo "ROOT_DIR=$ROOT_DIR"
echo "current_gateway_profile=$(read_runtime_pointer current_gateway_profile || true)"
echo "HTTP_PROXY=${HTTP_PROXY:-}"
echo "HTTPS_PROXY=${HTTPS_PROXY:-}"
echo "NODE_USE_ENV_PROXY=${NODE_USE_ENV_PROXY:-}"
