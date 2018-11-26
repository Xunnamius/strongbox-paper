LATEX=latex
BIBTEX=bibtex
DVIPS=dvips
DVIPDF=dvipdf
DVIPDF=dvipdfm
PDFLATEX=pdflatex

TEX-FILES = *.tex
BIB-FILES = *.bib
TOP-LEVEL-ROOT = acmart-sigplanproc-template
CRNAME = asplos052-dickens

# Insert a hard break in the references manually as required by cam ready
POSTREFS = sed -i -e \
's%url{https://doi.org/10.1145/605397.605409}}%url{https://doi.org/10.1145/605397.605409}}\n\n\n\\vfill\\eject%'

all: generate-pdf save-temporary $(CRNAME)

generate-pdf: ${TEX-FILES} ${BIB-FILES}
	mkdir -p out
	$(PDFLATEX) -shell-escape ${TOP-LEVEL-ROOT}
	$(BIBTEX) ${TOP-LEVEL-ROOT}
	$(POSTREFS) ${TOP-LEVEL-ROOT}.bbl
	$(PDFLATEX) -shell-escape ${TOP-LEVEL-ROOT}
	$(PDFLATEX) -shell-escape ${TOP-LEVEL-ROOT}

save-temporary: generate-pdf
	mkdir -p out
	if test -e *.aux; then mv *.aux out; fi
	if test -e *.blg; then mv *.blg out; fi
	if test -e *.bbl; then mv *.bbl out; fi
	if test -e *.out; then mv *.out out; fi
	if test -e *.log; then mv *.log out; fi
	if test -e *.xml; then mv *.xml out; fi
	if test -e *.cut; then mv *.cut out; fi
	if test -e *.auxlock; then mv *.auxlock out; fi
	if test -e *blx.bib; then mv *blx.bib out; fi
	if test -e out/_minted*; then rm -rf out/_minted*; fi
	if test -e _minted*; then mv -f _minted* out; fi

$(CRNAME): $(TOP-LEVEL-ROOT).pdf
	\gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dEmbedAllFonts=true -sOutputFile=$(CRNAME).pdf -f $(TOP-LEVEL-ROOT).pdf

clean:
	rm -f *.bbl *.blg *-blx.bib
	rm -f *.pdf *.aux* *.log *.out *.xml
	rm -rf out _minted*
