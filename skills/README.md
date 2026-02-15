# Skills

Reusable analysis prompts that can be referenced by commands or used directly in conversation.

## Available Skills

| Skill | File | Purpose |
|-------|------|---------|
| Profile Data | `profile-data.md` | Comprehensive data profiling — types, distributions, nulls, uniques |
| Join Strategy | `join-strategy.md` | Determine optimal join keys, types, and cardinality between files |
| Detect Anomalies | `detect-anomalies.md` | Find outliers, unexpected values, data quality issues |
| Summarize Stats | `summarize-stats.md` | Descriptive statistics, group-by summaries, correlations |

## Usage

Skills are used by commands internally. You can also reference them directly:

> "Use the join-strategy skill to figure out how to connect orders.csv and customers.xlsx"

Each skill accepts placeholder inputs (marked with `{{PLACEHOLDER}}`) that get filled in by the command or conversation context.
