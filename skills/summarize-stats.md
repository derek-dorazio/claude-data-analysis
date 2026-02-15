# Skill: Summarize Statistics

Generate descriptive statistics, aggregations, and group-by summaries.

## Input
- **Data**: {{INPUT}} (file path or description of loaded data)
- **Focus**: {{TOPIC}} (optional — specific columns or metrics of interest)

## Process

1. **Overall descriptive statistics**:
   - Count, mean, std, min, 25%, 50%, 75%, max for all numeric columns
   - Value counts for categorical columns
   - Date ranges for temporal columns

2. **Group-by analysis** (if categorical columns exist):
   - For each low-cardinality categorical column, compute:
     - Count per group
     - Mean/median of numeric columns per group
     - Percentage of total per group

3. **Correlation analysis**:
   - Pairwise correlation matrix for numeric columns
   - Highlight strong correlations (|r| > 0.7)

4. **Distribution insights**:
   - Identify skewed distributions
   - Note bimodal or unusual patterns
   - Flag uniform distributions (may indicate synthetic data)

5. **Key takeaways**:
   - Top 3-5 most interesting statistical findings
   - Patterns that suggest further investigation

## Output Format

```markdown
## Statistical Summary

### Descriptive Statistics
| Column | Count | Mean | Std | Min | 25% | 50% | 75% | Max |
|--------|-------|------|-----|-----|-----|-----|-----|-----|

### Group Analysis
| Group | Count | % of Total | Avg <metric> | Median <metric> |
|-------|-------|------------|--------------|-----------------|

### Correlations
| Column A | Column B | Correlation | Strength |
|----------|----------|-------------|----------|

### Key Findings
1. ...
```
