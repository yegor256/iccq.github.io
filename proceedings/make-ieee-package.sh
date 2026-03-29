#!/usr/bin/env bash
# SPDX-FileCopyrightText: Copyright (c) 2020-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

set -ex

rm -rf ieee-package-list
mkdir ieee-package-list
(cd ieee-package-list && ruby ../../make-ieee-package-list.rb ..)
cat ieee-package-list/package.txt
zip="$(cat ieee-record.txt)_$(cat ieee-part.txt)"
cp -r ieee-package-list "${zip}"
rm -rf "${zip}.zip"
zip -r "${zip}.zip" "${zip}"
rm -rf "${zip}"
