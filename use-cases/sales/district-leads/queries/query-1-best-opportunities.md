# Query 1: Best Opportunities (Composite Score Ranking)

## Description

Rank all open pipeline opportunities using the composite scoring heuristic. Exclude Closed Won and Closed Lost deals. Join with district data to include district context in the output.

## Logic

1. Load `opportunities.csv` and `districts.csv` from `input/`
2. Join on `districtId` to get district name, state, enrollment, urbanicity
3. Exclude `salesStage` in ('Closed Won', 'Closed Lost')
4. Apply the scoring heuristic from `scoring-heuristic.md` (reference date: 2025-02-15):
   - **Deal Size (25 pts)**: `(amount / max_amount_in_pipeline) * 25`
   - **Probability (25 pts)**: `(probability / 100) * 25`
   - **Stage (20 pts)**: stage weight * 20
   - **Incumbent Factor (20 pts)**: incumbent weight * 20
   - **Recency (10 pts)**: recency weight * 10
5. Sort by total score descending

## Expected Output Columns

| Column | Source |
|--------|--------|
| opportunityId | Opportunities |
| districtName | Districts (via join) |
| state | Districts (via join) |
| enrollment | Districts (via join) |
| products | Opportunities |
| amount | Opportunities |
| salesStage | Opportunities |
| probability | Opportunities |
| totalScore | Calculated |
| scoreLabel | Calculated (Hot/Warm/Developing/Long-term) |
| assignedRep | Opportunities |

## Expected Top 5 (by composite score)

See `tests/test-cases.md` for verified scores.
