% cadenca.ly ::- a lilypond encoded cadence for demonstrating some
% capabilities of harmonyli.ly, a LilyPond library for integrating
% functional harmony analysis symbols into a score
%
% (c) 2019  Karsten Reincke (Frankfurt/Germany)
%
% This file is licensed under CC-BY-SA 4.0 international
% for details see https://creativecommons.org/licenses/by-sa/4.0/

\version "2.18.2"

\header { tagline = "" }
\include "harmonyli.ly"
  
\score {
  \new StaffGroup {
    \time 4/4
    <<
      \new Staff {
        \relative d' {
          \clef "treble"
          \key d \major  
          \stemUp
          < fis a d>2	< fis a dis> < g b e> < g b eis>2 | 
          < fis b fis'>2 < b e gis> < a e' g!> < a d fis>2 \bar "||"
        }
   
      }
      \new Staff {
        \relative d { 
          \clef "bass"
          \key d \major  
          \stemDown
          d2 b d cis  |
          d b d4 cis4 d2 \bar "||"
        }   
      }
      \addlyrics {
          \markup \setHAS "T" #'(("C"."D")("fr" . " "))
          \markup \setImArea "D" #'(("B"."1")("a" . "7")("fr" . " "))
          \markup \setHAS "Sp" #'(("B"."7")("a" . "7")("fl" . " ")("fr" . " "))
          \markup \setHAS "D" #'(("T"."x")("B"."3")("a" . "5")("b" . "7")("c" . "♭9>♯8")("fr" . " "))
          \markup \setHAS "Tp" #'(("B"."3")("fl" . " ")("fr" . " ")) 
          \markup \setHAS "D" #'(("T"."d")("B"."5")("a" . "7")("b" . "8")("fr" . " ")) 
                 
          \initTextSpan "   "
          \markup \initZoomRow "D" #'(("a"."4")("fl" . " "))
          \startTextSpan
          \markup \expZoomRow #'(("a"."3")("fr" . " ")) 
          \stopTextSpan
  
          \markup \setHAS "T" #'(("fr" . " "))
        }
    >>
  }
  \layout {
    \context {
      \Lyrics
      \consists "Text_spanner_engraver"
    }
  }
  \midi {}
}

