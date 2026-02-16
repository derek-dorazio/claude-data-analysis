# Data Analysis Workflow

An agentic Claude Code project for reading, joining, and analyzing local data files, organized by use case.

## Project Structure

```
data-analysis/
├── .claude/commands/     # Slash commands (/plan, /implement, /explore, /query, /export)
├── skills/               # Reusable analysis prompts (profile, join-strategy, anomalies, etc.)
├── scripts/              # Helper shell scripts
├── templates/            # Reusable output templates
└── use-cases/            # All data, queries, tests, and output live here
    └── <domain>/
        └── <use-case>/
            ├── input/    # CSV, Excel, JSON data files
            ├── output/   # Timestamped run folders: <name>-YYYY-MM-DD-HHMMSS/
            ├── queries/  # Predefined query definitions (.md)
            └── tests/    # Test cases with expected results
```

## Use Cases

Each use case is a self-contained folder under `use-cases/<domain>/<name>/` with its own input data, queries, tests, and output. Commands automatically resolve the use case from user input.

### Current Use Cases

- `use-cases/hr/pto-analysis` — PTO and long-term leave analysis
- `use-cases/sales/district-leads` — Sales pipeline scoring, ranking, and opportunity analysis

## Supported Input Formats

- **CSV** (.csv) — comma, tab, pipe, or semicolon delimited
- **Excel** (.xlsx, .xls) — single or multi-sheet workbooks
- **JSON** (.json) — flat arrays, nested objects, or JSON Lines (.jsonl)

## Workflow

1. **Plan** (`/plan`) — Reads input files, profiles the data, and produces an analysis plan
2. **Implement** (`/implement`) — Executes an analysis plan with Python/pandas

### Quick Commands

- `/explore` — Fast data profiling without a full plan
- `/query` — Ask a natural-language question about your data
- `/export` — Convert analysis results to Excel, CSV, markdown, HTML, and PDF (all by default)

## Skills

| Skill | Purpose |
|---|---|
| `profile-data` | Column types, distributions, nulls, uniques, sample values |
| `join-strategy` | Identify join keys, relationship types, cardinality |
| `detect-anomalies` | Outliers, unexpected values, data quality issues |
| `summarize-stats` | Descriptive statistics, aggregations, group-by summaries |

## Conventions

- **Output folders**: Each command run creates `output/<use-case-name>-YYYY-MM-DD-HHMMSS/`
- **File naming**: `YYYY-MM-DD-<slug>.<ext>` for files within run folders
- **Python**: Use pandas for data manipulation; scripts are ephemeral
- **Reports**: Markdown format with tables; HTML reports use `templates/report.html`
- **Use case paths**: Always `use-cases/<domain>/<name>/`

## Tools Available

- **Read / Write / Glob / Grep** — file operations
- **Bash** — run Python/pandas scripts, shell commands
- **MCP: excel** — read/write Excel workbooks directly
- **MCP: filesystem** — enhanced file operations
- **md-to-html.py** — markdown-to-HTML/PDF conversion (`python3 scripts/md-to-html.py input.md output.html [--pdf output.pdf]`)
- **weasyprint** — HTML-to-PDF engine (used by md-to-html.py)
- **mdpdf** — markdown-to-PDF fallback (`mdpdf -o output.pdf input.md`)

## Important Notes

- Always read and profile input data before proposing joins or analysis
- Validate join keys exist and check cardinality before joining
- Preserve original input files — never modify files in `input/`
- All output goes to timestamped run folders under the use case's `output/` directory
- Queries in `queries/` define reusable, testable analysis objectives
- Tests in `tests/` provide expected results for validation
