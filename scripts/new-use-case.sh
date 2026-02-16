#!/bin/bash
# Scaffold a new use case with the standard directory structure and starter files.
#
# Usage: ./scripts/new-use-case.sh <domain> <use-case-name>
# Example: ./scripts/new-use-case.sh finance budget-analysis

set -e

if [ $# -lt 2 ]; then
    echo "Usage: $0 <domain> <use-case-name>"
    echo "Example: $0 finance budget-analysis"
    echo ""
    echo "This creates the standard directory structure under use-cases/<domain>/<use-case-name>/"
    exit 1
fi

DOMAIN="$1"
NAME="$2"
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
UC_DIR="$PROJECT_DIR/use-cases/$DOMAIN/$NAME"

if [ -d "$UC_DIR" ]; then
    echo "Error: Use case already exists at $UC_DIR"
    exit 1
fi

echo "Creating use case: $DOMAIN/$NAME"

# Create directory structure
mkdir -p "$UC_DIR"/{input,output,queries,tests}

# Create .gitkeep for empty output dir
touch "$UC_DIR"/output/.gitkeep

# Copy templates as starter files
TMPL_DIR="$PROJECT_DIR/templates"

if [ -f "$TMPL_DIR/data-dictionary-template.md" ]; then
    sed "s/<Domain>/$DOMAIN/g; s/<Use Case Name>/$NAME/g" \
        "$TMPL_DIR/data-dictionary-template.md" > "$UC_DIR/data-dictionary.md"
fi

if [ -f "$TMPL_DIR/test-cases-template.md" ]; then
    sed "s/<Use Case Name>/$NAME/g" \
        "$TMPL_DIR/test-cases-template.md" > "$UC_DIR/tests/test-cases.md"
fi

if [ -f "$TMPL_DIR/query-template.md" ]; then
    cp "$TMPL_DIR/query-template.md" "$UC_DIR/queries/query-template.md"
fi

# Create input README
cat > "$UC_DIR/input/README.md" << EOF
# Input Data: $DOMAIN / $NAME

Place your data files here. Supported formats: CSV, Excel (.xlsx/.xls), JSON, JSON Lines (.jsonl).

See \`data-dictionary.md\` in the parent folder for the expected schema and column definitions.
EOF

echo ""
echo "Created use case at: use-cases/$DOMAIN/$NAME/"
echo ""
echo "Directory structure:"
echo "  use-cases/$DOMAIN/$NAME/"
echo "  ├── input/              <- Put your data files here"
echo "  ├── output/             <- Generated output (timestamped run folders)"
echo "  ├── queries/            <- Define your query .md files here"
echo "  ├── tests/              <- Add test cases here"
echo "  ├── data-dictionary.md  <- Document your input file schemas"
echo "  └── input/README.md"
echo ""
echo "Next steps:"
echo "  1. Add your input data files to use-cases/$DOMAIN/$NAME/input/"
echo "  2. Edit data-dictionary.md to document your schemas"
echo "  3. Add query definitions in queries/ (see queries/query-template.md)"
echo "  4. Add test cases in tests/test-cases.md"
echo "  5. Run: /plan $DOMAIN/$NAME — <description>"
EOF
