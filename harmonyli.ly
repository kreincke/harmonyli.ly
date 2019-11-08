% harmonyli.ly :- a library for inserting Functional Harmony Analysis Symbols 
% into musical scores encoded in and created by LilyPOnd
%
% Copyright (c) 2019 Karsten Reincke, Frankfurt, Hans Blum
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definition using the EBNF to formally describe the structure of a
% Functional Harmony Analysis Symbol ( = part of the functional harmony theory)
% 
% FHAS ::= {x},(cRS|RS),{DV} { BN }, { SN }, {AN, {AN, {AN, {AN, {AN}}}}}, {CT} {FS}
%
% cRS ::= RS,DV /* not separated by a blank */
%
%  RS ::= 'T' | 't' | 'S' | 's' | 'SS' | 'D' | 'd' | 'DD' 
%
%  DV ::= 'p' | 'P' | 'g' | 'G' | 
%
%   x ::= 'x' /* cross thought the RS */ 
%
%  BN ::= '1', ... ,'7'
%  SN ::= AN
%  AN ::= '1', ... ,'12'
%  CT ::= 'c', 'cis', ... 'h' | cRS
%
% Note: this is a syntactical definition. There is a semantical restriction
% which cannot easily be expressed by a context free grammar. The condition
% is 'AN1 < AN2 < AN3 < AN4 < AN5'. Therefore we only use the symbol AN
%
% Note: This definition also allows to express some a bit esoteric analyze 
% results like (Double Dominant or Double Sub dominant or Tonika,... relative
% counter relative) without no root tone / note. It depends on the context
% (and the viewpoint of the analyzer), which of them are semantically adequate.  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some implementation details:
% We refer to the parts of a RFS by the following identifiers:
%
%                              5 added note number = e | e5
%                              4 added note number = d | d4
%                              3 added note number = c | c3
% Sopran-Note-Number = S | SN  2 added note number = b | b2
% Riemann-Symbol = RS          1 added note number = a | a1  fillstring = fs | FS
% Bass-Note-Number = B | BN
% 
%
% This harmonyli.ly offers 3 interfaces:
%
% A) The basic method of harmonyli.ly is 'rfs' (riemann functional symbol). It 
% expects all elements of an RFS at a specific position and none of them may be 
% forgotten. If any of elements shall not be used, then the respective argument 
% must contain a "".
%
% Advantage: The analyzer gets the complete freedom to create his own version.
% Disadvantage: He must respect all details for not getting surprising results
% 
% B) The core method of harmonyli.ly is the method 'RFS'. It takes the naked 
% Riemann Symbol (like T, Tp, S, D, ...) and a list of pairs using the values of 
% BNoteKey, SNoteKey, ... as keys and as value any string / markup the user 
% wants to insert into the Riemann Function Symbol
%
% On this level, there exist 4 variants:
%   a) the method RFS - as described above
%   b) the method dRFS :- doubling the root RS symbol
%   c) the method xRFS :- crossing out the root RS symbol
%   d) the method xdRFS :- crossing out the doubled root RS symbol 
%
% Advantage: The analyzer may ignore the key value pairs he do not need.
% Disadvantage: He must know / respect the syntax of an association list
%
% C) Finally harmonyli.ly offers some often used instantiations of RFS
% as prepared functions
%
% Advantage: It is simple to insert such fixed RFS.
% Disadvantage: Not all RFS are delivered as fixed RFS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% About some special features
%
% (1) intermediary dominant and intermediary sections
% -----------------------------------------------
% Sometimes, the musicologist wants to express that in an intermediary section
% all chords function with respect to an intermediary harmonical focus instead
% being described with respect to the basic tone. 
% 
% The most simple example for such an intermediary section is the 'intermediary 
% dominant' (in German: 'Zwischendominante): It is not the dominant of the (
% keynote) tonic, but the dominant of the following chord.

% Moreover, sometimes the chord to which an intermediary section is refered
% does not close the section but is replaced by a functional equivalent. A
% famous example is the 'deceptive cadence' as closure of such an intermediary
% section.

% Hence, sometimes the musicologist does not only want to express that he reads
% a succession of chords as an intermediary section, he also want to explicitly
% name the assumed harmonical focus.

% For that purpose harmonyli.ly offers rows of intermediary chords:
%
% IntermediarySection ::- 'initIntermediaryArea' RFS+ closingRFS
%                 RFS ::- /* see above */
%          closingRFS ::- RFS with special parameter 'Context'
%
%
% (2) ZoomAnalyses
% ----------------
%
% In theoretical harmonical analyses often each analysis symbol refers to one 
% chord. In practical harmoncal analyses the analysis symbols refer to rows of 
% tones which are treated as passing notes.

% But sometimes, the musicologist does not want to ignore some shorter notes.
% Instead of this, he wants to increase the granularity of his symbols by
% integrating such 'detail notes' into his symbol. He wants to zoom into the
% the score.
%
% The most known example is the suspended chord as for example
%   6>5
%   4>3
%  D 
%
% For enabling musicologists to express such details, harmonyli.ly offers
% ZoomAreas. ZoomAreas use one pure Riemann Symbol for all chords, and the
% differences of the cords are described by numbers referring to the base tone
% of the chord
%
% ZoomArea ::- 
%     'initZoomArea' 
%     'setZoomRoot' 
%     'openZoomArea'
%     'setZoomSuccessor'+
%     'closeZoomArea'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ---------------------------------------------------------------------
% Harmonyli Interface No 1: The basic method for inserting all manually
% ---------------------------------------------------------------------

#(define-markup-command (fhas layout props RS SN BN aN bN cN dN eN CT fst)
  (markup? markup? markup? markup? markup? markup? markup? markup? markup? markup?)
  (let* ((lCT (string-append "[" CT "]")))
    (if (equal? CT "")(set! lCT ""))
    (interpret-markup layout props
     #{
       \markup{
         \concat {
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
               \dir-column { $aN  $bN $cN $dN $eN }
             }
           }
           $fst
         }
       }
     #}
 )))
 

#(define-markup-command 
  (flas layout props 
    RSl SNl BNl aNl bNl cNl dNl eNl CTl
    RSr SNr BNr aNr bNr cNr dNr eNr CTr 
  fst)
  ( markup? markup? markup? markup? markup? markup? markup? markup? markup?
    markup? markup? markup? markup? markup? markup? markup? markup? markup?
    markup?
  )

    (interpret-markup layout props
     #{
        \markup{
          \box
          \concat {
            \fhas #RSl #SNl #BNl #aNl #bNl #cNl #dNl #eNl #CTl ""
            " ⇨ "
            \fhas #RSr #SNr #BNr #aNr #bNr #cNr #dNr #eNr #CTr ""
          }      
          $fst 
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
#(define fsKey "f")
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
#(define-markup-command (setFHAS layout props RS AL)
  (markup? list?)
  (let*
    ( (lBN (assign BNoteKey AL BNoteDValue))
      (lSN (assign SNoteKey AL SNoteDValue))
      (laN (assign aNoteKey AL aNoteDValue))
      (lbN (assign bNoteKey AL bNoteDValue))
      (lcN (assign cNoteKey AL cNoteDValue))
      (ldN (assign dNoteKey AL dNoteDValue))
      (leN (assign eNoteKey AL eNoteDValue))
      (lFS (assign fsKey AL fsDValue))
      (lRS (assign RsSpec AL RsSpecDValue ))
      (lCT (assign RsCont AL RsContDValue))
    )
  
    (interpret-markup layout props
      (cond
        ( (equal? lRS "d")
          #{
             \markup \fhas \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFS
          #}
        )
        ( (equal? lRS "x")
          #{
             \markup \fhas \crossout #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFS
          #}
        )
        ( (equal? lRS "xd")
          #{
             \markup \fhas \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFS
          #}
        )
        ( (equal? lRS "dx")
          #{
             \markup \fhas \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFS
          #}
        )
        ( else
          #{
             \markup \fhas #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFS
          #}
        )
      )
    )
   )
 )

% INTERFACE 2.A
% returns the Riemann Function Symbol as markup
#(define-markup-command (setFLAS layout props RSl RSr AL)
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
           
      (lBNr (assign NBNoteKey AL BNoteDValue))
      (lSNr (assign NSNoteKey AL SNoteDValue))
      (laNr (assign NaNoteKey AL aNoteDValue))
      (lbNr (assign NbNoteKey AL bNoteDValue))
      (lcNr (assign NcNoteKey AL cNoteDValue))
      (ldNr (assign NdNoteKey AL dNoteDValue))
      (leNr (assign NeNoteKey AL eNoteDValue))
      (lRSr (assign NRsSpec AL RsSpecDValue ))
      (lCTr (assign NRsCont AL RsContDValue))      
      
      (lFS (assign fsKey AL fsDValue))

    )
  
    (interpret-markup layout props
      (cond
        ;; ---------- combinations with left double
        ( (and (equal? lRSl "d") (equal? lRSr "d"))
          #{
             \markup \flas  
                \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
        ( (and (equal? lRSl "d") (equal? lRSr "x"))
          #{
             \markup \flas  
                \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \crossout #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
         ( (and (equal? lRSl "d") (equal? lRSr "dx"))
          #{
             \markup \flas  
                \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
         ( (and (equal? lRSl "d") (equal? lRSr "xd"))
          #{
             \markup \flas  
                \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
        ( (and (equal? lRSl "d") (equal? lRSr ""))
          #{
             \markup \flas  
                \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
        ;; ---------- combinations with left crossout
        ( (and (equal? lRSl "x") (equal? lRSr "d"))
          #{
             \markup \flas  
                \crossout #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
        ( (and (equal? lRSl "x") (equal? lRSr "x"))
          #{
             \markup \flas  
                \crossout #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \crossout #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
         ( (and (equal? lRSl "x") (equal? lRSr "dx"))
          #{
             \markup \flas  
                \crossout #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
         ( (and (equal? lRSl "x") (equal? lRSr "xd"))
          #{
             \markup \flas  
                \crossout #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
        ( (and (equal? lRSl "x") (equal? lRSr ""))
          #{
             \markup \flas  
                \crossout #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
        ;; ---------- combinations with left crossout double (dx)
        ( (and (equal? lRSl "dx") (equal? lRSr "d"))
          #{
             \markup \flas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
        ( (and (equal? lRSl "dx") (equal? lRSr "x"))
          #{
             \markup \flas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \crossout #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
         ( (and (equal? lRSl "dx") (equal? lRSr "dx"))
          #{
             \markup \flas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
         ( (and (equal? lRSl "dx") (equal? lRSr "xd"))
          #{
             \markup \flas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
        ( (and (equal? lRSl "dx") (equal? lRSr ""))
          #{
             \markup \flas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
        ;; ---------- combinations with left crossout double (xd)
        ( (and (equal? lRSl "xd") (equal? lRSr "d"))
          #{
             \markup \flas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
        ( (and (equal? lRSl "xd") (equal? lRSr "x"))
          #{
             \markup \flas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \crossout #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
         ( (and (equal? lRSl "xd") (equal? lRSr "dx"))
          #{
             \markup \flas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
         ( (and (equal? lRSl "xd") (equal? lRSr "xd"))
          #{
             \markup \flas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
        ( (and (equal? lRSl "xd") (equal? lRSr ""))
          #{
             \markup \flas  
                \crossout \double #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
        ;; ---------- combinations with left pure
        ( (and (equal? lRSl "") (equal? lRSr "d"))
          #{
             \markup \flas  
                #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
        ( (and (equal? lRSl "") (equal? lRSr "x"))
          #{
             \markup \flas  
                #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \crossout #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
         ( (and (equal? lRSl "") (equal? lRSr "dx"))
          #{
             \markup \flas  
                #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )
         ( (and (equal? lRSl "") (equal? lRSr "xd"))
          #{
             \markup \flas  
                #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                \crossout \double #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
          #}
        )

        ( else
          #{
             \markup \flas 
                #RSl #lSNl #lBNl  #laNl #lbNl #lcNl #ldNl #leNl #lCTl 
                #RSr #lSNr #lBNr  #laNr #lbNr #lcNr #ldNr #leNr #lCTr             
                #lFS
         #}
        )
      )
    )
   )
 )

% ------------------------------------------------------------------------------
% Harmonyli Interface No 2.B: Functions to use intermediary areas
% ------------------------------------------------------------------------------

initIMArea = 
  { \set stanza = \markup {\normal-text \magnify #1.1 " ("} }

% returns the Riemann Function Symbol as markup
#(define-markup-command (closeIMArea layout props RS AL)
  (markup? list?)
  (let*
    ( (lBN (assign BNoteKey AL BNoteDValue))
      (lSN (assign SNoteKey AL SNoteDValue))
      (laN (assign aNoteKey AL aNoteDValue))
      (lbN (assign bNoteKey AL bNoteDValue))
      (lcN (assign cNoteKey AL cNoteDValue))
      (ldN (assign dNoteKey AL dNoteDValue))
      (leN (assign eNoteKey AL eNoteDValue))
      (lFS (assign fsKey AL fsDValue))
      (lRS (assign RsSpec AL RsSpecDValue ))
      (lCT (assign RsCont AL RsContDValue))
    )
    (set! lFS (string-append ")" lFS ))
    (interpret-markup layout props
      (cond
        ( (equal? lRS "d")
          #{
             \markup \fhas \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFS
          #}
        )
        ( (equal? lRS "x")
          #{
             \markup \fhas \crossout #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFS
          #}
        )
        ( (equal? lRS "xd")
          #{
             \markup \fhas \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFS
          #}
        )
        ( (equal? lRS "dx")
          #{
             \markup \fhas \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFS
          #}
        )
        ( else
          #{
             \markup \fhas #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFS
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


#(define-markup-command (initZoomRow layout props RS AL)
  (markup? list?)
  (let*
    ( (lBN (assign BNoteKey AL BNoteDValue))
      (lSN (assign SNoteKey AL SNoteDValue))
      (laN (assign aNoteKey AL aNoteDValue))
      (lbN (assign bNoteKey AL bNoteDValue))
      (lcN (assign cNoteKey AL cNoteDValue))
      (ldN (assign dNoteKey AL dNoteDValue))
      (leN (assign eNoteKey AL eNoteDValue))
      (lFS (assign fsKey AL fsDValue))
      (lRS (assign RsSpec AL RsSpecDValue ))
      (lCT (assign RsCont AL RsContDValue))
    )
 
    (interpret-markup layout props
      (cond
        ( (equal? lRS "d")
          #{
             \markup \fhas \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFS
          #}
        )
        ( (equal? lRS "x")
          #{
             \markup \fhas \crossout #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFS
          #}
        )
        ( (equal? lRS "xd")
          #{
             \markup \fhas \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFS
          #}
        )
        ( (equal? lRS "dx")
          #{
             \markup \fhas \crossout \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFS
          #}
        )
        ( else
          #{
             \markup \fhas #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lCT #lFS
          #}
        )
      )
    )
   )
 )

#(define-markup-command (expZoomRow layout props AL)
  (list?)
  (let*
    ( (laN (assign aNoteKey AL aNoteDValue))
      (lbN (assign bNoteKey AL bNoteDValue))
      (lcN (assign cNoteKey AL cNoteDValue))
      (ldN (assign dNoteKey AL dNoteDValue))
      (leN (assign eNoteKey AL eNoteDValue))
      (lFS (assign fsKey AL fsDValue))
    )
 
    (interpret-markup layout props
     #{
         \markup \fhas "" "" "" #laN #lbN #lcN #ldN #leN "" #lFS
     #}
    )
   )
 )



#(define-markup-command (closeIMZoomRow layout props AL)
  (list?)
  (let*
    ( (laN (assign aNoteKey AL aNoteDValue))
      (lbN (assign bNoteKey AL bNoteDValue))
      (lcN (assign cNoteKey AL cNoteDValue))
      (ldN (assign dNoteKey AL dNoteDValue))
      (leN (assign eNoteKey AL eNoteDValue))
      (lFS (assign fsKey AL fsDValue))
    )
    (set! lFS (string-append " )" lFS) )
    (interpret-markup layout props
      #{ \markup \fhas "" "" ""  #laN #lbN #lcN #ldN #leN "" #lFS #}
    )
   )
 )
% -----------------------------------------------------------------------------
% Harmonyli Interface No 3: Some often used RFS (= instantiation of level 2)
% ------------------------------------------------------------------------------

#(define-markup-command (FHAS layout props rs)
  (markup?)
  (interpret-markup layout props
    #{ \markup \setFHAS #rs #'() #}
   )
 )


#(define-markup-command (FHASth layout props rs)
  (markup?)
  (interpret-markup layout props
    #{ \markup \setFHAS #rs #'(("B"."3") ) #}
   )
 ) 
 

#(define-markup-command (Dsept layout props)
  ()
  (interpret-markup layout props
    #{ \markup \setFHAS "D" #'(("a"."7") ) #}
   )
 )

#(define-markup-command (Dseptnone layout props)
  ()
  (interpret-markup layout props
    #{ \markup \setFHAS "D" #'(("a"."7")("b"."9")) #}
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

% ---------------------------------------------------------------
% opening round bracket before a chord:
% ---------------------------------------------------------------

openbracket = { \set stanza = \markup {\normal-text \magnify #1.1 " ("} }



