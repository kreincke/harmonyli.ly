% minimal.ly :- a minimalistic example
% Copyright (c) 2019 Karsten Reincke, 
%
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

\version "2.18.2"

\include "harmonyli.ly"

analysis = \lyricmode {
  \markup \setHas "T" #'() 
  \markup \setImHas "D" #'(("B"."3")("a" . "7")("b" . "9♭"))
  \initTextSpan "   "
  \markup \openZoomRow "Sp" #'(("a"."9")) 
  \startTextSpan
  \markup \expZoomRow #'(("a"."8")) 
  \stopTextSpan
}

\score {
  \new GrandStaff <<
    \new Staff << \clef treble \key c \major  \time 4/4
      \new Voice = "top" { \stemUp e''4 e'' e''( d'')  }
      \new Voice = "middle" { \stemDown <g' c''>4 <g' bes'>4 <f' a'>2
      }
      >> 
    \new Staff << \clef bass  \key c \major  \time 4/4
      \new Voice = "down" { \stemUp c4 cis4 d2 }
      \new NullVoice = "rhythm" { \stemDown c,4 c,4 c,4 c,4 }
      \new Lyrics \lyricsto "rhythm" {\analysis}
      >>
  >>
  \layout {
    \context {
      \Score \override SpacingSpanner.base-shortest-duration = #(ly:make-moment 1/32) 
    }
    \context {
       \Lyrics \consists "Text_spanner_engraver" 
    }
  }
} 