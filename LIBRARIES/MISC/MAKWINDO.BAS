DECLARE SUB DrawFrame (x%, y%, w%, h%, colf%, colb%, Typ%, Fill$)
DECLARE SUB DrawBox (x%, y%, w%, h%, colf%, colb%, box$)
DEFINT A-Z
'Draws text windows and boxes

'X% and Y% are the upper-left corner of box
'W% and H% are the width and height
'COLF% and COLB% are the text foreground and background colors
'TYP% is the frame style: 0-7
'FILL$ is the pattern to fill the window

SCREEN 0
x% = 5
y% = 5
w% = 5
h% = 10
colf% = 3
colb% = 4
Typ% = 1
Fill$ = ""

CLS
DrawFrame x%, y%, w%, h%, colf%, colb%, Typ%, Fill$

END

SUB DrawBox (x%, y%, w%, h%, colf%, colb%, box$) STATIC
  
   COLOR colf%, colb%
   LOCATE x%, y%
   PRINT LEFT$(box$, 1); STRING$(w%, MID$(box$, 2, 1)); MID$(box$, 3, 1);
   FOR row = y% + 1 TO h%
      LOCATE row, x%
      PRINT MID$(box$, 4, 1); STRING$(w%, MID$(box$, 5, 1)); MID$(box$, 4, 1);
   NEXT row
   LOCATE row, x%
   PRINT MID$(box$, 6, 1); STRING$(w%, MID$(box$, 2, 1)); MID$(box$, 7, 1);
END SUB

DEFSNG A-Z
SUB DrawFrame (x%, y%, w%, h%, colf%, colb%, Typ%, Fill$)
 SELECT CASE Typ%
  CASE 0: box$ = "ÚÄ¿³ ÀÙ"        'put what you want for a pattern
  CASE 1: box$ = "ÉÍ»º È¼"
  CASE 2: box$ = "±±±± ±±"
  CASE 3: box$ = "**** **"
  CASE 4: box$ = ":::: ::"
  CASE 5: box$ = "!!!! !!"
  CASE 6: box$ = "???? ??"
  CASE ELSE: box$ = "         "
 END SELECT
 IF Fill$ = "" THEN Fill$ = CHR$(0)
 MID$(box$, 5, 1) = Fill$

 DrawBox x%, y%, w%, h%, colf%, colb%, box$

END SUB

