# SPDX-FileCopyrightText: Copyright (c) 2020-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

TEXS=$(wildcard *.tex)
PDFS=$(TEXS:.tex=.pdf)

all: $(PDFS)

%.pdf: %.tex
	latexmk -pdf $<
	mv $@ $@.bak
	gs -dNoOutputFonts -sDEVICE=pdfwrite -o $@ $@.bak
	convert $@.bak $@.jpeg

clean:
	for e in dvi aux toc ind fdb_latexmk log ilg fls idx out; do \
	  rm -rf *.$${e}; \
	done
	rm -rf ${PDFS}
