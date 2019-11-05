% http://lsr.di.unimi.it/LSR/Item?id=967
% http://lists.gnu.org/archive/html/lilypond-user/2014-12/msg00123.html
% http://www.mail-archive.com/lilypond-user%40gnu.org/msg60732.html
% Contributed by Klaus Blum

\version "2.18.2"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definition using the EBNF to formally describe the structure of a
% Riemann Functional Symbol ( = part of the functional harmony theory)
% 
% RFS ::= {x},(cRS|RS),{DV} { BN }, { SN }, {AN, {AN, {AN, {AN, {AN}}}}}, {FS}
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
%                                 5 added note number = e | e5
%                                 4 added note number = d | d4
%                                 3 added note number = c | c3
% Sopran-Note-Number = S | SN     2 added note number = b | b2
% Riemann-Symbol = RS             1 added note number = a | a1  fillstring = fs | FS
% Bass-Note-Number = B | BN
% 
%
% This harmonyli offers 3 interfaces:
%
% A) The basic method is the lisp function 'rfs'. It expects all elements of
% an RFS at a specific position and none of them may be forgotten. If any of 
% the optional elements shall not be used, then the corresponding argument 
% must contain a "".
%
% Advantage: The analyzer gets the complete freedom to create his own version.
% Disadvantage: He must respect all details for not getting surprising results
% 
% B) The core method is the lisp function 'RFS'. It takes the naked
% Riemann Symbol (like T, Tp, S, D, ...) and a list of pairs using
% the  globally defined BNoteKey, SNoteKey, ... as keys and any value
% string / markup the user wanted to insert into the Riemann Function Symbol
%
%   There exist 4 variants:
%   a) the method RFS - as describe above
%   b) the method dRFS :- doubling the root RS symbol
%   c) the method xRFS :- crossing out the root RS symbol
%   d) the method xdRFS :- crossing out the douled root RS symbol 
%
% Advantage: The analyzer may ignore the key value pairs he do not need.
% Disadvantage: He must know / respect the syntax of an association list
%
% c) Some instantiations of RFS which define often used RFS
%
% Advantage: It is simple to insert such fixed RFS.
% Disadvantage: Not all RFS are delivered as fixed RFS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ---------------------------------------------------------------------
% Harmonyli Interface No 1: The basic method for inserting all manually
% ---------------------------------------------------------------------

#(define-markup-command (rsf layout props FunctionLetter SopranoNote BassNote OptA OptB OptC OptD OptE FillStr)
   (markup? markup? markup? markup? markup? markup? markup? markup? markup?)
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
               $FunctionLetter
               \tiny
               \halign #CENTER
               $SopranoNote
             }
             \tiny
             $BassNote
           }
           \tiny
           \override #`(direction . ,UP)
           \override #'(baseline-skip . 0.8)
           \dir-column {
             " "
             {
               \override #`(direction . ,UP)
               \override #'(baseline-skip . 1.3)
               \dir-column { $OptA  $OptB $OptC $OptD $OptE }
             }
           }
           $FillStr
         }
       }
     #}))

  
% ------------------------------------------------------------------------------
% Harmonyli Interface No 2: The core method for inserting only the needed values
% ------------------------------------------------------------------------------

#(define BNoteKey "B")
#(define SNoteKey "S")
#(define aNoteKey "a")
#(define bNoteKey "b")
#(define cNoteKey "c")
#(define dNoteKey "d")
#(define eNoteKey "e")
#(define fsKey "f")

#(define BNoteDValue "")
#(define SNoteDValue "")
#(define aNoteDValue "")
#(define bNoteDValue "")
#(define cNoteDValue "")
#(define dNoteDValue "")
#(define eNoteDValue "")
#(define fsDValue "")

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
% INTERFACE 2.A --------------------------------
% returns the Riemann Function Symbol as markup
#(define-markup-command (RSF layout props RS AL)
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
    )

    (interpret-markup layout props
      #{
        \markup \rsf #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lFS
      #}
    )
   )
 )
% INTERFACE 2.B --------------------------------
% returns the Riemann Function Symbol with a crossed out root element as markup
#(define-markup-command (xRSF layout props RS AL)
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
    )

    (interpret-markup layout props
      #{
        \markup \rsf \crossout #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lFS
      #}
    )
   )
 )
% INTERFACE 2.C --------------------------------  
% returns the Riemann Function Symbol with a doubled root element as markup
#(define-markup-command (dRSF layout props RS AL)
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
    )

    (interpret-markup layout props
      #{
        \markup \rsf \double #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lFS
      #}
    )
   )
 )
% INTERFACE 2.D --------------------------------
% returns the Riemann Function Symbol with a doubled root element as markup
#(define-markup-command (dRSF layout props RS AL)
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
    )

    (interpret-markup layout props
      #{
        \markup \rsf \double \crossout #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lFS
      #}
    )
   )
 )


% INTERFACE 2.E --------------------------------
% returns the Riemann Function Symbol as markup
#(define-markup-command (iRSF layout props RS AL)
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
    )

    (interpret-markup layout props
      #{
         \markup \rsf #RS #lSN #lBN  #laN #lbN #lcN #ldN #leN #lFS
      #}
    )
   )
 )

% ----------------------------------------------------------------------------------
% Harmonyli Interface No 3: Some often used RFS defined as instantiation of method 2
% ----------------------------------------------------------------------------------

#(define-markup-command (RS layout props rs fs)
  (markup? string?)
  (interpret-markup layout props
    #{ \markup \RSF #rs #'(("f" . "???")) #}
   )
 )


#(define-markup-command (T layout props)
  ()
  (interpret-markup layout props
    #{ \markup \RSF "T" #'() #}
   )
 )

#(define-markup-command (Tthird layout props)
  ()
  (interpret-markup layout props
    #{ \markup \RSF "T" #'(("B"."3")("f" . "  ") ) #}
   )
 )

#(define-markup-command (t layout props)
  ()
  (interpret-markup layout props
    #{ \markup \RSF "t" #'() #}
   )
 )
 
 #(define-markup-command (tthird layout props)
  ()
  (interpret-markup layout props
    #{ \markup \RSF "t" #'(("B"."3")("f" . "  ") ) #}
   )
 )
 
#(define-markup-command (S layout props)
  ()
  (interpret-markup layout props
    #{ \markup \RSF "S" #'() #}
   )
 )

#(define-markup-command (Sthird layout props)
  ()
  (interpret-markup layout props
    #{ \markup \RSF "S" #'(("B"."3")("f" . "  ") ) #}
   )
 ) 
 
#(define-markup-command (s layout props)
  ()
  (interpret-markup layout props
    #{ \markup \RSF "s" #'() #}
   )
 )

#(define-markup-command (sthid layout props)
  ()
  (interpret-markup layout props
    #{ \markup \RSF "s" #'(("B"."3")("f" . "  ") ) #}
   )
 ) 
 
#(define-markup-command (D layout props)
  ()
  (interpret-markup layout props
    #{ \markup \RSF "D" #'() #}
   )
 ) 

#(define-markup-command (Dthird layout props)
  ()
  (interpret-markup layout props
    #{ \markup \RSF "D" #'(("B"."3")("f" . "  ") ) #}
   )
 )  
 
#(define-markup-command (d layout props)
  ()
  (interpret-markup layout props
    #{ \markup \RSF "d" #'() #}
   )
 ) 

#(define-markup-command (dthird layout props)
  ()
  (interpret-markup layout props
    #{ \markup \RSF "d" #'(("B"."3")("f" . "  ") ) #}
   )
 ) 

#(define-markup-command (Dsept layout props)
  ()
  (interpret-markup layout props
    #{ \markup \RSF "D" #'(("a"."7")("f" . "  ") ) #}
   )
 )

#(define-markup-command (Dseptnone layout props)
  ()
  (interpret-markup layout props
    #{ \markup \RSF "D" #'(("a"."7")("b"."9")("f" . "  ") ) #}
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



