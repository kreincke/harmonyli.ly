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
         < fis  d'>2    
          < fis  dis'>2   
          < b  e>2        
          < b  eis>2        
          | 
          < b fis'>2  
          < e gis >2 
          < e a >4
          < e a >4 
          < a fis>2       
          \bar "||"
        }
        \addlyrics {
          \markup \setHas "T" #'(("C"."D")("fr" . " "))
          \markup \setImHas "D" #'(("B"."1")("a" . "7")("fr" . " "))
          \markup \setHas "Sp" #'(("B"."7")("a" . "7")("fl" . " ")("fr" . " "))
          \markup \setHas "D" #'(("T"."x")("B"."3")("a" . "5")("b" . "7")("c" . "♭9>♯8")("fr" . " "))
          \markup \setHas "Tp" #'(("B"."3")("fl" . " ")("fr" . " ")) 
          \markup \setHas "D" #'(("T"."d")("B"."5")("a" . "7")("b" . "8")("fr" . " ")) 
                 
          \initTextSpan "   "
          \markup \openZoomRow "D" #'(("a"."4")("fl" . " "))
          \startTextSpan
          \markup \expZoomRow #'(("a"."3")("fr" . " ")) 
          \stopTextSpan
  
          \markup \setHas "T" #'(("fr" . " "))
        }   
      }
      \new Staff {
        \relative d { 
          \clef "bass"
          \key d \major  
          \stemDown
          < d a'>2                              
          < b a'>2                   
          < d g>2                
          < cis g'>2                                    
          |
          < d fis>2                      
          < b d>2                  
          <<
            { a4( a4)   }
            { d4( cis4) }
          >> 
          < d, d'>2       
          \bar "||"
        }   
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

