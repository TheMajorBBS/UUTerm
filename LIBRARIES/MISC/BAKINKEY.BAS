DECLARE FUNCTION Iinkey$ (Max%, Row%, Col%, fore%)
DEFINT A-Z

'An INKEY$ routine for input. Allows backspace
'MAX is maximum # of characters to be inputted
'ROW and COL is the location to enter text
'FORE is the text color

Max = 5
Row = 14
Col = 25
fore = 3

SCREEN 0
CLS
'LINE (170, 180)-(470, 198), 4, BF
inline$ = Iinkey$(Max, Row, Col, fore)


FUNCTION Iinkey$ (Max%, Row%, Col%, fore)

CONST YES = 1, NO = 0, ENTER = &HD, BS = 8

LOCATE Row%, Col%
COLOR fore
DO
  DO
    K$ = INKEY$
  LOOP UNTIL K$ <> ""

  IF LEN(K$) = 2 THEN
    Extend% = YES
    K% = ASC(RIGHT$(K$, 1))
  ELSE
    Extend% = NO
    K% = ASC(K$)
  END IF
  IF (Extend% = NO) AND (K% = ENTER) THEN
    Iinkey$ = i$
    EXIT FUNCTION
  ELSEIF (Extend% = NO) AND (K% = BS) AND (Le% > 0) AND (CurPos% > 0) THEN
    Work1$ = LEFT$(i$, CurPos% - 1)
    Work2$ = RIGHT$(i$, Le% - CurPos%)
    i$ = Work1$ + Work2$
    CurPos% = CurPos% - 1
    Le% = Le% - 1
    LOCATE Row%, Col%, 1
    PRINT i$ + SPACE$(1);
    LOCATE Row%, Col% + CurPos%
  ELSEIF (Extend% = NO) AND (K% > 31) AND (K% < 127) AND (Le% < Max%) THEN
    Work1$ = LEFT$(i$, CurPos%)
    Work2$ = RIGHT$(i$, Le% - CurPos%)
    i$ = Work1$ + CHR$(K%) + Work2$
    Le% = Le% + 1
    CurPos% = CurPos% + 1
    LOCATE Row%, Col%, 1
    PRINT i$;
    LOCATE Row%, Col% + Le%
  ELSE
    BEEP
  END IF
LOOP
END FUNCTION

