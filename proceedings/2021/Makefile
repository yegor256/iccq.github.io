all: book.pdf cover.pdf texsc texqc ieee

install:
	gem install texsc
	gem install texqc

texsc:
	texsc *.tex

texqc:
	texqc book

clean:
	rm -rf *.toc *.ilg *.idx *.ind *.aux *.bbl *.bcf *.blg *.fdb_latexmk *.fls *.log *.run.xml *.pdf *.out
	rm -rf _minted-article
	rm -rf ieee-package-list

%.pdf: %.tex *.tex
	latexmk -pdf $<

ieee: ieee-package-list/package.txt

ieee-package-list/package.txt: book.pdf cover.pdf make-ieee-package-list.rb
	rm -rf ieee-package-list
	mkdir ieee-package-list
	cd ieee-package-list && ruby ../make-ieee-package-list.rb ..
	cat ieee-package-list/package.txt
