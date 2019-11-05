\version "2.18.2"

% A pure scheme / guile solution to define a LilyPond markup
% command with a variable list of arguments by using a
% technique of lisp scheme / guile called association lists 
% (demoed by using the box example from the extend tutorial). 

% The target is, that the users of the function may insert 
% the arguments they really need (without having to deal with 
% those, they do not need) and that they may insert the arguments
% they want to use in the order they prefer 

% feel free to adopt this example under the following terms:

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
 
% 1) we should define the keys, we want to use 
% (they must be communicated to the users of our function

#(define ka "k1")
#(define kb "k2")
#(define kc "k3")
#(define kd "k4")
#(define ke "k5")


% 2)  we should define the respective default values
#(define dva "blank") % a filled string
#(define dvb "") % an empty string
#(define dvc '()) % a null value
#(define dvd "blank") % a filled string 
#(define dve "") % an empty string 

% 3) we need a function - let us name it "assign" 
% (you will understand in a short time, why) - which takes 
% a key, an association list (alist) and a default value. 
% If the alist contains any pair with the same key, 
% then function shall return the corresponding value, 
% otherwise the given default value

#(define (assign keyValue assocList defaultValue)
  (string? list? string?)
  (let* ((localPair (assoc keyValue assocList)))
    (if localPair (cdr localPair) defaultValue)
  )
)

% Based on this pre-work, we can now define a markup function
% with a flexible variable parameter list: 
% a) At the beginning we define the local parameter variables 
% and let them be instantiated by our assign function. 
% b) Then we manipulate the given values in any way. 
% c) And finally we return - as a markup 'object' - 
% a box containing the result of our manipulation:


#(define-markup-command (mybox layout props AL)
  (list?)
  (let*
    ( (la (assign ka AL dva))
      (lb (assign kb AL dvb))
      (lc (assign kc AL dvc))
      (ld (assign kd AL dvd))
      (le (assign ke AL dve))
      (lresult "result")
    )
    ;  because we used an empty list (nil) as default value
    (if (eq? lc '()) (set! lc ""))
    ; our 'manupilation' is a concatenation ;-)
    (set! lresult (string-append la lb lc ld le))

    (interpret-markup layout props
      #{
        \markup \box { #lresult }
      #}
    )
   )
 )  
    
\markup \mybox #'(("k5" . "V5")("k1" . "V1"))