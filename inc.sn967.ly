% http://lsr.di.unimi.it/LSR/Item?id=967
% http://lists.gnu.org/archive/html/lilypond-user/2014-12/msg00123.html
% http://www.mail-archive.com/lilypond-user%40gnu.org/msg60732.html
% Contributed by Klaus Blum

\version "2.18.2"

% ---------------------------------------------------------------
%               The "central" function
% Usage:
% FunctionLetter SopranoNote BassNote OptA OptB OptC OptD OptE FillStr
% ---------------------------------------------------------------

#(define-markup-command (fSymbol layout props FunctionLetter SopranoNote BassNote OptA OptB OptC OptD OptE FillStr)
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





