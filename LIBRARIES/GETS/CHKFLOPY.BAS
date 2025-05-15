DECLARE SUB diskStatus (drivea&, driveb&)
'checks on floppy drives for errors

'$INCLUDE: 'qb.bi'
DEFINT A-Z
CLS
diskStatus drivea&, driveb&

PRINT drivea&
PRINT driveb&
END

DEFSNG A-Z
SUB diskStatus (drivea&, driveb&) STATIC

' Illegal command to driver                          =   1
' Disk Not formatted                                 =   2
' Write Protected Disk                               =   3
' Requested sector not found                         =   4
' Reset failed                                       =   5
' Diskette Change line active                        =   6
' DMA overrun                                        =   8
' DMA attempt across 64k boundary                    =   9
' Invalid Media                                      =  12
' CRC error on disk read                             =  16
' Controller Error                                   =  32
' Seek Failure                                       =  64
' Drive not ready)                                   = 128


DIM InRegs AS RegType, outregs AS RegType
REDIM flag(2), diskspace&(2), drive&(2)

FOR j = 0 TO 1
  FOR i = 0 TO 1
    InRegs.ax = 0      'reset floppy
    InRegs.dx = i
    CALL INTERRUPT(&H13, InRegs, outregs)

    InRegs.ax = &H401    'verify drives
    InRegs.dx = i
    InRegs.cx = &H101
    CALL INTERRUPT(&H13, InRegs, outregs)

    flag(i) = (outregs.ax \ 256) AND 255
    IF flag(i) <> 0 THEN GOTO continue

    InRegs.ax = &H3600    'verify drives
    InRegs.dx = i + 1
    CALL INTERRUPT(&H21, InRegs, outregs)

    sectors& = outregs.ax
    freeclusters& = outregs.bx
    bytes& = outregs.cx
    diskspace&(i) = sectors& * freeclusters& * bytes&
continue:
  NEXT
NEXT

FOR i = 0 TO 1
  IF flag(i) <> 0 THEN
    drive&(i) = flag(i)
  ELSE
    drive&(i) = diskspace&(i)
  END IF
NEXT

drivea& = drive&(0)
driveb& = drive&(1)
END SUB

