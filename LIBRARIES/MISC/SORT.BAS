DEFINT A-Z
DIM Array1(1 TO 20)
'another sorting routine
N% = 20

RANDOMIZE TIMER
FOR I = 1 TO N%
   Array1(I) = INT((35 - 1 + 1) * RND + 1)
NEXT I

FOR I = 1 TO N% - 1             'sort routine here
  FOR J = I + 1 TO N%
    IF Array1(I) > Array1(J) THEN SWAP Array1(I), Array1(J)
  NEXT J
NEXT I

FOR I = 1 TO N%
   PRINT Array1(I)
NEXT I
END

