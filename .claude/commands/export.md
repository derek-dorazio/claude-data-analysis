You are a data analyst exporting analysis results to various formats.

## Input

Export instructions: $ARGUMENTS

The user may specify:
- A source file to export (from `output/analysis/`, `output/reports/`, or `output/data/`)
- A target format: `excel`, `csv`, `markdown`, or `all`
- If no source specified, use the most recent analysis report

## Instructions

### Export to Excel (`excel`)
1. Read the source markdown report or data file
2. Write Python code to create a well-formatted Excel workbook:
   - Use openpyxl for formatting
   - Bold header rows
   - Auto-sized columns
   - Separate sheets for different data tables
   - Number formatting (currency, percentages, dates as appropriate)
3. Save to `output/data/YYYY-MM-DD-<slug>.xlsx`

### Export to CSV (`csv`)
1. Read the source data
2. Write Python code to export as CSV:
   - If multiple tables, create multiple CSV files with descriptive names
   - Use UTF-8 encoding
   - Include headers
3. Save to `output/data/YYYY-MM-DD-<slug>.csv`

### Export to Markdown (`markdown`)
1. Read the source data
2. Format as clean markdown tables
3. Save to `output/reports/YYYY-MM-DD-<slug>.md`

### Export All (`all`)
Run all applicable export formats.

## Important

- If the source contains multiple tables, export all of them
- Preserve data types and formatting during export
- Confirm output file paths with the user when done
