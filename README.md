# Data Analysis Workflow

A Claude Code agentic project for loading, joining, and analyzing local data files. Data, queries, tests, and output are organized by use case so the same commands work across multiple datasets.

## Getting Started

### Prerequisites

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)
- Python 3.8+ with pandas (`pip3 install pandas openpyxl xlrd`)
- [uv](https://docs.astral.sh/uv/) for MCP servers (`brew install uv`)
- Node.js/npm (for filesystem MCP server)

### Quick Start

```bash
# 1. Place data files in a use case's input folder
cp sales.csv customers.xlsx use-cases/hr/pto-analysis/input/

# 2. Open Claude Code in this directory
claude

# 3. Profile data for a use case
/explore hr/pto-analysis

# 4. Plan an analysis
/plan hr/pto-analysis — analyze PTO errors during long-term leave

# 5. Execute the plan
/implement hr/pto-analysis
```

## Commands

| Command | Purpose | Output |
|---------|---------|--------|
| `/plan <use-case> <description>` | Profile input data and create a structured analysis plan | `<use-case>/output/plan/` |
| `/implement [use-case]` | Execute the most recent analysis plan | `<use-case>/output/analysis/` |
| `/explore [use-case] [file]` | Quick data profiling — schema, stats, quality flags | `<use-case>/output/explore/` |
| `/query [use-case] <question>` | Ask a natural-language question about your data | `<use-case>/output/reports/` |
| `/export [use-case] <format>` | Export results to Excel, CSV, or markdown | `<use-case>/output/data/` |

### Workflow

```
/plan  →  review plan  →  /implement  →  review report
                                              ↓
                                     /export (optional)
```

For quick one-off questions, use `/query` or `/explore` directly.

## Use Cases

Each use case lives in `use-cases/<domain>/<name>/` with its own input data, queries, tests, and output. See [use-cases/README.md](use-cases/README.md) for details.

| Domain | Use Case | Description |
|--------|----------|-------------|
| hr | pto-analysis | PTO and long-term leave analysis — error detection and usage tracking |

### Creating a New Use Case

```bash
mkdir -p use-cases/<domain>/<name>/{input,output/{plan,analysis,explore,data,reports},queries,tests}
touch use-cases/<domain>/<name>/output/{plan,analysis,explore,data,reports}/.gitkeep
```

Then add data to `input/`, query definitions to `queries/`, and test cases to `tests/`.

## Project Structure

```
data-analysis/
├── .claude/commands/        # Slash commands (use-case aware)
├── skills/                  # Reusable analysis prompts
├── scripts/                 # Helper shell scripts
├── templates/               # Reusable output templates
└── use-cases/
    └── <domain>/
        └── <use-case>/
            ├── input/       # CSV, Excel, JSON data files
            ├── output/      # plan/, analysis/, explore/, data/, reports/
            ├── queries/     # Predefined query definitions
            └── tests/       # Test cases with expected results
```

## Input Formats

| Format | Extensions | Notes |
|--------|-----------|-------|
| CSV | `.csv` | Auto-detects delimiter (comma, tab, pipe, semicolon) |
| Excel | `.xlsx`, `.xls` | Multi-sheet workbooks supported |
| JSON | `.json` | Flat arrays or nested objects |
| JSON Lines | `.jsonl` | One JSON object per line |

## MCP Servers

| Server | Package | Purpose |
|--------|---------|---------|
| excel | `excel-mcp-server` | Read/write Excel workbooks with formatting |
| filesystem | `@anthropic/mcp-filesystem-server` | Enhanced file operations on use-cases dir |

## Skills

| Skill | Purpose |
|-------|---------|
| `profile-data` | Column types, distributions, nulls, uniques, sample values |
| `join-strategy` | Identify join keys, relationship types, cardinality |
| `detect-anomalies` | Outliers, unexpected values, data quality issues |
| `summarize-stats` | Descriptive statistics, aggregations, group-by summaries |

## Helper Scripts

```bash
# List output files (all use cases or specific)
./scripts/list-output.sh                        # all
./scripts/list-output.sh hr/pto-analysis        # specific use case
./scripts/list-output.sh hr/pto-analysis plan   # specific type

# Clean old output
./scripts/clean-output.sh                       # 30 days, all use cases
./scripts/clean-output.sh 7 hr/pto-analysis     # 7 days, specific use case
```
