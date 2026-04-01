# SPDX-FileCopyrightText: Copyright (c) 2020-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

SUBDIRS=$(shell find . -mindepth 1 -maxdepth 1 -type d -name '[0-9]*' | sort)

all:
	for d in $(SUBDIRS); do $(MAKE) -C $$d; done

clean:
	for d in $(SUBDIRS); do $(MAKE) -C $$d clean; done
