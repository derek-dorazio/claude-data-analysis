#!/bin/bash
# Remove output files older than N days across all use cases
# Usage: ./scripts/clean-output.sh [days] [use-case-path]
# Default: 30 days, all use cases

DAYS="${1:-30}"
USE_CASE="${2:-}"
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Cleaning output files older than $DAYS days..."

count=0

clean_use_case() {
    local uc_dir="$1"
    for dir in plan analysis explore data reports; do
        if [ -d "$uc_dir/output/$dir" ]; then
            while IFS= read -r -d '' file; do
                echo "  Removing: $file"
                rm "$file"
                count=$((count + 1))
            done < <(find "$uc_dir/output/$dir" -type f ! -name '.gitkeep' -mtime +"$DAYS" -print0)
        fi
    done
}

if [ -n "$USE_CASE" ]; then
    clean_use_case "$PROJECT_DIR/use-cases/$USE_CASE"
else
    find "$PROJECT_DIR/use-cases" -mindepth 2 -maxdepth 2 -type d | while read -r d; do
        clean_use_case "$d"
    done
fi

echo "Removed $count file(s)."
