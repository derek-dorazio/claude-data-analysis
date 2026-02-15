# Skill: Detect Anomalies

Find outliers, unexpected values, and data quality issues in a dataset.

## Input
- **Data**: {{INPUT}} (file path or loaded DataFrame description)

## Process

1. **Numeric outliers**:
   - Compute IQR for each numeric column
   - Flag values below Q1 - 1.5*IQR or above Q3 + 1.5*IQR
   - Check for impossible values (negative ages, percentages > 100, future dates)
   - Note extreme skewness

2. **Categorical anomalies**:
   - Find rare values (frequency < 1% of total)
   - Detect likely typos (similar strings via edit distance)
   - Inconsistent casing or formatting
   - Unexpected category values

3. **Temporal anomalies** (if date columns exist):
   - Gaps in time series
   - Records with dates outside expected range
   - Duplicate timestamps

4. **Cross-column anomalies**:
   - Contradictory values (e.g., end_date before start_date)
   - Implausible combinations
   - Correlation breaks

5. **Structural anomalies**:
   - Duplicate rows
   - Rows with all/mostly null values
   - Columns that should be unique but aren't

## Output Format

```markdown
## Anomaly Report

### Summary
- X anomalies detected across Y columns

### Findings
| Type | Column(s) | Count | Severity | Description | Example Values |
|------|-----------|-------|----------|-------------|----------------|

### Recommendations
- Numbered list of suggested actions
```
