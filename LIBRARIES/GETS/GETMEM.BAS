DEFINT A-Z
'find base memory, extenden memory, available memory
'$INCLUDE: 'qb.bi'

DECLARE FUNCTION BaseMem% ()                 'Base memory
DECLARE FUNCTION ExtMem% ()                  'Extended memory (raw)
DECLARE FUNCTION GetDOSMem& ()               'DOS memory available
DIM SHARED IRegs AS RegType, ORegs AS RegType

PRINT BaseMem%
PRINT ExtMem%
PRINT GetDOSMem&
END

'***********************************************************************
'* FUNCTION BaseMem%
'*
'* PURPOSE
'*    Uses BIOS ISR 12H, (Memory-Size Service) to return the amount of
'*    base memory in kilobytes.
'*
'* EXTERNAL ROUTINE(S)
'*    QBX.LIB
'*    -------
'*    SUB Interrupt (IntNum%, IRegs AS RegType, ORegs AS RegType)
'***********************************************************************
FUNCTION BaseMem% STATIC
   INTERRUPT &H12, IRegs, ORegs
   BaseMem% = ORegs.ax
END FUNCTION

'***********************************************************************
'* FUNCTION ExtMem%
'*
'* PURPOSE
'*    Uses BIOS ISR 15H, Service 88H (Get Extended Memory Size) to
'*    return the amount of extended memory in kilobytes.
'*
'* EXTERNAL ROUTINE(S)
'*    QBX.LIB
'*    -------
'*    SUB Interrupt (IntNum%, IRegs AS RegType, ORegs AS RegType)
'***********************************************************************
FUNCTION ExtMem% STATIC
   IRegs.ax = &H8800
   INTERRUPT &H15, IRegs, ORegs
   ExtMem% = ORegs.ax
END FUNCTION

'***********************************************************************
'* FUNCTION GetDOSMem&
'*
'* PURPOSE
'*    Uses DOS ISR 21H, Function 48H (Allocate Memory) to determine the
'*    amount of DOS memory available.  Allocate Memory, although
'*    intended to, well, allocate memory <g>, can also be used to
'*    determine the amount of available memory.  This is done by trying
'*    to allocate an impossibly large amount of memory; Function 48H
'*    will return with the carry flag set, ax set to 8h (not enough
'*    memory), and bx set to the number of paragraphs in the largest
'*    available memory block.
'*
'* EXTERNAL ROUTINE(S)
'*    QBX.LIB
'*    -------
'*    SUB Interrupt (IntNum%, IRegs AS RegType, ORegs AS RegType)
'***********************************************************************
FUNCTION GetDOSMem& STATIC
   IRegs.ax = &H4800                      'DOS Allocate Memory function
   IRegs.bx = &HFFFF                      'An impossible value
   INTERRUPT &H21, IRegs, ORegs           'call DOS

   IF (ORegs.flags AND 1) THEN            'Is carry flag set? (should be)
      GetDOSMem& = (ORegs.bx - 65536 * (ORegs.bx < 0)) * 16
   ELSE                                   'Something is wrong
      GetDOSMem& = -1                     '  return -1 to indicate error
   END IF
END FUNCTION

