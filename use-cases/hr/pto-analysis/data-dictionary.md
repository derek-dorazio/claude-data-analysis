# Data Dictionary: HR / PTO Analysis

This documents the expected schema for each input file. If you upload new data, it **must** match these column names and types or queries will fail.

---

## employee-pto.csv

Employee paid time off entries. One row per PTO event.

| Column | Type | Required | Description | Example |
|--------|------|----------|-------------|---------|
| employeeNumber | integer | Yes | Unique employee identifier | 1001 |
| firstname | string | Yes | Employee first name | Sarah |
| lastname | string | Yes | Employee last name | Chen |
| department | string | Yes | Department name | Engineering |
| ptoDate | date (YYYY-MM-DD) | Yes | Date of the PTO entry | 2025-03-10 |
| ptoType | enum | Yes | Type of time off | vacation |
| hours | numeric | Yes | Hours taken (typically 4 or 8) | 8 |

**ptoType values**: `vacation`, `sick`, `holiday`, `personal`, `bereavement`, `parental`

### Notes
- One row per day per employee (an employee taking 3 days off = 3 rows)
- `holiday` entries are company-wide and typically automatic
- Expect multiple rows per employee across the year

---

## long-term-leave.csv

Long-term leave records. One row per leave period per employee.

| Column | Type | Required | Description | Example |
|--------|------|----------|-------------|---------|
| employeeNumber | integer | Yes | Unique employee identifier (FK to employee-pto) | 1005 |
| firstname | string | Yes | Employee first name | Emily |
| lastname | string | Yes | Employee last name | Rodriguez |
| department | string | Yes | Department name | HR |
| startDate | date (YYYY-MM-DD) | Yes | Leave start date (inclusive) | 2025-04-01 |
| endDate | date (YYYY-MM-DD) | Yes | Leave end date (inclusive) | 2025-06-30 |
| leaveEnum | enum | Yes | Type of long-term leave | maternity |

**leaveEnum values**: `paternity`, `maternity`, `mental health`, `health`, `safe leave`, `jury duty`

### Join Key

`employeeNumber` links both files. An employee may appear in one or both files.

### Notes
- An employee should have at most one active leave period at a time
- Employees on leave should NOT have PTO entries during their leave dates (this is what Query 1 detects)
