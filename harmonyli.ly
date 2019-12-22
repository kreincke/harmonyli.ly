% harmonyli.ly :- a library for inserting Functional Harmony Analysis Symbols 
% into musical scores encoded in and created by LilyPOnd
%
% Copyright (c) 2019 Karsten Reincke, Frankfurt, Hans Blum
%
% release 1.2
%
% This file is distributed either under the terms of the MIT license or under 
% the terms of the GPLv3 license. Feel free to choose the distribution method 
% you prefer by deleting the unsuitable licensing statement (Don't delete both): 
%
% (a) If you want to use it under the terms of the MIT license erase the 
%     following GPLv3 licensing statement:
% (b) If you want to use harmonyli.ly under the terms of the GPLv2 license
%      erase the following MIT license text
%
% GPLv3-Licensing Statement
% -------------------------

% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.

% MIT-License and Licensing Statement
% --------------------------------------
% Copyright 2019 Karsten Reincke, Frankfurt

% Permission is hereby granted, free of charge, to any person 
% obtaining a copy of this software and associated documentation 
% files (the "Software"), to deal in the Software without 
% restriction, including without limitation the rights to use, 
% copy, modify, merge, publish, distribute, sublicense, and/or sell 
% copies of the Software, and to permit persons to whom the 
% Software is furnished to do so, subject to the following conditions:

% The above copyright notice and this permission notice shall be 
% included in all copies or substantial portions of the Software.

% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
% OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
% HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
% WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE 
% OR OTHER DEALINGS IN THE SOFTWARE.
%
% Some Compliance Hints: 
% ----------------------
% (A) MIT Usage
% -------------
% (1) For using harmonyli.ly compliantly it is sufficient if the
% MIT license text is part of this file.
% (2) For modifying harmonyli.ly compliantly or for using part of
% it, it is sufficient if the MIT license text is included in 
% all copies or substantial portions
% (3) Under the terms of the MIT license you may use harmonyli.ly
% as part of your overarching work and you may distribute this
% overarching complex as whole under any license you want. But
% you may not erase the MIT license text in this file or in
% all derived files - just as the MIT license requires:
%
% The above copyright notice and this permission notice shall be 
% included in all copies or substantial portions of the Software.
%
% (B) GPLv3 Usage
% ---------------
% If you prefer to distribute harmonyli.ly under the terms of the
% GPLv3, then you have to fulfill all requirements of the GPLv3,
% especially those of §4 and §5 (strong copyleft effect and so on)
% and those of §6 (Conveying Non-Source Forms)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Reference to groundwork
% -----------------------
% harmonyli.ly heavily uses ideas and code of Klaus Blum's groundwork which has 
% been published in the 'Lilypond Snippet Repository':
% -> http://lsr.di.unimi.it/LSR/Item?id=967
%
% In a mail from Nov. the 4th 2019 Klaus Blum explicitly approved that he 
% a) distributes his code under the terms of the (American) public domain 
% b) agrees to use his file as groundwork for harmonyli.ly
% c) to distribute the result under the terms of of a dual-license: the user 
%    shall be enabled to choose whether he wants to use it under the terms
%   of the GPLv3 or the MIT
%
% Just as Klaus Blum's groundwork, also harmonyli.ly uses some explanations of 
% Neil Puttock by which he described the use text span engraver.
% -> http://www.mail-archive.com/lilypond-user%40gnu.org/msg60732.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\version "2.18.2"


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For details of the implementation take a look at the tutorial in doc 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% harmonyli.ly config area

% ImInfix

#(define imInfix "")


% ---------------------------------------------------------------------
% Harmonyli Interface No 1: The basic method for inserting all manually
% ---------------------------------------------------------------------

#(define-markup-command (addnum layout props adc adn ANL)
  (markup? markup? list?)
  (interpret-markup layout props
    (cond 
      ( (member adc ANL)
        #{
           \markup \numx #adn
        #}
      )
      ( else
        #{
           \markup  #adn 
        #}
      )
    )
  )
)
 
#(define-markup-command (has layout props RS SN BN aN bN cN dN eN CT fstl fstr NUNS)
  (markup? markup? markup? markup? markup? markup? markup? markup? markup? markup? markup? list?)
  (let* ((lCT (string-append "[" CT "]")))
    (if (equal? CT "")(set! lCT ""))
    (interpret-markup layout props
     #{
       \markup{
         \concat {
           $fstl
           \override #'(baseline-skip . 1.4)
           \center-column {
             \override #`(direction . ,UP)
             \override #'(baseline-skip . 2.0)
             \dir-column {
               \halign #CENTER
                \concat { $RS \tiny {  $lCT  } }
               \tiny
               \halign #CENTER
               $SN
             }
             \tiny
             $BN
           }
           \tiny
           \override #`(direction . ,UP)
           \override #'(baseline-skip . 0.8)
           \dir-column {
             " "
             {
               \override #`(direction . ,UP)
               \override #'(baseline-skip . 1.3)
               \dir-column { 
                 \addnum "a" $aN $NUNS  
                 \addnum "b" $bN $NUNS  
                 \addnum "c" $cN $NUNS
                 \addnum "d" $dN $NUNS   
                 \addnum "e" $eN $NUNS  
               }
             }
           }
           $fstr
         }
       }
     #}
 )))
 

#(define-markup-command 
  (rfhas layout props 
    RSl SNl BNl aNl bNl cNl dNl eNl CTl fstll fstrl NUNSl
    RSr SNr BNr aNr bNr cNr dNr eNr CTr fstlr fstrr NUNSr
    )
  ( markup? markup? markup? markup? markup? markup? markup? markup? markup?
    markup? markup? list?
    markup? markup? markup? markup? markup? markup? markup?
    markup? markup? markup? markup? list?
  )

    (interpret-markup layout props
     #{
        \markup{
          \concat {
            \box
            \concat {
              \has #RSl #SNl #BNl #aNl #bNl #cNl #dNl #eNl #CTl $fstll $fstrl #NUNSl
              " ⇨ "
              \has #RSr #SNr #BNr #aNr #bNr #cNr #dNr #eNr #CTr $fstlr $fstrr  #NUNSr
            }
            " "
          }      
        }
     #}
 ))
 
% ------------------------------------------------------------------------------
% Harmonyli Interface No 2.A: The core method for inserting only relevant values
% ------------------------------------------------------------------------------

#(define BNoteKey "B")
#(define SNoteKey "S")
#(define aNoteKey "a")
#(define bNoteKey "b")
#(define cNoteKey "c")
#(define dNoteKey "d")
#(define eNoteKey "e")
#(define fsKeyL "fl")
#(define fsKeyR "fr")
#(define nuKey "n")

#(define RsSpec "T")
#(define RsCont "C")

#(define NBNoteKey "nB")
#(define NSNoteKey "nS")
#(define NaNoteKey "na")
#(define NbNoteKey "nb")
#(define NcNoteKey "nc")
#(define NdNoteKey "nd")
#(define NeNoteKey "ne")
#(define NRsSpec "nT")
#(define NRsCont "nC")
#(define NfsKeyL "nfl")
#(define NfsKeyR "nfr")
#(define NnuKey "nn")

#(define BNoteDValue "")
#(define SNoteDValue "")
#(define aNoteDValue "")
#(define bNoteDValue "")
#(define cNoteDValue "")
#(define dNoteDValue "")
#(define eNoteDValue "")
#(define fsDValue "") 
#(define RsSpecDValue "")
#(define RsContDValue "")

#(define nuDValue (list ))

% The RS can be crossed out and or doubled To express the combinations
% we invent a parameter RS taking the values [ n (normal) | x | d | xd ]
% x

% evaluating the arguments:
% gets the associatedList and the key of the wanted RFS element
% if any pair in the list contains the key, it returns the value
% defined in the pair, otherwise it returns the default value
#(define (assign keyValue assocList defaultValue)
  (string? list?)
  (let* ((localPair (assoc keyValue assocList)))
    (if localPair (cdr localPair) defaultValue)
  )
)

% INTERFACE 2.A
% returns the Riemann Function Symbol as markup
#(define-markup-command (setHas layout props RS AL)
  (markup? list?)
  (let*
    ( 
      (lRS (assign RsSpec AL RsSpecDValue ))
      (lBN (assign BNoteKey AL BNoteDValue))
      (lSN (assign SNoteKey AL SNoteDValue))
      (laN (assign aNoteKey AL aNoteDValue))
      (lbN (assign bNoteKey AL bNoteDValue))
      (lcN (assign cNoteKey AL cNoteDValue))
      (ldN (assign dNoteKey AL dNoteDValue))
      (leN (assign eNoteKey AL eNoteDValue))
      (lCT (assign RsCont AL RsContDValue))
      (lFSl (assign fsKeyL AL fsDValue))
      (lFSr (assign fsKeyR AL fsDValue))
      (lnu (assign nuKey AL nuDValue ))
    )
  
    (interpret-markup layout props
      (cond
        ( (equal? lRS "d")
          #{
             \markup \has \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "x")
          #{
             \markup \has \crossout #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "xd")
          #{
             \markup \has \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "dx")
          #{
             \markup \has \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( else
          #{
             \markup \has #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
      )
    )
   )
 )





% INTERFACE 2.A
% returns the Riemann Function Symbol as markup
#(define-markup-command (setRfHas layout props RSl RSr AL)
  (markup? markup? list?)
  (let*
    ( (lBNl (assign BNoteKey AL BNoteDValue))
      (lSNl (assign SNoteKey AL SNoteDValue))
      (laNl (assign aNoteKey AL aNoteDValue))
      (lbNl (assign bNoteKey AL bNoteDValue))
      (lcNl (assign cNoteKey AL cNoteDValue))
      (ldNl (assign dNoteKey AL dNoteDValue))
      (leNl (assign eNoteKey AL eNoteDValue))
      (lRSl (assign RsSpec AL RsSpecDValue ))
      (lCTl (assign RsCont AL RsContDValue)) 
      (lFSll (assign fsKeyL AL fsDValue))
      (lFSrl (assign fsKeyR AL fsDValue))
      (lnul (assign nuKey AL nuDValue ))
                
      (lBNr (assign NBNoteKey AL BNoteDValue))
      (lSNr (assign NSNoteKey AL SNoteDValue))
      (laNr (assign NaNoteKey AL aNoteDValue))
      (lbNr (assign NbNoteKey AL bNoteDValue))
      (lcNr (assign NcNoteKey AL cNoteDValue))
      (ldNr (assign NdNoteKey AL dNoteDValue))
      (leNr (assign NeNoteKey AL eNoteDValue))
      (lRSr (assign NRsSpec AL RsSpecDValue ))
      (lCTr (assign NRsCont AL RsContDValue))      
      (lFSlr (assign NfsKeyL AL fsDValue))
      (lFSrr (assign NfsKeyR AL fsDValue))
      (lnur (assign nuKey AL nuDValue ))
    )
  
    (interpret-markup layout props
      (cond
        ;; ---------- combinations with left double
        ( (and (equal? lRSl "d") (equal? lRSr "d"))
          #{
             \markup \rfhas 
                \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur
          #}
        )
        ( (and (equal? lRSl "d") (equal? lRSr "x"))
          #{
             \markup \rfhas   
                \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \crossout #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur          
          #}
        )
         ( (and (equal? lRSl "d") (equal? lRSr "dx"))
          #{
             \markup \rfhas   
                \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur             
          #}
        )
         ( (and (equal? lRSl "d") (equal? lRSr "xd"))
          #{
             \markup \rfhas  
                \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur            
          #}
        )
        ( (and (equal? lRSl "d") (equal? lRSr ""))
          #{
             \markup \rfhas  
                \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur      
          #}
        )
        ;; ---------- combinations with left crossout
        ( (and (equal? lRSl "x") (equal? lRSr "d"))
          #{
             \markup \rfhas  
                \crossout #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur            
          #}
        )
        ( (and (equal? lRSl "x") (equal? lRSr "x"))
          #{
             \markup \rfhas  
                \crossout #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \crossout #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur          
          #}
        )
         ( (and (equal? lRSl "x") (equal? lRSr "dx"))
          #{
             \markup \rfhas  
                \crossout #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur            
          #}
        )
         ( (and (equal? lRSl "x") (equal? lRSr "xd"))
          #{
             \markup \rfhas  
                \crossout #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur           
          #}
        )
        ( (and (equal? lRSl "x") (equal? lRSr ""))
          #{
             \markup \rfhas  
                \crossout #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur        
          #}
        )
        ;; ---------- combinations with left crossout double (dx)
        ( (and (equal? lRSl "dx") (equal? lRSr "d"))
          #{
             \markup \rfhas          
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur       
          #}
        )
        ( (and (equal? lRSl "dx") (equal? lRSr "x"))
          #{
             \markup \rfhas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
               \crossout #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur         
          #}
        )
         ( (and (equal? lRSl "dx") (equal? lRSr "dx"))
          #{
             \markup \rfhas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur           
          #}
        )
         ( (and (equal? lRSl "dx") (equal? lRSr "xd"))
          #{
             \markup \rfhas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur           
          #}
        )
        ( (and (equal? lRSl "dx") (equal? lRSr ""))
          #{
             \markup \rfhas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur        
          #}
        )
        ;; ---------- combinations with left crossout double (xd)
        ( (and (equal? lRSl "xd") (equal? lRSr "d"))
          #{
             \markup \rfhas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur         
          #}
        )
        ( (and (equal? lRSl "xd") (equal? lRSr "x"))
          #{
             \markup \rfhas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \crossout #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur          
          #}
        )
         ( (and (equal? lRSl "xd") (equal? lRSr "dx"))
          #{
             \markup \rfhas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur           
          #}
        )
         ( (and (equal? lRSl "xd") (equal? lRSr "xd"))
          #{
             \markup \rfhas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur            
          #}
        )
        ( (and (equal? lRSl "xd") (equal? lRSr ""))
          #{
             \markup \rfhas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur          
          #}
        )
        ;; ---------- combinations with left pure
        ( (and (equal? lRSl "") (equal? lRSr "d"))
          #{
             \markup \rfhas  
                #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur            
          #}
        )
        ( (and (equal? lRSl "") (equal? lRSr "x"))
          #{
             \markup \rfhas  
                #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \crossout #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur           
          #}
        )
         ( (and (equal? lRSl "") (equal? lRSr "dx"))
          #{
             \markup \rfhas  
                #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur            
          #}
        )
         ( (and (equal? lRSl "") (equal? lRSr "xd"))
          #{
             \markup \rfhas  
                #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur           
          #}
        )

        ( else
          #{
             \markup \rfhas 
                #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl #lFSll #lFSrl #lnul
                #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr #lFSlr #lFSrr #lnur         
         #}
        )
      )
    )
   )
 )

% ------------------------------------------------------------------------------
% Harmonyli Interface No 2.B: Functions to use intermediary areas
% ------------------------------------------------------------------------------

% returns the Riemann Function Symbol as markup
#(define-markup-command (setImHas layout props RS AL)
  (markup? list?)
  (let*
    ( (lBN (assign BNoteKey AL BNoteDValue))
      (lSN (assign SNoteKey AL SNoteDValue))
      (laN (assign aNoteKey AL aNoteDValue))
      (lbN (assign bNoteKey AL bNoteDValue))
      (lcN (assign cNoteKey AL cNoteDValue))
      (ldN (assign dNoteKey AL dNoteDValue))
      (leN (assign eNoteKey AL eNoteDValue))
      (lRS (assign RsSpec AL RsSpecDValue ))
      (lCT (assign RsCont AL RsContDValue))
      (lFSl (assign fsKeyL AL fsDValue))
      (lFSr (assign fsKeyR AL fsDValue))
      (lnu (assign nuKey AL nuDValue ))
    )
    (set! lFSl (string-append lFSl "(" imInfix  ))
    (set! lFSr (string-append imInfix  ")" lFSr ))
    (interpret-markup layout props
      (cond
        ( (equal? lRS "d")
          #{
             \markup \has \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "x")
          #{
             \markup \has \crossout #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "xd")
          #{
             \markup \has \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "dx")
          #{
             \markup \has \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( else
          #{
             \markup \has #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
      )
    )
   )
 )

% returns the Riemann Function Symbol as markup
#(define-markup-command (openImRow layout props RS AL)
  (markup? list?)
  (let*
    ( (lBN (assign BNoteKey AL BNoteDValue))
      (lSN (assign SNoteKey AL SNoteDValue))
      (laN (assign aNoteKey AL aNoteDValue))
      (lbN (assign bNoteKey AL bNoteDValue))
      (lcN (assign cNoteKey AL cNoteDValue))
      (ldN (assign dNoteKey AL dNoteDValue))
      (leN (assign eNoteKey AL eNoteDValue))
      (lRS (assign RsSpec AL RsSpecDValue ))
      (lCT (assign RsCont AL RsContDValue))
      (lFSl (assign fsKeyL AL fsDValue))
      (lFSr (assign fsKeyR AL fsDValue))
      (lnu (assign nuKey AL nuDValue ))
    )
    (set! lFSl (string-append lFSl "(" imInfix ))
    (interpret-markup layout props
      (cond
        ( (equal? lRS "d")
          #{
             \markup \has \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "x")
          #{
             \markup \has \crossout #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "xd")
          #{
             \markup \has \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "dx")
          #{
             \markup \has \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( else
          #{
             \markup \has #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
      )
    )
   )
 )

% returns the Riemann Function Symbol as markup
#(define-markup-command (closeImRow layout props RS AL)
  (markup? list?)
  (let*
    ( (lBN (assign BNoteKey AL BNoteDValue))
      (lSN (assign SNoteKey AL SNoteDValue))
      (laN (assign aNoteKey AL aNoteDValue))
      (lbN (assign bNoteKey AL bNoteDValue))
      (lcN (assign cNoteKey AL cNoteDValue))
      (ldN (assign dNoteKey AL dNoteDValue))
      (leN (assign eNoteKey AL eNoteDValue))
      (lRS (assign RsSpec AL RsSpecDValue ))
      (lCT (assign RsCont AL RsContDValue))
      (lFSl (assign fsKeyL AL fsDValue))
      (lFSr (assign fsKeyR AL fsDValue))
      (lnu (assign nuKey AL nuDValue ))
    )
    (set! lFSr (string-append imInfix ")" lFSr ))
    (interpret-markup layout props
      (cond
        ( (equal? lRS "d")
          #{
             \markup \has \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "x")
          #{
             \markup \has \crossout #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "xd")
          #{
             \markup \has \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "dx")
          #{
             \markup \has \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( else
          #{
             \markup \has #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
      )
    )
   )
 )

% ------------------------------------------------------------------------------
% Harmonyli Interface No 2.C: Functions to use zoom in analyses
% ------------------------------------------------------------------------------

initTextSpan =
#(define-music-function (parser location fText) (string?)
   #{
     \once \override TextSpanner #'direction = #DOWN
     \once \override TextSpanner #'style = #'line
     \once \override TextSpanner #'outside-staff-priority = ##f
     \once \override TextSpanner #'padding = #-0.6 % sets the distance of the line from the lyrics
     \once \override TextSpanner #'bound-details =
     #`((left . ((Y . 0)
                 (padding . 0)
                 (attach-dir . ,LEFT)))
        (left-broken . ((end-on-note . #t)))
        (right . ((Y . 0)
                  (padding . 0)
                  (attach-dir . ,RIGHT))))
     \once \override TextSpanner.bound-details.left.text = $fText
   #})


#(define-markup-command (openZoomRow layout props RS AL)
  (markup? list?)
  (let*
    ( (lBN (assign BNoteKey AL BNoteDValue))
      (lSN (assign SNoteKey AL SNoteDValue))
      (laN (assign aNoteKey AL aNoteDValue))
      (lbN (assign bNoteKey AL bNoteDValue))
      (lcN (assign cNoteKey AL cNoteDValue))
      (ldN (assign dNoteKey AL dNoteDValue))
      (leN (assign eNoteKey AL eNoteDValue))
      (lRS (assign RsSpec AL RsSpecDValue ))
      (lCT (assign RsCont AL RsContDValue))
      (lFSl (assign fsKeyL AL fsDValue))
      (lFSr (assign fsKeyR AL fsDValue))
      (lnu (assign nuKey AL nuDValue ))
    )
 
    (interpret-markup layout props
      (cond
        ( (equal? lRS "d")
          #{
             \markup \has \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "x")
          #{
             \markup \has \crossout #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "xd")
          #{
             \markup \has \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "dx")
          #{
             \markup \has \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( else
          #{
             \markup \has #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
      )
    )
   )
 )

#(define-markup-command (openImZoomRow layout props RS AL)
  (markup? list?)
  (let*
    ( 
      (lRS (assign RsSpec AL RsSpecDValue ))    
      (lBN (assign BNoteKey AL BNoteDValue))
      (lSN (assign SNoteKey AL SNoteDValue))
      (laN (assign aNoteKey AL aNoteDValue))
      (lbN (assign bNoteKey AL bNoteDValue))
      (lcN (assign cNoteKey AL cNoteDValue))
      (ldN (assign dNoteKey AL dNoteDValue))
      (leN (assign eNoteKey AL eNoteDValue))
      (lCT (assign RsCont AL RsContDValue))
      (lFSl (assign fsKeyL AL fsDValue))
      (lFSr (assign fsKeyR AL fsDValue))
      (lnu (assign nuKey AL nuDValue ))
    )
    (set! lFSl (string-append lFSl "(" imInfix ))
    (interpret-markup layout props
      (cond
        ( (equal? lRS "d")
          #{
             \markup \has \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "x")
          #{
             \markup \has \crossout #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "xd")
          #{
             \markup \has \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( (equal? lRS "dx")
          #{
             \markup \has \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
        ( else
          #{
             \markup \has #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFSl #lFSr #lnu
          #}
        )
      )
    )
   )
 )


#(define-markup-command (expZoomRow layout props AL)
  (list?)
  (let*
    ( (lBN (assign BNoteKey AL BNoteDValue))
      (laN (assign aNoteKey AL aNoteDValue))
      (lbN (assign bNoteKey AL bNoteDValue))
      (lcN (assign cNoteKey AL cNoteDValue))
      (ldN (assign dNoteKey AL dNoteDValue))
      (leN (assign eNoteKey AL eNoteDValue))
      (lnu (assign nuKey AL nuDValue ))
    )
  
    (interpret-markup layout props
     #{
         \markup \has " " "" #lBN #laN #lbN #lcN #ldN #leN "" "" "" #lnu
     #}
    )
   )
 )


#(define-markup-command (closeImZoomRow layout props AL)
  (list?)
  (let*
    ( (lBN (assign BNoteKey AL BNoteDValue))
      (laN (assign aNoteKey AL aNoteDValue))
      (lbN (assign bNoteKey AL bNoteDValue))
      (lcN (assign cNoteKey AL cNoteDValue))
      (ldN (assign dNoteKey AL dNoteDValue))
      (leN (assign eNoteKey AL eNoteDValue))
      (lFSr (assign fsKeyR AL fsDValue))
      (lnu (assign nuKey AL nuDValue ))
    )
    (set! lFSr (string-append imInfix ")" lFSr) )
    (interpret-markup layout props
      #{ \markup \has " " "" #lBN  #laN #lbN #lcN #ldN #leN "" "" #lFSr #lnu #}
    )
   )
 )
% -----------------------------------------------------------------------------
% Harmonyli Interface No 3: Some often used RFS (= instantiation of level 2)
% ------------------------------------------------------------------------------

#(define-markup-command (FHAS layout props rs)
  (markup?)
  (interpret-markup layout props
    #{ \markup \setHas #rs #'() #}
   )
 )


#(define-markup-command (FHASth layout props rs)
  (markup?)
  (interpret-markup layout props
    #{ \markup \setHas #rs #'(("B"."3") ) #}
   )
 ) 
 

#(define-markup-command (Dsept layout props)
  ()
  (interpret-markup layout props
    #{ \markup \setHas "D" #'(("a"."7") ) #}
   )
 )

#(define-markup-command (Dseptnone layout props)
  ()
  (interpret-markup layout props
    #{ \markup \setHas "D" #'(("a"."7")("b"."9")) #}
   )
 )
 
% ---------------------------------------------------------------
%               Extender lines
% The text parameter "fText" will be placed at the left end of the extender.
% It will only consist of some spaces to move the left end a little forward.
% ---------------------------------------------------------------

fExtend =
#(define-music-function (parser location fText) (string?)
   #{
     \once \override TextSpanner #'direction = #DOWN
     \once \override TextSpanner #'style = #'line
     \once \override TextSpanner #'outside-staff-priority = ##f
     \once \override TextSpanner #'padding = #-0.6 % sets the distance of the line from the lyrics
     \once \override TextSpanner #'bound-details =
     #`((left . ((Y . 0)
                 (padding . 0)
                 (attach-dir . ,LEFT)))
        (left-broken . ((end-on-note . #t)))
        (right . ((Y . 0)
                  (padding . 0)
                  (attach-dir . ,RIGHT))))
     \once \override TextSpanner.bound-details.left.text = $fText
   #})

% ---------------------------------------------------------------
% ----- cross out the letter for "shortened dominants" (where base is omitted):
% ---------------------------------------------------------------

#(define-markup-command (crossout layout props letter)
   (markup?)
   (interpret-markup layout props
     #{
       \markup{
         \concat {
           \override #'(baseline-skip . 0.4)
           \left-column {
             $letter
             \with-dimensions #'(-0.0 . 0.0) #'(0 . 0)
             \translate-scaled #'(-0.3 . 0.3)
             \with-dimensions #'(-0.0 . 0.0) #'(0 . 0)
             \draw-line #'(2.3 . 1.8)
           }
         }
       }
     #}))

#(define-markup-command (numx layout props num)
   (markup?)
   (interpret-markup layout props
     #{
       \markup{
         \concat {
           \override #'(baseline-skip . 0)
           \left-column {
             $num
             \with-dimensions #'(-0.0 . 0.0) #'(0 . 0)
             \translate-scaled #'(-0.1 . 0.1)
             \with-dimensions #'(-0.0 . 0.0) #'(0 . 0)
             \draw-line #'(1.2 . 1.2)
           }
         }
       }
     #}))

% ---------------------------------------------------------------
% ----- double-printed letters for double dominant or double subdominant:
% ---------------------------------------------------------------

#(define-markup-command (double layout props letter)
   (markup?)
   (interpret-markup layout props
     #{
       \markup{
         \concat {
           \override #'(baseline-skip . 0.4)
           \left-column {
             $letter
             \with-dimensions #'(-0.4 . 0.6) #'(0 . 0)
             $letter
           }
         }
       }
     #}))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a proposal for an improved function 'double' which unfortunately
% needs LilyPond 2.19.x
% #(define-markup-command (double layout props letter)
%   (markup?)
%   (interpret-markup layout props
%     #{
%       \markup{
%         \overlay {
%           $letter
%           \translate-scaled #'(0.4 . -0.4)
%           $letter
%         }
%       }
%     #}))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





