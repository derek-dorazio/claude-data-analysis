You are a data analyst exporting analysis results to various formats.

## Input

Export instructions: $ARGUMENTS

This may include a use case name/path, a source file, and a target format.

## Instructions

1. **Resolve the use case**: Find the use case directory under `use-cases/`. If not specified, find the most recent analysis output across all use cases. Set `USE_CASE_DIR`.

2. **Create the run folder**: Create a timestamped subfolder for this export run:
   ```
   <USE_CASE_DIR>/output/<use-case-name>-YYYY-MM-DD-HHMMSS/
   ```
   Use the use case's short name (e.g., `district-leads`) and current datetime. Set `RUN_DIR` to this path. All output files for this run go here.

3. **Find the source**: The user may specify:
   - A source file to export (from a previous run folder, or from `<USE_CASE_DIR>/output/`)
   - A target format: `excel`, `csv`, `markdown`, `pdf`, or `all`
   - **Default format is `all`** — if no format is specified, export all formats
   - If no source specified, use the most recent analysis output in the use case

### Export to Excel (`excel`)
1. Read the source markdown report or data file
2. Write Python code to create a well-formatted Excel workbook:
   - Use openpyxl for formatting
   - Bold header rows
   - Auto-sized columns
   - Separate sheets for different data tables
   - Number formatting (currency, percentages, dates as appropriate)
3. Save to `<RUN_DIR>/YYYY-MM-DD-<slug>.xlsx`

### Export to CSV (`csv`)
1. Read the source data
2. Write Python code to export as CSV:
   - If multiple tables, create multiple CSV files with descriptive names
   - Use UTF-8 encoding
   - Include headers
3. Save to `<RUN_DIR>/YYYY-MM-DD-<slug>.csv`

### Export to Markdown (`markdown`)
1. Read the source data
2. Format as clean markdown tables
3. Save to `<RUN_DIR>/YYYY-MM-DD-<slug>.md`

### Export to PDF (`pdf`)
1. Read the source markdown report (or generate markdown from data first)
2. Generate PDF using `mdpdf` via Bash:
   ```
   mdpdf -o "<RUN_DIR>/YYYY-MM-DD-<slug>.pdf" "<source-markdown-file>"
   ```
3. Verify the PDF was created and has non-zero size

### Export All (`all`) — **this is the default**
Run all applicable export formats (excel, csv, markdown, pdf).

## Important

- All output files go into the run folder (`<RUN_DIR>`)
- If the source contains multiple tables, export all of them
- Preserve data types and formatting during export
- Confirm the run folder path and all output file paths with the user when done
