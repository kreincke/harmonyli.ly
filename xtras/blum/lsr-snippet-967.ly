% http://lsr.di.unimi.it/LSR/Item?id=967
% http://lists.gnu.org/archive/html/lilypond-user/2014-12/msg00123.html
% http://www.mail-archive.com/lilypond-user%40gnu.org/msg60732.html
% Contributed by Klaus Blum

\paper {
  indent = 0
  ragged-right = ##f
}

\header {
  tagline = ##f
}

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

% ---------------------------------------------------------------
% ----- Voices: soprano, alto, tenor
% ---------------------------------------------------------------

global  = { \key c \major  \time 4/4}

sopranmel = \relative c'' {
  \clef treble
  \stemUp
  \global
  e4 e e( d)
  c4 d d2
  d4 e8 d c4 c
  d8( c) <b g>4 c2\fermata

}

altmel = \relative c'' {
  \clef treble
  \stemDown
  \global
  c4 bes a2
  a4 c c( b)
  b2 g4 a
  a4 \hideNotes g8 s \unHideNotes g2
}

tenormel = \relative c' {
  \clef treble
  \stemDown
  \global
  g'4 g f2
  d4 a' a( g)
  e2 e4 f
  d4 d8( f) e2
}



% ---------------------------------------------------------------
% ----- hidden bass voice (not to be displayed, only
% ----- for aligning the lyrics via "lyricsto"
% ---------------------------------------------------------------

bassmelhidden =
\relative c {
  \clef bass
  \stemDown
  \global
  \override NoteHead.color = #red
  \override NoteColumn #'ignore-collision = ##t
  f,4 cis'4 d d
  f4 fis4 g g
  gis4 gis8 gis bes4 a8 g
  fis8 fis g8 g c,2
}

% ---------------------------------------------------------------
% ----- bass voice to be displayed
% ---------------------------------------------------------------

bassmelshown = \relative c {
  \clef bass
  \stemNeutral
  \global
  %    \hideNotes
  c4 cis4 d2
  f4 fis4 g2
  gis2 bes4 a8 g
  fis4 g4 c,2
}

% ---------------------------------------------------------------
% ----- "lyrics": Symbols for functional harmony
% ---------------------------------------------------------------

lyr = \lyricmode {
  \override LyricText.self-alignment-X = #LEFT
  \override LyricExtender.left-padding = #-0.5
  \override LyricExtender.extra-offset = #'(0 . 0.5)

  % Usage:
  %
  % FunctionLetter SopranoNote BassNote OptA OptB OptC OptD OptE FillStr

  \set stanza = #"C-Dur:"
  \markup \fSymbol "T" "3" ""  "" "" "" "" ""   ""
  \openbracket
  \markup \fSymbol \crossout "D" "" "3"  "7" "9>" "" "" ""   ")"
  \fExtend "     " % call this function BEFORE the lyric event
  \markup \fSymbol "Sp" "" ""  "9" "" "" "" ""   ""
  \startTextSpan  % call \startTextSpan AFTER the lyric event
  \markup \fSymbol "" "" ""  "8" "" "" "" ""   ""
  \stopTextSpan
  \markup \fSymbol "S" "" ""  "5" "6" "" "" ""   ""
  \openbracket
  \markup \fSymbol "D" "" "3"  "7" "" "" "" ""   " )"
  \fExtend "   "
  \markup \fSymbol "D" "" ""  "2" "4" "" "" ""   ""
  \startTextSpan
  \markup \fSymbol "" "" ""  "1" "3" "" "" ""   ""
  \stopTextSpan
  \openbracket
  \fExtend "   "
  \markup \fSymbol "D" "" "3"  "7" "" "" "" ""   ""
  \startTextSpan
  \markup \fSymbol "" "" ""  "8" "" "" "" ""   ""
  \markup \fSymbol "" "" ""  "7" "" "" "" ""   " )[Tp]"
  \stopTextSpan
  \openbracket
  \markup \fSymbol "D" "" "7"  "" "" "" "" ""   ")"
  \fExtend "   "
  \markup \fSymbol "S" "" "3"  "" "" "" "" ""   ""
  \startTextSpan
  \markup \fSymbol " " "" "2"  "" "" "" "" ""   ""
  \stopTextSpan
  \fExtend "    "
  \markup \fSymbol \double "D" "" "3"  "8" "" "" "" ""   ""
  \startTextSpan
  \markup \fSymbol "" "" ""  "7" "" "" "" ""   ""
  \stopTextSpan
  \fExtend "   "
  \markup \fSymbol "D" "" ""  "5" "" "" "" ""   ""
  \startTextSpan
  \markup \fSymbol "" "" ""  "7" "" "" "" ""   ""
  \stopTextSpan
  \markup \fSymbol "T" "" ""  "" "" "" "" ""   ""
}


\score {
  \new GrandStaff <<
    \new Staff = upper
    \with { printPartCombineTexts = ##f }
    {
      <<
        \sopranmel \\
        \partcombine \altmel \tenormel
      >>
    }
    \new Staff = lower
    \new Voice = "bassstimmeSichtbar"
    \with { printPartCombineTexts = ##f }
    {
      <<
        \bassmelshown
        % change "NullVoice" to "Voice" to make the hidden bass voice visible:
        \new NullVoice = "bassstimme" {\shiftOff  \bassmelhidden}
        \new Lyrics \lyricsto "bassstimme" \lyr
      >>
    }
  >>
  \layout {
    \context {
      \Lyrics
      \consists "Text_spanner_engraver"
    }
  }
}

\markup \vspace #2

\score {
  \relative c' { c1 c c2 c c c c c }
  \addlyrics {
    \override LyricText.self-alignment-X = #LEFT
    \set stanza = #"Usage:"
    \markup \fSymbol "F" "2" "3"  "4" "5" "6" "7" "8"   "9"
    \markup \fSymbol "Function" "Soprano" "Bass"  "OptA" "OptB" "OptC" "OptD" "OptE"   "FillStr       "
    \override LyricText.self-alignment-X = #CENTER
    \markup \fSymbol "S" "" ""  "" "" "" "" ""   ""
    \markup \fSymbol "D" "" ""  "" "" "" "" ""   ""
    \markup \fSymbol \double S "  \double S  " ""  "" "" "" "" ""   ""
    \markup \fSymbol \double "D" "  \double D  " ""  "" "" "" "" ""   ""
    \markup \fSymbol \crossout "D" "  \crossout D  " ""  "" "" "" "" ""   ""
    \markup \fSymbol \crossout \double "D" "  \crossout\double D  " ""  "" "" "" "" ""   ""
  }
}