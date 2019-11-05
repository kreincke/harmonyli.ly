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
 \markup \rsf "TX" "3" ""  "" "" "" "" ""   ""
  \openbracket
  \markup \rsf \crossout "D" "" "3"  "7" "9>" "" "" ""   ")"
  \fExtend "     " % call this function BEFORE the lyric event
  \markup \rsf "Sp" "" ""  "9" "" "" "" ""   ""
  \startTextSpan  % call \startTextSpan AFTER the lyric event
  \markup \rsf "" "" ""  "8" "" "" "" ""   ""
  \stopTextSpan
  \markup \rsf "S" "" ""  "5" "6" "" "" ""   ""
  \openbracket
  \markup \rsf "D" "" "3"  "7" "" "" "" ""   " )"
  \fExtend "   "
  \markup \rsf "D" "" ""  "2" "4" "" "" ""   ""
  \startTextSpan
  \markup \rsf "" "" ""  "1" "3" "" "" ""   ""
  \stopTextSpan
  \openbracket
  \fExtend "   "
  \markup \rsf "D" "" "3"  "7" "" "" "" ""   ""
  \startTextSpan
  \markup \rsf "" "" ""  "8" "" "" "" ""   ""
  \markup \rsf "" "" ""  "7" "" "" "" ""   " )[Tp]"
  \stopTextSpan
  \openbracket
  \markup \rsf "D" "" "7"  "" "" "" "" ""   ")"
  \fExtend "   "
  \markup \rsf "S" "" "3"  "" "" "" "" ""   ""
  \startTextSpan
  \markup \rsf " " "" "2"  "" "" "" "" ""   ""
  \stopTextSpan
  \fExtend "    "
  \markup \rsf \double "D" "" "3"  "8" "" "" "" ""   ""
  \startTextSpan
  \markup \rsf "" "" ""  "7" "" "" "" ""   ""
  \stopTextSpan
  \fExtend "   "
  \markup \rsf "D" "" ""  "5" "" "" "" ""   ""
  \startTextSpan
  \markup \rsf "" "" ""  "7" "" "" "" ""   ""
  \stopTextSpan
  \markup \rsf "T" "" ""  "" "" "" "" ""   ""
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
    \markup \rsf "F" "2" "3"  "4" "5" "6" "7" "8"   "9"
    \markup \rsf "Function" "Soprano" "Bass"  "OptA" "OptB" "OptC" "OptD" "OptE"   "FillStr       "
    \override LyricText.self-alignment-X = #CENTER
    \markup \rsf "S" "" ""  "" "" "" "" ""   ""
    \markup \rsf "D" "" ""  "" "" "" "" ""   ""
    \markup \rsf \double S "  \double S  " ""  "" "" "" "" ""   ""
    \markup \rsf \double "D" "  \double D  " ""  "" "" "" "" ""   ""
    \markup \rsf \crossout "D" "  \crossout D  " ""  "" "" "" "" ""   ""

    %\markup \dRSF "D" #'(("S" . "2") ("B"."1") ("a"."3") ("b"."4") ("c"."5") ("d"."6") ("e"."") ("f" . "--") )
    %\markup \Dseptnone
    \markup \iRSF "D" #'(("B"."3")("f" . "  ") )
  }
} 