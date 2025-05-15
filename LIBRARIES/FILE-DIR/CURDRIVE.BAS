DECLARE FUNCTION GetDir$ (Drive$)
DECLARE FUNCTION GetDrv$ ()
DEFINT A-Z
'Get current drive and directory

TYPE RegTypeX
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
DIM SHARED InRegs AS RegTypeX, OutRegs AS RegTypeX
DECLARE SUB INTERRUPTX (intnum AS INTEGER, InReg AS RegTypeX, OutReg AS RegTypeX)
  
'current = 0, A: = 1, B: = 2, C: = 3, etc.
PRINT "Current drive is "; GetDrv$
PRINT "Current directory is "; GetDir$("")

END

FUNCTION GetDir$ (Drive$) STATIC
   DIM Temp AS STRING * 64

   InRegs.ax = &H4700
   IF Drive$ > "" THEN            'must convert drive to integer
      InRegs.dx = ASC(UCASE$(Drive$)) - 64
   ELSE
      InRegs.dx = 0
   END IF
   InRegs.ds = VARSEG(Temp$)
   InRegs.si = VARPTR(Temp$)
   INTERRUPTX &H21, InRegs, OutRegs

   GetDir$ = "\" + LEFT$(Temp$, INSTR(Temp$, CHR$(0)) - 1)
END FUNCTION

FUNCTION GetDrv$ STATIC
   InRegs.ax = &H1900
   INTERRUPTX &H21, InRegs, OutRegs
   GetDrv$ = CHR$((OutRegs.ax AND &HFF) + 65) + ":"
END FUNCTION

