'Adds PDS 7.X CHDRV command to QB 4.5
'easiest way to do a change drive is to call the 0Eh function of the
'DOS services interrupt (21h). To do this, load QB with the QB.QLB
'quick library and include the following routines in your program.
'The FUNCTION GetDrive$ returns the current drive letter, and the
'SUB ChgDrive() sets the current to drive to the calling argument.
'====================================================================

'$INCLUDE: 'QB.BI'
DECLARE FUNCTION GetDrive$ ()
DECLARE SUB chgdrive (Drive AS STRING)
 
CLS
PRINT "Your are now on drive: "; GetDrive$
chgdrive ("D")
PRINT "Your are now on drive: "; GetDrive$

SUB chgdrive (Drive AS STRING)    ' Set the current drive letter
DIM REGS AS RegType               ' Type declared in QB.BI
AH = &HE                          ' Function number set in AH
AL = &H0                          ' AL is not set to anything
REGS.AX = AH * &H100 + AL         ' AH is high 8 bits, AL is low 8
DH = &H0                          ' DH is not set to anything
DL = ASC(UCASE$(Drive)) - 65      ' DL is set to the drive number
				  ' A=0, B=1, C=2, etc.
REGS.DX = DH * &H100 + DL
CALL Interrupt(&H21, REGS, REGS)  ' Call the DOS services int
AL = REGS.AX MOD &H100            ' Set AL to low 8 bits of AX
				  ' AL returns the max number of
				  ' drives available 25=Z, etc
END SUB

FUNCTION GetDrive$                ' Get the current drive letter
DIM REGS AS RegType               ' Type declared in QB.BI
AH = &H19                         ' Function number
AL = &H0                          ' AL is not set to anything
REGS.AX = AH * &H100 + AL         ' AL is 16 bit
CALL Interrupt(&H21, REGS, REGS)  ' Call the DOS services int
AL = REGS.AX MOD &H100            ' AL is low 8 bits of AX
GetDrive$ = CHR$(AL + 65)         ' AL returns the drive number
				  ' convert to ASCII with 0=A
END FUNCTION

