# Query 1: PTO Entries During Long-Term Leave

## Description

Find all instances where employees entered PTO entries between the dates of their long-term leave. This is an error — employees should not have to book PTO while out on long-term leave.

## Logic

1. Load `employee-pto.csv` and `long-term-leave.csv` from `input/`
2. Parse all date columns (handle bad date values gracefully — flag but skip unparseable dates)
3. For each long-term leave record, find PTO entries where:
   - `pto.employeeNumber == leave.employeeNumber`
   - `pto.ptoDate >= leave.startDate`
   - `pto.ptoDate <= leave.endDate`
4. Return all matching PTO rows with the corresponding leave details

## Expected Output Columns

| Column | Source |
|--------|--------|
| employeeNumber | PTO |
| firstname | PTO |
| lastname | PTO |
| department | PTO |
| ptoDate | PTO |
| ptoType | PTO |
| hours | PTO |
| leaveStartDate | Leave |
| leaveEndDate | Leave |
| leaveEnum | Leave |

## Expected Result Count

**15 rows** across 5 employees (1003, 1005, 1006, 1008, 1011)

## Validation Notes

- Employee 1009 (Lisa Nakamura) is on leave but has NO PTO during her leave period — she should NOT appear
- Employee 1006 (David Kim) has a bad date row (`ptoDate = 8`) — this should be flagged as a data quality issue, not included as a match
