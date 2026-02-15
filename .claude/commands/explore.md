You are a data analyst performing quick data profiling.

## Input

Use case and optional file name or focus: $ARGUMENTS

## Instructions

1. **Resolve the use case**: Find the use case directory under `use-cases/`. If not specified, list available use cases and ask. Set `USE_CASE_DIR`.

2. **Find input files**: If the user specified a file, look for it in `<USE_CASE_DIR>/input/`. Otherwise, discover all files matching `*.csv`, `*.xlsx`, `*.xls`, `*.json`, `*.jsonl`.

3. **Profile each file** by running Python code:

   ```python
   import pandas as pd

   # For each file, generate:
   # - Shape (rows x columns)
   # - Column names and dtypes
   # - Null counts and percentages per column
   # - Unique value counts per column
   # - Sample values (first 3 non-null values per column)
   # - Basic statistics for numeric columns
   # - Value frequency for low-cardinality columns (< 20 unique values)
   ```

4. **Produce a profile report** for each file:

   ```markdown
   # Data Profile: <filename>
   **Use case**: <USE_CASE_DIR>
   **Rows**: N | **Columns**: N | **File size**: X KB

   ## Schema
   | Column | Type | Non-Null | Nulls (%) | Unique | Sample Values |
   |--------|------|----------|-----------|--------|---------------|

   ## Numeric Summary
   | Column | Min | Max | Mean | Median | Std Dev |
   |--------|-----|-----|------|--------|---------|

   ## Categorical Summary
   | Column | Top Values (count) |
   |--------|--------------------|

   ## Data Quality Flags
   - Columns with >50% nulls
   - Columns with only 1 unique value
   - Potential date columns stored as strings
   - Possible ID/key columns
   ```

5. **Cross-file relationships** (if multiple files):
   - Identify shared column names
   - Compare value overlap in potential join keys
   - Note compatible vs. incompatible types

6. **Save**: Create a timestamped run subfolder and save there:
   ```
   <USE_CASE_DIR>/output/<use-case-name>-YYYY-MM-DD-HHMMSS/YYYY-MM-DD-<slug>-profile.md
   ```

## Important

- All paths relative to the use case directory
- Use Python/pandas for all profiling — do not eyeball from raw file reads
- For large files (>100K rows), sample for frequency analysis but use full data for counts
- Install openpyxl/xlrd if needed for Excel files
