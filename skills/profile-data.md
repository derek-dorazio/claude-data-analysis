# Skill: Profile Data

Generate a comprehensive profile of a dataset.

## Input
- **File**: {{FILE}} (path to CSV, Excel, or JSON file)

## Process

1. Load the file using pandas with appropriate reader
2. Compute for each column:
   - Data type (as inferred by pandas and as semantic type: ID, category, numeric, date, text, boolean)
   - Non-null count and null percentage
   - Unique value count and cardinality ratio (unique / total)
   - Min, max, mean, median, std dev (for numeric)
   - Top 5 most frequent values with counts (for categorical)
   - Min/max length (for string columns)
   - Date range (for datetime columns)
3. Compute dataset-level metrics:
   - Total rows and columns
   - Complete rows (no nulls) count and percentage
   - Duplicate row count
   - Memory usage estimate
4. Flag potential issues:
   - Columns with >50% nulls
   - Constant columns (1 unique value)
   - High-cardinality string columns (possible free text vs. category)
   - Numeric columns with suspicious distributions (all same value, extreme outliers)
   - Date columns stored as strings

## Output Format

Structured markdown with:
- Schema table
- Numeric summary table
- Categorical summary table
- Data quality flags list
