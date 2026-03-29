# SPDX-FileCopyrightText: Copyright (c) 2020-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

.PHONY: all test clean install texsc texqc ieee

all: book.pdf cover.pdf texsc texqc ieee booklet.pdf book-cmyk.pdf cover-cmyk.pdf

test: all

install:
	gem install texsc
	gem install texqc

texsc:
	texsc *.tex

texqc:
	texqc book

clean:
	rm -rf *.toc *.ilg *.idx *.ind *.aux *.bbl *.bcf *.blg *.fdb_latexmk *.fls *.log *.run.xml *.pdf *.out
	rm -rf _minted-article ieee-package-list *.zip
	rm -rf svg-inkscape book.pages

%.pdf: %.tex *.tex papers/*.pdf
	latexmk -pdf $<

%-cmyk.pdf: %.pdf
	gs -dSAFER -dBATCH -dNOPAUSE -dNOCACHE -sDEVICE=pdfwrite \
		-sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK \
		-sOutputFile=$@ $<

ieee: ieee-package-list/package.txt

ieee-package-list/package.txt: book.pdf cover.pdf Makefile
	./make-ieee-package.sh

booklet.pdf: ieee
	qpdf --empty --pages ieee-package-list/*.pdf -- iccq-2021-booklet.pdf
