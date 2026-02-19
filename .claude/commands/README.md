# Commands

Slash commands for the data analysis workflow. All commands are use-case aware — they resolve the target use case from your input and operate on its `input/`, `output/`, and `queries/` directories.

## Quick Reference

| Command | Purpose | Creates Output? |
|---------|---------|-----------------|
| `/explore` | Profile input data — schema, stats, quality flags | Yes |
| `/plan` | Create a structured analysis plan | Yes |
| `/implement` | Execute the most recent plan | Yes |
| `/query` | Answer a natural-language question | Optional |
| `/export` | Export results to multiple formats | Yes |

## Workflow

```
/explore  →  understand data  →  /plan  →  review plan  →  /implement  →  review report
                                                                              ↓
                                                                     /export (optional)
```

For quick one-off questions, skip the plan and use `/query` directly.

---

## `/explore`

**Purpose**: Fast data profiling without a full analysis plan. Use this as your first look at new or unfamiliar data.

**Usage**: `/explore <use-case> [file-name]`

**Examples**:
```
/explore hr/pto-analysis
/explore sales/district-leads districts.csv
```

**What it does**:
1. Resolves the use case directory
2. Discovers all input files (CSV, Excel, JSON)
3. Profiles each file with Python/pandas:
   - Shape (rows x columns)
   - Column names and data types
   - Null counts and percentages
   - Unique value counts
   - Sample values per column
   - Basic statistics for numeric columns
   - Value frequencies for low-cardinality columns (< 20 unique values)
4. Identifies cross-file relationships (shared columns, potential join keys)
5. Flags data quality issues (high nulls, single-value columns, dates stored as strings)

**Output**: `<use-case>/output/<name>-YYYY-MM-DD-HHMMSS/YYYY-MM-DD-<slug>-profile.md`

---

## `/plan`

**Purpose**: Create a structured analysis plan by profiling input data, reading query definitions, and proposing a step-by-step approach.

**Usage**: `/plan <use-case> [— description]`

**Examples**:
```
/plan hr/pto-analysis — find PTO errors and low usage
/plan sales/district-leads — rank opportunities by composite score
```

**What it does**:
1. Resolves the use case directory
2. Discovers and profiles all input files
3. Reads predefined query definitions from `queries/`
4. Checks for test cases in `tests/`
5. Identifies join keys and relationship types between files
6. Drafts a plan covering:
   - **Data Overview**: columns, types, row counts per file
   - **Data Quality Assessment**: nulls, type issues, duplicates
   - **Join Strategy**: keys, join type, expected row counts
   - **Cleaning Steps**: numbered list of data prep operations
   - **Analysis Objectives**: derived from queries and user description
   - **Proposed Outputs**: tables, summaries, and export files

**Output**: `<use-case>/output/<name>-YYYY-MM-DD-HHMMSS/YYYY-MM-DD-<slug>-plan.md`

---

## `/implement`

**Purpose**: Execute the most recent analysis plan. Loads data, cleans, joins, runs all queries, validates against test cases, and produces a report.

**Usage**: `/implement [use-case]`

**Examples**:
```
/implement
/implement hr/pto-analysis
```

**What it does**:
1. Finds the most recent plan file across use case output folders
2. Sets up Python environment (pandas, openpyxl, xlrd)
3. Loads each input file listed in the plan
4. Executes cleaning steps (nulls, types, duplicates, standardization)
5. Joins data following the plan's join strategy with diagnostics
6. Runs each analysis objective / predefined query
7. Validates results against test cases (if available)
8. Compiles a markdown report with:
   - **Executive Summary**: key findings
   - **Data Preparation**: files loaded, cleaning applied, join results
   - **Findings**: results per objective with tables
   - **Test Case Validation**: pass/fail for expected results
   - **Data Quality Notes**: issues and how they were handled

**Output**: `<use-case>/output/<name>-YYYY-MM-DD-HHMMSS/YYYY-MM-DD-<slug>-report.md` (plus data files)

---

## `/query`

**Purpose**: Answer a specific natural-language question about your data. Skips the plan step — loads data and computes an answer directly.

**Usage**: `/query <use-case> — <question>`

**Examples**:
```
/query hr/pto-analysis — which employees have zero vacation time this year?
/query sales/district-leads — what are the top 5 deals by win probability?
```

**What it does**:
1. Resolves the use case directory
2. Checks for predefined queries in `queries/` that match the question
3. Discovers and loads relevant input files
4. Writes and executes Python/pandas code to answer the question
5. Presents a clear, direct answer with supporting data tables
6. Includes the Python code used so you can verify or reuse it

**Output**: Optionally saved to `<use-case>/output/<name>-YYYY-MM-DD-HHMMSS/YYYY-MM-DD-query-<slug>.md`

---

## `/export`

**Purpose**: Export analysis results to multiple formats. Defaults to exporting all formats with zip packaging.

**Usage**: `/export <use-case> [format] [--no-zip]`

**Examples**:
```
/export hr/pto-analysis
/export sales/district-leads excel
/export hr/pto-analysis csv --no-zip
```

**What it does**:
1. Resolves the use case and finds the most recent analysis output
2. Creates a timestamped run folder for exports
3. Exports to the requested format(s):

| Format | Description | File |
|--------|-------------|------|
| `excel` | Formatted workbook with bold headers, auto-sized columns, separate sheets | `.xlsx` |
| `csv` | UTF-8 CSV with headers; multiple files if multiple tables | `.csv` |
| `markdown` | Clean markdown tables | `.md` |
| `html` | Styled HTML using `templates/report.html` (i-Ready branded) | `.html` |
| `pdf` | PDF via weasyprint (fallback: mdpdf) | `.pdf` |
| `all` | All of the above **(default)** | all |

4. Zips the run folder **(on by default)**; use `--no-zip` to skip

**Output**: `<use-case>/output/<name>-YYYY-MM-DD-HHMMSS/` (plus `.zip` archive)

---

## Common Behavior

All commands share these conventions:

- **Use case resolution**: Commands accept a use case path (e.g., `hr/pto-analysis`) or name. If omitted, available use cases are listed.
- **Output folders**: Each run creates a timestamped subfolder: `output/<name>-YYYY-MM-DD-HHMMSS/`
- **File naming**: Files within run folders follow `YYYY-MM-DD-<slug>.<ext>`
- **Input protection**: Commands never modify files in `input/`
- **Python/pandas**: All data operations use Python with pandas for reproducibility
