# Opportunity Scoring Heuristic

A composite score (0–100) to rank opportunities by likelihood and value of closing.

## Components (5 factors, weighted to 100)

### 1. Deal Size (25 points)
Normalized amount relative to the largest open opportunity in the pipeline.

```
deal_size_score = (amount / max_amount) * 25
```

### 2. Win Probability (25 points)
Direct from the `probability` field.

```
probability_score = (probability / 100) * 25
```

### 3. Stage Advancement (20 points)
Later stages indicate more invested effort and closer to close.

| Stage | Weight |
|-------|--------|
| Prospect | 0.10 |
| Qualified | 0.25 |
| Demo | 0.45 |
| Proposal | 0.65 |
| Negotiation | 0.85 |
| Closed Won | 1.00 |
| Closed Lost | 0.00 |

```
stage_score = stage_weight * 20
```

### 4. Incumbent Factor (20 points)
No incumbent is easiest to win. An incumbent with an expiring contract is an opportunity. An entrenched incumbent is hardest.

| Scenario | Weight |
|----------|--------|
| No incumbent | 1.00 |
| Incumbent, contract ends within 6 months | 0.70 |
| Incumbent, contract ends within 12 months | 0.50 |
| Incumbent, contract ends > 12 months or unknown | 0.20 |

```
incumbent_score = incumbent_weight * 20
```

Reference date for "within X months": **2025-02-15** (today)

### 5. Engagement Recency (10 points)
Recent activity signals active deal momentum. Stale deals are risky.

| Last Activity | Weight |
|---------------|--------|
| Within 7 days | 1.00 |
| Within 14 days | 0.80 |
| Within 30 days | 0.60 |
| Within 60 days | 0.30 |
| Over 60 days | 0.10 |

```
recency_score = recency_weight * 10
```

Reference date: **2025-02-15** (today)

## Composite Score

```
total_score = deal_size_score + probability_score + stage_score + incumbent_score + recency_score
```

## Exclusions

- **Closed Won** and **Closed Lost** opportunities are excluded from ranking (they're already resolved)
- Only open pipeline opportunities are scored

## Interpretation

| Score Range | Label | Action |
|-------------|-------|--------|
| 75–100 | Hot | Prioritize — close this quarter |
| 55–74 | Warm | Actively work — advance stage |
| 35–54 | Developing | Nurture — build relationships |
| 0–34 | Long-term | Monitor — revisit next quarter |
