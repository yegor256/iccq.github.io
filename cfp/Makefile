all: cfp

cfp: cfp.pdf

%.pdf: %.tex
	latexmk -pdf $<

clean:
	for e in pdf dvi aux toc ind fdb_latexmk log ilg fls idx out; do \
	  rm -rf *.$${e}; \
	done
