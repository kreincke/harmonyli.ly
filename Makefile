# (c) Karsten Reincke, Frankfurt am Main, Germany, 2011 ff
# This file is licensed under the MIT license
# For details the file LICENSE

RES_EXTS=png pdf midi 

TFS=./sn967.pdf \
    ./cadenca-functional-harmony-theory.pdf \
    ./cadenca-scale-step-theory.pdf \
    ./doc/source/lilypond/cadenca-method-three.pdf \
    ./doc/source/lilypond/cadenca-method-two.pdf \
    ./doc/source/lilypond/cadenca-method-one.pdf \
    ./modulation-scale-step-theory.pdf \
    ./modulation-functional-harmony-theory.pdf

help:
	@echo "call 'make XYZ.(pdf|png)' for creating a single file or 'make test' for creating all"

play:
	timidity $<

test:
	$(foreach F, ${TFS}, make  ${F} ;)

.SUFFIXES: .ly .pdf .png

.ly.png:
	@ echo "### `date +'%Y%m%dT%H%M%S'`: converting $< to $@" 
	@ lilypond --png $< 

.ly.pdf: clean
	@ echo "### `date +'%Y%m%dT%H%M%S'`: converting $< to $@" 
	@ lilypond $< 

clean:	
	$(foreach EXT, ${RES_EXTS}, if [ ! "x`ls *.${EXT} 2>/dev/null`" = "x" ]; then rm *.${EXT}; fi;)
