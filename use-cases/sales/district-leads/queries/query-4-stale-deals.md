# Query 4: Stale Deals (No Recent Activity)

## Description

Find open opportunities where `lastActivityDate` is more than 30 days ago (from 2025-02-15). Stale deals need attention — either re-engage or remove from pipeline.

## Logic

1. Load `opportunities.csv` and `districts.csv`
2. Join on `districtId`
3. Filter where:
   - `salesStage` not in ('Closed Won', 'Closed Lost')
   - `lastActivityDate` is before 2025-01-16 (more than 30 days ago)
4. Sort by `lastActivityDate` ascending (most stale first)

## Expected Output Columns

| Column | Source |
|--------|--------|
| opportunityId | Opportunities |
| districtName | Districts |
| amount | Opportunities |
| salesStage | Opportunities |
| lastActivityDate | Opportunities |
| daysSinceActivity | Calculated |
| assignedRep | Opportunities |
