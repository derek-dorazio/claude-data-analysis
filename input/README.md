# Input Folder

Place your data files here for analysis.

## Supported Formats

| Format | Extensions | Notes |
|--------|-----------|-------|
| CSV | `.csv` | Auto-detects delimiter (comma, tab, pipe, semicolon) |
| Excel | `.xlsx`, `.xls` | Multi-sheet workbooks supported |
| JSON | `.json` | Flat arrays or nested objects |
| JSON Lines | `.jsonl` | One JSON object per line |

## Tips

- File names don't need to follow a convention, but descriptive names help
- For multi-file analysis, ensure files share at least one common column for joining
- Large files (>100MB) will be sampled during profiling for performance
- Input files are **never modified** — all output goes to `output/`
