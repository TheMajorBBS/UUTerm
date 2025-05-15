 'Code to save the VGA palette
 SUB SavePalette (FileName$, N%)
 OUT &H3C7, 0
 FOR A% = 0 TO N% * 3 - 1
   A$ = A$ + CHR$(INP(&H3C9))
 NEXT
 File% = FREEFILE
 OPEN FileName$ FOR BINARY AS File%
   PUT File%, 1, A$
 CLOSE File%
 END SUB
