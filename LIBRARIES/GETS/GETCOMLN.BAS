DECLARE FUNCTION CmdLine$ ()
'preserves the command line in it's original case

DEFINT A-Z
' $INCLUDE: 'qb.bi'

PRINT "Here's the original command line:"
PRINT "["; CmdLine; "]"

END

FUNCTION CmdLine$
  '
  ' CmdLine - returns original command line
  '
  DIM Regs AS RegType
  STATIC CmdLen, CmdBuild$, i
  '
  ' DOS Interrupt 21h service 62h returns the segment
  ' address of the running program's PSP in the bx register.
  '
  Regs.ax = &H6200
  CALL Interrupt(&H21, Regs, Regs)
  DEF SEG = Regs.BX
  '
  ' The command line's length is found at offset 80h of the PSP
  ' and the actual command line starts at 81h
  '
  CmdBuild$ = ""
  CmdLen = PEEK(&H80)
  FOR i = 1 TO CmdLen
    CmdBuild$ = CmdBuild$ + CHR$(PEEK(&H80 + i))
  NEXT
  '
  ' restore BASIC data segment and return data
  '
  DEF SEG
  CmdLine$ = CmdBuild$
END FUNCTION

