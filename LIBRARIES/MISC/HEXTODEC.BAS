'converts a hex to decimal
temp$ = "0123456789ABCDEF"
CLS
INPUT "Enter number: ", z$
y = 1
FOR x = 1 TO 3
  DO UNTIL MID$(z$, x, 1) = MID$(temp$, y, 1)
    y = y + 1
  LOOP
  y = y - 1
  SELECT CASE x
    CASE 1: hx = y * 256
    CASE 2: hx = hx + (y * 16)
    CASE 3: hx = hx + y
  END SELECT
  y = 1
NEXT x
PRINT hx


