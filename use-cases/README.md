# Use Cases

Each use case is a self-contained folder with its own input data, queries, tests, and output. The same analysis commands (`/plan`, `/implement`, `/explore`, `/query`, `/export`) work across all use cases.

## For Data Analysts

Pick a use case below, check its `data-dictionary.md` for the expected file schema, then replace the sample data in `input/` with your own. See the [root README](../README.md#how-to-data-analysts) for the full walkthrough.

## For Use Case Builders

Use the scaffold script to create a new use case, then follow the builder guide in the [root README](../README.md#how-to-use-case-builders).

```bash
./scripts/new-use-case.sh <domain> <use-case-name>
```

## Use Case Structure

Every use case follows this layout:

```
use-cases/<domain>/<use-case-name>/
├── input/              # Source data files (CSV, Excel, JSON)
├── output/             # Generated output
│   ├── plan/           #   Analysis plans
│   ├── analysis/       #   Full reports
│   ├── explore/        #   Data profiles
│   ├── data/           #   Exported data (Excel, CSV)
│   └── reports/        #   Query results and summaries
├── queries/            # Predefined query definitions (.md)
├── tests/              # Test cases with expected results
└── data-dictionary.md  # Schema contract for input files
```

### Key Files

| File | Who Creates It | Who Uses It | Purpose |
|------|----------------|-------------|---------|
| `data-dictionary.md` | Builder | Analyst | Documents exact columns, types, and enums analysts must match |
| `queries/*.md` | Builder (or Analyst) | Both | Defines reusable analysis logic with expected results |
| `tests/test-cases.md` | Builder | Both | Verified expected results for validating query correctness |
| `input/*.csv` | Builder (sample) / Analyst (real) | Commands | The actual data files |

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

**Join key**: `employeeNumber` across both files
**Schema**: See `hr/pto-analysis/data-dictionary.md`

#### Queries

| Query | File | Description |
|-------|------|-------------|
| PTO During Leave | `query-1-pto-during-leave.md` | Find erroneous PTO entries booked during long-term leave. Expected: 15 error rows across 5 employees. |
| Low PTO Usage | `query-2-low-pto-usage.md` | Find employees with no or low non-holiday PTO. Configurable threshold. 3 employees have zero non-holiday PTO. |

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
| `districts.csv` | School district profiles — ID, name, state, enrollment, urbanicity, Title I % | 15 | 7 |
| `opportunities.csv` | Sales pipeline — products, amounts, stages, incumbent info, rep assignments | 20 | 13 |

**Join key**: `districtId` (districts.csv) -> `districtId` (opportunities.csv)
**Schema**: See `sales/district-leads/data-dictionary.md`

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
| Best Opportunities | `query-1-best-opportunities.md` | Rank all open pipeline deals by composite score. Top deal: OPP-001 at 74.2. |
| Pipeline by Rep | `query-2-pipeline-by-rep.md` | Summarize pipeline by sales rep — deal count, total/weighted amounts, average score. |
| Incumbent Displacement | `query-3-incumbent-displacement.md` | Find deals where competitor contract expires within 12 months. Expected: 6 opportunities. |
| Stale Deals | `query-4-stale-deals.md` | Find open deals with no activity in 30+ days. Expected: 3 opportunities. |

#### Key Data Design Choices

- **Normalized data**: District info is separate from opportunities — queries must join on `districtId`
- **Multiple opps per district**: D002 (Riverside) and D014 (Detroit) each have 2+ opportunities
- **2 closed deals** (OPP-012 Closed Won, OPP-020 Closed Lost) to test exclusion filters
- **Stale deals** planted: OPP-016 (87 days stale), OPP-011 (62 days), OPP-015 (31 days)
- **No "Hot" deals**: The highest score is 74.2, just below the 75-point Hot threshold — by design
