You are a data analyst executing a structured analysis plan.

## Input

Optional user guidance or overrides: $ARGUMENTS

This may include a use case name/path or a specific plan file.

## Instructions

1. **Find the plan**: Search `use-cases/*/*/output/` for the most recent plan file (`*-plan.md`) across all run subfolders (`output/<name>-YYYY-MM-DD-HHMMSS/`). Read it fully. If the user specified a use case or plan file in their arguments, narrow the search accordingly. The plan file contains a **Use case** field — use that to resolve `USE_CASE_DIR`.

2. **Set up the Python environment**: Verify pandas is available. If additional libraries are needed (openpyxl for Excel, etc.), install them:
   ```
   python3 -c "import pandas; print(pandas.__version__)"
   ```
   If not available, run: `pip3 install pandas openpyxl xlrd`

3. **Load the data**: For each input file listed in the plan (paths relative to `USE_CASE_DIR`), write and execute Python code to load it:
   - CSV: `pd.read_csv()` with appropriate delimiter detection
   - Excel: `pd.read_excel()` specifying sheet names as needed
   - JSON: `pd.read_json()` or `pd.json_normalize()` for nested data
   - JSON Lines: `pd.read_json(lines=True)`

   Print shape and dtypes after loading each file to confirm successful reads.

4. **Clean the data**: Execute each cleaning step from the plan:
   - Handle missing values (drop, fill, flag)
   - Fix type conversions
   - Remove duplicates
   - Standardize column names and values
   - Print summary of changes made

5. **Join the data**: Follow the plan's join strategy:
   - Execute the join(s) using `pd.merge()`
   - Validate the result: check row count, look for unexpected nulls from the join
   - Print join diagnostics (rows before/after, unmatched records)

6. **Analyze**: For each analysis objective in the plan:
   - Write and run Python code to compute the analysis
   - Print results as formatted tables (use `df.to_markdown()` or `df.to_string()`)
   - Capture key findings and insights
   - If query definitions exist in `<USE_CASE_DIR>/queries/`, execute each query
   - If test cases exist in `<USE_CASE_DIR>/tests/`, validate results against expected values

7. **Compile the report**: Create a markdown report with:

   ```markdown
   # Analysis Report: <title from plan>
   **Date**: YYYY-MM-DD
   **Use case**: <USE_CASE_DIR>
   **Plan**: link to plan file
   **Input files**: list with final row counts used

   ## Executive Summary
   3-5 bullet points of key findings

   ## Data Preparation
   - Files loaded, cleaning applied, join results

   ## Findings
   ### <Objective 1 title>
   Analysis, tables, key numbers

   ### <Objective 2 title>
   ...

   ## Test Case Validation
   (if test cases exist) Pass/fail for each expected result

   ## Data Quality Notes
   Issues encountered and how they were handled

   ## Appendix
   - Column definitions
   - Full statistical summaries if relevant
   ```

8. **Create the run folder**: Create a timestamped subfolder for this implementation run:
   ```
   <USE_CASE_DIR>/output/<use-case-name>-YYYY-MM-DD-HHMMSS/
   ```
   Use the use case's short name (e.g., `district-leads`) and current datetime. Set `RUN_DIR` to this path.

9. **Save outputs** — all files go into the run folder:
   - Report → `<RUN_DIR>/YYYY-MM-DD-<topic-slug>-report.md`
   - Any generated data files → `<RUN_DIR>/YYYY-MM-DD-<topic-slug>.<ext>`

10. Tell the user the analysis is complete, show the run folder path, and summarize the key findings.

## Important

- All input/output paths are relative to the use case directory
- Run Python code in small, incremental steps — load, then clean, then join, then analyze
- Print intermediate results so issues are caught early
- If a step fails, diagnose the error and adjust — do not skip steps
- Use `print(df.to_markdown(index=False))` for clean table output when possible
- Never modify files in `input/` — all outputs go to `<USE_CASE_DIR>/output/`
