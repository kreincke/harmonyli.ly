% a lilypond cadence for demonstrating the use of harmonyli
% (c) 2019 Frankfurt, Germany, Karsten Reincke
% This file is licensed under CC-BY-SA 4.0 international
% for details see https://creativecommons.org/licenses/by-sa/4.0/
\version "2.18.2"

\header { tagline = "" }
\include "inc.harmonyli.ly"
  
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
          \markup \setFHAS "T" #'(("C"."C")("f" . ""))
          \initIMArea
          \markup \closeIMArea "D" #'(("B"."1")("a" . "7"))
          \markup \setFHAS "Sp" #'(("B"."7")("a" . "7"))
          \markup \setFHAS "D" #'(("T"."x")("B"."3")("a" . "5")("b" . "7")("c" . "♭9>♯8"))
          \markup \setFHAS "Tp" #'(("B"."3")) 
          \markup \setFHAS "D" #'(("T"."d")("B"."5")("a" . "7")("b" . "8")) 
                 
          \initTextSpan "   "
          \markup \initZoomRow "D" #'(("a"."4")) 
          \startTextSpan
          \markup \expZoomRow #'(("a"."3")) 
          \stopTextSpan
  
          \markup \setFHAS "T" #'(("f" . ""))
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

