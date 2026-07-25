#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_common.sh"

apply_default_proxy

echo "=== commands ==="
for x in node openclaw; do
  if command -v "$x" >/dev/null 2>&1; then
    echo "$x -> $(command -v "$x")"
  else
    echo "$x -> MISSING"
  fi
done

echo
echo "=== versions ==="
node -v || true
openclaw --help >/dev/null 2>&1 && echo "openclaw help ok" || echo "openclaw help failed"

echo
echo "=== proxy env ==="
env | grep -i proxy || true

echo
echo "=== node fetch probe ==="
NODE_USE_ENV_PROXY=1 node -e "fetch('https://generativelanguage.googleapis.com').then(r=>console.log('google_probe_status', r.status)).catch(e=>console.error('google_probe_error', e))"
