# Data Dictionary: Sales / District Leads

This documents the expected schema for each input file. If you upload new data, it **must** match these column names and types or queries will fail.

---

## districts.csv

School district profiles. One row per district.

| Column | Type | Required | Description | Example |
|--------|------|----------|-------------|---------|
| districtId | string | Yes | Unique district identifier | D001 |
| districtName | string | Yes | Full district name | Springfield Unified |
| state | string | Yes | Two-letter state code | IL |
| enrollment | integer | Yes | Total student enrollment | 28500 |
| numSchools | integer | Yes | Number of schools in district | 42 |
| urbanicity | enum | Yes | District setting | Suburban |
| title1Pct | numeric | Yes | Percentage of Title I eligible students | 38 |

**urbanicity values**: `Urban`, `Suburban`, `Rural`

### Notes
- `districtId` must be unique
- `title1Pct` is a percentage (0–100), not a decimal
- Every `districtId` referenced in opportunities.csv should exist here

---

## opportunities.csv

Sales pipeline opportunities. One row per opportunity. Multiple opportunities can exist per district.

| Column | Type | Required | Description | Example |
|--------|------|----------|-------------|---------|
| opportunityId | string | Yes | Unique opportunity identifier | OPP-001 |
| districtId | string | Yes | FK to districts.csv | D002 |
| products | string | Yes | Semicolon-separated product list | i-Ready Math;i-Ready Reading |
| amount | numeric | Yes | Deal value in dollars | 485000 |
| salesStage | enum | Yes | Current stage in pipeline | Negotiation |
| probability | integer | Yes | Win probability percentage (0–100) | 80 |
| hasIncumbent | enum | Yes | Whether district has existing solution | Yes |
| incumbentProduct | string | No | Name of competitor product (if hasIncumbent=Yes) | Renaissance Star |
| incumbentContractEnd | date (YYYY-MM-DD) | No | When incumbent contract expires | 2025-08-01 |
| assignedRep | string | Yes | Sales rep name | Maria Santos |
| lastActivityDate | date (YYYY-MM-DD) | Yes | Date of most recent activity on this opp | 2025-02-10 |
| createdDate | date (YYYY-MM-DD) | Yes | When opportunity was created | 2024-09-15 |
| notes | string | No | Free-text notes (no commas — use semicolons) | Contract expiring summer |

**salesStage values**: `Prospect`, `Qualified`, `Demo`, `Proposal`, `Negotiation`, `Closed Won`, `Closed Lost`
**hasIncumbent values**: `Yes`, `No`
**products** (semicolon-separated): `i-Ready Math`, `i-Ready Reading`, `Magnetic Reading`

### Join Key

`districtId` links to `districts.csv`. Every opportunity must reference a valid district.

### Notes
- `incumbentProduct` and `incumbentContractEnd` may be blank when `hasIncumbent = No`
- `probability` should be 100 for Closed Won and 0 for Closed Lost
- `products` uses semicolons as separators (not commas) to avoid CSV parsing issues
- `notes` should avoid commas; use semicolons or periods instead
