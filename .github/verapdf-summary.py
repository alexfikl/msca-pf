# SPDX-FileCopyrightText: 2026 Alexandru Fikl <alexfikl@gmail.com>
# SPDX-License-Identifier: CC-BY-4.0

import html.parser
import re
import sys
from pathlib import Path

PROFILE_LABELS = {
    "WCAG-2.2-Complete": "WCAG 2.2",
}


class _TableParser(html.parser.HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self._tables = []
        self._in_table = 0
        self._current = None

    def handle_starttag(self, tag, attrs):
        if tag == "table":
            self._in_table += 1
            if self._in_table == 1:
                self._tables.append([])
        elif self._in_table and tag in {"td", "th"}:
            self._current = ""

    def handle_endtag(self, tag):
        if self._in_table and tag in {"td", "th"}:
            if self._current is not None:
                self._tables[-1].append(self._current.strip())
            self._current = None
        elif tag == "table":
            self._in_table -= 1

    def handle_data(self, data):
        if self._current is not None:
            self._current += data

    def summaries(self):
        result = []
        for table in self._tables:
            pairs = {}
            for i in range(0, len(table) - 1, 2):
                key = re.sub(r"\s*:\s*$", "", table[i]).strip().lower()
                pairs[key] = table[i + 1]
            if "passed checks" in pairs and "failed checks" in pairs:
                result.append(pairs)
        return result


def parse(path):
    parser = _TableParser()
    parser.feed(path.read_text(encoding="utf-8"))
    return parser.summaries()


def profile_label(profile):
    if not profile:
        return profile
    name = re.sub(r"\s+validation profile$", "", profile.strip(), flags=re.IGNORECASE)
    return PROFILE_LABELS.get(name, name)


def compliance_cell(value):
    if value and "fail" in value.lower():
        return f":x: **{value}**"
    return f":white_check_mark: **{value}**"


def failed_cell(value):
    try:
        n = int(value)
    except (TypeError, ValueError):
        return value
    if n:
        return f":x: **{n}**"
    return f"**{n}**"


def sort_key(row):
    name, _, _, failed = row
    try:
        nfailed = int(failed)
    except (TypeError, ValueError):
        nfailed = 0
    return (0 if nfailed else 1, name)


def main():
    header = "| Report | Compliance | Passed | Failed |"
    separator = "|---|---|---|---|"
    rows = []
    for arg in sys.argv[1:]:
        path = Path(arg)
        for data in parse(path):
            rows.append(
                (
                    profile_label(data.get("validation profile")) or "-",
                    data.get("compliance", "-"),
                    data.get("passed checks", "-"),
                    data.get("failed checks", "0"),
                )
            )
    rows.sort(key=sort_key)
    print(header)
    print(separator)
    for name, compliance, passed, failed in rows:
        print(
            f"| {name} | {compliance_cell(compliance)} "
            f"| **{passed}** | {failed_cell(failed)} |"
        )


if __name__ == "__main__":
    main()
