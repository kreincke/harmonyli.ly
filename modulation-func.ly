% modulation.ly :- for demonstrating the use of harmonyli.ly in a modulation
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

\version "2.20.0"

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
  subtitle = "for demonstrating special aspects of the expressiveness of harmonyli.ly"
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


  \set stanza = #"C-Major:"
  % encoding on level 1 
  \markup \setHas  "T" #'(("C"."C"))
  \markup \setHas  "S" #'(("B"."3"))
  \initTextSpan "   "
  \markup \openZoomRow "D" #'(("a"."4")("b"."7"))
  \startTextSpan
  \markup \expZoomRow #'(("a"."3")) 
  \stopTextSpan
  \markup \FHAS "T"
  \markup \Dsept 
  \markup \FHAS "T"
  \markup \setHas  "S" #'(("B"."3"))
  \markup \setRfHas "Sp" "s" 
    #'( ("B"."6")("a"."5")("b"."6")("C" . "C")
        ("nB"."6")("na"."5")("nb"."6")("nC" . "A")
    )
  \markup \setHas  "D" #'(("a"."7")("C"."A")) 
  \markup \setHas  "T" #'(("C"."A"))
  \markup \setHas  "D" #'(("a"."7")("C"."A")) 
  \markup \setHas  "T" #'(("C"."A"))
  \markup \setHas  "Tp" #'(("C"."A"))
  \markup \setHas  "Tg" #'(("C"."A"))

    \markup \setRfHas "D" "D" 
    #'( ("T"."dx")("B"."♭9")("a"."7")("b"."♭9")("C" . "A")("fr".")")("fl"."(")
        ("nT"."x")("nB"."3")("na"."7")("nb"."♭9")("nC" . "S (As)")("nfr".")")("nfl"."(")
       
    )

  \markup \setHas  "Sp" #'(("C"."As")) 
  \markup \setHas  "D" #'(("B"."3")("C"."as")) 
  \markup \setHas  "D" #'(("B"."7")("a"."7")("C"."as")) 
  \markup \setHas  "t" #'(("C"."as"))

  \markup \setImHas "D" #'(("T"."d")("B"."7")("a" . "7")) 
  
  
  \markup \setHas  "D" #'(("T"."d")("a"."7")("C"."as")) 
  \markup \setHas  "D" #'(("B" . "3")("a"."7")("C"."as")) 
  \markup \setHas  "t" #'(("C"."as"))
  \markup \setHas  "D" #'(("a"."7")("C"."as")) 
  \set stanza = #"as-minor"
  \markup \setHas  "t" #'(("C"."as"))

}

fhasLine = \lyricmode {
  \override LyricText.self-alignment-X = #LEFT
  \override LyricExtender.left-padding = #-0.5
  \override LyricExtender.extra-offset = #'(0 . 0.5)


  \set stanza = #"C-Major:"
  % encoding on level 1 
  \markup \setHas  "T" #'(("C"."C"))
  \markup \setHas  "S" #'(("B"."3"))
  \initTextSpan "   "
  \markup \openZoomRow "D" #'(("a"."4")("b"."7"))
  \startTextSpan
  \markup \expZoomRow #'(("a"."3")) 
  \stopTextSpan
  \markup \FHAS "T"
  \markup \Dsept 
  \markup \FHAS "T"
  \markup \setHas  "S" #'(("B"."3"))
  \markup \setRfHas "Sp" "s" 
    #'( ("B"."6")("a"."5")("b"."6")("C" . "C")
        ("nB"."6")("na"."5")("nb"."6")("nC" . "A")
    )
  \markup \setHas  "D" #'(("a"."7")("C"."A")) 
  \markup \setHas  "T" #'(("C"."A"))
  \markup \setHas  "D" #'(("a"."7")("C"."A")) 
  \markup \setHas  "T" #'(("C"."A"))
  \markup \setHas  "Tp" #'(("C"."A"))
  \markup \setHas  "Tg" #'(("C"."A"))

   \markup \setRfHas "D!" "D" 
    #'( ("T"."dx")("B"."♭9")("a"."7")("b"."♭9")("C" . "A")("fr".")")("fl"."(")
        ("nT"."x")("nB"."3")("na"."7")("nb"."♭9")("nC" . "S (As)")("nfr".")")("nfl"."(")
       
    )

  \markup \setHas  "Sp" #'(("C"."As")) 
  \markup \setHas  "D" #'(("B"."3")("C"."as")) 
  \markup \setHas  "D" #'(("B"."7")("a"."7")("C"."as")) 
  \markup \setHas  "t" #'(("C"."as"))

  \markup \setImHas "D" #'(("T"."d")("B"."7")("a" . "7")) 
  
  
  \markup \setHas  "D" #'(("T"."d")("a"."7")("C"."as")) 
  \markup \setHas  "D" #'(("B" . "3")("a"."7")("C"."as")) 
  \markup \setHas  "t" #'(("C"."as"))
  \markup \setHas  "D" #'(("a"."7")("C"."as")) 
  \set stanza = #"as-minor"
  \markup \setHas  "t" #'(("C"."as"))

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
          % change "Voice" to "NullVoice" to make analyze voice unvisible:
          \new Voice = "AnalysisSubline" {\shiftOff  \fhaVoiceHidden}
          \new Lyrics \lyricsto "AnalysisSubline" \fhasSubline
        >>
      }
    >>
    \new RhythmicStaff = analysis
    \with { printPartCombineTexts = ##f }
    {
      << 
          \new Voice = "AnalysisLine" { \fhaRhythmVoice}
          \new Lyrics \lyricsto "AnalysisLine" \fhasLine
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
\markup { 
  \column {
    \line { 
      Nevertheless, this file only uses (indicates) a subset of 'harmonyli'.
      For details see the harmonily-tutorial. }
    \line{ 
      Additionally it demonstrates the two ways to integrate 
      \italic{ Functional Harmony Analysis Symbols} into a score:
      }
  
    \line {
      1) Create an unvisible voice (red) as part of the
      (deepest) staff and bind the analyzing lyrics to that voice.}
    \line {
      2) Create a special staff (RhythmicStaff) with a rhythm voice 
      and bind the analyzing lyrics to that voice.
    }
  
  }
}


