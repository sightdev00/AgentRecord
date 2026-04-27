#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/_common.sh"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <profile-file-in-profiles-dir>"
  exit 1
fi

profile_name="$1"
profile_path="$ROOT_DIR/profiles/$profile_name"

if [[ ! -f "$profile_path" ]]; then
  echo "Profile not found: $profile_path" >&2
  exit 1
fi

write_runtime_pointer "current_gateway_profile" "$profile_path"
log "Switched OpenClaw gateway profile -> $profile_name"
