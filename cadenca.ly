% a lilypond cadence for demonstrating the use of harmonyli
% (c) 2019 Frankfurt, Germany, Karsten Reincke
% This file is licensed under CC-BY-SA 4.0 international
% for details see https://creativecommons.org/licenses/by-sa/4.0/
\version "2.18.2"

\header { tagline = "" }
\include "inc.harmonyli.ly"
  
\score {
  \new StaffGroup {
    \time 4/2
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
        \addlyrics {
          \override LyricText.self-alignment-X = #LEFT
          \markup \T
          \markup \T 
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
            { a2        }
            { d4( cis4) }
          >> 
          < d, d'>2       
          \bar "||"
        }   
      }
    >>
  }
  \layout { }
  \midi {}
}

