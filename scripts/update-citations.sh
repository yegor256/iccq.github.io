#!/bin/bash
# SPDX-FileCopyrightText: Copyright (c) 2020-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT
#
# Update "Cited by NNN" counts in year .md files using the
# Semantic Scholar Academic Graph API.
#
# Usage:
#   bash scripts/update-citations.sh
#
# Optional environment:
#   SEMANTIC_SCHOLAR_API_KEY  raise the per-IP rate limit
#   CITE_DELAY                seconds between API calls (default 1.2)
#
# The script reads each pages/YYYY.md file, finds every
#   [Cited by N](https://scholar.google.com/scholar?...)
# link, and refreshes N from Semantic Scholar.
#
# Resolution order for each paper:
#   1. DOI in the scholar?q=doi:... URL
#   2. DOI inferred from a sibling https://ieeexplore.ieee.org/document/NNNN link
#   3. Title from the preceding **Bold** markdown line, searched on
#      Semantic Scholar (citation URLs in the markdown may be wrong,
#      so the title is the most reliable identifier we have).
#
# The Scholar URL is left untouched; only the count is updated.

set -e

PAGES_DIR="$(cd "$(dirname "$0")/../pages" && pwd)"
export PAGES_DIR

python3 -u - <<'PYEOF'
import os
import re
import sys
import time
import glob
import json
import urllib.parse

try:
    import requests
except ImportError:
    sys.exit('requests is required: pip install requests')

API = 'https://api.semanticscholar.org/graph/v1'
HEADERS = {'User-Agent': 'iccq-citation-updater/1.0 (+https://www.iccq.ru)'}
API_KEY = os.environ.get('SEMANTIC_SCHOLAR_API_KEY')
if API_KEY:
    HEADERS['x-api-key'] = API_KEY

session = requests.Session()
session.headers.update(HEADERS)

DELAY = float(os.environ.get('CITE_DELAY', '1.2'))
RETRY_AFTER = 20.0

pages_dir = os.environ['PAGES_DIR']
year_files = sorted(glob.glob(os.path.join(pages_dir, '[0-9][0-9][0-9][0-9].md')))
if not year_files:
    sys.exit(f'No year .md files found in {pages_dir}')

def get(url, params=None, retries=3):
    for attempt in range(retries):
        try:
            r = session.get(url, params=params, timeout=20)
        except requests.exceptions.RequestException as e:
            print(f'    {type(e).__name__}: {e}', file=sys.stderr)
            time.sleep(RETRY_AFTER)
            continue
        if r.status_code == 429:
            wait = float(r.headers.get('Retry-After') or RETRY_AFTER)
            print(f'    rate-limited, sleeping {wait}s', file=sys.stderr)
            time.sleep(wait)
            continue
        if r.status_code == 404:
            return None
        if r.status_code != 200:
            print(f'    HTTP {r.status_code} on {url} {params or ""}', file=sys.stderr)
            time.sleep(RETRY_AFTER)
            continue
        try:
            return r.json()
        except ValueError:
            return None
    return None

def count_by_doi(doi):
    data = get(f'{API}/paper/DOI:{urllib.parse.quote(doi, safe="")}',
               params={'fields': 'citationCount,title'})
    if not data:
        return None
    return data.get('citationCount')

def count_by_title(title):
    data = get(f'{API}/paper/search/match',
               params={'query': title, 'fields': 'citationCount,title'})
    if data and data.get('data'):
        return data['data'][0].get('citationCount')
    data = get(f'{API}/paper/search',
               params={'query': title, 'limit': 1, 'fields': 'citationCount,title'})
    if data and data.get('data'):
        return data['data'][0].get('citationCount')
    return None

CITE_RE = re.compile(
    r'\[Cited by (\d+)\]\((https://scholar\.google\.com/scholar\?[^)]+)\)'
)
TITLE_RE = re.compile(r'^\*\*([^*][^\n]+?)\*\*\s*$', re.MULTILINE)
IEEE_DOC_RE = re.compile(r'ieeexplore\.ieee\.org/document/(\d+)')

def paper_context(content, idx):
    """Return (title, ieee_doc_id) inferred from the markdown block above idx."""
    block_start = content.rfind('\n\n', 0, idx)
    block = content[block_start:idx] if block_start >= 0 else content[:idx]
    titles = TITLE_RE.findall(block)
    title = titles[-1].strip() if titles else None
    ieee = IEEE_DOC_RE.search(block)
    return title, (ieee.group(1) if ieee else None)

def doi_from_url(scholar_url):
    m = re.search(r'q=doi:([^&]+)', scholar_url)
    return urllib.parse.unquote(m.group(1)) if m else None

def resolve_count(year, scholar_url, title, ieee_doc):
    sources = []
    doi = doi_from_url(scholar_url)
    if doi:
        sources.append(('doi-from-url', doi))
    if ieee_doc and (not doi or not doi.endswith(ieee_doc)):
        sources.append(('doi-from-ieee', f'10.1109/{ieee_doc}'))
    for label, value in sources:
        n = count_by_doi(value)
        time.sleep(DELAY)
        if n is not None:
            return n, label, value
    if title:
        n = count_by_title(title)
        time.sleep(DELAY)
        if n is not None:
            return n, 'title', title
    return None, None, None

total_updated = 0
total_seen = 0
total_unresolved = 0

for filepath in year_files:
    year = os.path.basename(filepath).replace('.md', '')
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    original = content
    print(f'Processing {year}.md...')

    edits = []
    for m in CITE_RE.finditer(content):
        total_seen += 1
        current = int(m.group(1))
        url = m.group(2)
        title, ieee = paper_context(content, m.start())
        new_count, via, value = resolve_count(year, url, title, ieee)
        label = title or url[:60]
        if new_count is None:
            total_unresolved += 1
            print(f'  [{year}] unresolved: {label}')
            continue
        if new_count != current:
            print(f'  [{year}] {current} -> {new_count} ({via}: {value}) {label}')
            edits.append((m.start(), m.end(), f'[Cited by {new_count}]({url})'))

    if edits:
        edits.sort(reverse=True)
        for start, end, repl in edits:
            content = content[:start] + repl + content[end:]
        total_updated += len(edits)

    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'  [{year}] file updated ({len(edits)} change(s))')

print(f'\nDone. Saw {total_seen}; updated {total_updated}; unresolved {total_unresolved}.')
PYEOF
