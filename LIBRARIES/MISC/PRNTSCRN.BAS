'use PrntScrn key from your program instead of keyboard
DEFINT A-Z
DECLARE SUB PrtScrn ()
'$INCLUDE: 'qb.bi'

'***********************************************************************
'* SUB PrtScrn
'*
'* PURPOSE
'*    Uses BIOS ISR 05H (Print-Screen Service) to print the screen, just
'*    as if the Print Screen key had been pressed.
'*
'* EXTERNAL ROUTINE(S)
'*    QB.LIB:
'*       SUB Interrupt (IntNum%, IRegs AS RegType, ORegs AS RegType)
'***********************************************************************
SUB PrtScrn STATIC
   DIM Regs AS RegType
   Regs.ax = 0
   INTERRUPT &H5, Regs, Regs
END SUB

