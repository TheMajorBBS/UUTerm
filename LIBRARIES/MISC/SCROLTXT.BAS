DECLARE SUB WinScroll (dir%)

'scrolls an array on the screen

TYPE RegType
  ax    AS INTEGER
  bx    AS INTEGER
  cx    AS INTEGER
  dx    AS INTEGER
  bp    AS INTEGER
  si    AS INTEGER
  di    AS INTEGER
  flags AS INTEGER
  ds    AS INTEGER
  es    AS INTEGER
END TYPE
DIM SHARED InRegs AS RegType, OutRegs AS RegType
DECLARE SUB INTERRUPT (intnum AS INTEGER, InReg AS RegType, OutReg AS RegType)

SCREEN 9
CLS

top = 1: bottom = 19
OPEN "I", 2, "scroll.bas"
DO
  LINE INPUT #2, line$                  'finds size
  cnt = cnt + 1
LOOP UNTIL EOF(2)

IF cnt < 19 THEN size = 19 ELSE size = cnt
REDIM temp$(size)
SEEK #2, 1

FOR x = 1 TO cnt                       'loads array
  LINE INPUT #2, line$
  IF LEN(line$) > 25 THEN line$ = LEFT$(line$, 25)
  temp$(x) = line$
NEXT x
CLOSE #2

LINE (350, 30)-(561, 320), 11, B   'get rid of this for screen 0
ver = 3
FOR offset = 1 TO 19               'prints 19 lines to screen
  ver = ver + 1
  LOCATE ver, 45: PRINT temp$(offset)
NEXT offset
offset = offset - 1

DO                                         'gets key press
  DO
    choice$ = UCASE$(INKEY$)
  LOOP UNTIL choice$ <> ""
 
  IF RIGHT$(choice$, 1) = "P" THEN                       'executes choicd
    offset = bottom + 1
    IF offset <= size THEN
      bottom = bottom + 1: top = top + 1
      WinScroll -1              'up
      LOCATE 22, 45: PRINT temp$(offset)
    ELSE
      BEEP
    END IF
  END IF
 
  IF RIGHT$(choice$, 1) = "H" THEN                     'executes choicd
    offset = top - 1
    IF offset > 0 THEN
      bottom = bottom - 1: top = top - 1
      WinScroll 1                             'down
      LOCATE 4, 45: PRINT temp$(offset)
    ELSE
      BEEP
    END IF
  END IF

LOOP
END

SUB WinScroll (dir%)
 '*** scrolls the contents of a window up or down
 '** move up-(Dir%<0) or down-(Dir%>0)
 offset = 20
 ColW% = 0: ColT% = 0   'color of window and text
 hor% = 44: ver% = 3      'how far in and from top
 ht% = 21: wd% = 27


 InRegs.bx = &H1000 * ColW% + &H100 * ColT%
 InRegs.cx = &H100 * ver% + hor%
 InRegs.dx = InRegs.cx + &H100 * ht% + wd% - &H303


 IF dir% < 0 THEN
  InRegs.ax = &H600 - dir%            '*** Scroll up
 ELSE
  InRegs.ax = &H700 + dir%            '*** Scroll down
 END IF
 CALL INTERRUPT(&H10, InRegs, OutRegs)

 offset = offset - dir%   '*** correct Y-Offset

END SUB

