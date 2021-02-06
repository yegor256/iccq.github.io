all: book.pdf cover.pdf texsc texqc

install:
	gem install texsc
	gem install texqc

texsc:
	texsc *.tex

texqc:
	texqc book

clean:
	rm -rf *.aux *.bbl *.bcf *.blg *.fdb_latexmk *.fls *.log *.run.xml *.pdf *.out
	rm -rf _minted-article

%.pdf: %.tex *.tex
	latexmk -pdf $<
