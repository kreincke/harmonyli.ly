% cadenca-method-two.ly :- for demonstrating the use of harmonyli.ly
% Copyright (c) 2019 Karsten Reincke, 
%

% This file is distributed under the terms of the MIT license:
% --------------------------------------
% Copyright 2019 Karsten Reincke (Frankfurt)

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

\version "2.18.2"
\include "harmonyli.ly"

\paper {
  indent = 0
  ragged-right = ##f
  system-system-spacing, basic-distance = #20
  score-system-spacing =
    #'((basic-distance . 12)
       (minimum-distance . 6)
       (padding . 1)
       (stretchability . 12))
}

\header { tagline = "" }

global  = { \key d \major  \time 4/4}

descant = \relative c' {
  \clef treble \stemUp \global
  < fis a d>2	< fis a dis> < g b e> < g b eis>2 | 
  < fis b fis'>2 < b e gis> < a e' g!> < a d fis>2 \bar "||"
}

bass = \relative c {
  \clef bass \stemNeutral \global
  d2 b d cis  | d b d4 cis4 d2 \bar "||"
}

hasRhythmHidden =
\relative c, {
  \clef bass
  \stemDown
  \global
  \override NoteHead.color = #red
  \override NoteColumn #'ignore-collision = ##t
  c2 c | c c | c c | c4 c4 c2 \bar "||"
}

hasSymbols = \lyricmode {
  \override LyricText.self-alignment-X = #LEFT
  \override LyricExtender.left-padding = #-0.5
  \override LyricExtender.extra-offset = #'(0 . 0.5)

  \markup \setHas "T" #'(("C"."D")("fr" . " "))
  \markup \setImHas "D" #'(("B"."1")("a" . "7")("fr" . " "))
  \markup \setHas "Sp" #'(("B"."7")("a" . "7")("fl" . " ")("fr" . " "))
  \markup \setHas "D" #'(("T"."x")("B"."3")("a" . "5")("b" . "7")
                          ("c" . "♭9>♯8")("fr" . " "))
  \markup \setHas "Tp" #'(("B"."3")("fl" . " ")("fr" . " ")) 
  \markup \setHas "D" #'(("T"."d")("B"."5")("a" . "7")("b" . "8")
                          ("fr" . " "))    
  \initTextSpan "    "
  \markup \openZoomRow "D" #'(("a"."4")("fl" . " "))
  \startTextSpan
  \markup \expZoomRow #'(("a"."3")("fr" . " ")) 
  \stopTextSpan
  \markup \setHas "T" #'(("fr" . " "))
}

\score {
  <<
    \new GrandStaff <<
      \new Staff = upper
      \with { printPartCombineTexts = ##f }
      {
        <<
          \descant 
        >>
      }
      \new Staff = lower
      \new Voice = "Musical Bass"
      \with { printPartCombineTexts = ##f }
      {
        <<
          \bass
          % change "Voice" to "NullVoice" to make analyze voice unvisible:
          \new Voice = "AnalysisSubline" {\shiftOff  \hasRhythmHidden}
          \new Lyrics \lyricsto "AnalysisSubline" \hasSymbols
        >>
      }
    >>
  >>

  \layout{ \context { \Lyrics \consists "Text_spanner_engraver" } }
} 
 




