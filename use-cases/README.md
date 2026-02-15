# Use Cases

Each use case is a self-contained folder with its own input data, queries, tests, and output. This allows the same analysis commands (`/plan`, `/implement`, `/explore`, `/query`, `/export`) to work across different datasets and domains.

## Directory Structure

```
use-cases/
└── <domain>/
    └── <use-case-name>/
        ├── input/        # Source data files (CSV, Excel, JSON)
        ├── output/       # Generated output (plans, reports, data)
        │   ├── plan/
        │   ├── analysis/
        │   ├── explore/
        │   ├── data/
        │   └── reports/
        ├── queries/      # Predefined query definitions (.md)
        └── tests/        # Test cases with expected results
```

## Creating a New Use Case

```bash
# Create the folder structure
mkdir -p use-cases/<domain>/<name>/{input,output/{plan,analysis,explore,data,reports},queries,tests}

# Add .gitkeep files to preserve empty output dirs
touch use-cases/<domain>/<name>/output/{plan,analysis,explore,data,reports}/.gitkeep

# Drop your data files in input/
cp your-data.csv use-cases/<domain>/<name>/input/

# Optionally add query definitions and test cases
```

---

## Current Use Cases

### hr / pto-analysis

**Domain**: Human Resources
**Purpose**: Analyze employee PTO (Paid Time Off) usage and detect errors in PTO booking during long-term leave.

#### Datasets

| File | Description | Rows | Columns |
|------|-------------|------|---------|
| `employee-pto.csv` | Employee PTO entries for 2025 — 12 employees across 4 departments with date, type, and hours | 120+ | 7 (employeeNumber, firstname, lastname, department, ptoDate, ptoType, hours) |
| `long-term-leave.csv` | Long-term leave records — 6 employees with leave type and date range | 6 | 7 (employeeNumber, firstname, lastname, department, startDate, endDate, leaveEnum) |

**PTO Types**: vacation, sick, holiday, personal, bereavement, parental
**Leave Types**: paternity, maternity, mental health, health, safe leave, jury duty
**Departments**: Engineering, Marketing, Finance, HR

#### Queries

| Query | File | Description |
|-------|------|-------------|
| PTO During Leave | `query-1-pto-during-leave.md` | Find erroneous PTO entries booked during an employee's long-term leave period. Expected: 15 error rows across 5 employees. |
| Low PTO Usage | `query-2-low-pto-usage.md` | Find employees with no or low non-holiday PTO usage within a date range. Configurable threshold. 3 employees have zero non-holiday PTO. |

#### Data Quality Notes

- Employee 1006 (David Kim) has an intentional bad date value (`ptoDate = 8`) for testing data quality handling
- Employee 1009 (Lisa Nakamura) is on leave but has no PTO overlap — serves as a negative test case
