#!/bin/bash
# List output files organized by type
# Usage: ./scripts/list-output.sh [type]
# Types: plan, analysis, explore, data, reports, all (default)

TYPE="${1:-all}"
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)/output"

list_files() {
    local dir="$1"
    local label="$2"
    if [ -d "$dir" ]; then
        files=$(find "$dir" -type f ! -name '.gitkeep' | sort -r)
        if [ -n "$files" ]; then
            echo "== $label =="
            echo "$files" | while read -r f; do
                size=$(du -h "$f" | cut -f1)
                mod=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$f" 2>/dev/null || stat --printf="%y" "$f" 2>/dev/null | cut -d. -f1)
                echo "  $size  $mod  $(basename "$f")"
            done
            echo ""
        fi
    fi
}

case "$TYPE" in
    plan)     list_files "$BASE_DIR/plan" "Plans" ;;
    analysis) list_files "$BASE_DIR/analysis" "Analysis Reports" ;;
    explore)  list_files "$BASE_DIR/explore" "Data Profiles" ;;
    data)     list_files "$BASE_DIR/data" "Data Files" ;;
    reports)  list_files "$BASE_DIR/reports" "Reports" ;;
    all)
        list_files "$BASE_DIR/plan" "Plans"
        list_files "$BASE_DIR/analysis" "Analysis Reports"
        list_files "$BASE_DIR/explore" "Data Profiles"
        list_files "$BASE_DIR/data" "Data Files"
        list_files "$BASE_DIR/reports" "Reports"
        ;;
    *) echo "Usage: $0 [plan|analysis|explore|data|reports|all]" ;;
esac
