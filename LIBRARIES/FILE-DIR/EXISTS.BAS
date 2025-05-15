DECLARE FUNCTION exists% (FileName$)
'Checks to see if a file exists

TYPE RegTypeX
  ax    AS INTEGER
  bx    AS INTEGER
  cx    AS INTEGER
  dx    AS INTEGER
  bp    AS INTEGER
  si    AS INTEGER
  di    AS INTEGER
  flags AS INTEGER
  DS    AS INTEGER
  es    AS INTEGER
END TYPE
DIM SHARED InRegs AS RegTypeX, OutRegs AS RegTypeX
DECLARE SUB INTERRUPTX (intnum AS INTEGER, InReg AS RegTypeX, OutReg AS RegTypeX)

IF exists("qb.exe") THEN
  PRINT "File found."
ELSE
  PRINT "File not found."
END IF

FUNCTION exists% (FileName$)
 dta$ = STRING$(80, " ")

 InRegs.ax = &H1A00              '*** Set DTA
 InRegs.dx = SADD(dta$)
 InRegs.DS = VARSEG(dta$)
 CALL INTERRUPTX(&H21, InRegs, OutRegs)

 FilN$ = FileName$ + CHR$(0)
 InRegs.ax = &H4E00              '*** Find First
 InRegs.cx = 0                   '*** Files and Sub-Directories
 InRegs.dx = SADD(FilN$)
 InRegs.DS = VARSEG(FilN$)
CALL INTERRUPTX(&H21, InRegs, OutRegs)

 exists% = (OutRegs.ax = 0)
END FUNCTION

