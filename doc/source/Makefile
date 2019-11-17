# (c) Karsten Reincke, Frankfurt am Main, Germany, 2011 ff
# This file is licensed under the Creative Commons Attribution 3.0 Germany
# for details see LICENSE in the top directory

#LATEX=latex
LATEX=pdflatex

AUX_EXTS=url bbl blg aux dvi toc log lof nlo nls ilg ils ent out log
RES_EXTS=ps pdf 
SUB_DIRS=cfg bib
T=CH


all:
	echo "insert the name of the main tex file into the Make file"

	
.SUFFIXES: .tex .dvi .ps .pdf .rtf 

.tex.pdf:
	@ echo "### `date +'%Y%m%dT%H%M%S'`" 
	@ echo "### converting $< to $@"
	@ $(LATEX) $< 
	@ bibtex `basename $< .tex`
	@ makeindex `basename $< .tex`.nlo -s cfg/nomencl.ist -o `basename $< .tex`.nls
	@ $(LATEX) $< 
	@ $(LATEX) $< 
	@ $(LATEX) $< 
ifneq ($(LATEX),pdflatex)
	@ echo "### converting DVI to PostScript"
	@ dvips $<
	@ echo "### converting PostScript to PDF"
	@ ps2pdf $<
endif
	@ mv $@ `basename $@ .pdf`-`cat inc.rel.tex`.pdf
	@ make clearAuxFiles

.tex.dvi:
	@ echo "### `date +'%Y%m%dT%H%M%S'`" 
	@ echo "### converting $< to $@"
	@ latex $< 
	@ bibtex `basename $< .tex`
	@ makeindex `basename $< .tex`.nlo -s cfg/nomencl.ist -o `basename $< .tex`.nls
	@ latex $< 
	@ latex $< 
	@ latex $< 

.dvi.ps:
	@ echo "### `date +'%Y%m%dT%H%M%S'`" 
	@ echo "### converting $< to $@"
	@ dvips $<

clearAuxFiles:
	$(foreach EXT, ${AUX_EXTS}, if [ ! "x`ls *.${EXT} 2>/dev/null`" = "x" ]; then rm *.${EXT}; fi;)

clean:	clearAuxFiles
	$(foreach EXT, ${RES_EXTS}, if [ ! "x`ls *.${EXT} 2>/dev/null`" = "x" ]; then rm *.${EXT}; fi;)

clear:	clean

dclean:
	echo '#!/bin/bash' > xc.sh
	echo FEXT="\"`echo $(AUX_EXTS) | sed 's/ /|/g'`\"" >> xc.sh
	echo 'find . | egrep "\.($$FEXT)" | while read f; do echo "deleting $$f"; rm $$f; done' >> xc.sh
	chmod 755 xc.sh
	./xc.sh
	rm xc.sh
