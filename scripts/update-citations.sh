#!/bin/bash
# SPDX-FileCopyrightText: Copyright (c) 2020-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT
#
# Update "Cited by NNN" counts in year .md files by querying Google Scholar.
# Run this script locally (not in CI) since Google Scholar blocks cloud IPs.
#
# Usage:
#   bash scripts/update-citations.sh
#
# Requirements:
#   pip install requests beautifulsoup4
#
# Each paper's "Cited by NNN" link is updated with the current count from Scholar.
# Links must be in the format: https://scholar.google.com/scholar?cites=CLUSTERID
# For papers using the ?q=doi: format, the script will search by DOI to find
# the cluster ID and citation count.

set -e

PAGES_DIR="$(cd "$(dirname "$0")/../pages" && pwd)"
YEARS=$(ls "$PAGES_DIR" | grep -E '^[0-9]{4}\.md$' | sort)

python3 - <<'PYEOF'
import re
import sys
import time
import urllib.request
import urllib.parse
import ssl

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 '
                  '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
}

import os
import glob

pages_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'pages')
year_files = sorted(glob.glob(os.path.join(pages_dir, '[0-9][0-9][0-9][0-9].md')))

def fetch_scholar(url, retries=2):
    """Fetch a Google Scholar page and return the HTML."""
    for attempt in range(retries):
        try:
            req = urllib.request.Request(url, headers=HEADERS)
            resp = urllib.request.urlopen(req, timeout=15, context=ctx)
            return resp.read().decode('utf-8', errors='ignore')
        except Exception as e:
            if attempt < retries - 1:
                time.sleep(2)
            else:
                return None

def get_citation_count_by_cites(cluster_id):
    """Get citation count from a ?cites=CLUSTERID Scholar URL."""
    url = f'https://scholar.google.com/scholar?cites={cluster_id}'
    html = fetch_scholar(url)
    if html is None:
        return None
    # Scholar shows "About N results" for cites pages
    match = re.search(r'About ([\d,]+) results', html)
    if match:
        return int(match.group(1).replace(',', ''))
    # Or directly cited by count
    match = re.search(r'Cited by (\d+)', html)
    if match:
        return int(match.group(1))
    return None

def get_citation_count_by_doi(doi):
    """Search Scholar by DOI and return (citation_count, cluster_id)."""
    url = f'https://scholar.google.com/scholar?q=doi:{urllib.parse.quote(doi)}'
    html = fetch_scholar(url)
    if html is None:
        return None, None
    # Find cited by link and count
    match = re.search(r'cites=(\d+)[^"]*"[^>]*>Cited by (\d+)', html)
    if match:
        return int(match.group(2)), match.group(1)
    # Try alternate format
    match = re.search(r'Cited by (\d+)', html)
    cites_match = re.search(r'cites=(\d+)', html)
    count = int(match.group(1)) if match else None
    cluster_id = cites_match.group(1) if cites_match else None
    return count, cluster_id

total_updated = 0

for filepath in year_files:
    year = os.path.basename(filepath).replace('.md', '')
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original = content

    # Find all "Cited by N" links
    pattern = r'\[Cited by (\d+)\]\((https://scholar\.google\.com/scholar\?[^)]+)\)'

    def update_citation(m):
        global total_updated
        current_count = int(m.group(1))
        scholar_url = m.group(2)

        new_count = None
        new_cluster_id = None

        if 'cites=' in scholar_url:
            cluster_id = re.search(r'cites=(\d+)', scholar_url).group(1)
            new_count = get_citation_count_by_cites(cluster_id)
            new_cluster_id = cluster_id
        elif 'q=doi:' in scholar_url:
            doi = urllib.parse.unquote(re.search(r'q=doi:([^&]+)', scholar_url).group(1))
            new_count, new_cluster_id = get_citation_count_by_doi(doi)

        if new_count is None:
            print(f'  [{year}] Could not fetch count for: {scholar_url[:60]}...')
            return m.group(0)

        # Build the link - prefer cites= format, fall back to q=doi:
        if new_cluster_id and 'cites=' not in scholar_url:
            new_url = f'https://scholar.google.com/scholar?cites={new_cluster_id}'
        else:
            new_url = scholar_url

        result = f'[Cited by {new_count}]({new_url})'

        if new_count != current_count or new_url != scholar_url:
            print(f'  [{year}] Updated: {current_count} -> {new_count}')
            if new_url != scholar_url:
                print(f'         URL: {scholar_url[:60]} -> {new_url}')
            total_updated += 1

        time.sleep(1)  # Be polite to Scholar
        return result

    # Process the file
    print(f'Processing {year}.md...')
    content = re.sub(pattern, update_citation, content)

    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'  [{year}] File updated.')

print(f'\nDone. {total_updated} citation(s) updated.')
PYEOF
