TEXS=$(wildcard *.tex)
PDFS=$(TEXS:.tex=.pdf)

all: $(PDFS)

%.pdf: %.tex
	latexmk -pdf $<
	mv $@ $@.bak
	gs -dNoOutputFonts -sDEVICE=pdfwrite -o $@ $@.bak

clean:
	for e in dvi aux toc ind fdb_latexmk log ilg fls idx out; do \
	  rm -rf *.$${e}; \
	done
	rm -rf ${PDFS}
