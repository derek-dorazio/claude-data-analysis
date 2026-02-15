# Query 2: Employees with No or Low PTO Usage

## Description

Find employees with no PTO time — or less than a given threshold — within a date range. Holidays are excluded from the count since they are automatic. This helps identify employees who may not be taking adequate time off.

## Parameters

- **date_start**: Start of the date range (e.g., `2025-01-01`)
- **date_end**: End of the date range (e.g., `2025-12-31`)
- **threshold_hours**: Maximum hours below which an employee is flagged (e.g., `0`, `16`, `40`)

## Logic

1. Load `employee-pto.csv` from `input/`
2. Parse date columns (skip unparseable dates)
3. Filter PTO records to the specified date range
4. Exclude `ptoType == 'holiday'` — only count voluntary/discretionary PTO
5. Sum hours per employee
6. Include employees with zero non-holiday PTO (they may not appear in the filtered set at all — use the full employee list)
7. Return employees where total non-holiday hours < threshold

## Expected Output Columns

| Column | Description |
|--------|-------------|
| employeeNumber | Employee ID |
| firstname | First name |
| lastname | Last name |
| department | Department |
| nonHolidayPtoHours | Total non-holiday PTO hours in the date range |

## Expected Results (Full Year 2025)

### Threshold = 0 (zero PTO): 3 employees

| # | Employee | Hours |
|---|----------|-------|
| 1006 | David Kim | 0 |
| 1009 | Lisa Nakamura | 0 |
| 1011 | Angela Brooks | 0 |

### Threshold < 40 hours: 6 employees

Adds: Sarah Chen (28), James Martinez (32), Rachel Foster (36)

### Threshold < 50 hours: 8 employees

Adds: Marcus Thompson (44), Kevin O'Brien (48)

## Reference: All Employee Non-Holiday PTO Totals (2025)

| # | Employee | Department | Hours |
|---|----------|------------|-------|
| 1006 | David Kim | Finance | 0 |
| 1009 | Lisa Nakamura | HR | 0 |
| 1011 | Angela Brooks | Engineering | 0 |
| 1001 | Sarah Chen | Engineering | 28 |
| 1002 | James Martinez | Marketing | 32 |
| 1007 | Rachel Foster | Marketing | 36 |
| 1004 | Marcus Thompson | Engineering | 44 |
| 1012 | Kevin O'Brien | Marketing | 48 |
| 1003 | Priya Patel | Finance | 56 |
| 1005 | Emily Rodriguez | HR | 64 |
| 1008 | Tom Wilson | Engineering | 80 |
| 1010 | Carlos Rivera | Finance | 80 |
