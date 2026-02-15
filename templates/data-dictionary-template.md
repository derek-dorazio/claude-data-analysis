# Data Dictionary: <Domain> / <Use Case Name>

This documents the expected schema for each input file. If you upload new data, it **must** match these column names and types or queries will fail.

---

## <filename.csv>

<1-2 sentence description. What does one row represent?>

| Column | Type | Required | Description | Example |
|--------|------|----------|-------------|---------|
| column_name | type | Yes/No | What this column contains | example_value |

**Enum values for <column>**: `value1`, `value2`, `value3`

### Notes
<Any important context about this file: uniqueness constraints, typical row counts, etc.>

---

## <second-file.csv>

<Repeat the pattern above for each input file.>

---

## Join Keys

<Document how files relate to each other.>

| From File | Column | To File | Column | Relationship |
|-----------|--------|---------|--------|--------------|
| file_a.csv | key_col | file_b.csv | key_col | many-to-one |

### Notes
<Any join-related considerations: optional relationships, orphaned records, etc.>
