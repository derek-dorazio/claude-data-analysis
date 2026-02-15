#!/bin/bash
# List output files organized by use case and type
# Usage: ./scripts/list-output.sh [use-case-path] [type]
# Types: plan, analysis, explore, data, reports, all (default)
# Example: ./scripts/list-output.sh hr/pto-analysis plan
#          ./scripts/list-output.sh              # all use cases, all types

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
USE_CASE="${1:-}"
TYPE="${2:-all}"

list_files() {
    local dir="$1"
    local label="$2"
    if [ -d "$dir" ]; then
        files=$(find "$dir" -type f ! -name '.gitkeep' | sort -r)
        if [ -n "$files" ]; then
            echo "  == $label =="
            echo "$files" | while read -r f; do
                size=$(du -h "$f" | cut -f1)
                mod=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$f" 2>/dev/null || stat --printf="%y" "$f" 2>/dev/null | cut -d. -f1)
                echo "    $size  $mod  $(basename "$f")"
            done
            echo ""
        fi
    fi
}

list_use_case() {
    local uc_dir="$1"
    local uc_name="${uc_dir#$PROJECT_DIR/use-cases/}"
    echo "[$uc_name]"

    case "$TYPE" in
        plan)     list_files "$uc_dir/output/plan" "Plans" ;;
        analysis) list_files "$uc_dir/output/analysis" "Analysis Reports" ;;
        explore)  list_files "$uc_dir/output/explore" "Data Profiles" ;;
        data)     list_files "$uc_dir/output/data" "Data Files" ;;
        reports)  list_files "$uc_dir/output/reports" "Reports" ;;
        all)
            list_files "$uc_dir/output/plan" "Plans"
            list_files "$uc_dir/output/analysis" "Analysis Reports"
            list_files "$uc_dir/output/explore" "Data Profiles"
            list_files "$uc_dir/output/data" "Data Files"
            list_files "$uc_dir/output/reports" "Reports"
            ;;
    esac
}

if [ -n "$USE_CASE" ]; then
    uc_dir="$PROJECT_DIR/use-cases/$USE_CASE"
    if [ -d "$uc_dir" ]; then
        list_use_case "$uc_dir"
    else
        echo "Use case not found: $USE_CASE"
        echo "Available use cases:"
        find "$PROJECT_DIR/use-cases" -mindepth 2 -maxdepth 2 -type d | while read -r d; do
            echo "  ${d#$PROJECT_DIR/use-cases/}"
        done
        exit 1
    fi
else
    find "$PROJECT_DIR/use-cases" -mindepth 2 -maxdepth 2 -type d | sort | while read -r d; do
        list_use_case "$d"
    done
fi
