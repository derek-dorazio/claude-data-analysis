#!/bin/bash
# Remove output files older than N days
# Usage: ./scripts/clean-output.sh [days]
# Default: 30 days

DAYS="${1:-30}"
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)/output"

echo "Cleaning output files older than $DAYS days..."

count=0
for dir in plan analysis explore data reports; do
    if [ -d "$BASE_DIR/$dir" ]; then
        while IFS= read -r -d '' file; do
            echo "  Removing: $file"
            rm "$file"
            count=$((count + 1))
        done < <(find "$BASE_DIR/$dir" -type f ! -name '.gitkeep' -mtime +"$DAYS" -print0)
    fi
done

echo "Removed $count file(s)."
