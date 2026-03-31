#!/bin/bash
# SPDX-FileCopyrightText: Copyright (c) 2020-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

set -e

input="$1"
output="$2"

echo '% Auto-generated from _colors.scss' > "$output"
grep '^\$' "$input" | sed 's/\$\([a-z]*\): #\([0-9a-fA-F]\{6\}\);/\\definecolor{\1}{HTML}{\U\2}/' | \
    sed 's/\$\([a-z]*\): #\([0-9a-fA-F]\)\([0-9a-fA-F]\)\([0-9a-fA-F]\);/\\definecolor{\1}{HTML}{\U\2\2\3\3\4\4}/' >> "$output"
