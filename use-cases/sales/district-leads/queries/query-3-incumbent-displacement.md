# Query 3: Incumbent Displacement Opportunities

## Description

Find deals where a competitor incumbent's contract is expiring within the next 12 months (from 2025-02-15). These represent time-sensitive displacement windows. Join with district data for context.

## Logic

1. Load `opportunities.csv` and `districts.csv`
2. Join on `districtId`
3. Filter where:
   - `hasIncumbent == 'Yes'`
   - `incumbentContractEnd` is a valid date
   - `incumbentContractEnd` is between 2025-02-15 and 2026-02-15
   - `salesStage` not in ('Closed Won', 'Closed Lost')
4. Sort by `incumbentContractEnd` ascending (most urgent first)

## Expected Output Columns

| Column | Source |
|--------|--------|
| opportunityId | Opportunities |
| districtName | Districts |
| state | Districts |
| amount | Opportunities |
| incumbentProduct | Opportunities |
| incumbentContractEnd | Opportunities |
| monthsUntilExpiry | Calculated |
| salesStage | Opportunities |
| probability | Opportunities |
| assignedRep | Opportunities |

## Validation Notes

- Deals with `incumbentContractEnd` > 12 months out (e.g., OPP-005, OPP-011, OPP-016) should NOT appear
- Deals with no incumbent should NOT appear
- Deals where `incumbentContractEnd` is blank (e.g., OPP-007) should NOT appear
