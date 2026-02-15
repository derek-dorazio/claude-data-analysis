# Query 2: Pipeline Summary by Sales Rep

## Description

Summarize the open pipeline grouped by assigned sales rep. Join with district data to include state/region context. Helps identify rep workload balance and pipeline concentration risk.

## Logic

1. Load `opportunities.csv` and `districts.csv`
2. Join on `districtId`
3. Exclude Closed Won and Closed Lost
4. Group by `assignedRep` and compute:
   - Number of open opportunities
   - Total pipeline amount
   - Weighted pipeline (sum of `amount * probability / 100`)
   - Average deal score (from Query 1 heuristic)
   - States covered (distinct list)
   - Stage distribution (count per stage)

## Expected Output Columns

| Column | Description |
|--------|-------------|
| assignedRep | Rep name |
| numOpportunities | Count of open deals |
| totalPipeline | Sum of amounts |
| weightedPipeline | Sum of amount * probability% |
| avgScore | Average composite score |
| states | Comma-separated list |
