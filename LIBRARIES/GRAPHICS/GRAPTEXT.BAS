'display text on multiple colored bg in EGA/VGA
DECLARE SUB PutText2 (Text$, TextColor%, BackColor%)
'$INCLUDE: 'qb.bi'

DEFINT A-Z
fg = 1: bg = 0
SCREEN 9
COLOR 7, 0
CLS
LOCATE 1, 2: PRINT "Hello Mark"
LINE (320, 50)-(600, 300), 7, BF
LOCATE 8, 43
PutText2 "Hello Mark " + STR$(fg%), fg%, bg%
END

SUB PutText2 (Text$, TextColor%, BackColor%)
'by Douglas H. Lusher, 07-10-1993
DIM Register AS RegType

Col% = POS(0) - 1
Register.bx = (TextColor% XOR BackColor%) OR 128
Register.cx = 1
FOR Ptr% = 1 TO LEN(Text$)
  Register.ax = &H900 + ASC(MID$(Text$, Ptr%, 1))
  LOCATE , Col% + Ptr%
  CALL INTERRUPT(&H10, Register, Register)
NEXT

END SUB

