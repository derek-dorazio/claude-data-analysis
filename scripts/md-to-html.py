#!/usr/bin/env python3
"""Convert a markdown report to styled HTML using the i-Ready report template.

Usage:
    python3 scripts/md-to-html.py <input.md> <output.html> [--pdf <output.pdf>]

The script:
1. Reads the markdown file
2. Parses it into sections and tables
3. Renders into the HTML template (templates/report.html)
4. Optionally converts to PDF via weasyprint
"""

import argparse
import os
import re
import sys
from pathlib import Path


def parse_metadata(md_text):
    """Extract title, date, use_case from the markdown frontmatter."""
    title = "Analysis Report"
    date = ""
    use_case = ""

    # Title from first H1
    m = re.search(r"^#\s+(.+)$", md_text, re.MULTILINE)
    if m:
        title = m.group(1).strip()

    # Date and use case from bold metadata lines
    for line in md_text.split("\n")[:20]:
        if re.match(r"\*\*(Reference )?Date", line, re.IGNORECASE):
            date = re.sub(r"\*\*.*?\*\*:?\s*", "", line).strip()
        elif re.match(r"\*\*Use [Cc]ase", line):
            use_case = re.sub(r"\*\*.*?\*\*:?\s*", "", line).strip()
        elif re.match(r"\*\*Generated", line):
            if not date:
                date = re.sub(r"\*\*.*?\*\*:?\s*", "", line).strip()

    return title, date, use_case


def md_table_to_html(table_text):
    """Convert a markdown table to an HTML table."""
    lines = [l.strip() for l in table_text.strip().split("\n") if l.strip()]
    if len(lines) < 2:
        return ""

    # Parse header
    header_cells = [c.strip() for c in lines[0].strip("|").split("|")]

    # Skip separator line (line 1)
    rows = []
    for line in lines[2:]:
        cells = [c.strip() for c in line.strip("|").split("|")]
        rows.append(cells)

    # Detect numeric columns
    numeric_cols = set()
    for ci in range(len(header_cells)):
        vals = [r[ci] for r in rows if ci < len(r) and r[ci].strip()]
        num_count = sum(1 for v in vals if re.match(r"^[\$\-]?[\d,]+\.?\d*%?$", v.replace(",", "")))
        if vals and num_count / len(vals) > 0.5:
            numeric_cols.add(ci)

    # Badge columns (label, scoreLabel, etc.)
    badge_map = {
        "hot": "badge-hot", "warm": "badge-warm",
        "developing": "badge-developing", "long-term": "badge-long-term",
    }

    html = '<div class="table-wrapper"><table>\n<thead><tr>'
    for h in header_cells:
        html += f"<th>{h}</th>"
    html += "</tr></thead>\n<tbody>\n"

    for row in rows:
        html += "<tr>"
        for ci, cell in enumerate(row):
            css = ' class="number"' if ci in numeric_cols else ""

            # Check for badge values
            cell_lower = cell.lower().strip()
            if cell_lower in badge_map:
                cell_html = f'<span class="badge {badge_map[cell_lower]}">{cell}</span>'
                css = ""
            elif cell.strip() in ("Yes", "Pass"):
                cell_html = f'<span class="validation-pass">{cell}</span>'
            elif cell.strip() in ("No", "Fail"):
                cell_html = f'<span class="validation-fail">{cell}</span>'
            else:
                cell_html = cell

            html += f"<td{css}>{cell_html}</td>"
        html += "</tr>\n"

    html += "</tbody></table></div>\n"
    return html


def convert_md_to_html_content(md_text):
    """Convert markdown body to HTML content sections."""
    # Remove the title line and metadata lines
    lines = md_text.split("\n")
    content_lines = []
    skip_header = True
    for line in lines:
        if skip_header:
            if line.startswith("---"):
                skip_header = False
                continue
            if line.startswith("#") or line.startswith("**") or not line.strip():
                continue
            skip_header = False
        content_lines.append(line)

    body = "\n".join(content_lines)

    # Split into sections by H2
    sections = re.split(r"(?=^## )", body, flags=re.MULTILINE)

    html_parts = []
    for section in sections:
        section = section.strip()
        if not section:
            continue

        # Extract H2 title
        h2_match = re.match(r"^## (.+)$", section, re.MULTILINE)
        if h2_match:
            section_title = h2_match.group(1).strip()
            section_body = section[h2_match.end():].strip()
        else:
            section_title = None
            section_body = section

        html = '<div class="section">\n'
        if section_title:
            html += f"<h2>{section_title}</h2>\n"

        # Process the section body block by block
        blocks = re.split(r"\n\n+", section_body)
        in_table = False
        table_lines = []

        for block in blocks:
            block = block.strip()
            if not block:
                continue

            # Check if this is a table
            if "|" in block and "---" in block:
                html += md_table_to_html(block)
            elif block.startswith("### "):
                title = block[4:].strip()
                html += f"<h3>{title}</h3>\n"
            elif block.startswith("- "):
                items = block.split("\n")
                html += "<ul>\n"
                for item in items:
                    item_text = re.sub(r"^-\s+", "", item.strip())
                    # Convert bold
                    item_text = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", item_text)
                    html += f"  <li>{item_text}</li>\n"
                html += "</ul>\n"
            elif block.startswith("|"):
                # Table without separator detected in split
                html += md_table_to_html(block)
            else:
                # Paragraph — convert inline markdown
                p = block.replace("\n", " ")
                p = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", p)
                p = re.sub(r"\*(.+?)\*", r"<em>\1</em>", p)
                p = re.sub(r"`(.+?)`", r"<code>\1</code>", p)

                # Check if it's a description line
                if section_title and blocks.index(block) == 0:
                    html += f'<p class="description">{p}</p>\n'
                else:
                    html += f"<p>{p}</p>\n"

        html += "</div>\n"
        html_parts.append(html)

    return "\n".join(html_parts)


def render_html(template_path, title, date, use_case, content):
    """Render the HTML template with the given values."""
    with open(template_path) as f:
        template = f.read()

    html = template.replace("{{ title }}", title)
    html = html.replace("{{ date }}", date)
    html = html.replace("{{ use_case }}", use_case)
    html = html.replace("{{ content }}", content)
    return html


def main():
    parser = argparse.ArgumentParser(description="Convert markdown report to styled HTML")
    parser.add_argument("input", help="Input markdown file")
    parser.add_argument("output", help="Output HTML file")
    parser.add_argument("--pdf", help="Also generate PDF output", default=None)
    parser.add_argument("--template", help="HTML template path", default=None)
    args = parser.parse_args()

    # Find template
    if args.template:
        template_path = args.template
    else:
        script_dir = Path(__file__).resolve().parent
        template_path = script_dir.parent / "templates" / "report.html"

    if not os.path.exists(template_path):
        print(f"Error: Template not found at {template_path}", file=sys.stderr)
        sys.exit(1)

    # Read markdown
    with open(args.input) as f:
        md_text = f.read()

    # Parse and convert
    title, date, use_case = parse_metadata(md_text)
    content = convert_md_to_html_content(md_text)
    html = render_html(template_path, title, date, use_case, content)

    # Write HTML
    os.makedirs(os.path.dirname(os.path.abspath(args.output)), exist_ok=True)
    with open(args.output, "w") as f:
        f.write(html)
    print(f"HTML: {args.output}")

    # Optionally generate PDF
    if args.pdf:
        try:
            from weasyprint import HTML
            os.makedirs(os.path.dirname(os.path.abspath(args.pdf)), exist_ok=True)
            HTML(filename=os.path.abspath(args.output)).write_pdf(args.pdf)
            print(f"PDF:  {args.pdf}")
        except ImportError:
            print("Warning: weasyprint not installed, skipping PDF generation", file=sys.stderr)
            print("Install with: pip3 install weasyprint", file=sys.stderr)
            sys.exit(1)


if __name__ == "__main__":
    main()
