'Patch to Change Text (Fast Save/Load) in QB 4.5
              ' by J. S. Paravati    12/93


  'Note!:  This program will modify a QB.EXE file! Backup your original
  '        file first!

 ' This program is intended for those who used my Patch to by-pass the
 ' "Fast Save/Load" bug.  It will modify the text in the "Format" box
 ' so there will be no confusion that the "Fast Save/Load" is disabled.
 ' Both positions will now say "TEXT -  ASCII Save"

DEFINT A-Z

CLS

F$ = "C:\QB45\QB.EXE"
 F$ = UCASE$(F$)
 OldData$ = STRING$(68, " ")
OPEN F$ FOR BINARY AS #1

       SK& = &H3FED4
     IF SK& < 0 THEN SK& = 32768 + SK& + 32769

   PRINT HEX$(SK&); "  Address": PRINT
  SEEK #1, SK&
    GET #1, , OldData$
   PRINT "Old Data:"
   PRINT OldData$

   PRINT "Length = "; LEN(OldData$): PRINT

  NewData$ = "~TEXT -      `~TEXT -`ASCII Save   `    ` ASCII Save"
        `"

   FOR N = 1 TO LEN(NewData$)
     CheckByte = ASC(MID$(NewData$, N, 1))
    IF CheckByte = 96 THEN
     MID$(NewData$, N, 1) = MKI$(0)
    END IF
   NEXT N

  PRINT "New Data:"
  PRINT NewData$

    PRINT "Length = "; LEN(NewData$): PRINT
   SEEK #1, SK&
    IF LEN(NewData$) <> 68 THEN STOP
    PUT #1, , NewData$

  SEEK #1, SK&
    GET #1, , NewData$
    PRINT "Check of New Data:": PRINT NewData$

CLOSE #1
CLOSE
END

