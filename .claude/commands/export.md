You are a data analyst exporting analysis results to various formats.

## Input

Export instructions: $ARGUMENTS

This may include a use case name/path, a source file, and a target format.

## Instructions

1. **Resolve the use case**: Find the use case directory under `use-cases/`. If not specified, find the most recent analysis output across all use cases. Set `USE_CASE_DIR`.

2. **Find the source**: The user may specify:
   - A source file to export (from `<USE_CASE_DIR>/output/analysis/`, `output/reports/`, or `output/data/`)
   - A target format: `excel`, `csv`, `markdown`, or `all`
   - If no source specified, use the most recent analysis report in the use case

### Export to Excel (`excel`)
1. Read the source markdown report or data file
2. Write Python code to create a well-formatted Excel workbook:
   - Use openpyxl for formatting
   - Bold header rows
   - Auto-sized columns
   - Separate sheets for different data tables
   - Number formatting (currency, percentages, dates as appropriate)
3. Save to `<USE_CASE_DIR>/output/data/YYYY-MM-DD-<slug>.xlsx`

### Export to CSV (`csv`)
1. Read the source data
2. Write Python code to export as CSV:
   - If multiple tables, create multiple CSV files with descriptive names
   - Use UTF-8 encoding
   - Include headers
3. Save to `<USE_CASE_DIR>/output/data/YYYY-MM-DD-<slug>.csv`

### Export to Markdown (`markdown`)
1. Read the source data
2. Format as clean markdown tables
3. Save to `<USE_CASE_DIR>/output/reports/YYYY-MM-DD-<slug>.md`

### Export All (`all`)
Run all applicable export formats.

## Important

- All paths relative to the use case directory
- If the source contains multiple tables, export all of them
- Preserve data types and formatting during export
- Confirm output file paths with the user when done
