# Skill: Join Strategy

Determine the optimal strategy for joining multiple datasets.

## Input
- **Files**: {{FILES}} (list of files to join)

## Process

1. Load all files and identify column names in each
2. Find candidate join keys:
   - Exact column name matches across files
   - Similar column names (fuzzy match: id vs ID vs Id, customer_id vs customerID)
   - Columns with overlapping value sets even if differently named
3. For each candidate key pair, assess:
   - **Type compatibility**: Do types match? Can they be coerced?
   - **Value overlap**: What percentage of values in file A exist in file B?
   - **Cardinality**: One-to-one, one-to-many, or many-to-many?
   - **Uniqueness**: Is the key unique in each file?
   - **Null keys**: Any null values in join columns?
4. Recommend:
   - Join key(s) to use
   - Join type (inner, left, right, outer) with rationale
   - Join order if more than 2 files
   - Pre-join cleaning needed (type casting, trimming, case normalization)
   - Expected result shape

## Output Format

```markdown
## Join Strategy

### Candidate Keys
| File A Column | File B Column | Overlap % | Cardinality | Recommended |
|---|---|---|---|---|

### Recommended Join
- **Keys**: file_a.col = file_b.col
- **Type**: left join
- **Rationale**: ...
- **Expected rows**: ~N
- **Pre-join steps**: ...
```
