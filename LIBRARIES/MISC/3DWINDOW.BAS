DECLARE SUB cubeit (h%, V%, WD%, HT%, C1%, C2%, FILD%)
DECLARE SUB icon (h%, V%, WD%, HT%, C1%, C2%, FILD%, OUTIN%)
'create screens with 3D windows/buttons
'H and V is the upper left corner
'WD and HT are width and height of window
'C1 and C2 are colors of the highlite/shadow
'FILD is the color of the window
'OUTIN is 1 = add border 0 = no border

DEFINT A-Z
h = 20
V = 20
WD = 100
HT = 100
C1 = 15
C2 = 8
FILD = 7
OUTIN = 1

SCREEN 9, , 1, 0
CLS
cubeit h, V, WD, HT, C1, C2, FILD
icon h + 20, V + 20, WD - 40, HT - 40, C1, C2, FILD, OUTIN
SCREEN 9, , 0, 1
SLEEP
END

SUB cubeit (h, V, WD, HT, C1, C2, FILD)

LINE (h, V)-STEP(WD, HT), C1, BF
LINE (h + 3, V + 3)-STEP(WD - 3, HT - 3), FILD, BF
LINE (h, V + HT)-(h + WD, V + HT), C2
LINE (h + 1, V + HT - 1)-(h + WD, V + HT - 1), C2
LINE (h + 2, V + HT - 2)-(h + WD, V + HT - 2), C2
LINE (h + WD, V)-(h + WD, V + HT), C2
LINE (h + WD - 1, V + 1)-(h + WD - 1, V + HT), C2
LINE (h + WD - 2, V + 2)-(h + WD - 2, V + HT), C2

END SUB

DEFSNG A-Z
SUB drawbox (sw%)
DEFINT A-Z
  V = 168: HT = 70
  IF sw = 0 THEN h = 115: WD = 410
  IF sw = 1 THEN h = 60: WD = 520
  cubeit h, V, WD, HT, 15, 8, 7
  icon h + 30, V + 22, WD - 60, HT - 44, 15, 8, 7, 1
  LINE (h + 10, V + 10)-(h + WD - 12, V + 60), 8, B
  PAINT (h + 12, V + 12), pattern$, 8
  LINE (h + 10, V + 60)-(h + WD - 12, V + 60), 15
  LINE -(h + WD - 12, V + 10), 15
END SUB

SUB icon (h, V, WD, HT, C1, C2, FILD, OUTIN)
LINE (h, V)-(h + WD, V + HT), FILD, BF
LINE (h, V)-(h + WD, V + HT), C1, B
LINE (h, V + HT)-(h + WD, V + HT), C2
LINE (h + WD, V + HT)-(h + WD, V), C2
IF OUTIN = 1 THEN LINE (h - 1, V - 1)-(h + WD + 1, V + HT + 1), 8, B
END SUB

