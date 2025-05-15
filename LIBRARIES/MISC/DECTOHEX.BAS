'converts a deci-number to hex
temp$ = "123456789ABCDEF0"
CLS
INPUT "Enter number: ", z
FOR x = 1 TO z
  cnt = cnt + 1
  b$ = MID$(temp$, cnt, 1)
  IF b$ = "0" THEN cnt = 0: cnt1 = cnt1 + 1: a$ = MID$(temp$, cnt1, 1)
  'SLEEP
NEXT x
PRINT a$ + b$

