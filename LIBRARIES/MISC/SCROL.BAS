DECLARE SUB ScrnScroll (ULRow%, ULColumn%, LRRow%, LRColumn%, NumOfLines%)
'scrolls what's on the screen
'len weaver
DEFINT A-Z
'$INCLUDE: 'Qb.Bi'
'ULRow%, ULColumn%, LRRow%, LRColumn%, NumOfLines%

SCREEN 9
WIDTH 80, 43
OPEN "con" FOR OUTPUT AS #1

v = 205
LINE (0, v)-(639, v), 14
FOR x = 1 TO 129
  PRINT #1, x
  IF x > 25 THEN ScrnScroll 1, 1, 25, 80, 1
NEXT

SUB ScrnScroll (ULRow%, ULColumn%, LRRow%, LRColumn%, NumOfLines%)
' =========================================================
'                         ScrnScroll
' =========================================================
DIM Regs AS RegType
DEF SEG = 0

IF PEEK(&H463) = &HB4 THEN
  Regs.bx = &H7 * 256
ELSE
  Regs.bx = &H3 * 256
END IF
DEF SEG

Regs.cx = ((ULRow% - 1) * 256) OR (ULColumn% - 1)
Regs.dx = ((LRRow% - 1) * 256) OR (LRColumn% - 1)

IF NumOfLines% < 0 THEN
  Regs.ax = &H700 OR ABS(NumOfLines%)
ELSE
  Regs.ax = &H600 OR NumOfLines%
END IF

INTERRUPT &H10, Regs, Regs
END SUB

