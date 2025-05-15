'Draw graphs and pie-charts in 3D Graphics ***

DECLARE SUB Calc3D (x%, y%, z%, px%, py%)
DECLARE SUB Plot (x%, y%, z%)
DECLARE SUB RDraw (x%, y%, z%, ex%, ey%, ez%)
DECLARE SUB RDrawTo (x%, y%, z%)
DECLARE SUB Cube (xn%, yn%, zn%, w%, h%, d%, FFlag%)

DECLARE SUB ShowCube ()
DECLARE SUB Diagram3D (Table!(), Num%, x%, y%, w%, h%, Depth%, Cols%)

DECLARE SUB Pie (Table!(), Num%, x%, y%, Ra%, Cols%, ExPiece%)

DIM SHARED Fill$(5)     '** Field for fill pattern with CGA/HGC

DIM SHARED VX%, VY%, BF%
VX% = 500               '** reference or vanishing point X/Y
VY% = 400
BF% = 1000              '** bias factor
Depth% = 50             '** depth

scrn% = 9               '** data for SCREEN

IF scrn% < 8 THEN                      '*** read in fill pattern for CGA/HGC
  Fill$(0) = CHR$(0)
  Fill$(1) = CHR$(&H11) + CHR$(&H22) + CHR$(&H44) + CHR$(&H88)
  Fill$(2) = CHR$(&H88) + CHR$(&H44) + CHR$(&H22) + CHR$(&H11)
  Fill$(3) = CHR$(&H88) + CHR$(&H44) + CHR$(&H22) + CHR$(&H44)
  Fill$(4) = CHR$(&HEE) + CHR$(&HBB)
  Fill$(5) = CHR$(&H55) + CHR$(&HAA)
END IF

'*** read in data for diagram ***
DIM Table(100)
FOR i% = 1 TO 100
 READ Table(i%)
 IF Table(i%) = -1 THEN EXIT FOR
NEXT i%
Number% = i% - 1

DATA 10,20,30,10,15,8,22,40
DATA -1

'ShowCube
Diagram3D Table(), Number%, 20, 100, 300, 200, Depth%, scrn% '** 3D Diagram
Pie Table(), Number%, 480, 100, 100, scrn%, -1        '** pie chart
COLOR 7, 0
LOCATE 23, 1
PRINT "Strike any key..."
WHILE INKEY$ = ""
WEND

SUB Calc3D (x%, y%, z%, px%, py%)
 '*** calculate screen coordinates px/py from
 '*** 3D coordinates x/y/z

  z1 = 1 + z% / BF%
  px% = x% / z1 + VX% - VX% / z1
  py% = y% / z1 + VY% - VY% / z1

END SUB

SUB Cube (xn%, yn%, zn%, Wdth%, Hgt%, Dep%, FFlag%)
 '*** draw 3D cube
 DEFINT A-Z

 Calc3D xn, yn, Dep + zn, ox, oy
 Calc3D xn + Wdth, yn + Hgt, Dep + zn, px, py
 GOSUB DrawIt                           '*** plane Z

 RDraw xn, yn, zn, xn, yn, Dep + zn               '** Line 0 to Z
 RDraw Wdth + xn, yn, zn, Wdth + xn, yn, Dep + zn
 RDraw xn, Hgt + yn, zn, xn, Hgt + yn, Dep + zn
 RDraw Wdth + xn, Hgt + yn, zn, Wdth + xn, Hgt + yn, Dep + zn

 Calc3D xn, yn, zn, ox, oy
 Calc3D xn + Wdth, yn + Hgt, zn, px, py
 GOSUB DrawIt                           '*** plane 0

EXIT SUB

DrawIt:
 IF FFlag% THEN
   IF FFlag% >= 0 THEN
    LINE (ox, oy)-(px, py), FFlag%, BF
   ELSE
    LINE (ox, oy)-(px, py), 0, BF
    LINE (ox, oy)-(px, py), , B
    PAINT (ox + 2, oy + 2), Fill$(-FFlag% MOD 6)
   END IF
 END IF
 LINE (ox, oy)-(px, py), , B
RETURN

END SUB

DEFSNG A-Z
SUB Diagram3D (Table(), Num%, x%, y%, w%, h%, Depth%, Cols%)
 '** draw 3D diagram with data in Table()
 '** Position x%/y%, Width w%, Height h%, Depth Depth%
 '** Cols%: SCREEN (2,3,8,9)

 Max = 0
 FOR i% = 1 TO Num%
  IF Table(i%) > Max THEN Max = Table(i%)
 NEXT i%

 '***  set display for graphics  ***
 SCREEN Cols%                '** 8/9 only with EGA/VGA!, 2 with CGA, 3 with HGC
 WINDOW (0, 0)-(640, 400)

 '***  Display coordinate system  ***
 Cube x%, y%, 0, 0, h%, Depth%, 0      '** front side
 Cube x%, y%, 0, w%, 0, Depth%, 0      '** floor
 Cube x%, y%, Depth%, w%, h%, 0, 0     '** back side

 '*** 3-D-Balken zeichnen ***
 x1% = x%
 wd% = w% / Num%
 FOR i% = 1 TO Num%
  Col% = i%
  IF Cols% < 8 THEN Col% = -Col%
  Cube x1%, y%, 0, wd% * .8, Table(i%) / Max * h%, Depth%, Col%
  x1% = x1% + wd%
 NEXT i%


END SUB

SUB Pie (Table(), Num%, x%, y%, Ra%, Cols%, ExPiece%)
 '*** draw pie chart with data in Table()
 '** Num%: Number values, x%,y%: center of pie, Ra%: Radius
 '** Cols%: SCREEN (2,3,8,9)
 '** ExPiece%: number of segment to be removed, 0=none, -1=largest

 Pi = 3.141592653589#
 Pi2 = Pi * 2

 Sum# = 0
 Max = 0
 Max% = 0
 FOR i% = 1 TO Num%
  Sum# = Sum# + Table(i%)       '** find total
  IF Table(i%) > Max THEN Max = Table(i%): Max% = i%
 NEXT i%

 IF ExPiece% = -1 THEN ExPiece% = Max%

 '***  set display for graphics  ***
 SCREEN Cols%                   '** 8 with EGA/VGA, 2 with CGA, 3 with HGC
 WINDOW (640, 200)-(0, 0)       '** define the screen

 wa = .0000000001#              '** start angle
 FOR i% = 1 TO Num%
  IF Cols% > 7 THEN COLOR i%    '** set colors

  we = wa + (Table(i%) / Sum#)    '** Find final angle
  IF we > 1 THEN we = 1
  wm = (we - wa) / 2
  cow = COS((wa + wm) * Pi2)
  siw = SIN((wa + wm) * Pi2)
  w1 = ((we + wa) / 2) * Pi2
  xo% = Ra% / 5 * COS(w1)
  yo% = Ra% / 10 * SIN(w1)
 
  IF i% = ExPiece% THEN
   '** 1. draw pie segment
   xm% = x% + xo%
   ym% = y% + yo%
  ELSE
   xm% = x%
   ym% = y%
  END IF

  CIRCLE (xm%, ym%), Ra%, , -wa * Pi2, -we * Pi2  '** draw pie segment
 
  IF ABS(wa - we) > .025 THEN
   IF Cols% > 3 THEN
     PAINT (x% + 3 * xo%, y% + 3 * yo%)           '** fill
   ELSE
     PAINT (x% + 3 * xo%, y% + 3 * yo%), Fill$(i% MOD 6)'** with CGA/HGC
   END IF
  END IF

  LOCATE 25 - (ym% + Ra% / 1.9 * siw) / 8 - (siw > 0), xm% / 8 + Ra% / 7 * cow + (cow < 0) * LEN(LTRIM$(STR$(Table(i%))))
  PRINT Table(i%)                   '** show data

  wa = we                       '** start angle=end angle

 NEXT i%
 IF Cols% > 7 THEN COLOR 7      '** reset color to white

END SUB

SUB Plot (x%, y%, z%)
 '*** set 3D points in plane x/y/z

 Calc3D ex%, ey%, ez%, tx%, ty%
 LINE (tx%, ty%)-(tx%, ty%)
END SUB

SUB RDraw (x%, y%, z%, ex%, ey%, ez%)
 '*** Draw one  3-D-Line from x/y/z to ex/ey/ez

 Calc3D x%, y%, z%, ox%, oy%
 Calc3D ex%, ey%, ez%, tx%, ty%
 LINE (ox%, oy%)-(tx%, ty%)
END SUB

SUB RDrawTo (x%, y%, z%)
 '*** draw a 3D line from current position to x/y/z

 Calc3D x%, y%, z%, tx%, ty%
 LINE -(tx%, ty%)
END SUB

SUB ShowCube
 '*** DEMO: draws a 3D cube that can be changed with the cursor keys

DEFINT A-Z

B = 100
h = 100
t = 100
DO
 COLOR 7
 LOCATE 1, 1: PRINT USING "#### Wdth, #### Hgt, #### Dep"; w; h; t
 COLOR 7 + 8
 Plot 0, 0, 9999      '** vanishing point
 Cube 100, 100, 0, w, h, t, 0

 DO
  k$ = INKEY$
 LOOP UNTIL LEN(k$)
 IF k$ = CHR$(27) THEN EXIT DO
 IF LEN(k$) = 2 THEN sk% = ASC(RIGHT$(k$, 1))

 COLOR 0
 Cube 100, 100, 0, B, h, t, 0

 w = w + 10 * ((sk% = 75) - (sk% = 77))
 h = h + 10 * ((sk% = 80) - (sk% = 72))
 t = t + 10 * ((sk% = 81) - (sk% = 73))

LOOP

END SUB

