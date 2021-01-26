all: book.pdf spell qc

install:
	gem install texsc
	gem install texqc

qc:
	texqc book

spell:
	texsc *.tex

clean:
	rm -rf *.aux *.bbl *.bcf *.blg *.fdb_latexmk *.fls *.log *.run.xml *.pdf *.out
	rm -rf _minted-article

%.pdf: %.tex *.tex
	latexmk -pdf $<
