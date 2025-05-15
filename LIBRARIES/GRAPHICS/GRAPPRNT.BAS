'Print text on any color BG while in graphic mode
DECLARE SUB ColorText (Text$, Row%, Col%, FG%, BG%)

'$INCLUDE: 'Qb.Bi'
RANDOMIZE ((TIMER * 100) MOD 32767)
SCREEN 9
Row% = 1: Col% = 10          'Row and Column positions.
Text$ = " Graphic Screen Text Produced by Microsoft QuickBasic 4.50 "

FOR I% = 1 TO 12
  FG% = (RND * 15)          'Random Foreground and
  BG% = (RND * 14) + 1      'Background colors.
  CALL ColorText(Text$, Row% + (I% * 2), Col%, FG%, BG%)
NEXT I%

WHILE INKEY$ = "": WEND
SCREEN 0
END

DEFINT A-Z
SUB ColorText (Text$, Row%, Col%, FG%, BG%)
 DIM InRegs AS RegTypeX
 DIM OutRegs AS RegTypeX
 C$ = STRING$(LEN(Text$), 219)  'Create string of solid characters.

 InRegs.ax = &H1301             'Video service 13h, subfuntion 0
 InRegs.bx = BG%                'BH = page 0, BL = color
 InRegs.cx = LEN(Text$)         'CX = String length
 InRegs.dx = 256 * (Row% - 1) + (Col% - 1)
 InRegs.es = VARSEG(C$)         'ES = String data segment
 InRegs.bp = SADD(C$)           'BP = String offset address
 CALL INTERRUPTX(&H10, InRegs, OutRegs)   'Call BIOS.

 InRegs.ax = &H1300             'Video service 13h, subfuntion 0
 InRegs.bx = (FG% XOR BG%) + &H80         'XOR onto background color.
 InRegs.es = VARSEG(Text$)      'ES = String data segment
 InRegs.bp = SADD(Text$)        'BP = String offset address
 CALL INTERRUPTX(&H10, InRegs, OutRegs)   'Call BIOS.

END SUB

