DEFINT A-Z
'determines multiple key presses
TYPE KeyboardInfo
   Insert     AS INTEGER
   CapLock    AS INTEGER
   NumLock    AS INTEGER
   ScrLock    AS INTEGER
   Alt        AS INTEGER
   Ctrl       AS INTEGER
   LeftShift  AS INTEGER
   RightShift AS INTEGER
   SysReq     AS INTEGER
   CapLock2   AS INTEGER
   NumLock2   AS INTEGER
   ScrLock2   AS INTEGER
   RightAlt   AS INTEGER
   RightCtrl  AS INTEGER
   LeftAlt    AS INTEGER
   LeftCtrl   AS INTEGER
END TYPE

'$INCLUDE: 'qbx.bi'

DECLARE SUB ShiftKeys ()               'use with 101 key keyboards
DECLARE SUB ShiftKeys2 ()              'use with older, 84 key keyboards

DIM SHARED Regs AS RegType
DIM SHARED KB   AS KeyboardInfo

'***********************************************************************
'* SUB ShiftKeys
'*
'* PURPOSE
'*    Uses BIOS ISR 16H, Service 12H (Get Extended Shift Status) to
'*    return the status of the keyboard toggle and shift keys at the
'*    time of the call.
'***********************************************************************
SUB ShiftKeys STATIC
   Regs.ax = &H1200
   Regs.ax = 0
   Interrupt &H16, Regs, Regs

   al% = Regs.ax AND &HFF
   ah% = Regs.ax \ &HFF

   'Extract bits 7 through 0 in order of AL and AH.
   KB.Insert    = (al% AND 128) \ 128: KB.SysReq   = (ah% AND 128) \ 128
   KB.CapLock   = (al% AND  64) \  64: KB.CapLock2 = (ah% AND  64) \  64
   KB.NumLock   = (al% AND  32) \  32: KB.NumLock2 = (ah% AND  32) \  32
   KB.ScrLock   = (al% AND  16) \  16: KB.ScrLock2 = (ah% AND  16) \  16
   KB.Alt       = (al% AND   8) \   8: KB.RightAlt = (ah% AND   8) \   8
   KB.Ctrl      = (al% AND   4) \   4: KB.RightCtrl= (ah% AND   4) \   4
   KB.LeftShift = (al% AND   2) \   2: KB.LeftAlt  = (ah% AND   2) \   2
   KB.RightShift= (al% AND   1)      : KB.LeftCtrl = (ah% AND   1)
END SUB

'***********************************************************************
'* SUB ShiftKeys2
'*
'* PURPOSE
'*    Uses BIOS ISR 16H, Service 02H (Get Shift Status) to return the
'*    status of the keyboard toggle and shift keys at the time of the
'*    call.
'***********************************************************************
SUB ShiftKeys2 STATIC
   Regs.ax = &H200
   Regs.ax = 0
   Interrupt &H16, Regs, Regs
   al% = Regs.ax AND &HFF

   'Extract bits 7 through 0 in order
   KB.Insert     = (al% AND 128) \ 128
   KB.CapLock    = (al% AND  64) \  64
   KB.NumLock    = (al% AND  32) \  32
   KB.ScrLock    = (al% AND  16) \  16
   KB.Alt        = (al% AND   8) \   8
   KB.Ctrl       = (al% AND   4) \   4
   KB.LeftShift  = (al% AND   2) \   2
   KB.RightShift = (al% AND   1)
END SUB

