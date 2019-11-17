# (c) Karsten Reincke, Frankfurt am Main, Germany, 2011 ff
# This file is licensed under the MIT license
# For details the file LICENSE

RES_EXTS=png pdf midi 

play:
	timidity $<

.SUFFIXES: .ly .pdf .png

.ly.png:
	@ echo "### `date +'%Y%m%dT%H%M%S'`: converting $< to $@" 
	@ lilypond --png $< 

.ly.pdf: clean
	@ echo "### `date +'%Y%m%dT%H%M%S'`: converting $< to $@" 
	@ lilypond $< 

clean:	
	$(foreach EXT, ${RES_EXTS}, if [ ! "x`ls *.${EXT} 2>/dev/null`" = "x" ]; then rm *.${EXT}; fi;)

