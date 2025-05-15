'This is the same Emulator found as ANSIEMUL.BAS, but I've modified it for
'graphic modes. And is the same as in my programs.

DEFINT A-Z
SUB emul (st$) STATIC
IF LEN(st$) > 2 THEN
  z = INSTR(st$, crlf$)
  st$ = MID$(st$, z + 1)
END IF
FOR disp0% = 1 TO LEN(st$)
  ch0$ = MID$(st$, disp0%, 1)
  IF ANSIcode0% THEN
    IF LEFT$(ANSIst0$, 2) = "[M" OR LEFT$(ANSIst0$, 2) = "[m" THEN
      IF ASC(ch0$) = 14 THEN
        ANSIst0$ = ""
        ANSIcode0% = 0
      ELSE
        ANSIst0$ = ANSIst0$ + ch0$
      END IF
    ELSEIF INSTR("ABCDEFGHIJKLMNOPQRSTUVWXYZ", UCASE$(ch0$)) THEN
         SELECT CASE ch0$
            CASE "A": GOSUB CursorUp0
            CASE "B": GOSUB CursorDown0
            CASE "C": GOSUB CursorRight0
            CASE "D": GOSUB CursorLeft0
            CASE "H", "f": GOSUB CursorLocate0
            CASE "s": GOSUB SaveCursorPosn0
            CASE "u": GOSUB RestCursorPosn0
            CASE "J": GOSUB BigErase0
            CASE "K": GOSUB SmallErase0
            CASE "h", "l": REM  set display mode... ignored
            CASE "m": GOSUB SetColors0
            CASE ELSE
               PRINT ANSIst0$;
               ANSIcode0% = 0: ANSIst0$ = ""
         END SELECT
         ANSIst0$ = ""
         ANSIcode0% = 0
      ELSEIF ASC(ch0$) <= 32 OR LEN(ANSIst0$) > 60 THEN   'special chr
         ANSIcode0% = 0: ANSIst0$ = ""
      ELSE
         ANSIst0$ = ANSIst0$ + ch0$
      END IF
   ELSEIF ASC(ch0$) = 27 THEN       'turn on ansi characters
      ANSIcode0% = -1
      ANSIst0$ = ""
   ELSE
     first = 0
     IF ch0$ = CHR$(10) THEN                    'end of line
       PRINT ch0$;
       'check the line for any string of text you may want to be notified of
       'alertchek
       'if user has opened a capture file then print line to disk
       'IF log$ = "ON" THEN PRINT #6, line$
       'also update your scrollback buffer here
       'updateSBack scrollcnt, scrollback$(), line$
       col = POS(0): row = CSRLIN
       IF row% > maxline THEN    'maxline is if you want 24 or 43 line display
         ScrnScroll 1, 1, maxline, 80, 1, 0
         IF maxline = 24 THEN x = 184 ELSE x = 312
         LOCATE maxline, 1
       END IF
       line$ = ""
     ELSEIF ch0$ <> CHR$(13) THEN '     if not end of line
       'print the character to screen. I use a graphic routine here for that
       doprint ch0$, line$, fore0, back0, crai, row%, col  'print to screen
       LOCATE row, col%
     END IF
   END IF
NEXT
EXIT SUB
'
CursorUp0:
Tmp0% = VAL(MID$(ANSIst0$, 2))
IF Tmp0% < 1 THEN Tmp0% = 1
row0% = CSRLIN: col0% = POS(0)
row0% = row0% - Tmp0%
IF row0% < 1 THEN row0% = 1
LOCATE row0%, col0%
RETURN
'
CursorDown0:
Tmp0% = VAL(MID$(ANSIst0$, 2))
IF Tmp0% < 1 THEN Tmp0% = 1
row0% = CSRLIN: col0% = POS(0)
row0% = row0% + Tmp0%
IF row0% > 25 THEN row0% = 25
LOCATE row0%, col0%
RETURN
'
CursorLeft0:
Tmp0% = VAL(MID$(ANSIst0$, 2))
IF Tmp0% < 1 THEN Tmp0% = 1
row0% = CSRLIN: col0% = POS(0)
col0% = col0% - Tmp0%
IF col0% < 1 THEN col0% = 1
LOCATE row0%, col0%
RETURN
'
CursorRight0:
Tmp0% = VAL(MID$(ANSIst0$, 2))
IF Tmp0% < 1 THEN Tmp0% = 1
row0% = CSRLIN: col0% = POS(0)
col0% = col0% + Tmp0%
IF col0% > 80 THEN col0% = 80
LOCATE row0%, col0%
RETURN
'
CursorLocate0:
row0% = VAL(MID$(ANSIst0$, 2))
Tmp0% = INSTR(ANSIst0$, ";")
IF Tmp0% THEN
   col0% = VAL(MID$(ANSIst0$, Tmp0% + 1))
ELSE
   col0% = 1
END IF
IF row0% < 1 THEN
   row0% = 1
ELSEIF row0% > 25 THEN
   row0% = 25
END IF
IF col0% < 1 THEN
   col0% = 1
ELSEIF col0% > 80 THEN
   col0% = 80
END IF
LOCATE row0%, col0%
RETURN
'
SaveCursorPosn0:
SaveRow0% = CSRLIN: SaveCol0% = POS(0)
RETURN
'
RestCursorPosn0:
IF SaveRow0% > 0 THEN
  LOCATE SaveRow0%, SaveCol0%
END IF
RETURN
'
BigErase0:
IF maxline = 24 THEN x = 200 ELSE x = 330
LINE (0, 0)-(639, x), 0, BF
LOCATE 1, 1
RETURN
'
SmallErase0:
row0% = CSRLIN: col0% = POS(0)
ver% = row0% * 8 - 8
remain = 80 - col0%
FOR x = 1 TO remain + 1
  hor% = col0% * 8 - 8
  'this is a 3rd party library that prints a character to the screen
  'you'll have to put your own routine here for doing this
  nz = DRAWSTR%(0, " ", hor%, ver%, fore0%, back0%, 8)
  col0% = col0% + 1
NEXT
IF col0% > 80 THEN col0% = 80
LOCATE row0%, col0%
RETURN
'
SetColors0:
ANSIst0$ = MID$(ANSIst0$, 2)
DO WHILE LEN(ANSIst0$)
  Tmp0% = VAL(ANSIst0$)
  SELECT CASE Tmp0%
    CASE 0: fore0% = 7: back0% = 0             ' reset colors
    CASE 1: fore0% = (fore0% OR 8)             ' high intensity
    CASE 2: fore0% = (fore0% AND &H17)         ' normal intensity
    CASE 5: fore0% = (fore0% OR 16)            ' blink
    CASE 7: fore0% = 0: back0% = 7             ' reverse video
    CASE 8: fore0% = 0: back0% = 0            ' invisible
    CASE 30: fore0% = (fore0% AND &H18)        ' black foreground
    CASE 31: fore0% = (fore0% AND &H18) OR 4   ' red foreground
    CASE 32: fore0% = (fore0% AND &H18) OR 2   ' green foreground
    CASE 33: fore0% = (fore0% AND &H18) OR 6   ' yellow foreground
    CASE 34: fore0% = (fore0% AND &H18) OR 1   ' blue foreground
    CASE 35: fore0% = (fore0% AND &H18) OR 5   ' magenta foreground
    CASE 36: fore0% = (fore0% AND &H18) OR 3   ' cyan foreground
    CASE 37: fore0% = (fore0% OR 7)            ' white foreground
    CASE 40: back0% = 0                        ' black background
    CASE 41: back0% = 4                        ' red background
    CASE 42: back0% = 2                        ' green background
    CASE 43: back0% = 6                        ' yellow background
    CASE 44: back0% = 1                        ' blue background
    CASE 45: back0% = 5                        ' magenta background
    CASE 46: back0% = 3                        ' cyan background
    CASE 47: back0% = 7                        ' white background
    CASE ELSE                                  ' ignore anything weird
  END SELECT
  Tmp0% = INSTR(ANSIst0$, ";")
  IF Tmp0% THEN
    ANSIst0$ = MID$(ANSIst0$, Tmp0% + 1)
  ELSE
    ANSIst0$ = ""
  END IF
LOOP
RETURN
END SUB


END SUB

