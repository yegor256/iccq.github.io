all: cfp

cfp: cfp.pdf

%.pdf: %.tex ../cfp.cls
	latexmk -pdf $<

clean:
	for e in dvi aux toc ind fdb_latexmk log ilg fls idx out; do \
	  rm -rf *.$${e}; \
	done
	rm -rf cfp.pdf
