# Data Analysis Workflow

A Claude Code agentic project for loading, joining, and analyzing local data files. Data, queries, tests, and output are organized by use case so the same commands work across multiple datasets.

## Who Is This For?

This project supports two types of users:

- **Data Analysts** — Upload data, run queries, get results. See [How To: Data Analysts](#how-to-data-analysts).
- **Use Case Builders** — Define new use cases, datasets, queries, and test cases. See [How To: Use Case Builders](#how-to-use-case-builders).

## Prerequisites

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)
- Python 3.8+ with pandas (`pip3 install pandas openpyxl xlrd`)
- weasyprint for HTML-to-PDF (`pip3 install weasyprint`)
- [uv](https://docs.astral.sh/uv/) for MCP servers (`brew install uv`)
- Node.js/npm (for filesystem MCP server)

---

## How To: Data Analysts

You have data files and want to analyze them using an existing use case.

### Step 1: Choose a Use Case

See what's available:

| Domain | Use Case | What It Does |
|--------|----------|-------------|
| hr | pto-analysis | Detect PTO errors during long-term leave; find low PTO usage |
| sales | district-leads | Rank sales opportunities by composite score; pipeline analysis |

Each use case has a `data-dictionary.md` that documents the exact columns and types your files need. **Read it first** — your data must match the expected schema.

### Step 2: Upload Your Data

Replace the sample files in the use case's `input/` folder with your own data:

```bash
# Copy your files (must match the schema in data-dictionary.md)
cp your-pto-export.csv use-cases/hr/pto-analysis/input/employee-pto.csv
cp your-leave-data.csv use-cases/hr/pto-analysis/input/long-term-leave.csv
```

**Important**: Keep the same file names as the originals, or update the query definitions in `queries/` to reference the new names.

### Step 3: Run the Analysis

```bash
# Open Claude Code in the project root
claude

# Option A: Full workflow (plan, then implement)
/plan hr/pto-analysis — find PTO errors and low usage
# Review the plan, then:
/implement hr/pto-analysis

# Option B: Quick exploration
/explore hr/pto-analysis

# Option C: Ask a specific question
/query hr/pto-analysis — which employees have zero vacation time this year?
```

### Step 4: Review Results

Each command run creates a timestamped subfolder under `output/`:

```
use-cases/hr/pto-analysis/output/
├── pto-analysis-2025-02-15-143022.zip  # Zip archive (default)
└── pto-analysis-2025-02-15-143022/     # Run folder (also kept)
    ├── 2025-02-15-pto-analysis-report.md
    ├── 2025-02-15-pto-analysis-report.html
    ├── 2025-02-15-pto-analysis-report.pdf
    ├── 2025-02-15-query-1-pto-during-leave.csv
    ├── 2025-02-15-query-2-low-pto-usage.csv
    └── 2025-02-15-pto-analysis.xlsx
```

### Adding a New Query

If the existing queries don't cover what you need, you can add your own:

1. Copy the query template: `cp templates/query-template.md use-cases/hr/pto-analysis/queries/query-3-my-query.md`
2. Edit the file — fill in the description, logic steps, and expected output columns
3. Run `/plan` or `/query` and reference your new query

See `templates/query-template.md` for the standard format.

### Commands Reference

| Command | What It Does | When to Use |
|---------|-------------|-------------|
| `/explore <use-case>` | Profile all input files — schema, stats, quality flags | First look at new data |
| `/plan <use-case> <description>` | Create a structured analysis plan | Starting a full analysis |
| `/implement [use-case]` | Execute the most recent plan | After reviewing a plan |
| `/query <use-case> <question>` | Answer a specific question | Quick one-off analysis |
| `/export <use-case> [format]` | Export results to Excel, CSV, markdown, HTML, and PDF; zipped by default (`--no-zip` to skip) | Sharing results |

For more information, see [.claude/commands/README.md](.claude/commands/README.md).

### Workflow

```
/explore  →  understand data  →  /plan  →  review plan  →  /implement  →  review report
                                                                               ↓
                                                                      /export (optional)
```

For quick one-off questions, skip the plan and use `/query` directly.

---

## How To: Use Case Builders

You want to create a new use case — a new domain, dataset, and set of queries.

### Step 1: Scaffold the Use Case

```bash
./scripts/new-use-case.sh <domain> <use-case-name>
# Example:
./scripts/new-use-case.sh finance budget-analysis
```

This creates the full directory structure with starter files from templates:

```
use-cases/finance/budget-analysis/
├── input/              # Put your data files here
│   └── README.md
├── output/             # Auto-created output dirs
├── queries/
│   └── query-template.md   # Starter template
├── tests/
│   └── test-cases.md       # Starter template
└── data-dictionary.md      # Starter template
```

### Step 2: Add Sample Data

Add representative sample data files to `input/`. Design the data intentionally:

- Include enough records to test all queries (15-30 records is usually sufficient)
- Plant specific records that trigger each query's logic
- Include edge cases: nulls, bad dates, boundary values
- Include negative test cases (records that should NOT match)
- If queries require joining files, ensure they share a join key

### Step 3: Document the Schema

Edit `data-dictionary.md` to document every input file:

- Column names, types, required/optional
- Enum values for categorical columns
- Join keys between files
- Any constraints or business rules

This is the contract between builders and analysts. Analysts rely on this to format their data correctly.

### Step 4: Define Queries

Create one `.md` file per query in `queries/`. Use the template from `templates/query-template.md`:

- **Description**: What the query finds and why it matters
- **Parameters**: Any configurable inputs (date ranges, thresholds)
- **Logic**: Step-by-step instructions (which files to load, how to join, what to filter/compute)
- **Expected Output Columns**: Column names and sources
- **Expected Results**: Specific values for the sample dataset

### Step 5: Verify and Write Test Cases

Run the queries against your sample data using Python/pandas to get actual results. Then document them in `tests/test-cases.md`:

```bash
# From Claude Code:
/query <domain>/<name> — <run each query against sample data>
```

**Always verify programmatically** — don't hand-calculate expected results.

### Step 6: Update Documentation

Add your use case to `use-cases/README.md` following the existing format:

- Domain and purpose
- Dataset descriptions with row/column counts
- Join keys
- Query summaries
- Key data design choices

### Builder Checklist

Before considering a use case complete:

- [ ] `input/` has sample data files
- [ ] `data-dictionary.md` documents every column in every file
- [ ] `queries/` has at least one query definition
- [ ] `tests/test-cases.md` has verified expected results for each query
- [ ] `use-cases/README.md` is updated with the new use case
- [ ] All test results have been verified programmatically (not hand-calculated)

---

## Project Structure

```
data-analysis/
├── .claude/commands/        # Slash commands (use-case aware)
│   ├── plan.md
│   ├── implement.md
│   ├── explore.md
│   ├── query.md
│   └── export.md
├── skills/                  # Reusable analysis prompts
├── scripts/
│   ├── new-use-case.sh      # Scaffold a new use case
│   ├── md-to-html.py        # Markdown to HTML/PDF converter
│   ├── list-output.sh       # List output files
│   └── clean-output.sh      # Clean old output
├── templates/               # Starter files and report templates
│   ├── report.html          # i-Ready branded HTML report template
│   ├── query-template.md
│   ├── test-cases-template.md
│   └── data-dictionary-template.md
└── use-cases/
    ├── README.md            # Index of all use cases
    ├── hr/
    │   └── pto-analysis/
    │       ├── input/           # employee-pto.csv, long-term-leave.csv
    │       ├── output/          # Timestamped run folders
    │       ├── queries/         # query-1-pto-during-leave.md, query-2-low-pto-usage.md
    │       ├── tests/           # test-cases.md
    │       └── data-dictionary.md
    └── sales/
        └── district-leads/
            ├── input/           # districts.csv, opportunities.csv
            ├── output/
            ├── queries/         # scoring-heuristic.md, query-1 through query-4
            ├── tests/           # test-cases.md
            └── data-dictionary.md
```

## Available Use Cases

| Domain | Use Case | Datasets | Queries | Description |
|--------|----------|----------|---------|-------------|
| hr | pto-analysis | 2 files, 12 employees | 2 queries | PTO error detection and usage tracking |
| sales | district-leads | 2 files, 15 districts, 20 opportunities | 4 queries + scoring heuristic | Sales pipeline ranking and analysis |

For more information, see [use-cases/README.md](use-cases/README.md).

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

Reusable analysis prompts in `skills/`:

| Skill | Purpose |
|-------|---------|
| `profile-data` | Column types, distributions, nulls, uniques, sample values |
| `join-strategy` | Identify join keys, relationship types, cardinality |
| `detect-anomalies` | Outliers, unexpected values, data quality issues |
| `summarize-stats` | Descriptive statistics, aggregations, group-by summaries |

For more information, see [skills/README.md](skills/README.md).

## Helper Scripts

```bash
# Scaffold a new use case
./scripts/new-use-case.sh finance budget-analysis

# List output files
./scripts/list-output.sh                        # all use cases
./scripts/list-output.sh hr/pto-analysis        # specific use case
./scripts/list-output.sh hr/pto-analysis plan   # specific type

# Clean old output
./scripts/clean-output.sh                       # 30 days, all use cases
./scripts/clean-output.sh 7 hr/pto-analysis     # 7 days, specific use case
```
