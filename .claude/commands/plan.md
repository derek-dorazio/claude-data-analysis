You are a data analyst creating a structured analysis plan for a specific use case.

## Input

The user's analysis request: $ARGUMENTS

This should include or reference a use case path under `use-cases/` (e.g., `hr/pto-analysis`).

## Instructions

1. **Resolve the use case**: Identify the use case directory under `use-cases/`. If the user provided a name or path, find the matching folder. If not specified, use Glob to list available use cases (`use-cases/*/*/`) and ask which to use.

   Set `USE_CASE_DIR` = the resolved path (e.g., `use-cases/hr/pto-analysis`).

2. **Discover input files**: Use Glob to find all files in `<USE_CASE_DIR>/input/` matching `*.csv`, `*.xlsx`, `*.xls`, `*.json`, `*.jsonl`. List every file found.

3. **Check for queries**: Look for query definitions in `<USE_CASE_DIR>/queries/`. If they exist, read them and incorporate as analysis objectives.

4. **Check for test cases**: Look for test case files in `<USE_CASE_DIR>/tests/`. If they exist, note the expected results for validation during implementation.

5. **Profile each file**: For each input file:
   - Read or sample the file to understand its structure
   - For CSV: detect delimiter, read first 5-10 rows, identify columns and types
   - For Excel: list all sheets, read first 5-10 rows of each sheet, identify columns and types
   - For JSON: detect structure (array of objects, nested, JSON Lines), identify fields and types
   - Note: row count, column count, sample values, obvious data quality issues (nulls, mixed types)

6. **Identify relationships**: Across all input files:
   - Find columns that could serve as join keys (shared names, matching value patterns)
   - Assess relationship type (one-to-one, one-to-many, many-to-many)
   - Note cardinality and potential issues (mismatched keys, duplicates)

7. **Draft the analysis plan** with these sections:

   ```markdown
   # Analysis Plan: <descriptive title>
   **Date**: YYYY-MM-DD
   **Use case**: <USE_CASE_DIR>
   **Input files**: list each file with row/column counts

   ## Data Overview
   For each file: columns, types, row count, notable observations

   ## Data Quality Assessment
   - Missing values per file/column
   - Type inconsistencies
   - Duplicate detection
   - Value range issues

   ## Join Strategy
   - Join keys identified
   - Join type (inner, left, outer) and rationale
   - Expected row count after join
   - Handling of unmatched records

   ## Cleaning Steps
   Numbered list of data cleaning operations needed before analysis

   ## Analysis Objectives
   Based on user request, query definitions, and available data:
   1. Objective with specific columns/metrics involved
   2. ...

   ## Proposed Outputs
   - Tables, charts, summaries, or export files to produce
   ```

8. **Save the plan** to `<USE_CASE_DIR>/output/plan/YYYY-MM-DD-<topic-slug>.md`

9. Tell the user the plan is ready for review and they can run `/implement` to execute it.

## Important

- All paths are relative to the use case directory — input from `<USE_CASE_DIR>/input/`, output to `<USE_CASE_DIR>/output/`
- Read actual file contents — do not guess schemas
- If no input files are found, tell the user to place files in the use case's `input/` folder
- If query definitions exist in `queries/`, use them as the primary analysis objectives
- Use Python (pandas) via Bash to profile large files if needed
