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
          < e a >2
          < a fis>2       
          \bar "||"
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
            { a2   }
            { d4 cis4 }
          >> 
          < d, d'>2       
          \bar "||"
        } 
                % TODO: fstring nicht ausgewertet1
        \addlyrics {
          \markup \setFHAS "I" #'(("fr" . " "))
          \markup \setFHAS "VI" #'(("a" . "♯3")("b" . "5")("c" . "6")("fr" . " "))
          \markup \setFHAS "I" #'(("a" . "2")("fr" . " "))
          \markup \setFHAS "VII" #'(("a" . "♯3")("b" . "7")("fl" . " ")("fr" . " "))
          \markup \setFHAS "I" #'(("a" . "6")("fr" . " ")("fr" . " ")) 
          \markup \setFHAS "VI" #'(("a" . "3")("b" . "4")("c" . "♯6")("fr" . " ")) 
                 
          \initTextSpan "   "
          \markup \initZoomRow "V" #'(("a"."4")("b"."5")("fl" . " ")) 
          \startTextSpan
          \markup \expZoomRow #'(("a"."3")("fr" . " ")) 
          \stopTextSpan
  
          \markup \setFHAS "I" #'(("fr" . " "))
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

