'fade a color in VGA mode

SCREEN 12
LINE (1, 1)-(639, 349), 4, BF
FOR x = 63 TO 0 STEP -1
  PALETTE 4, x
  FOR z = 1 TO 100: NEXT z
NEXT x

