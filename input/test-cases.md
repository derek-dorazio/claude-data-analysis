# Test Cases for Employee PTO & Leave Queries

These test cases document expected results for queries against `employee-pto.csv` and `long-term-leave.csv`. Results have been verified programmatically.

---

## Data Design Summary

### All Employees (12 total)

| # | Employee | Department | On Leave? |
|---|----------|------------|-----------|
| 1001 | Sarah Chen | Engineering | No |
| 1002 | James Martinez | Marketing | No |
| 1003 | Priya Patel | Finance | Yes — paternity 2025-09-15 to 2025-12-15 |
| 1004 | Marcus Thompson | Engineering | No |
| 1005 | Emily Rodriguez | HR | Yes — maternity 2025-04-01 to 2025-06-30 |
| 1006 | David Kim | Finance | Yes — health 2025-06-01 to 2025-08-31 |
| 1007 | Rachel Foster | Marketing | No |
| 1008 | Tom Wilson | Engineering | Yes — mental health 2025-06-01 to 2025-07-31 |
| 1009 | Lisa Nakamura | HR | Yes — safe leave 2025-01-13 to 2025-04-13 |
| 1010 | Carlos Rivera | Finance | No |
| 1011 | Angela Brooks | Engineering | Yes — jury duty 2025-02-01 to 2025-05-31 |
| 1012 | Kevin O'Brien | Marketing | No |

### Intentional Data Quality Issue

Employee 1006 (David Kim) has a row with `ptoDate` = `8` instead of a valid date. This should be flagged during data quality checks.

---

## Query 1: PTO Entries During Long-Term Leave (Errors)

**Logic**: Find PTO records where `ptoDate` falls between the employee's long-term leave `startDate` and `endDate` (inclusive). These are errors — employees on leave should not be booking PTO.

### Expected Results (15 rows)

| # | Employee | PTO Date | PTO Type | Hours | Leave Period | Leave Type |
|---|----------|----------|----------|-------|--------------|------------|
| 1003 | Priya Patel | 2025-11-27 | holiday | 8 | 2025-09-15 to 2025-12-15 | paternity |
| 1005 | Emily Rodriguez | 2025-04-07 | parental | 8 | 2025-04-01 to 2025-06-30 | maternity |
| 1005 | Emily Rodriguez | 2025-04-08 | parental | 8 | 2025-04-01 to 2025-06-30 | maternity |
| 1005 | Emily Rodriguez | 2025-04-09 | parental | 8 | 2025-04-01 to 2025-06-30 | maternity |
| 1005 | Emily Rodriguez | 2025-04-10 | parental | 8 | 2025-04-01 to 2025-06-30 | maternity |
| 1005 | Emily Rodriguez | 2025-04-11 | parental | 8 | 2025-04-01 to 2025-06-30 | maternity |
| 1005 | Emily Rodriguez | 2025-05-02 | vacation | 8 | 2025-04-01 to 2025-06-30 | maternity |
| 1005 | Emily Rodriguez | 2025-05-05 | sick | 8 | 2025-04-01 to 2025-06-30 | maternity |
| 1005 | Emily Rodriguez | 2025-05-12 | vacation | 8 | 2025-04-01 to 2025-06-30 | maternity |
| 1005 | Emily Rodriguez | 2025-05-26 | holiday | 8 | 2025-04-01 to 2025-06-30 | maternity |
| 1006 | David Kim | 2025-07-04 | holiday | 8 | 2025-06-01 to 2025-08-31 | health |
| 1008 | Tom Wilson | 2025-06-18 | sick | 8 | 2025-06-01 to 2025-07-31 | mental health |
| 1008 | Tom Wilson | 2025-06-19 | sick | 8 | 2025-06-01 to 2025-07-31 | mental health |
| 1008 | Tom Wilson | 2025-07-04 | holiday | 8 | 2025-06-01 to 2025-07-31 | mental health |
| 1011 | Angela Brooks | 2025-05-26 | holiday | 8 | 2025-02-01 to 2025-05-31 | jury duty |

**Summary by employee**:
- 1005 Emily Rodriguez: 9 error entries (heaviest offender — PTO during maternity leave)
- 1008 Tom Wilson: 3 error entries (sick days + holiday during mental health leave)
- 1003 Priya Patel: 1 error entry (Thanksgiving holiday during paternity leave)
- 1006 David Kim: 1 error entry (July 4th holiday during health leave)
- 1011 Angela Brooks: 1 error entry (Memorial Day holiday during jury duty)

**Employees on leave with NO errors**:
- 1009 Lisa Nakamura — on safe leave 2025-01-13 to 2025-04-13, but all her PTO dates fall outside this range

---

## Query 2: Employees with No/Low PTO in a Date Range

### Reference: Non-Holiday PTO Hours by Employee (Full Year 2025)

| # | Employee | Department | Non-Holiday Hours | Breakdown |
|---|----------|------------|-------------------|-----------|
| 1006 | David Kim | Finance | 0 | holidays only |
| 1009 | Lisa Nakamura | HR | 0 | holidays only |
| 1011 | Angela Brooks | Engineering | 0 | holidays only |
| 1001 | Sarah Chen | Engineering | 28 | vacation 8 + sick 4 + vacation 8 + vacation 8 |
| 1002 | James Martinez | Marketing | 32 | personal 8 + vacation 8+8+8 |
| 1007 | Rachel Foster | Marketing | 36 | sick 4 + vacation 8+8 + personal 8 + sick 8 |
| 1004 | Marcus Thompson | Engineering | 44 | bereavement 8+8+8 + sick 4 + vacation 8+8 |
| 1012 | Kevin O'Brien | Marketing | 48 | vacation 8+8 + sick 8 + vacation 8+8+8 |
| 1003 | Priya Patel | Finance | 56 | sick 8 + vacation 8 + vacation 8+8+8+8+8 |
| 1005 | Emily Rodriguez | HR | 64 | parental 8+8+8+8+8 + vacation 8 + sick 8 + vacation 8 |
| 1008 | Tom Wilson | Engineering | 80 | vacation 8*5 + sick 8+8 + vacation 8*3 |
| 1010 | Carlos Rivera | Finance | 80 | personal 8 + vacation 8*5 + vacation 8+8 + vacation 8+8 |

### Test Case 2a: Zero non-holiday PTO in 2025

**Expected**: 3 employees — David Kim (1006), Lisa Nakamura (1009), Angela Brooks (1011)

### Test Case 2b: Less than 40 hours non-holiday PTO in 2025

**Expected**: 6 employees

| # | Employee | Non-Holiday Hours |
|---|----------|-------------------|
| 1006 | David Kim | 0 |
| 1009 | Lisa Nakamura | 0 |
| 1011 | Angela Brooks | 0 |
| 1001 | Sarah Chen | 28 |
| 1002 | James Martinez | 32 |
| 1007 | Rachel Foster | 36 |

### Test Case 2c: Less than 50 hours non-holiday PTO in 2025

**Expected**: 8 employees (adds Marcus Thompson at 44 and Kevin O'Brien at 48)
