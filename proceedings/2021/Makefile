all: book.pdf cover.pdf texsc texqc pl

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

%.pdf: %.tex *.tex
	latexmk -pdf $<

pl:
	rm -rf package-list.txt
	echo "3\t1.17" > package-list.txt
	echo "Yegor Bugayenko" >> package-list.txt
	echo "yegor256@gmail.com" >> package-list.txt
	echo "+79855806546" >> package-list.txt
	echo "ICCQ 2021" >> package-list.txt
	echo "Moscow, Russia" >> package-list.txt
	date >> package-list.txt
	echo "Final" >> package-list.txt
	echo "51190" >> package-list.txt
	echo $$(cat issn.txt) "Electronic" >> package-list.txt
	echo $$(cat isbn.txt) "Electronic" >> package-list.txt
