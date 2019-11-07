% http://lsr.di.unimi.it/LSR/Item?id=967
% http://lists.gnu.org/archive/html/lilypond-user/2014-12/msg00123.html
% http://www.mail-archive.com/lilypond-user%40gnu.org/msg60732.html
% Contributed by Klaus Blum

\version "2.18.2"

\include "inc.harmonyli.ly"

%\paper {
%  indent = 0
%  ragged-right = ##f
%}

%\header {
%  tagline = ##f
%}


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

  % Usage:
  %
  % FunctionLetter SopranoNote BassNote OptA OptB OptC OptD OptE FillStr

  \set stanza = #"C-Dur:"
  % encoding on level 1 
  \markup \fhas "T" "3" ""  "" "" "" "" ""  "" ""
  \initIMArea
  \markup \fhas \crossout "D" "" "3"  "7" "9>" "" "" ""  "" ")"
  \initTextSpan "     "
  \markup \fhas "Sp" "" ""  "9" "" "" "" "" ""  ""
  \startTextSpan  % call \startTextSpan AFTER the lyric event
  \markup \fhas "" "" ""  "8" "" "" "" "" ""  ""
  \stopTextSpan

  % encoding on level 2  
  \markup \setFHAS "S" #'(("a"."5") ("b"."6"))
  \initIMArea
  \markup \closeIMArea "D" #'(("B"."3")("a" . "7")) 

  \initTextSpan "   "
  \markup \initZoomRow "D" #'(("a"."2")("b" . "4")) 
  \startTextSpan
  \markup \expZoomRow #'(("a"."1")("b" . "3")) 
  \stopTextSpan
  
  \initIMArea
  \initTextSpan "         "
  \markup \initZoomRow "D" #'(("B"."3")("a" . "7")("CT"."Tp")) 
  \startTextSpan
  \markup \expZoomRow #'(("a"."8")) 
  \markup \closeIMZoomRow #'(("a"."7")) 
  \stopTextSpan
  
  \initIMArea
  \markup \closeIMArea "D" #'(("a" . "7")("CT"."S")) 

  \initTextSpan "   " 
  \markup \initZoomRow "S" #'(("B"."3")("a" . "3"))
  \startTextSpan
  \markup \expZoomRow #'(("a"."2"))   
  \stopTextSpan
  
  \initTextSpan "    "
  \markup \initZoomRow "D" #'(("T" ."d")("B"."3")("a" . "8"))
  \startTextSpan
  \markup \expZoomRow #'(("a"."7"))  
  \stopTextSpan
  
  \initTextSpan "   "
  \markup \initZoomRow "D" #'(("a" . "5")("f" . "")) 
  \startTextSpan  \startTextSpan
  \markup \expZoomRow #'(("a"."7"))   
  \stopTextSpan
  
  % symbol on level 3
  \markup \RS "T" 
}


\score {
  \new GrandStaff <<
    \new Staff = upper
    \with { printPartCombineTexts = ##f }
    {
      <<
        \sopranmel \\
        \partcombine \altmel \tenormel
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
} 
 
\markup \vspace #2

\score {
  \relative c' { c1 c c2 c c c c c }
  \addlyrics {
    \override LyricText.self-alignment-X = #LEFT
    \set stanza = #"Usage:"
    \markup \fhas "F" "2" "3"  "4" "5" "6" "7" "8"  "C" ""
    \markup \fhas "Function" "Soprano" "Bass" 
      "a (1. num)" "b (2. num)" "c (3. num)" 
        "d (4. num)" "e (5. num)" "Context"  "fill "
    \override LyricText.self-alignment-X = #CENTER
    \markup \fhas "S" "" ""  "" "" "" "" ""   "C" ""
    \markup \fhas "D" "" ""  "" "" "" "" ""  "D" ""
    \markup \fhas \double S "  \double S  " ""  "" "" "" "" ""  "" ""
    \markup \fhas \double "D" "  \double D  " ""  "" "" "" "" ""  "" ""
    \markup \fhas \crossout "D" "  \crossout D  " ""  "" "" "" "" ""  "" ""


    \initIMArea
    \markup \closeIMArea "D" #'(("T"."x")("B"."3")("f" . "")("CT" . "Tp")) 
  }
} 