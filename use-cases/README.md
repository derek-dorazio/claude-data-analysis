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

---

### sales / district-leads

**Domain**: Sales
**Purpose**: Analyze and rank software sales opportunities to K-12 school districts. Uses a composite scoring heuristic to identify "best" opportunities based on deal size, probability, stage, incumbent situation, and engagement recency.

#### Datasets

| File | Description | Rows | Columns |
|------|-------------|------|---------|
| `districts.csv` | School district profiles — ID, name, state, enrollment, school count, urbanicity, Title I percentage | 15 | 7 (districtId, districtName, state, enrollment, numSchools, urbanicity, title1Pct) |
| `opportunities.csv` | Sales pipeline opportunities — linked to districts by districtId, with products, amounts, stages, incumbent info, and rep assignments | 20 | 13 (opportunityId, districtId, products, amount, salesStage, probability, hasIncumbent, incumbentProduct, incumbentContractEnd, assignedRep, lastActivityDate, createdDate, notes) |

**Join key**: `districtId` (districts.csv) -> `districtId` (opportunities.csv)
**Products**: i-Ready Math, i-Ready Reading, Magnetic Reading
**Sales Stages**: Prospect, Qualified, Demo, Proposal, Negotiation, Closed Won, Closed Lost
**Sales Reps**: Maria Santos, James Park, Kevin O'Neill, Sarah Lin

#### Scoring Heuristic

A composite score (0-100) combining five weighted factors:

| Factor | Weight | Description |
|--------|--------|-------------|
| Deal Size | 25 pts | Normalized against largest open deal |
| Win Probability | 25 pts | From probability field |
| Stage Advancement | 20 pts | Later stages score higher |
| Incumbent Factor | 20 pts | No incumbent = best; expiring contract = good; entrenched = worst |
| Engagement Recency | 10 pts | Recent activity = higher score |

See `queries/scoring-heuristic.md` for full formula.

#### Queries

| Query | File | Description |
|-------|------|-------------|
| Best Opportunities | `query-1-best-opportunities.md` | Rank all open pipeline deals by composite score. Top deal: OPP-001 at 74.2 (Warm). |
| Pipeline by Rep | `query-2-pipeline-by-rep.md` | Summarize pipeline by sales rep — deal count, total/weighted amounts, average score. |
| Incumbent Displacement | `query-3-incumbent-displacement.md` | Find deals where competitor contract expires within 12 months. Expected: 6 opportunities. |
| Stale Deals | `query-4-stale-deals.md` | Find open deals with no activity in 30+ days. Expected: 3 opportunities. |

#### Key Data Design Choices

- **Normalized data**: District info is separate from opportunities — queries must join on `districtId`
- **Multiple opps per district**: D002 (Riverside) and D014 (Detroit) each have 2+ opportunities
- **2 closed deals** (OPP-012 Closed Won, OPP-020 Closed Lost) to test exclusion filters
- **Stale deals** planted: OPP-016 (87 days stale), OPP-011 (62 days), OPP-015 (31 days)
- **No "Hot" deals**: The highest score is 74.2, just below the 75-point Hot threshold — by design
