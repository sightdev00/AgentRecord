#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR/profiles"

for f in *.example; do
  target="${f%.example}"
  if [[ ! -f "$target" ]]; then
    cp "$f" "$target"
    echo "Created $target"
  else
    echo "Skip existing $target"
  fi
done
