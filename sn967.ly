% sn967.ly :- a re-implementation of Hans Blum's reference document
% Copyright (c) 2019 Hans Blum, Karsten Reincke, 
%
% This file uses the score by which Hans Blum has explained / implemented
% his version of inserting Functional Harmony Analysis Symbols (FHAS) 
% see http://lsr.di.unimi.it/LSR/Item?id=967
% 
% It replaces his symbols by the equivalents of harmonyli.ly to verify that 
% harmonyli.ly has at least the same expressiveness like as Hans Blum's 
% preparatory work

% As reference to him, this file is named by a condensed version of the title
% "snippet no 977 of the LilyPond % Snippet Repository" = sn967.ly

% This file is distributed under the terms of the MIT license:
% --------------------------------------
% Copyright 2019 Karsten Reincke (Frankfurt), Hans Blum, 

% Permission is hereby granted, free of charge, to any person obtaining a copy 
% of this software and associated documentation files (the "Software"), to deal 
% in the Software without restriction, including without limitation the rights 
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
% copies of the Software, and to permit persons to whom the Software is 
% furnished to do so, subject to the following conditions:

% The above copyright notice and this permission notice shall be included in all 
% copies or substantial portions of the Software.

% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
% IN THE SOFTWARE.

\version "2.20.0"

\include "harmonyli.ly"


\paper {
  indent = 0
  ragged-right = ##f
}

\header {
  %tagline = ##f
  title = "Hans Blum's Reference Document"
  subtitle = "rewritten with the capabilities of harmonyli.ly"
}


% ---------------------------------------------------------------
% ----- Voices: soprano, alto, tenor
% ---------------------------------------------------------------

global  = { \key c \major  \time 4/4}

sopranmel = \relative c'' {
  \clef treble
  \stemUp
  \global
  e4 e e( d)
  c4 d d2
  d4 e8 d c4 c
  d8( c) <b g>4 c2\fermata

}

altmel = \relative c'' {
  \clef treble
  \stemDown
  \global
  c4 bes a2
  a4 c c( b)
  b2 g4 a
  a4 \hideNotes g8 s \unHideNotes g2
}

tenormel = \relative c' {
  \clef treble
  \stemDown
  \global
  g'4 g f2
  d4 a' a( g)
  e2 e4 f
  d4 d8( f) e2
}



% ---------------------------------------------------------------
% ----- hidden bass voice (not to be displayed, only
% ----- for aligning the lyrics via "lyricsto"
% ---------------------------------------------------------------

bassmelhidden =
\relative c {
  \clef bass
  \stemDown
  \global
  \override NoteHead.color = #red
  \override NoteColumn #'ignore-collision = ##t
  f,4 cis'4 d d
  f4 fis4 g g
  gis4 gis8 gis bes4 a8 g
  fis8 fis g8 g c,2
}

% ---------------------------------------------------------------
% ----- bass voice to be displayed
% ---------------------------------------------------------------

bassmelshown = \relative c {
  \clef bass
  \stemNeutral
  \global
  %    \hideNotes
  c4 cis4 d2
  f4 fis4 g2
  gis2 bes4 a8 g
  fis4 g4 c,2
}

% ---------------------------------------------------------------
% ----- "lyrics": Symbols for functional harmony
% ---------------------------------------------------------------

lyr = \lyricmode {
  \override LyricText.self-alignment-X = #LEFT
  \override LyricExtender.left-padding = #-0.5
  \override LyricExtender.extra-offset = #'(0 . 0.5)

  % Usage: see the harmonyli.ly tutorial

  \set stanza = #"C-Dur:"
  % encoding on level 1 
  \markup \has "T" "3" ""  "" "" "" "" ""  "" "" "" #'()

  \markup \has \crossout "D" "" "3"  "7" "♭9" "" "" ""  "" "(" ")" #'()
  \initTextSpan "       "
  \markup \has "Sp" "" ""  "9" "" "" "" "" ""  "( " "" #'()
  \startTextSpan  
  \markup \has "" "" ""  "8" "" "" "" "" ""  "" " )" #'()
  \stopTextSpan

  % encoding on level 2  
  \markup \setHas "S" #'(("a"."5") ("b"."6"))

  \markup \setImHas "D" #'(("B"."3")("a" . "7")) 

  \initTextSpan "   "
  \markup \openZoomRow "D" #'(("a"."2")("b" . "4")) 
  \startTextSpan
  \markup \expZoomRow #'(("a"."1")("b" . "3")) 
  \stopTextSpan
  
 
  \initTextSpan "          "
  \markup \openImZoomRow "D" #'(("B"."3")("a" . "7")("C"."Tp")) 
  \startTextSpan
  \markup \expZoomRow #'(("a"."8")) 
  \markup \closeImZoomRow #'(("a"."7")) 
  \stopTextSpan
  

  \markup \setImHas "D" #'(("a" . "7")("C"."S")) 

  \initTextSpan "   " 
  \markup \openZoomRow "S" #'(("B"."3")("a" . "3"))
  \startTextSpan
  \markup \expZoomRow #'(("a"."2"))   
  \stopTextSpan
  
  \initTextSpan "    "
  \markup \openZoomRow "D" #'(("T" ."d")("B"."3")("a" . "8"))
  \startTextSpan
  \markup \expZoomRow #'(("a"."7"))  
  \stopTextSpan
  
  \initTextSpan "   "
  \markup \openZoomRow "D" #'(("a" . "5")("f" . "")) 
  \startTextSpan  \startTextSpan
  \markup \expZoomRow #'(("a"."7"))   
  \stopTextSpan
  
  % symbol on level 3
  \markup \FHAS "T" 
}


\score {
  \new GrandStaff <<
    \new Staff = upper
    \with { printPartCombineTexts = ##f }
    {
      <<
        \sopranmel \\
        \partCombine \altmel \tenormel
      >>
    }
    \new Staff = lower
    \new Voice = "bassstimmeSichtbar"
    \with { printPartCombineTexts = ##f }
    {
      <<
        \bassmelshown
        % change "NullVoice" to "Voice" to make the hidden bass voice visible:
        \new NullVoice = "bassstimme" {\shiftOff  \bassmelhidden}
        \new Lyrics \lyricsto "bassstimme" \lyr
      >>
    }
  >>
  \layout {
    \context {
      \Lyrics
      \consists "Text_spanner_engraver"
    }
  }
  \midi {}
} 
 
\markup \vspace #2

\score {
  \relative c' { c1 c c2 c c c c c }
  \addlyrics {
    \override LyricText.self-alignment-X = #LEFT
    \set stanza = #"Usage:"
    \markup \has "F" "2" "3"  "4" "5" "6" "7" "8"  "C" "-- " " --" #'()
    \markup \has "Function" "Soprano" "Bass"  
      "a (1. num)" "b (2. num)" "c (3. num)" 
        "d (4. num)" "e (5. num)" "Context"  "fillleft " " fillright" #'()
    \override LyricText.self-alignment-X = #CENTER
    \markup \has "S" "Context Tonika" ""  "" "" "" "" ""   "T" "" "" #'()
    \markup \has "D" "Context es" ""  "" "" "" "" ""  "es" "" "" #'()
    \markup \has \double "S" "  \double S  " ""  "" "" "" "" ""  "" "" "" #'()
    \markup \has \double "D" "  \double D  " ""  "" "" "" "" ""  "" "" "" #'()
    \markup \has \crossout "D" "  \crossout D  " ""  "" "" "" "" ""  "" "" "" #'()

    \markup \setRfHas "T" "D" 
    #'( ("T"."dx")("S"."1")("B"."2")("a"."3")("b"."4")("c"."5")("d"."6")("e"."7")("C" . "c")("fr".")")("fl"."(")
        ("nT"."d")("nS"."1")("nB"."2")("na"."3")("nb"."4")("nc"."5")("nd"."6")("ne"."7")("nC" . "d")("nfr".")")("nfl"."(")
       
    )

    %\markup 
    %\flas "T" "1" "2"  "3" "4" "5" "6" "7"  "8" "[" "]" "D" "1" "2"  "3" "4" "5" "6" "7"  "8" "(" ")"
    %\setImHas "S" #'(("T"."xd")("S"."1")
    %("B"."2")("a"."3")("b"."4")("c"."5")("d"."6")("e"."7")("C" . "c")("fr"."(")("fl".")"))


  }
} 

\markup \vspace #2
\markup { 
  This file only uses (indicates) a subset of 'harmonyli'. 
  For details see the harmonily-tutorial.
}
