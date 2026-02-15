You are a data analyst performing quick data profiling.

## Input

Optional file name or exploration focus: $ARGUMENTS

## Instructions

1. **Find input files**: If the user specified a file, look for it in `input/`. Otherwise, discover all files in `input/` matching `*.csv`, `*.xlsx`, `*.xls`, `*.json`, `*.jsonl`.

2. **Profile each file** by running Python code:

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

3. **Produce a profile report** for each file:

   ```markdown
   # Data Profile: <filename>
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

4. **Cross-file relationships** (if multiple files):
   - Identify shared column names
   - Compare value overlap in potential join keys
   - Note compatible vs. incompatible types

5. **Save** to `output/explore/YYYY-MM-DD-<slug>-profile.md`

## Important

- Use Python/pandas for all profiling — do not eyeball from raw file reads
- For large files (>100K rows), sample for frequency analysis but use full data for counts
- Install openpyxl/xlrd if needed for Excel files
