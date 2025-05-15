DECLARE FUNCTION printerready! ()
'Finds if the printer is ready
TYPE RegType
  ax    AS INTEGER
  bx    AS INTEGER
  cx    AS INTEGER
  dx    AS INTEGER
  bp    AS INTEGER
  si    AS INTEGER
  di    AS INTEGER
  flags AS INTEGER
  ds    AS INTEGER
  es    AS INTEGER
END TYPE
DIM SHARED InRegs AS RegType, OutRegs AS RegType
DECLARE SUB INTERRUPT (intnum AS INTEGER, InReg AS RegType, OutReg AS RegType)
x = printerready
IF x = 0 THEN PRINT "not ready"
IF x = 1 THEN PRINT "ready"
END

FUNCTION printerready
 '*** Return if printer is ready
 '*** Ask Retry/Abort when not

 OK% = 0
 DO
  InRegs.ax = &H200
  InRegs.dx = 0
  CALL INTERRUPT(&H17, InRegs, OutRegs)

  IF ((OutRegs.ax AND &H1000) = 0) OR ((OutRegs.ax AND &H1000000) = 0) THEN
   printerready = 0
   OK% = -1
  ELSE
   printerready = 1
   OK% = 1
   InRegs.ax = &H100
   CALL INTERRUPT(&H17, InRegs, OutRegs) '** Printer Init
  END IF
 LOOP UNTIL OK%

END FUNCTION

