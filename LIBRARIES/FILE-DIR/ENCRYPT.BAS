  DECLARE SUB Crypt (Buffer$, Key$, Start%)
  DEFINT A-Z

  CStr$ = "well her goes, will!"
  Key1$ = "my key."
  Key$ = Key1$
 
  CLS
  PRINT "{"; CStr$; "}"
  PRINT "{"; Key$; "}"
  CALL Crypt(CStr$, Key$, 10)
  PRINT "{"; CStr$; "}"
  PRINT "{"; Key$; "}"
  Key$ = Key1$
  CALL Crypt(CStr$, Key$, 10)
  PRINT "{"; CStr$; "}"
  PRINT "{"; Key$; "}"

SUB Crypt (Buffer$, Key$, Start)

'encrypt text strings and data files

BufLen = LEN(Buffer$)
KeyLen = LEN(Key$)

IF Start = 0 OR Start > KeyLen THEN
  Start = 1
END IF

FOR I = 1 TO BufLen
  MID$(Buffer$, I, 1) = CHR$(ASC(MID$(Buffer$, I, 1)) XOR (ASC(MID$(Key$, Start, 1)) XOR (ASC(MID$(Key$, 1, 1)) * Start)) AND &HFF)
  IF Start < KeyLen THEN
    MID$(Key$, Start, 1) = CHR$((ASC(MID$(Key$, Start, 1)) + ASC(MID$(Key$, Start + 1, 1))) AND &HFF)
    Start = Start + 1
  ELSE
    MID$(Key$, Start, 1) = CHR$((ASC(MID$(Key$, Start, 1)) + ASC(MID$(Key$, 1, 1))) AND &HFF)
    Start = 1
  END IF
NEXT
END SUB

