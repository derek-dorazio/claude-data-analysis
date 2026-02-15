# Data Analysis Workflow

An agentic Claude Code project for reading, joining, and analyzing local data files.

## Project Structure

```
data-analysis/
├── .claude/commands/     # Slash commands (/plan, /implement, /explore, /query, /export)
├── skills/               # Reusable analysis prompts (profile, join-strategy, anomalies, etc.)
├── scripts/              # Helper shell scripts
├── input/                # Drop CSV, Excel, or JSON files here
├── output/
│   ├── plan/             # Analysis plans
│   ├── analysis/         # Full analysis reports
│   ├── explore/          # Quick data profiles
│   ├── data/             # Generated Excel/CSV output
│   └── reports/          # Summary reports
└── templates/            # Reusable output templates
```

## Supported Input Formats

- **CSV** (.csv) — comma, tab, pipe, or semicolon delimited
- **Excel** (.xlsx, .xls) — single or multi-sheet workbooks
- **JSON** (.json) — flat arrays, nested objects, or JSON Lines (.jsonl)

Place input files in the `input/` folder before running commands.

## Workflow

1. **Plan** (`/plan`) — Reads input files, profiles the data, and produces an analysis plan with join strategy, cleaning steps, and analysis objectives.
2. **Implement** (`/implement`) — Executes an analysis plan by writing and running Python/pandas code to load, clean, join, and analyze the data.

### Quick Commands

- `/explore` — Fast data profiling (schema, stats, quality) without a full plan
- `/query` — Ask a natural-language question about your data and get an answer
- `/export` — Convert analysis results to Excel, CSV, or markdown

## Skills

| Skill | Purpose |
|---|---|
| `profile-data` | Column types, distributions, nulls, uniques, sample values |
| `join-strategy` | Identify join keys, relationship types, cardinality |
| `detect-anomalies` | Outliers, unexpected values, data quality issues |
| `summarize-stats` | Descriptive statistics, aggregations, group-by summaries |

## Conventions

- **File naming**: `YYYY-MM-DD-<slug>.<ext>` for all output
- **Python**: Use pandas for data manipulation; scripts are ephemeral (generated, run, results kept)
- **Reports**: Markdown format with tables, saved to `output/analysis/` or `output/reports/`

## Tools Available

- **Read / Write / Glob / Grep** — file operations
- **Bash** — run Python/pandas scripts, shell commands
- **MCP: excel** — read/write Excel workbooks directly
- **MCP: filesystem** — enhanced file operations on input/output dirs

## Important Notes

- Always read and profile input data before proposing joins or analysis
- Validate join keys exist and check cardinality before joining
- Preserve original input files — never modify files in `input/`
- Generated Python scripts are means to an end; the output data and reports are the deliverables
