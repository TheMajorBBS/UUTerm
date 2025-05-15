   'Toggle the switching of the use of the CTRL-C, CTRL-Break key
   'Input   : Sw% = 0 (false) to turn off CTRL-Break, Sw <> 0 (true) turns it on
   'Returns : none

SUB ToggleBreak (Sw%) STATIC
  
   DEF SEG = 0
   IF DimFlg = 0 THEN
      DimFlg = -1
      DIM OldSeg%(4)
      FOR I = &H6C TO &H6F
         OldSeg%(I - &H6C) = PEEK(I)
      NEXT I
   END IF
   IF Sw% = 0 THEN
      POKE &H6C, &H53
      POKE &H6D, &HFF
      POKE &H6E, &H0
      POKE &H6F, &HF0
   ELSE
      ' to reset:
      FOR I = &H6C TO &H6F
         POKE I, OldSeg%(I - &H6C)
      NEXT
   END IF

   DEF SEG
END SUB

