all: book.pdf cover.pdf texsc texqc ieee iccq-2021-booklet.pdf book-cmyk.pdf cover-cmyk.pdf

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
	rm -rf *.zip

%.pdf: %.tex *.tex papers/*.pdf
	latexmk -pdf $<

%-cmyk.pdf: %.pdf
	gs -dSAFER -dBATCH -dNOPAUSE -dNOCACHE -sDEVICE=pdfwrite \
		-sColorConversionStrategy=CMYK -dProcessColorModel=/DeviceCMYK \
		-sOutputFile=$@ $<

ieee: ieee-package-list/package.txt

ieee-package-list/package.txt: book.pdf cover.pdf make-ieee-package-list.rb Makefile
	rm -rf ieee-package-list
	mkdir ieee-package-list
	cd ieee-package-list && ruby ../make-ieee-package-list.rb ..
	cat ieee-package-list/package.txt
	zip="$$(cat ieee-record.txt)_$$(cat ieee-part.txt)" ;\
	cp -r ieee-package-list "$${zip}" ;\
	rm -rf "$${zip}.zip" ;\
	zip -r "$${zip}.zip" "$${zip}" ;\
	rm -rf "$${zip}"

iccq-2021-booklet.pdf: ieee
	qpdf --empty --pages ieee-package-list/*.pdf -- iccq-2021-booklet.pdf