#!/usr/bin/env bash
set -uo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "ERROR: run inside the AgentRecord repository"
    exit 2
}

errors=0
warnings=0

check_dir() {
    local dir="$1"
    if [[ ! -f "$root/$dir/README.md" ]]; then
        echo "ERROR: $dir/README.md is missing"
        errors=$((errors + 1))
    fi
}

for dir in foundations cases patterns decisions experiments inbox; do
    check_dir "$dir"
done

while IFS= read -r file; do
    if ! grep -q '^---$' "$file"; then
        echo "WARN: ${file#"$root/"} has no metadata block"
        warnings=$((warnings + 1))
        continue
    fi
    for field in type status created updated; do
        if ! grep -q "^${field}:" "$file"; then
            echo "ERROR: ${file#"$root/"} is missing '$field'"
            errors=$((errors + 1))
        fi
    done

    status="$(sed -n 's/^status:[[:space:]]*//p' "$file" | head -n1)"
    case "$status" in
        draft|tested|replicated|bounded|superseded) ;;
        *)
            echo "ERROR: ${file#"$root/"} has invalid status '$status'"
            errors=$((errors + 1))
            ;;
    esac

    top_dir="${file#"$root/"}"
    top_dir="${top_dir%%/*}"
    expected_type="${top_dir%s}"
    actual_type="$(sed -n 's/^type:[[:space:]]*//p' "$file" | head -n1)"
    if [[ "$actual_type" != "$expected_type" ]]; then
        echo "ERROR: ${file#"$root/"} has type '$actual_type', expected '$expected_type'"
        errors=$((errors + 1))
    fi
done < <(find "$root"/{foundations,cases,patterns,decisions,experiments} \
    -type f -name '*.md' ! -name 'README.md' -print)

while IFS= read -r dir; do
    echo "WARN: formal knowledge is organized under a tool-oriented directory: ${dir#"$root/"}"
    warnings=$((warnings + 1))
done < <(find "$root"/{foundations,cases,patterns,decisions,experiments} \
    -type d \( -name prompts -o -name skills -o -name tools \) -print)

echo "check complete: $errors error(s), $warnings warning(s)"
[[ "$errors" -eq 0 ]]
