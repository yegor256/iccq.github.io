TEXS=$(wildcard *.tex)
PDFS=$(TEXS:.tex=.pdf)

.NOTINTERMEDIATE:
.ONESHELL:

all: $(PDFS)

%.pdf: %.tex
	latexmk -pdf $<
	if [[ $@ =~ [0-9]+x[0-9]+.pdf ]]; then
		dim=$$(echo $@ | sed s/.pdf// | sed 's/^.\+-//')
		width=$$(echo "$${dim}" | cut -d 'x' -f 1)
		height=$$(echo "$${dim}" | cut -d 'x' -f 2)
		cp $@ $@.bak
		gs -dNoOutputFonts -sDEVICE=pdfwrite -o $@.pre $@
		pdftoppm -singlefile -f 1 -png -r 72 -scale-to-x "$${width}" -scale-to-y "$${height}" $@.pre $(basename $@)
	fi

clean:
	for e in dvi aux toc ind fdb_latexmk log ilg fls idx out jpg pdf bak jpeg png; do \
	  rm -rf *.$${e}; \
	done
	rm -rf ${PDFS}
