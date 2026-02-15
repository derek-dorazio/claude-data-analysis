# Test Cases for District Sales Lead Queries

These test cases document expected results for queries against `districts.csv` and `opportunities.csv`. All results verified programmatically with reference date **2025-02-15**.

---

## Data Design Summary

- **15 districts** across 12 states (urban, suburban, rural)
- **20 opportunities** across 4 sales reps, ranging from $28K to $920K
- **2 closed deals**: OPP-012 (Closed Won), OPP-020 (Closed Lost) — excluded from open pipeline queries
- **18 open pipeline deals** to score and rank
- Max open deal amount: **$920,000** (OPP-002, used for normalization)

---

## Query 1: Best Opportunities (Composite Score Ranking)

### Full Scored Pipeline (18 open opportunities, sorted by score)

| Rank | OppId | District | State | Amount | Stage | Prob | Score | Label | Rep |
|------|-------|----------|-------|--------|-------|------|-------|-------|-----|
| 1 | OPP-001 | Riverside County Schools | CA | $485,000 | Negotiation | 80% | 74.2 | Warm | Maria Santos |
| 2 | OPP-008 | Pine Valley ISD | TX | $52,000 | Negotiation | 85% | 69.7 | Warm | Kevin O'Neill |
| 3 | OPP-002 | Fairfax County Schools | VA | $920,000 | Proposal | 55% | 65.8 | Warm | James Park |
| 4 | OPP-009 | Charleston County Schools | SC | $245,000 | Proposal | 65% | 63.9 | Warm | Maria Santos |
| 5 | OPP-003 | Detroit City Schools | MI | $310,000 | Demo | 60% | 62.4 | Warm | Kevin O'Neill |
| 6 | OPP-014 | Greenfield Central Schools | IN | $28,000 | Proposal | 75% | 60.5 | Warm | Kevin O'Neill |
| 7 | OPP-004 | Brooklyn Community District 14 | NY | $275,000 | Proposal | 70% | 60.0 | Warm | Maria Santos |
| 8 | OPP-013 | Boise Independent District | ID | $145,000 | Demo | 45% | 54.2 | Developing | James Park |
| 9 | OPP-017 | Detroit City Schools | MI | $280,000 | Qualified | 40% | 52.6 | Developing | Kevin O'Neill |
| 10 | OPP-006 | Mesa Unified | AZ | $340,000 | Demo | 50% | 48.7 | Developing | James Park |
| 11 | OPP-019 | Anchorage School District | AK | $285,000 | Demo | 55% | 48.5 | Developing | Sarah Lin |
| 12 | OPP-010 | Lakewood Public Schools | OH | $180,000 | Demo | 40% | 41.9 | Developing | Sarah Lin |
| 13 | OPP-015 | Riverside County Schools | CA | $95,000 | Qualified | 35% | 39.3 | Developing | Maria Santos |
| 14 | OPP-007 | Wake County Schools | NC | $780,000 | Prospect | 15% | 36.9 | Developing | Sarah Lin |
| 15 | OPP-016 | Fairfax County Schools | VA | $750,000 | Prospect | 10% | 29.9 | Long-term | James Park |
| 16 | OPP-018 | Charleston County Schools | SC | $190,000 | Prospect | 20% | 28.2 | Long-term | Maria Santos |
| 17 | OPP-005 | Springfield Unified | IL | $125,000 | Qualified | 30% | 25.9 | Long-term | Sarah Lin |
| 18 | OPP-011 | Portland Public Schools | OR | $210,000 | Qualified | 25% | 22.0 | Long-term | Kevin O'Neill |

### Score Component Breakdown (Top 5)

| OppId | Deal Size (25) | Probability (25) | Stage (20) | Incumbent (20) | Recency (10) | Total |
|-------|---------------|-------------------|------------|----------------|-------------|-------|
| OPP-001 | 13.2 | 20.0 | 17.0 | 14.0 | 10.0 | 74.2 |
| OPP-008 | 1.4 | 21.2 | 17.0 | 20.0 | 10.0 | 69.7 |
| OPP-002 | 25.0 | 13.8 | 13.0 | 4.0 | 10.0 | 65.8 |
| OPP-009 | 6.7 | 16.2 | 13.0 | 20.0 | 8.0 | 63.9 |
| OPP-003 | 8.4 | 15.0 | 9.0 | 20.0 | 10.0 | 62.4 |

### Label Distribution

| Label | Count | Opportunities |
|-------|-------|---------------|
| Warm | 7 | OPP-001, OPP-008, OPP-002, OPP-009, OPP-003, OPP-014, OPP-004 |
| Developing | 7 | OPP-013, OPP-017, OPP-006, OPP-019, OPP-010, OPP-015, OPP-007 |
| Long-term | 4 | OPP-016, OPP-018, OPP-005, OPP-011 |
| Hot | 0 | (none — highest score is 74.2, just below 75 threshold) |

### Key Observations

- **OPP-001** ranks #1 despite not being the largest deal — high probability (80%), advanced stage (Negotiation), expiring incumbent, and recent activity all contribute
- **OPP-008** ranks #2 at only $52K because of 85% probability, Negotiation stage, no incumbent, and very recent activity — demonstrates that "best" isn't just about deal size
- **OPP-002** is the largest deal ($920K) but ranks #3 due to entrenched incumbent (contract not expiring for 16 months)
- **OPP-007** ($780K) scores poorly despite large size because it's only at Prospect stage with 15% probability and an unknown incumbent contract end

---

## Query 2: Pipeline by Sales Rep

| Rep | Open Opps | Total Pipeline | Weighted Pipeline | Avg Score | States |
|-----|-----------|---------------|-------------------|-----------|--------|
| James Park | 4 | $2,155,000 | $816,250 | 49.6 | AZ, ID, VA |
| Kevin O'Neill | 5 | $880,000 | $415,700 | 53.4 | IN, MI, OR, TX |
| Maria Santos | 5 | $1,290,000 | $811,000 | 53.1 | CA, NY, SC |
| Sarah Lin | 4 | $1,370,000 | $383,250 | 38.3 | AK, IL, NC, OH |

### Observations

- **James Park** has the highest total pipeline ($2.15M) but it's concentrated in two large long-term deals (OPP-002, OPP-016)
- **Sarah Lin** has the lowest average score (38.3) — her deals are early-stage or have entrenched incumbents
- **Kevin O'Neill** has the highest average score (53.4) with the most diverse pipeline across stages
- **Maria Santos** has the highest weighted pipeline ($811K) — her deals have higher close probability

---

## Query 3: Incumbent Displacement Opportunities (within 12 months)

**Expected: 6 opportunities** where incumbent contract expires between 2025-02-15 and 2026-02-15.

| OppId | District | State | Amount | Incumbent | Expires | Months Out | Stage | Rep |
|-------|----------|-------|--------|-----------|---------|------------|-------|-----|
| OPP-004 | Brooklyn Community Dist 14 | NY | $275,000 | Achieve3000 | 2025-07-15 | 4.9 | Proposal | Maria Santos |
| OPP-001 | Riverside County Schools | CA | $485,000 | Renaissance Star | 2025-08-01 | 5.5 | Negotiation | Maria Santos |
| OPP-006 | Mesa Unified | AZ | $340,000 | Lexia PowerUp | 2025-09-01 | 6.5 | Demo | James Park |
| OPP-019 | Anchorage School District | AK | $285,000 | Renaissance Star | 2025-10-01 | 7.5 | Demo | Sarah Lin |
| OPP-018 | Charleston County Schools | SC | $190,000 | McGraw-Hill Wonders | 2025-12-31 | 10.5 | Prospect | Maria Santos |
| OPP-010 | Lakewood Public Schools | OH | $180,000 | DreamBox | 2026-01-31 | 11.5 | Demo | Sarah Lin |

### Excluded (contract > 12 months or missing)

- OPP-002 (NWEA MAP, expires 2026-06-30 — 16.4 months)
- OPP-005 (IXL Math, expires 2027-06-30)
- OPP-016 (Amplify CKLA, expires 2027-06-30)
- OPP-011 (Achieve3000, expires 2027-08-01)
- OPP-007 (i-Ready renewal, no contract end date)

---

## Query 4: Stale Deals (>30 days since activity)

**Expected: 3 opportunities** with last activity before 2025-01-16.

| OppId | District | Amount | Stage | Last Activity | Days Stale | Rep |
|-------|----------|--------|-------|---------------|-----------|-----|
| OPP-016 | Fairfax County Schools | $750,000 | Prospect | 2024-11-20 | 87 | James Park |
| OPP-011 | Portland Public Schools | $210,000 | Qualified | 2024-12-15 | 62 | Kevin O'Neill |
| OPP-015 | Riverside County Schools | $95,000 | Qualified | 2025-01-15 | 31 | Maria Santos |

### Observations

- **OPP-016** is the most stale (87 days) but is a deliberate long-term relationship play ($750K)
- **OPP-011** is concerning — it's at Qualified stage but hasn't been touched in 62 days
- **OPP-015** just crossed the 30-day threshold — needs follow-up from Maria Santos
