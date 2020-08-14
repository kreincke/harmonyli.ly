% modulation.ly :- for demonstrating the scale step theory used by harmonyli.ly 
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

\header {
  title = "Modulation from C Major to as minor"
  subtitle = "for demonstrating the scale step expressiveness of harmonyli.ly"
}


% ---------------------------------------------------------------
% ----- Voices: soprano, alto, tenor
% ---------------------------------------------------------------

global  = { \key c \major  \time 4/4}

voiceS = \relative c'' {
  \clef treble
  \stemUp
  \global
  c4 c c( b) | c2 r4 d4 | e f d d | cis2 r4 d4 |
  cis4 cis gis' dis | bes bes bes es | e!2 f4 es |
  es2 des | ces1 \bar "|."
}

voiceA = \relative c'' {
  \clef treble
  \stemDown
  \global
  g4 f f2 | g2 r4 b4 | c c a b | a2 r4 b4 |
  a4 a cis a | f es g as | c2 d4 des  |
  ces2 bes | as1 \bar "|."
}

voiceT = \relative c' {
  \clef treble
  \stemDown
  \global
  e4 c d2 | e2 r4 f4 | g f f gis | e2 r4 gis4 |
  e4 fis gis fis | bes, bes es es | g2 as4 bes |
  as2 g | es1 \bar "|."
}

voiceB = \relative c {
  \clef bass
  \stemNeutral
  \global
  c4 a g2 | c2 r4 g4 | c a b e, | a2 r4 e4 |
  a4 fis e c' | des g des ces | bes2 bes4 g |
  as2 es'2 | as1 \bar "|."
}

% ---------------------------------------------------------------
% ----- hidden bass voice (not to be displayed, only
% ----- for aligning the lyrics via "lyricsto"
% ---------------------------------------------------------------

fhaVoiceHidden =
\relative c, {
  \clef bass
  \stemDown
  \global
  \override NoteHead.color = #red
  \override NoteColumn #'ignore-collision = ##t
  c4 c c c | c2 r4 c | c c c c | c2 r4 c | c c c c | c c c c | c2 c4 c | c2 c | c1 \bar "|."
}

fhaRhythmVoice =
\relative c {
  \stemDown
  \global
  c4 c c c | c2 r4 c | c c c c | c2 r4 c | c c c c | c c c c | c2 c4 c | c2 c | c1 \bar "|."
}

% ---------------------------------------------------------------
% ----- "lyrics": Symbols for functional harmony
% ---------------------------------------------------------------

fhasSubline = \lyricmode {
  \override LyricText.self-alignment-X = #LEFT
  \override LyricExtender.left-padding = #-0.5
  \override LyricExtender.extra-offset = #'(0 . 0.5)


  \markup \setHas "I" #'()
  \markup \setHas "VI" #'(("a"."6"))
  \initTextSpan "   "
  \markup \openZoomRow "V" #'(("a"."4")("b"."7"))
  \startTextSpan
  \markup \expZoomRow #'(("a"."3")) 
  \stopTextSpan
  
  \markup \setHas "I" #'()
  \markup \setHas "V" #'(("a"."7")("fr" . " ")) 
  
  \markup \setHas "I" #'()
  \markup \setHas "VI" #'(("a"."6"))
  \markup \setHas "VII" #'(("a"."7"))
  \markup \setHas "III" #'(("a"."♯3")("b"."7")("fr" . " "))
   
  \markup \setHas "VI" #'(("a"."♯3"))
  \markup \setHas "III" #'(("a"."♯3")("b"."7")("fr" . " ")) 
   
  \markup \setHas "VI" #'(("a"."♯3"))
  \markup \setHas "IV" #'(("B"."♯")("a"."♯5"))
  \markup \setHas "III" #'(("a"."♯3")("b"."♯6"))
  \markup \setHas "I" #'(("a"."♯2")("b"."♯4")("c"."6")("fr" . " "))

  \markup \setHas "II" #'(("B"."♭")("a"."♭6")) 
  \markup \setHas "V" #'(("a"."♭3")("b"."♭6")) 
  \markup \setHas "II" #'(("B"."♭")("a"."♭2")("b"."4")("c"."♭6")) 
  \markup \setHas "I" #'(("B"."♭")("a"."♭3")("b"."♭6")("fr" . " ")) 
  
  \markup \setHas "VII" #'(("B"."♭")("a"."2")("b"."♭4")("c"."♭6"))
  \markup \setHas "VII" #'(("B"."♭")("a"."♭7"))
  \markup \setHas "V" #'(("a"."♭3")("b"."♭5")("c"."♭6")("fr" . " ")) 
  
  \markup \setHas "VI" #'(("B"."♭")("a"."♭3")("b"."♭5"))
  \markup \setHas "III" #'(("B"."♭")("a"."♭5")("b"."♭7"))  

  \markup \setHas "VI" #'(("B"."♭")("a"."♭3")("b"."♭5"))

}


\score {
  <<
    \new GrandStaff <<
      \new Staff = upper
      \with { printPartCombineTexts = ##f }
      {
        <<
          \voiceS \\
          \partcombine \voiceA \voiceT
        >>
      }
      \new Staff = lower
      \new Voice = "Musical Bass"
      \with { printPartCombineTexts = ##f }
      {
        <<
          \voiceB
          % change "NullVoice" to "Voice" to make analyze voice visible:
          \new NullVoice = "AnalysisSubline" {\shiftOff  \fhaVoiceHidden}
          \new Lyrics \lyricsto "AnalysisSubline" \fhasSubline
        >>
      }
    >>

  >>

  \layout {
    \context {
      \Lyrics
      \consists "Text_spanner_engraver"
    }
  }
  \midi {}
} 
 





