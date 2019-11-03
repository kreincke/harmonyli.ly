% harmonyli.ly = library for creating musicological harmony analysis symbols
% following the concept of the LaTeX package harmony.
%
% Copyright 2019 Karsten Reincke
%
% licensed under the MIT license
%
% Permission is hereby granted, free of charge, to any person obtaining a copy 
% of this software and associated documentation files (the "Software"), to deal 
% in the Software without restriction, including without limitation the rights 
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
% copies of the Software, and to permit persons to whom the Software is 
% furnished to do so, subject to the following conditions:

% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.

% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
% PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
% COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
% IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
% CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

\version "2.18.2"

#(define BLNK " " )

% insert pure functional harmony analysis symbols like 
% T, S, D, Tp, Sp, Tg, and so on
#(define-markup-command 
  (hf layout props FS ) (markup?  )
  "insert a harmony analysis symbol + ( 0 bass & 0 descant specifier(s))"
  (interpret-markup layout props
    #{\markup 
      \line {
        \override #'(baseline-skip . 1.4) {
          \center-column{       
            \line{ #FS }
            \line{ \typewriter \fontsize #-5 \BLNK }
        } }  
        \super{
          \override #'(baseline-skip . 1.5) {
            \fontsize #-4 \typewriter
            \translate #'(-2 . 1)
            \column { \BLNK \BLNK \BLNK }
        } }      
      }       
    #}
  )
)

% insert the functional harmony analysis symbol added by 
% one on top number like:
% ------
% |  7 | 
% | D  |
% ------
#(define-markup-command 
  (hfOne layout props FS  Mid) (markup? markup? )
  "insert a harmony analysis symbol + ( 0 bass & 1 descant specifier(s))"
  (interpret-markup layout props
    #{\markup 
       \line {
        \override #'(baseline-skip . 1.4) {
          \center-column{       
            \line{ #FS }
            \line{ \typewriter \fontsize #-5 \BLNK }
        } }  
        \super{
          \override #'(baseline-skip . 1.5) {
            \fontsize #-4 \typewriter
            \translate #'(-2 . 1)
            \column { \BLNK #Mid \BLNK }
        } }      
      }       
    #}
  )
)

% insert the functional harmony analysis symbol added by 
% two on top numbers like:
% ------
% |  9 |
% |  7 | 
% | D  |
% ------
#(define-markup-command 
  (hfTwo layout props FS Mid Top) (markup? markup? markup? )
  "insert a harmony analysis symbol + ( 0 bass & 2 descant specifier(s))"
  (interpret-markup layout props
    #{\markup 
       \line {
        \override #'(baseline-skip . 1.4) {
          \center-column{       
            \line{ #FS }
            \line{ \typewriter \fontsize #-5 \BLNK }
        } }  
        \super{
          \override #'(baseline-skip . 1.5) {
            \fontsize #-4 \typewriter
            \translate #'(-2 . 1)
            \column { #Top #Mid \BLNK }
        } }      
      }       
    #}
  )
)

% insert the functional harmony analysis symbol added by 
% three on top numbers like:
% ------
% |  9 |
% |  7 |
% |  5 | 
% | D  |
% -------
#(define-markup-command 
  (hfTri layout props FS Bot Mid Top) (markup? markup? markup? markup? )
  "insert a harmony analysis symbol + ( 0 bass & 3 descant specifier(s))"
  (interpret-markup layout props
    #{\markup 
      \line {
        \override #'(baseline-skip . 1.4) {
          \center-column{       
            \line{ #FS }
            \line{ \typewriter \fontsize #-5 \BLNK }
        } }  
        \super{
          \override #'(baseline-skip . 1.5) {
            \fontsize #-4 \typewriter
            \translate #'(-2 . 1)
            \column { #Top #Mid #Bot }
        } }      
      }       
    #}
  )
)

% insert the functional harmony analysis symbol added by 
% a bass specification like 
% ----- 
% | D |
% | 3 |
% -----

#(define-markup-command 
  (hfi layout props FS Sub) (markup? markup?  )
  "insert a harmony analysis symbol + ( 1 bass &  0 descant specifier(s))"
  (interpret-markup layout props
    #{\markup 
      \line {
        \override #'(baseline-skip . 1.4) {
          \center-column{       
            \line{ #FS }
            \line{ \typewriter \fontsize #-5 #Sub }
        } }  
        \super{
          \override #'(baseline-skip . 1.5) {
            \fontsize #-4 \typewriter
            \translate #'(-2 . 1)
            \column { \BLNK \BLNK \BLNK }
        } }      
      }       
    #}
  )
)

% insert the functional harmony analysis symbol added by 
% a bass specification and one top number like:
% ------
% |  7 | 
% | D  |
% | 3  |
% ------
#(define-markup-command 
  (hfiOne layout props FS Sub Mid) (markup? markup? markup? )
  "insert a harmony analysis symbol + ( 1 bass &  1 descant specifier(s))"
  (interpret-markup layout props
    #{\markup 
       \line {
        \override #'(baseline-skip . 1.4) {
          \center-column{       
            \line{ #FS }
            \line{ \typewriter \fontsize #-5 #Sub }
        } }  
        \super{
          \override #'(baseline-skip . 1.5) {
            \fontsize #-4 \typewriter
            \translate #'(-2 . 1)
            \column { \BLNK #Mid \BLNK }
        } }      
      }       
    #}
  )
)

% insert the functional harmony analysis symbol added by 
% a bass specification and two top numbers like:
% ------
% |  9 |
% |  7 | 
% | D  |
% | 3  |
% ------
#(define-markup-command 
  (hfiTwo layout props FS Sub Mid Top) (markup? markup? markup? markup? )
  "insert a harmony analysis symbol + ( 1 bass &  2 descant specifier(s))"
  (interpret-markup layout props
    #{\markup 
       \line {
        \override #'(baseline-skip . 1.4) {
          \center-column{       
            \line{ #FS }
            \line{\typewriter \fontsize #-5 #Sub }
        } }  
        \super{
           \override #'(baseline-skip . 1.5) {
            \fontsize #-4 \typewriter
            \translate #'(-2 . 1)
            \column { #Top #Mid \BLNK }
        } }      
      }       
    #}
  )
)

% insert the functional harmony analysis symbol added by 
% a bass specification and three top numbers like:
% ------
% |  9 |
% |  7 |
% |  5 | 
% | D  |
% | 3  |
% ------

#(define-markup-command 
  (hfiTri layout props FS Sub Bot Mid Top) (markup? markup? markup? markup? markup? )
  "insert a harmony analysis symbol + ( 1 bass &  3 descant specifier(s))"
  (interpret-markup layout props
    #{\markup 
      \line {
        \override #'(baseline-skip . 1.4) {
          \center-column{       
            \line{ #FS }
            \line{ \typewriter \fontsize #-5 #Sub }
        } }  
        \super{
           \override #'(baseline-skip . 1.5) {
            \fontsize #-4 \typewriter
            \translate #'(-2 . 1)
            \column { #Top #Mid #Bot }
        } }      
      }       
    #}
  )
) 
