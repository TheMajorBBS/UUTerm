'patch to change QB SAVE option, to ASCII only
DEFINT A-Z
DEFLNG N

CLS

F$ = "C:\QB45\QB.EXE"
F$ = UCASE$(F$)

OPEN F$ FOR BINARY AS #1
      SK& = &HE9C5
     IF SK& < 0 THEN SK& = SK& + 65536 + 1

  SEEK #1, SK&
    GET #1, , AX: PRINT HEX$(AX), " Original Value Should = Hex 775"

   NewByte = 7 * 256 + &HEB
   SEEK #1, SK&
 PRINT HEX$(NewByte), " New Value Should = Hex 7EB"
 PRINT HEX$(SEEK(1)), " Address Should = E9C6"

 IF HEX$(AX) <> "775" OR HEX$(SEEK(1)) <> "E9C6" THEN
   PRINT
   PRINT "File Already Modified or Wrong Version: Quitting Program"
   CLOSE : END
 END IF

    PUT #1, , NewByte

  SEEK #1, SK&
    GET #1, , AX
  PRINT
  PRINT "File Modified. New Value at "; HEX$(SK&); " = "; HEX$(AX)

CLOSE #1
CLOSE
END

