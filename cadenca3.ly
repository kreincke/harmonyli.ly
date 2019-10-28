% a lilypond cadence for demonstrating the use of harmonyli
% (c) 2019 Frankfurt, Germany, Karsten Reincke
% This file is licensed under CC-BY-SA 4.0 international
% for details see https://creativecommons.org/licenses/by-sa/4.0/
\version "2.18.2"

\header { tagline = "" }
% the 'lib' must be included
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
      }
      \new Staff {
        \relative d { 
          \clef "bass"
          \key d \major  
          \stemDown
          < d a'>2        ^\markup { \hf T }                      
          < b a'>2        ^\markup { ( \hfOne D "7" ) }           
          < d g>2         ^\markup { \hfiOne Sp "7" "7" }         
          < cis g'>2      ^\markup { \hfiTri D "3" "5" "7" 
                                        \line{"9"{\super{\flat}}"=8"{\super{\sharp}}}
                                    }                               
          |
          < d fis>2       ^\markup { \hfi Tp "3" }                
          < b d>2         ^\markup { \hfiOne DD "5" "7" }         
          <<
            { a2          ^\markup { \hfOne D "4>3" }  }
            { d4( cis4) }
          >> 
          < d, d'>2       ^\markup { \hf T }
          \bar "||"
        }   
      }
    >>
  }
  \layout { }
  \midi {}
}

